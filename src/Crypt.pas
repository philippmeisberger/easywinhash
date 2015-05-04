{ *********************************************************************** }
{                                                                         }
{ Windows CryptAPI Delphi wrapper Unit                                    }
{                                                                         }
{ Copyright (c) 2011-2015 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit Crypt;

interface

uses
  Windows, Classes, SysUtils, CryptAPI;

type
  { TBytes }
  TBytes = array of Byte;

  { TBase64Flags }
  TBase64Flags = (
    bfHeader, bfDefault, bfBinary, bfRequestHeader, bfHex, bfHexAscii,
    bfBase64Any, bfAny, bfHexAny, bfX509CrlHeader, bfHexAddr, bfHexAsciiAddr,
    bfHexRaw
  );

  { TBase64 }
  TBase64 = class(TObject)
  private
    FFlag: TBase64Flags;
  public
    constructor Create;
    function Decode(const ABase64: string): string;
    function DecodeBinary(const ABase64: TBytes): string;
    function Encode(const AText: string): string;
    function EncodeBinary(const AText: string): TBytes;
    { external }
    property Flag: TBase64Flags read FFlag write FFlag;
  end;

  { Enumerations }
  THashAlgorithm = (haMd5, haSha, haSha256, haSha384, haSha512);
  TCryptAlgorithm = (caAes128, caAes192, caAes256);

  { Events }
  TProgressEvent = procedure(Sender: TObject; const AProgress: Cardinal) of object;

  { TCryptBase }
  TCryptBase = class(TObject)
  protected
    function DeriveKey(ACryptProvider: HCRYPTPROV; const APassword: string;
      AHashAlgorithm: THashAlgorithm;
      APasswordEncryptionAlgorithm: TCryptAlgorithm): HCRYPTKEY;
    function HashToString(HashHandle: HCRYPTHASH): string;
  end;

  { THash }
  THash = class(TCryptBase)
  private
    FOnStart, FOnProgress: TProgressEvent;
    FOnFinish: TNotifyEvent;
    FHashAlgorithm: THashAlgorithm;
  public
    constructor Create(AHashAlgorithm: THashAlgorithm); overload;
    function Hash(const AString: string): string;
    function HashFile(const AFileName: TFileName): string;
    function VerifyHash(const AHash, AString: string): Boolean;
    function VerifyFileHash(const AHash, AFileName: TFileName): Boolean;
    { external }
    property Algorithm: THashAlgorithm read FHashAlgorithm write FHashAlgorithm;
    property OnFinish: TNotifyEvent read FOnFinish write FOnFinish;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property OnStart: TProgressEvent read FOnStart write FOnStart;
  end;

  { THMac }
  THMac = class(TCryptBase)
  private
    FHashAlgorithm: THashAlgorithm;
    FPasswordEncryptionAlgorithm: TCryptAlgorithm;
  public
    constructor Create(AHashAlgorithm: THashAlgorithm;
      APasswordEncryptionAlgorithm: TCryptAlgorithm = caAes128);
    function HMac(const AMessage, APassword: string): string;
  end;

const
  { Enumeration to hash algorithm ID translator }
  THashAlgId: array[THashAlgorithm] of Cardinal = (
    CALG_MD5,
    CALG_SHA,
    CALG_SHA_256,
    CALG_SHA_384,
    CALG_SHA_512
  );

  { Enumeration to encryption algorithm ID translator }
  TCryptAlgId: array[TCryptAlgorithm] of Cardinal = (
    CALG_AES_128,
    CALG_AES_192,
    CALG_AES_256
  );

function StringToBytes(const AString: string): TBytes;

implementation

{ TBase64 }

{ public TBase64.Create

  Constructor for creating a TBase64 instance. }

constructor TBase64.Create;
begin
  inherited Create;
  FFlag := bfDefault;
end;

{ public TBase64.Decode

  Decodes a Base64 string value to a string. }

function TBase64.Decode(const ABase64: string): string;
begin
  Result := DecodeBinary(Pointer(PChar(ABase64)));
end;

{ public TBase64.DecodeBinary

  Decodes a Base64 binary value to a string. }

function TBase64.DecodeBinary(const ABase64: TBytes): string;
var
  BufferSize, Skipped, Flags: Cardinal;

begin
  // Retrieve and set required buffer size
  if not CryptStringToBinary(PChar(ABase64), Length(ABase64), Ord(FFlag),
    nil, BufferSize, Skipped, Flags) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  SetLength(Result, BufferSize);

  // Decode text
  if not CryptStringToBinary(PChar(ABase64), Length(ABase64), Ord(FFlag),
    Pointer(PChar(Result)), BufferSize, Skipped, Flags) then
    raise Exception.Create(SysErrorMessage(GetLastError()));
end;

{ public TBase64.Encode

  Encodes a Base64 string value to a string. }

function TBase64.Encode(const AText: string): string;
begin
  Result := PChar(EncodeBinary(AText));
end;

{ public TBase64.EncodeBinary

  Encodes a Base64 binary value to a string. }

function TBase64.EncodeBinary(const AText: string): TBytes;
var
  BufferSize: Cardinal;

begin
  // Retrieve and set required buffer size
  if not CryptBinaryToString(PChar(AText), Length(AText), Ord(FFlag),
    nil, BufferSize) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  SetLength(Result, BufferSize);

  // Encode text
  if not CryptBinaryToString(PChar(AText), Length(AText), Ord(FFlag),
    @Result[0], BufferSize) then
    raise Exception.Create(SysErrorMessage(GetLastError()));
end;


{ TCryptBase }

{ protected TCryptBase.DeriveKey

  Derives a symmetric key from a password string. }

function TCryptBase.DeriveKey(ACryptProvider: HCRYPTPROV;
  const APassword: string; AHashAlgorithm: THashAlgorithm;
  APasswordEncryptionAlgorithm: TCryptAlgorithm): HCRYPTKEY;
var
  PasswordHash: HCRYPTHASH;

begin
  Result := 0;

  // Init password hash object
  if not CryptCreateHash(ACryptProvider, THashAlgId[AHashAlgorithm], 0, 0,
    PasswordHash) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  try
    // Create hash of the password
    if not CryptHashData(PasswordHash, PChar(APassword), Length(APassword), 0) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    // Derive symmetric key from password
    if not CryptDeriveKey(ACryptProvider, TCryptAlgId[APasswordEncryptionAlgorithm],
      PasswordHash, 0, Result) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

  finally
    CryptDestroyHash(PasswordHash);
  end;  //of try
end;

{ public TCryptBase.HashToString

  Creates a string from a hash in buffer. }

function TCryptBase.HashToString(HashHandle: HCRYPTHASH): string;
var
  Hash: TBytes;
  HashLength, HashSize: Cardinal;
  i: Byte;

begin
  HashSize := SizeOf(DWORD);

  // Retrieve the length (in Byte) of the hash
  if not CryptGetHashParam(HashHandle, HP_HASHSIZE, @HashLength, HashSize, 0) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  // Resize the buffer to the blocksize of the used hash algorithm
  SetLength(Hash, HashLength * 8);

  // Load the hash value into buffer
  if not CryptGetHashParam(HashHandle, HP_HASHVAL, @Hash[0], HashLength, 0) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  // Build a string from buffer
  for i := 0 to HashLength - 1 do
    Result := Result + IntToHex(Hash[i], 2);

  Result := AnsiLowerCase(Result);
end;


{ THash }

{ public THash.Create

  Constructor for creating a THash instance. }

constructor THash.Create(AHashAlgorithm: THashAlgorithm);
begin
  inherited Create;
  FHashAlgorithm := AHashAlgorithm;
end;

{ public THash.Hash

  Uses the internal Windows implementation of well-known hash algorithms e.g.
  SHA or MD5 to create a hash from a string. }

function THash.Hash(const AString: string): string;
var
  CryptProvider: HCRYPTPROV;
  HashHandle: HCRYPTHASH;

begin
  if not CryptAcquireContext(CryptProvider, nil, nil, PROV_RSA_AES,
    CRYPT_VERIFYCONTEXT or CRYPT_MACHINE_KEYSET) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  // Init hash object
  if not CryptCreateHash(CryptProvider, THashAlgId[FHashAlgorithm], 0, 0, HashHandle) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  try
    // Create the hash of the string
    if not CryptHashData(HashHandle, PChar(AString), Length(AString), 0) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    Result := HashToString(HashHandle);

  finally
    CryptDestroyHash(HashHandle);
    CryptReleaseContext(CryptProvider, 0);
  end;  //of try
end;

{ public THash.HashFile

  Uses the internal Windows implementation of well-known hash algorithms e.g.
  SHA or MD5 to create a hash from a file. }

function THash.HashFile(const AFileName: TFileName): string;
var
  CryptProvider: HCRYPTPROV;
  HashHandle: HCRYPTHASH;
  Buffer: array[0..1023] of Byte;
  FileToHash: TFileStream;
  Algorithm, BytesRead: Cardinal;

begin
  // Open file
  FileToHash := TFileStream.Create(AFileName, fmOpenRead);

  // Use chosen hash algorithm
  Algorithm := THashAlgId[FHashAlgorithm];

  try
    if not CryptAcquireContext(CryptProvider, nil, nil, PROV_RSA_AES,
      CRYPT_VERIFYCONTEXT) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    // Init hash object
    if not CryptCreateHash(CryptProvider, Algorithm, 0, 0, HashHandle) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    // Notify start of file hashing
    if Assigned(FOnStart) then
      FOnStart(Self, FileToHash.Size);

    // Read first KB of file into buffer
    BytesRead := FileToHash.Read(Buffer, Length(Buffer));

    // EOF?
    while (BytesRead <> 0) do
    begin
      if Assigned(FOnProgress) then
        FOnProgress(Self, BytesRead);

      // Create hash of read bytes in buffer
      if not CryptHashData(HashHandle, @Buffer, BytesRead, 0) then
        raise Exception.Create(SysErrorMessage(GetLastError()));

      // Read next KB of file into buffer
      BytesRead := FileToHash.Read(Buffer, Length(Buffer));
    end;  //of while

    Result := HashToString(HashHandle);

  finally
    FileToHash.Free;
    CryptDestroyHash(HashHandle);
    CryptReleaseContext(CryptProvider, 0);

    // Notify end of file hashing
    if Assigned(FOnFinish) then
      FOnFinish(Self);
  end;  //of try
end;

{ public THash.VerifyHash

  Verifies a hash from a string. }

function THash.VerifyHash(const AHash, AString: string): Boolean;
begin
  Result := AnsiSameText(AHash, Hash(AString));
end;

{ public THash.VerifyFileHash

  Verifies a hash from a file. }

function THash.VerifyFileHash(const AHash, AFileName: TFileName): Boolean;
begin
  Result := AnsiSameText(AHash, HashFile(AFileName));
end;


{ THMac }

{ public THMac.Create

  Constructor for creating a THMac instance. }

constructor THMac.Create(AHashAlgorithm: THashAlgorithm;
  APasswordEncryptionAlgorithm: TCryptAlgorithm = caAes128);
begin
  inherited Create;
  FHashAlgorithm := AHashAlgorithm;
  FPasswordEncryptionAlgorithm := APasswordEncryptionAlgorithm;
end;

{ public THMac.HMac

  Uses the internal Windows implementation of well-known hash algorithms e.g.
  SHA or MD5 to create a HMAC from a message with password. }

function THMac.HMac(const AMessage, APassword: string): string;
var
  CryptProvider: HCRYPTPROV;
  HMacHash: HCRYPTHASH;
  Hmac: HMAC_INFO;
  Key: HCRYPTKEY;

begin
  if not CryptAcquireContext(CryptProvider, nil, nil, PROV_RSA_AES,
    CRYPT_VERIFYCONTEXT) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  Key := DeriveKey(CryptProvider, APassword, FHashAlgorithm,
    FPasswordEncryptionAlgorithm);

  try
    // Init HMAC with usage of derived key
    if not CryptCreateHash(CryptProvider, CALG_HMAC, Key, 0, HMacHash) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    // Init HMAC object
    FillChar(Hmac, SizeOf(Hmac), 0);
    Hmac.HashAlgId := THashAlgId[FHashAlgorithm];

    // Set HMAC parameters
    if not CryptSetHashParam(HMacHash, HP_HMAC_INFO, @Hmac, 0) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    // Create hash of the string
    if not CryptHashData(HMacHash, PChar(AMessage), Length(AMessage), 0) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    Result := HashToString(HMacHash);

  finally
    CryptDestroyHash(HMacHash);
    CryptDestroyKey(Key);
    CryptReleaseContext(CryptProvider, 0);
  end;  //of try
end;


{ public StringToBytes

  Converts a string value into a byte array. }

function StringToBytes(const AString: string): TBytes;
var
  BinarySize: Integer;

begin
  BinarySize := (Length(AString) + 1) * SizeOf(Char);
  SetLength(Result, BinarySize);
  Move(AString[1], Result[0], BinarySize);
end;

end.
