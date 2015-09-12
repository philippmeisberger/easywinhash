{ *********************************************************************** }
{                                                                         }
{ Windows CryptoAPI Unit v1.0.1                                           }
{                                                                         }
{ Copyright (c) 2011-2015 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit CryptoAPI;

interface

uses
  Windows, Classes, SysUtils, WinCrypt;

type
  { TBase64Flag }
  TBase64Flag = (
    bfHeader, bfDefault, bfBinary, bfRequestHeader, bfHex, bfHexAscii,
    bfBase64Any, bfAny, bfHexAny, bfX509CrlHeader, bfHexAddr, bfHexAsciiAddr,
    bfHexRaw, bfStrict
  );

  { TBase64AdditionalFlag }
  TBase64AdditionalFlag = (
    bfNone, bfNoCRLF, bfNoCR
  );

  { TBase64 }
  TBase64 = class(TObject)
  private
    FFlag: TBase64Flag;
  public
    constructor Create(AFlag: TBase64Flag = bfDefault);
    function Decode(const ABase64: string): string;
    function DecodeBinary(const ABase64: TBytes): string; overload;
    function DecodeBinary(const ABase64: string): TBytes; overload;
    function Encode(const AString: string;
      AAdditionalFlag: TBase64AdditionalFlag = bfNone): string;
    function EncodeBinary(const AData: TBytes;
      AAdditionalFlag: TBase64AdditionalFlag = bfNone): string; overload;
    function EncodeBinary(const AString: string;
      AAdditionalFlag: TBase64AdditionalFlag = bfNone): TBytes; overload;
    { external }
    property Flag: TBase64Flag read FFlag write FFlag;
  end;

  { THashAlgorithm }
  THashAlgorithm = (
    haMd5, haSha, haSha256, haSha384, haSha512
  );

  { TCryptAlgorithm }
  TCryptAlgorithm = (
    caAes128, caAes192, caAes256
  );

  { Events }
  TFileHashEvent = procedure(Sender: TObject; const AProgress, AProgressMax: Int64;
    var ACancel: Boolean) of object;

  { TCryptBase }
  TCryptBase = class(TObject)
  protected
    function DeriveKey(ACryptProvider: HCRYPTPROV; const APassword: string;
      AHashAlgorithm: THashAlgorithm;
      APasswordEncryptionAlgorithm: TCryptAlgorithm): HCRYPTKEY;
    function HashToString(AHashHandle: HCRYPTHASH): string;
  end;

  { THash }
  THash = class(TCryptBase)
  private
    FOnProgress: TFileHashEvent;
    FOnStart,
    FOnFinish: TNotifyEvent;
    FHashAlgorithm: THashAlgorithm;
  public
    constructor Create(AHashAlgorithm: THashAlgorithm); overload;
    function GenerateSalt(ALength: Cardinal): string;
    function Hash(const AString: string): string;
    function HashFile(const AFileName: TFileName): string;
    function HashSalted(const AString, ASalt: string): string;
    function VerifyHash(const AHash, AString: string): Boolean;
    function VerifyHashSalted(const AHash, AString, ASalt: string): Boolean;
    function VerifyFileHash(const AHash, AFileName: TFileName): Boolean;
    { external }
    property Algorithm: THashAlgorithm read FHashAlgorithm write FHashAlgorithm;
    property OnFinish: TNotifyEvent read FOnFinish write FOnFinish;
    property OnProgress: TFileHashEvent read FOnProgress write FOnProgress;
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
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
  { Enumeration to additional Base64 flag translator }
  TBase64AddFlag: array[TBase64AdditionalFlag] of Cardinal = (
    0,
    CRYPT_STRING_NOCRLF,
    CRYPT_STRING_NOCR
  );

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

{$IFNDEF UNICODE}
{ Backward compatibility for older Delphi versions }
type
  TBytes: array of Byte;

function BytesOf(AString: string): TBytes;
begin
  Result := TBytes(AString);
end;

function StringOf(ABytes: TBytes): string;
begin
  Result := PChar(ABytes);
end;
{$ENDIF}


implementation

{ TBase64 }

{ public TBase64.Create

  Constructor for creating a TBase64 instance. }

constructor TBase64.Create(AFlag: TBase64Flag = bfDefault);
begin
  inherited Create;
  FFlag := AFlag;
end;

{ public TBase64.Decode

  Decodes a Base64 string value to a string. }

function TBase64.Decode(const ABase64: string): string;
begin
  Result := StringOf(DecodeBinary(ABase64));
end;

{ public TBase64.DecodeBinary

  Decodes a Base64 binary value to a string. }

function TBase64.DecodeBinary(const ABase64: TBytes): string;
begin
  Result := StringOf(DecodeBinary(StringOf(ABase64)));
end;

{ public TBase64.DecodeBinary

  Decodes a Base64 string to a binary string. }

function TBase64.DecodeBinary(const ABase64: string): TBytes;
var
  BufferSize, Skipped, Flags: Cardinal;

begin
  // Retrieve and set required buffer size
  if not CryptStringToBinary(PChar(ABase64), Length(ABase64), Ord(FFlag),
    nil, BufferSize, Skipped, Flags) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  SetLength(Result, BufferSize);

  // Decode string
  if not CryptStringToBinary(PChar(ABase64), Length(ABase64), Ord(FFlag),
    PByte(Result), BufferSize, Skipped, Flags) then
    raise Exception.Create(SysErrorMessage(GetLastError()));
end;

{ public TBase64.Encode

  Encodes a string value to a Base64 string. }

function TBase64.Encode(const AString: string;
  AAdditionalFlag: TBase64AdditionalFlag = bfNone): string;
begin
  Result := EncodeBinary(BytesOf(AString), AAdditionalFlag);
end;

{ public TBase64.EncodeBinary

  Encodes a binary value to a Base64 string. }

function TBase64.EncodeBinary(const AData: TBytes;
  AAdditionalFlag: TBase64AdditionalFlag = bfNone): string;
var
  BufferSize: Cardinal;

begin
  // Retrieve and set required buffer size
  if not CryptBinaryToString(Pointer(AData), Length(AData), Ord(FFlag) +
    TBase64AddFlag[AAdditionalFlag], nil, BufferSize) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  SetLength(Result, BufferSize);

  // Encode string
  if not CryptBinaryToString(Pointer(AData), Length(AData), Ord(FFlag) +
    TBase64AddFlag[AAdditionalFlag], PChar(Result), BufferSize) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  // Remove null-terminator
  Result := PChar(Result);
end;

{ public TBase64.EncodeBinary

  Encodes a string value to a Base64 binary value. }

function TBase64.EncodeBinary(const AString: string;
  AAdditionalFlag: TBase64AdditionalFlag = bfNone): TBytes;
begin
  Result := BytesOf(EncodeBinary(BytesOf(AString), AAdditionalFlag));
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

function TCryptBase.HashToString(AHashHandle: HCRYPTHASH): string;
var
  Hash: TBytes;
  HashLength, HashSize: Cardinal;
  i, Bytes: Byte;

begin
  HashSize := SizeOf(DWORD);

  // Retrieve the length (in Byte) of the hash
  if not CryptGetHashParam(AHashHandle, HP_HASHSIZE, @HashLength, HashSize, 0) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  // Resize the buffer to the blocksize of the used hash algorithm
  SetLength(Hash, HashLength);

  // Load the hash value into buffer
  if not CryptGetHashParam(AHashHandle, HP_HASHVAL, @Hash[0], HashLength, 0) then
    raise Exception.Create(SysErrorMessage(GetLastError()));
  
  Bytes := SizeOf(Char);

  // Build a string from buffer
  for i := 0 to HashLength - 1 do
    Result := Result + IntToHex(Hash[i], Bytes);

  Result := LowerCase(Result);
end;


{ THash }

{ public THash.Create

  Constructor for creating a THash instance. }

constructor THash.Create(AHashAlgorithm: THashAlgorithm);
begin
  inherited Create;
  FHashAlgorithm := AHashAlgorithm;
end;

{ public THash.GenerateSalt

  Generates a random salt of specified length. }

function THash.GenerateSalt(ALength: Cardinal): string;
var
  CryptProvider: HCRYPTPROV;
  Salt: TBytes;
  Base64: TBase64;

begin
  Result := '';

  if not CryptAcquireContext(CryptProvider, nil, nil, PROV_RSA_AES,
    CRYPT_VERIFYCONTEXT or CRYPT_MACHINE_KEYSET) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  Base64 := TBase64.Create;

  try
    SetLength(Salt, ALength);

    if not CryptGenRandom(CryptProvider, ALength, PByte(Salt)) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    Result := Base64.EncodeBinary(Salt, bfNoCRLF);

  finally
    Base64.Free;
  end;  //of try
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
    if not CryptHashData(HashHandle, PChar(BytesOf(AString)), Length(AString), 0) then
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
  BytesRead: Cardinal;
  Cancel: Boolean;

begin
  // Open file
  FileToHash := TFileStream.Create(AFileName, fmOpenRead);

  try
    if not CryptAcquireContext(CryptProvider, nil, nil, PROV_RSA_AES,
      CRYPT_VERIFYCONTEXT) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    // Init hash object
    if not CryptCreateHash(CryptProvider, THashAlgId[FHashAlgorithm], 0, 0, HashHandle) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    // Notify start of file hashing
    if Assigned(FOnStart) then
      FOnStart(Self);

    // Read first KB of file into buffer
    BytesRead := FileToHash.Read(Buffer, Length(Buffer));
    Cancel := False;

    // EOF?
    while ((BytesRead <> 0) and not Cancel) do
    begin
      if Assigned(FOnProgress) then
        FOnProgress(Self, BytesRead, FileToHash.Size, Cancel);

      // Create hash of read bytes in buffer
      if not CryptHashData(HashHandle, @Buffer, BytesRead, 0) then
        raise Exception.Create(SysErrorMessage(GetLastError()));

      // Read next KB of file into buffer
      BytesRead := FileToHash.Read(Buffer, Length(Buffer));
    end;  //of while

    if not Cancel then
      Result := HashToString(HashHandle)
    else
      Result := '';

  finally
    FileToHash.Free;
    CryptDestroyHash(HashHandle);
    CryptReleaseContext(CryptProvider, 0);

    // Notify end of file hashing
    if Assigned(FOnFinish) then
      FOnFinish(Self);
  end;  //of try
end;

{ public THash.Hash

  Uses the internal Windows implementation of well-known hash algorithms e.g.
  SHA or MD5 to create a salted hash from a string. }

function THash.HashSalted(const AString, ASalt: string): string;
begin
  Result := Hash(ASalt + AString);
end;

{ public THash.VerifyHash

  Verifies a hash from a string. }

function THash.VerifyHash(const AHash, AString: string): Boolean;
begin
  Result := AnsiSameStr(AHash, Hash(AString));
end;

{ public THash.VerifyHashSalted

  Verifies a salted hash from a string. }

function THash.VerifyHashSalted(const AHash, AString, ASalt: string): Boolean;
begin
  Result := AnsiSameStr(AHash, HashSalted(AString, ASalt));
end;

{ public THash.VerifyFileHash

  Verifies a hash from a file. }

function THash.VerifyFileHash(const AHash, AFileName: TFileName): Boolean;
begin
  Result := AnsiSameStr(AHash, HashFile(AFileName));
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

end.
