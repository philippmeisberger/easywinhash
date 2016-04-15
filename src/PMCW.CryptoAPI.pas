{ *********************************************************************** }
{                                                                         }
{ Windows CryptoAPI Unit v1.1                                             }
{                                                                         }
{ Copyright (c) 2011-2016 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit PMCW.CryptoAPI;

interface

uses
  Winapi.Windows, Classes, SysUtils, Winapi.WinCrypt;

type
  /// <summary>
  ///   General flags for the Base64 encoding/decoding.
  /// </summary>
  TBase64Flag = (
    bfHeader, bfDefault, bfBinary, bfRequestHeader, bfHex, bfHexAscii,
    bfBase64Any, bfAny, bfHexAny, bfX509CrlHeader, bfHexAddr, bfHexAsciiAddr,
    bfHexRaw, bfStrict
  );

  /// <summary>
  ///   Additional flags for the Base64 encoding/decoding.
  /// </summary>
  TBase64AdditionalFlag = (

    /// <summary>
    ///   No special options.
    /// </summary>
    bfNone,

    /// <summary>
    ///   Output has no CRLF at the end.
    /// </summary>
    bfNoCRLF,

    /// <summary>
    ///   Output has no CR at the end.
    /// </summary>
    bfNoCR
  );

  /// <summary>
  ///   A <c>TBase64</c> is a Base64 encoder/decoder.
  /// </summary>
  TBase64 = class(TObject)
  private
    FFlag: TBase64Flag;
  public
    /// <summary>
    ///   Constructor for creating a <c>TBase64</c> instance.
    /// </summary>
    /// <param name="AFlag">
    ///   A <see cref="TBase64Flag"/> special encoding flag that influences the
    ///   output.
    /// </param>
    constructor Create(AFlag: TBase64Flag = bfDefault);

    /// <summary>
    ///   Decodes a Base64 string value to a string.
    /// </summary>
    /// <param name="ABase64">
    ///   A Base64 string value.
    /// </param>
    /// <returns>
    ///   The decoded Base64 string value.
    /// </returns>
    function Decode(const ABase64: string): string;

    /// <summary>
    ///   Decodes a Base64 binary value to a string.
    /// </summary>
    /// <param name="ABase64">
    ///   A Base64 binary value.
    /// </param>
    /// <returns>
    ///   The decoded Base64 string value.
    /// </returns>
    function DecodeBinary(const ABase64: TBytes): string; overload;

    /// <summary>
    ///   Decodes a Base64 string to a binary string.
    /// </summary>
    /// <param name="ABase64">
    ///   A Base64 string value.
    /// </param>
    /// <returns>
    ///   The decoded Base64 binary value.
    /// </returns>
    function DecodeBinary(const ABase64: string): TBytes; overload;

    /// <summary>
    ///   Encodes a string value to a Base64 string.
    /// </summary>
    /// <param name="ABase64">
    ///   A Base64 string value.
    /// </param>
    /// <param name="AAdditionalFlag">
    ///   A <see cref="TBase64AdditionalFlag"/> additional encoding flag.
    /// </param>
    /// <returns>
    ///   The encoded Base64 string value.
    /// </returns>
    function Encode(const AString: string;
      AAdditionalFlag: TBase64AdditionalFlag = bfNone): string;

    /// <summary>
    ///   Encodes a binary value to a Base64 string.
    /// </summary>
    /// <param name="AData">
    ///   A binary value.
    /// </param>
    /// <param name="AAdditionalFlag">
    ///   A <see cref="TBase64AdditionalFlag"/> additional encoding flag.
    /// </param>
    /// <returns>
    ///   The encoded Base64 string value.
    /// </returns>
    function EncodeBinary(const AData: TBytes;
      AAdditionalFlag: TBase64AdditionalFlag = bfNone): string; overload;

    /// <summary>
    ///   Encodes a string value to a Base64 binary value.
    /// </summary>
    /// <param name="AString">
    ///   A string value.
    /// </param>
    /// <param name="AAdditionalFlag">
    ///   A <see cref="TBase64AdditionalFlag"/> additional encoding flag.
    /// </param>
    /// <returns>
    ///   The encoded Base64 binary value.
    /// </returns>
    function EncodeBinary(const AString: string;
      AAdditionalFlag: TBase64AdditionalFlag = bfNone): TBytes; overload;

    /// <summary>
    ///   A <see cref="TBase64Flag"/> special encoding flag that influences the
    ///   output.
    /// </summary>
    property Flag: TBase64Flag read FFlag write FFlag;
  end;

  /// <summary>
  ///   Possible hash algorithms.
  /// </summary>
  THashAlgorithm = (

    /// <summary>
    ///   The MD5 hash algorithm.
    /// </summary>
    /// <remarks>
    ///   Do not use! Better use a SHA hash algorithm.
    /// </remarks>
    haMd5,

    /// <summary>
    ///   The SHA-160 better known as SHA-1 hash algorithm.
    /// </summary>
    haSha,
    /// <summary>
    ///   The SHA-256 hash algorithm.
    /// </summary>
    haSha256,

    /// <summary>
    ///   The SHA-384 hash algorithm.
    /// </summary>
    haSha384,

    /// <summary>
    ///   The SHA-512 hash algorithm.
    /// </summary>
    haSha512
  );

  /// <summary>
  ///   Possible encryption algorithms.
  /// </summary>
  TCryptAlgorithm = (

    /// <summary>
    ///   The AES-128 encryption algorithm.
    /// </summary>
    caAes128,

    /// <summary>
    ///   The AES-192 encryption algorithm.
    /// </summary>
    caAes192,

    /// <summary>
    ///   The AES-256 encryption algorithm.
    /// </summary>
    caAes256
  );

  { Events }
  TFileHashEvent = procedure(Sender: TObject; const AProgress, AProgressMax: Int64;
    var ACancel: Boolean) of object;

  /// <summary>
  ///   The base class for encryption and hashing operations.
  /// </summary>
  TCryptBase = class(TObject)
  protected
    /// <summary>
    ///   Derives a symmetric key from a password string.
    /// </summary>
    /// <param name="ACryptProvider">
    ///   The handle to a cryptographic provider.
    /// </param>
    /// <param name="APassword">
    ///   The password used for key derivation.
    /// </param>
    /// <param name="AHashAlgorithm">
    ///   The used hash algorithm.
    /// </param>
    /// <param name="APasswordEncryptionAlgorithm">
    ///   The used encryption algorithm to encrypt the password.
    /// </param>
    /// <returns>
    ///   A symmetric key handle which MUST be freed after usage using
    //   <c>CryptDestroyKey()</c>.
    /// </returns>
    function DeriveKey(ACryptProvider: TCryptProv; const APassword: string;
      AHashAlgorithm: THashAlgorithm;
      APasswordEncryptionAlgorithm: TCryptAlgorithm): TCryptKey; overload;

    /// <summary>
    ///   Derives a symmetric key from a binary password.
    /// </summary>
    /// <param name="ACryptProvider">
    ///   The handle to a cryptographic provider.
    /// </param>
    /// <param name="APassword">
    ///   The password used for key derivation.
    /// </param>
    /// <param name="AHashAlgorithm">
    ///   The used hash algorithm.
    /// </param>
    /// <param name="APasswordEncryptionAlgorithm">
    ///   The used encryption algorithm to encrypt the password.
    /// </param>
    /// <returns>
    ///   A symmetric key handle which MUST be freed after usage using
    ///   <c>CryptDestroyKey()</c>.
    /// </returns>
    function DeriveKey(ACryptProvider: TCryptProv; const APassword: TBytes;
      AHashAlgorithm: THashAlgorithm;
      APasswordEncryptionAlgorithm: TCryptAlgorithm): TCryptKey; overload;

    /// <summary>
    ///   Creates a binary representation from a hash in buffer.
    /// </summary>
    /// <param name="AHashHandle">
    ///   The handle to a hash in buffer.
    /// </param>
    /// <returns>
    ///   A binary hash value.
    /// </returns>
    function HashToBytes(AHashHandle: TCryptHash): TBytes;

    /// <summary>
    ///   Creates a string representation from a hash in buffer.
    /// </summary>
    /// <param name="AHashHandle">
    ///   The handle to a hash in buffer.
    /// </param>
    /// <returns>
    ///   A string hash value.
    /// </returns>
    function HashToString(AHashHandle: TCryptHash): string;
  public
    /// <summary>
    ///   Creates a hex string representation from a binary hash.
    /// </summary>
    /// <param name="AHash">
    ///   The binary hash value.
    /// </param>
    /// <returns>
    ///   The hex string hash value.
    /// </returns>
    function ToHex(const AHash: TBytes): string;
  end;

  /// <summary>
  ///  <c>THash</c> provides methods to calculate and verify hash values from
  ///  strings and files.
  /// </summary>
  THash = class(TCryptBase)
  private
    FOnProgress: TFileHashEvent;
    FOnStart,
    FOnFinish: TNotifyEvent;
    FHashAlgorithm: THashAlgorithm;
  public
    /// <summary>
    ///   Constructor for creating a <c>THash</c> instance.
    /// </summary>
    /// <param name="AHashAlgorithm">
    ///   The hash algorithm to use.
    /// </param>
    constructor Create(AHashAlgorithm: THashAlgorithm);

    /// <summary>
    ///   Generates a random salt of specified length.
    /// </summary>
    /// <param name="ALength">
    ///   The length of the salt in bytes.
    /// </param>
    /// <returns>
    ///   A Base64 encoded salt.
    /// </returns>
    function GenerateSalt(ALength: DWORD): string;

    /// <summary>
    ///   Creates a hash from a byte array.
    /// </summary>
    /// <param name="AData">
    ///   The bytes to be hashed.
    /// </param>
    /// <returns>
    ///   The hash.
    /// </returns>
    function Compute(const AData: TBytes): TBytes; overload;

    /// <summary>
    ///   Creates a hash from a string.
    /// </summary>
    /// <param name="AString">
    ///   The string to be hashed.
    /// </param>
    /// <param name="ASalt">
    ///   Optional: A salt.
    /// </param>
    /// <returns>
    ///   The hash.
    /// </returns>
    function Compute(const AString: string; const ASalt: string = ''): string; overload;

    /// <summary>
    ///   Creates a hash from a file.
    /// </summary>
    /// <param name="AFileName">
    ///   The absolute path to a file.
    /// </param>
    /// <returns>
    ///   The hash of the file.
    /// </returns>
    function Compute(const AFileName: TFileName): string; overload;

    /// <summary>
    ///   Verifies the hash from a string.
    /// </summary>
    /// <param name="AHash">
    ///   The hash to be verified.
    /// </param>
    /// <param name="AString">
    ///   The string to be verified.
    /// </param>
    /// <param name="ASalt">
    ///   Optional: The used salt.
    /// </param>
    /// <returns>
    ///   <c>True</c> if the hash matches to the string or <c>False</c> otherwise.
    /// </returns>
    function Verify(const AHash, AString: string; const ASalt: string = ''): Boolean; overload;

    /// <summary>
    ///   Verifies the hash from a file.
    /// </summary>
    /// <param name="AHash">
    ///   The hash to be verified.
    /// </param>
    /// <param name="AFileName">
    ///   The absolute path to a file.
    /// </param>
    /// <returns>
    ///   <c>True</c> if the hash matches to the file or <c>False</c> otherwise.
    /// </returns>
    function Verify(const AHash: string; AFileName: TFileName): Boolean; overload;

    /// <summary>
    ///   Gets or sets the used hash algorithm.
    /// </summary>
    property Algorithm: THashAlgorithm read FHashAlgorithm write FHashAlgorithm;

    /// <summary>
    ///   Event that is called when hash calculation has finished.
    /// </summary>
    property OnFinish: TNotifyEvent read FOnFinish write FOnFinish;

    /// <summary>
    ///   Event that is called during hash calculation.
    /// </summary>
    property OnProgress: TFileHashEvent read FOnProgress write FOnProgress;

    /// <summary>
    ///   Event that is called when hash calculation has started.
    /// </summary>
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
  end;

  /// <summary>
  ///   <c>THMac</c> provides methods to calculate keyed hash values (HMACs)
  ///   from strings and binary data.
  /// </summary>
  THMac = class(TCryptBase)
  private
    FHashAlgorithm: THashAlgorithm;
    FPasswordEncryptionAlgorithm: TCryptAlgorithm;
  public
    /// <summary>
    ///   Constructor for creating a <c>THMac</c> instance.
    /// </summary>
    /// <param name="AHashAlgorithm">
    ///   The used hash algorithm.
    /// </param>
    /// <param name="APasswordEncryptionAlgorithm">
    ///   The used encryption algorithm.
    /// </param>
    constructor Create(AHashAlgorithm: THashAlgorithm;
      APasswordEncryptionAlgorithm: TCryptAlgorithm = caAes128);

    /// <summary>
    ///   Creates an HMAC from binary data.
    /// </summary>
    /// <param name="AData">
    ///   The data to be hashed.
    /// </param>
    /// <param name="APassphrase">
    ///   The used passphrase for encryption.
    /// </param>
    /// <returns>
    ///   The HMAC.
    /// </returns>
    function Compute(const AData: TBytes; const APassphrase: string): string; overload;

    /// <summary>
    ///   Creates an HMAC from a string.
    /// </summary>
    /// <param name="AData">
    ///   The string to be hashed.
    /// </param>
    /// <param name="APassphrase">
    ///   The used passphrase for encryption.
    /// </param>
    /// <returns>
    ///   The HMAC.
    /// </returns>
    function Compute(const AString, APassphrase: string): string; overload;
  end experimental;

implementation

type
  THashAlgorithmHelper = record helper for THashAlgorithm
    function GetHashAlgorithm(): ALG_ID;
  end;

  TBase64FlagHelper = record helper for TBase64Flag
    function GetFlag(): DWORD;
  end;

{ THashAlgorithmHelper }

function THashAlgorithmHelper.GetHashAlgorithm(): ALG_ID;
begin
  case Self of
    haMd5:    Result := CALG_MD5;
    haSha:    Result := CALG_SHA_160;
    haSha256: Result := CALG_SHA_256;
    haSha384: Result := CALG_SHA_384;
    haSha512: Result := CALG_SHA_512;
    else      Result := 0;
  end;  //of case
end;


{ TBase64FlagHelper }

function TBase64FlagHelper.GetFlag(): DWORD;
begin
  case Self of
    bfHeader:        Result := CRYPT_STRING_BASE64HEADER;
    bfDefault:       Result := CRYPT_STRING_BASE64;
    bfBinary:        Result := CRYPT_STRING_BINARY;
    bfRequestHeader: Result := CRYPT_STRING_BASE64REQUESTHEADER;
    bfHex:           Result := CRYPT_STRING_HEX;
    bfHexAscii:      Result := CRYPT_STRING_HEXASCII;
    bfBase64Any:     Result := CRYPT_STRING_BASE64_ANY;
    bfAny:           Result := CRYPT_STRING_ANY;
    bfHexAny:        Result := CRYPT_STRING_HEX_ANY;
    bfX509CrlHeader: Result := CRYPT_STRING_BASE64X509CRLHEADER;
    bfHexAddr:       Result := CRYPT_STRING_HEXADDR;
    bfHexAsciiAddr:  Result := CRYPT_STRING_HEXASCIIADDR;
    bfHexRaw:        Result := CRYPT_STRING_HEXRAW;
    bfStrict:        Result := CRYPT_STRING_STRICT;
    else             Result := CRYPT_STRING_BASE64;
  end;  //of case
end;


{ TBase64 }

constructor TBase64.Create(AFlag: TBase64Flag = bfDefault);
begin
  inherited Create;
  FFlag := AFlag;
end;

function TBase64.Decode(const ABase64: string): string;
begin
  Result := StringOf(DecodeBinary(ABase64));
end;

function TBase64.DecodeBinary(const ABase64: TBytes): string;
begin
  Result := StringOf(DecodeBinary(StringOf(ABase64)));
end;

function TBase64.DecodeBinary(const ABase64: string): TBytes;
var
  BufferSize, Skipped, Flags: DWORD;

begin
  // Retrieve and set required buffer size
  if not CryptStringToBinary(PChar(ABase64), Length(ABase64), FFlag.GetFlag(),
    nil, BufferSize, Skipped, Flags) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  SetLength(Result, BufferSize);

  // Decode string
  if not CryptStringToBinary(PChar(ABase64), Length(ABase64), FFlag.GetFlag(),
    @Result[0], BufferSize, Skipped, Flags) then
    raise Exception.Create(SysErrorMessage(GetLastError()));
end;

function TBase64.Encode(const AString: string;
  AAdditionalFlag: TBase64AdditionalFlag = bfNone): string;
begin
  Result := EncodeBinary(BytesOf(AString), AAdditionalFlag);
end;

function TBase64.EncodeBinary(const AData: TBytes;
  AAdditionalFlag: TBase64AdditionalFlag = bfNone): string;
const
  cAdditionalFlags: array[TBase64AdditionalFlag] of DWORD = (
    0,
    CRYPT_STRING_NOCRLF,
    CRYPT_STRING_NOCR
  );

var
  BufferSize: DWORD;

begin
  // Retrieve and set required buffer size
  if not CryptBinaryToString(@AData[0], Length(AData), FFlag.GetFlag() +
    cAdditionalFlags[AAdditionalFlag], nil, BufferSize) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  SetLength(Result, BufferSize);

  // Encode string
  if not CryptBinaryToString(@AData[0], Length(AData), FFlag.GetFlag() +
    cAdditionalFlags[AAdditionalFlag], PChar(Result), BufferSize) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  // Remove null-terminator
  Result := PChar(Result);
end;

function TBase64.EncodeBinary(const AString: string;
  AAdditionalFlag: TBase64AdditionalFlag = bfNone): TBytes;
begin
  Result := BytesOf(EncodeBinary(BytesOf(AString), AAdditionalFlag));
end;


{ TCryptBase }

function TCryptBase.DeriveKey(ACryptProvider: TCryptProv;
  const APassword: TBytes; AHashAlgorithm: THashAlgorithm;
  APasswordEncryptionAlgorithm: TCryptAlgorithm): TCryptKey;
const
  cEncryptionAlgorithms: array[TCryptAlgorithm] of ALG_ID = (
    CALG_AES_128,
    CALG_AES_192,
    CALG_AES_256
  );

var
  PasswordHash: TCryptHash;

begin
  Result := 0;

  // Init password hash object
  if not CryptCreateHash(ACryptProvider, AHashAlgorithm.GetHashAlgorithm(), 0, 0,
    PasswordHash) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  try
    // Create hash of the password
    if not CryptHashData(PasswordHash, @APassword[0], Length(APassword), 0) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    // Derive symmetric key from password
    if not CryptDeriveKey(ACryptProvider, cEncryptionAlgorithms[APasswordEncryptionAlgorithm],
      PasswordHash, 0, Result) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

  finally
    CryptDestroyHash(PasswordHash);
  end;  //of try
end;

function TCryptBase.DeriveKey(ACryptProvider: TCryptProv;
  const APassword: string; AHashAlgorithm: THashAlgorithm;
  APasswordEncryptionAlgorithm: TCryptAlgorithm): TCryptKey;
begin
  Result := DeriveKey(ACryptProvider, BytesOf(APassword), AHashAlgorithm,
    APasswordEncryptionAlgorithm);
end;

function TCryptBase.HashToBytes(AHashHandle: TCryptHash): TBytes;
var
  HashLength, HashSize: DWORD;

begin
  HashSize := SizeOf(DWORD);

  // Retrieve the length (in Byte) of the hash
  if not CryptGetHashParam(AHashHandle, HP_HASHSIZE, @HashLength, HashSize, 0) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  // Resize the buffer to the blocksize of the used hash algorithm
  SetLength(Result, HashLength);

  // Load the hash value into buffer
  if not CryptGetHashParam(AHashHandle, HP_HASHVAL, @Result[0], HashLength, 0) then
    raise Exception.Create(SysErrorMessage(GetLastError()));
end;

function TCryptBase.HashToString(AHashHandle: TCryptHash): string;
begin
  Result := ToHex(HashToBytes(AHashHandle));
end;

function TCryptBase.ToHex(const AHash: TBytes): string;
var
  i, Bytes: Integer;

begin
  Bytes := SizeOf(Char);

  // Build a string from buffer
  for i := Low(AHash) to High(AHash) do
    Result := Result + IntToHex(AHash[i], Bytes);

  Result := LowerCase(Result);
end;


{ THash }

constructor THash.Create(AHashAlgorithm: THashAlgorithm);
begin
  inherited Create;
  FHashAlgorithm := AHashAlgorithm;
end;

function THash.GenerateSalt(ALength: DWORD): string;
var
  CryptProvider: TCryptProv;
  Salt: TBytes;
  Base64: TBase64;

begin
  Result := '';

  if (ALength = 0) then
    Exit;

  if not CryptAcquireContext(CryptProvider, nil, nil, PROV_RSA_AES,
    CRYPT_VERIFYCONTEXT or CRYPT_MACHINE_KEYSET) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  Base64 := TBase64.Create;

  try
    SetLength(Salt, ALength);

    if not CryptGenRandom(CryptProvider, ALength, @Salt[0]) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    Result := Base64.EncodeBinary(Salt, bfNoCRLF);

  finally
    Base64.Free;
  end;  //of try
end;

function THash.Compute(const AData: TBytes): TBytes;
var
  CryptProvider: TCryptProv;
  HashHandle: TCryptHash;

begin
  if not CryptAcquireContext(CryptProvider, nil, nil, PROV_RSA_AES,
    CRYPT_VERIFYCONTEXT or CRYPT_MACHINE_KEYSET) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  // Init hash object
  if not CryptCreateHash(CryptProvider, FHashAlgorithm.GetHashAlgorithm(), 0, 0,
    HashHandle) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  try
    // Create the hash of the string
    if not CryptHashData(HashHandle, @AData[0], Length(AData), 0) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    Result := HashToBytes(HashHandle);

  finally
    CryptDestroyHash(HashHandle);
    CryptReleaseContext(CryptProvider, 0);
  end;  //of try
end;

function THash.Compute(const AString: string; const ASalt: string = ''): string;
begin
  Result := ToHex(Compute(BytesOf(ASalt + AString)));
end;

function THash.Compute(const AFileName: TFileName): string;
var
  CryptProvider: TCryptProv;
  HashHandle: TCryptHash;
  Buffer: array[0..1023] of Byte;
  FileToHash: TFileStream;
  BytesRead: Integer;
  Cancel: Boolean;

begin
  // Open file
  FileToHash := TFileStream.Create(AFileName, fmOpenRead);

  try
    if not CryptAcquireContext(CryptProvider, nil, nil, PROV_RSA_AES,
      CRYPT_VERIFYCONTEXT) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    // Init hash object
    if not CryptCreateHash(CryptProvider, FHashAlgorithm.GetHashAlgorithm(), 0,
      0, HashHandle) then
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
      if not CryptHashData(HashHandle, @Buffer[0], BytesRead, 0) then
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

function THash.Verify(const AHash, AString: string; const ASalt: string = ''): Boolean;
begin
  Result := AnsiSameStr(AHash, Compute(AString, ASalt));
end;

function THash.Verify(const AHash: string; AFileName: TFileName): Boolean;
begin
  Result := AnsiSameStr(AHash, Compute(AFileName));
end;


{ THMac }

constructor THMac.Create(AHashAlgorithm: THashAlgorithm;
  APasswordEncryptionAlgorithm: TCryptAlgorithm = caAes128);
begin
  inherited Create;
  FHashAlgorithm := AHashAlgorithm;
  FPasswordEncryptionAlgorithm := APasswordEncryptionAlgorithm;
end;

function THMac.Compute(const AData: TBytes; const APassphrase: string): string;
var
  CryptProvider: TCryptProv;
  HMacHash: TCryptHash;
  Hmac: THMacInfo;
  Key: TCryptKey;

begin
  if not CryptAcquireContext(CryptProvider, nil, nil, PROV_RSA_AES,
    CRYPT_VERIFYCONTEXT) then
    raise Exception.Create(SysErrorMessage(GetLastError()));

  Key := DeriveKey(CryptProvider, APassphrase, FHashAlgorithm,
    FPasswordEncryptionAlgorithm);

  try
    // Init HMAC with usage of derived key
    if not CryptCreateHash(CryptProvider, CALG_HMAC, Key, 0, HMacHash) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    // Init HMAC object
    //ZeroMemory(@Hmac, SizeOf(THMacInfo));
    Hmac.HashAlgId := FHashAlgorithm.GetHashAlgorithm();

    // Set HMAC parameters
    if not CryptSetHashParam(HMacHash, HP_HMAC_INFO, @Hmac, 0) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    // Create hash of the string
    if not CryptHashData(HMacHash, @AData[0], Length(AData), 0) then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    Result := HashToString(HMacHash);

  finally
    CryptDestroyHash(HMacHash);
    CryptDestroyKey(Key);
    CryptReleaseContext(CryptProvider, 0);
  end;  //of try
end;

function THMac.Compute(const AString, APassphrase: string): string;
begin
  Result := Compute(BytesOf(AString), APassphrase);
end;

end.
