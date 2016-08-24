{ *********************************************************************** }
{                                                                         }
{ Windows CryptoAPI Unit v1.2                                             }
{                                                                         }
{ Copyright (c) 2011-2016 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit PMCW.CryptoAPI;

{$IFDEF FPC}{$mode delphiunicode}{$ENDIF}

interface

uses
  Windows, Classes, SysUtils, Winapi.WinCrypt;

type
  /// <summary>
  ///   WinCrypt exception class.
  /// </summary>
  EWinCryptError = class(EOSError);

  /// <summary>
  ///   The base class for WinCrypt operations.
  /// </summary>
  TCryptoBase = class abstract(TObject)

    /// <summary>
    ///   Checks the <c>BOOL</c> return value of certain WinCrypt functions and
    ///   raises a <c>EWinCryptError</c> exception with matching error message
    ///   if an error occured.
    /// </summary>
    /// <param name="AStatus">
    ///   The <c>BOOL</c> value to check.
    /// </param>
    /// <exception>
    ///   <c>EWinCryptError</c> if <c>AStatus</c> is <c>False</c>.
    /// </exception>
    procedure Check(AStatus: BOOL);
  end;

  /// <summary>
  ///   General flags for the Base64 encoding/decoding.
  /// </summary>
  TBase64Flag = (
    bfHeader, bfDefault, bfBinary, bfRequestHeader, bfHex, bfHexAscii,
    bfBase64Any, bfAny, bfHexAny, bfX509CrlHeader, bfHexAddr, bfHexAsciiAddr,
    bfHexRaw, bfStrict
  );

  /// <summary>
  ///   A <c>TBase64</c> is a Base64 encoder/decoder.
  /// </summary>
  TBase64 = class(TCryptoBase)
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
    /// <returns>
    ///   The encoded Base64 string value.
    /// </returns>
    function Encode(const AString: string): string;

    /// <summary>
    ///   Encodes a binary value to a Base64 string.
    /// </summary>
    /// <param name="AData">
    ///   A binary value.
    /// </param>
    /// <returns>
    ///   The encoded Base64 string value.
    /// </returns>
    function EncodeBinary(const AData: TBytes): string; overload;

    /// <summary>
    ///   Encodes a string value to a Base64 binary value.
    /// </summary>
    /// <param name="AString">
    ///   A string value.
    /// </param>
    /// <returns>
    ///   The encoded Base64 binary value.
    /// </returns>
    function EncodeBinary(const AString: string): TBytes; overload;

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

  THashAlgorithmHelper = record helper for THashAlgorithm
    function GetHashAlgorithm(): TAlgId;
  end;

  /// <summary>
  ///   Generic progress event.
  /// </summary>
  /// <param name="Sender">
  ///   The sender.
  /// </param>
  /// <param name="AProgress">
  ///   The current progress.
  /// </param>
  /// <param name="AProgressMax">
  ///   The maximum progress.
  /// </param>
  /// <param name="ACancel">
  ///   Set to <c>True</c> to cancel the pending operation.
  /// </param>
  TProgressEvent = procedure(Sender: TObject; const AProgress, AProgressMax: Int64;
    var ACancel: Boolean) of object;

  /// <summary>
  ///  <c>THash</c> provides methods to calculate and verify hash values from
  ///  strings and files.
  /// </summary>
  /// <remarks>
  ///   Uses the older WinCrypt API since Windows XP.
  /// </remarks>
  THash = class(TCryptoBase)
  private
    FOnProgress: TProgressEvent;
    FOnStart,
    FOnFinish: TNotifyEvent;
    FHashAlgorithm: THashAlgorithm;
  protected
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
    /// <returns>
    ///   The hash.
    /// </returns>
    function Compute(const AString: string): string; overload;

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
    ///   Creates a hex string representation from a binary hash.
    /// </summary>
    /// <param name="AHash">
    ///   The binary hash value.
    /// </param>
    /// <returns>
    ///   The hex string hash value.
    /// </returns>
    function ToHex(const AHash: TBytes): string;

    /// <summary>
    ///   Verifies the hash from a string.
    /// </summary>
    /// <param name="AHash">
    ///   The hash to be verified.
    /// </param>
    /// <param name="AString">
    ///   The string to be verified.
    /// </param>
    /// <returns>
    ///   <c>True</c> if the hash matches to the string or <c>False</c> otherwise.
    /// </returns>
    function Verify(const AHash, AString: string): Boolean; overload;

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
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;

    /// <summary>
    ///   Event that is called when hash calculation has started.
    /// </summary>
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
  end;

implementation

type
  TBase64FlagHelper = record helper for TBase64Flag
    function GetFlag(): DWORD;
  end;

{ THashAlgorithmHelper }

function THashAlgorithmHelper.GetHashAlgorithm(): TAlgId;
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


{ TCryptoBase }

procedure TCryptoBase.Check(AStatus: BOOL);
var
  LastError: DWORD;

begin
  if not AStatus then
  begin
    LastError := GetLastError();

    if (LastError <> ERROR_SUCCESS) then
      raise EWinCryptError.Create(SysErrorMessage(LastError)) {$IFNDEF FPC}at ReturnAddress{$ENDIF};
  end;  //of begin
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
  if (Length(ABase64) = 0) then
    Exit;

  // Retrieve and set required buffer size
  Check(CryptStringToBinary(PChar(ABase64), Length(ABase64), FFlag.GetFlag(),
    nil, BufferSize, Skipped, Flags));

  SetLength(Result, BufferSize);

  // Decode string
  Check(CryptStringToBinary(PChar(ABase64), Length(ABase64), FFlag.GetFlag(),
    @Result[0], BufferSize, Skipped, Flags));;
end;

function TBase64.Encode(const AString: string): string;
begin
  Result := EncodeBinary(BytesOf(AString));
end;

function TBase64.EncodeBinary(const AData: TBytes): string;
var
  BufferSize: DWORD;

begin
  if (Length(AData) = 0) then
    Exit;

  // Retrieve and set required buffer size
  Check(CryptBinaryToString(@AData[0], Length(AData), FFlag.GetFlag() +
    CRYPT_STRING_NOCRLF, nil, BufferSize));

  SetLength(Result, BufferSize);

  // Encode string
  Check(CryptBinaryToString(@AData[0], Length(AData), FFlag.GetFlag() +
    CRYPT_STRING_NOCRLF, PChar(Result), BufferSize));

  // Remove null-terminator
  Result := PChar(Result);
end;

function TBase64.EncodeBinary(const AString: string): TBytes;
begin
  Result := BytesOf(EncodeBinary(BytesOf(AString)));
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

  Check(CryptAcquireContext(CryptProvider, nil, nil, PROV_RSA_AES,
    CRYPT_VERIFYCONTEXT or CRYPT_MACHINE_KEYSET));

  Base64 := TBase64.Create;

  try
    SetLength(Salt, ALength);
    Check(CryptGenRandom(CryptProvider, ALength, @Salt[0]));
    Result := Base64.EncodeBinary(Salt);

  finally
    Base64.Free;
  end;  //of try
end;

function THash.HashToBytes(AHashHandle: TCryptHash): TBytes;
var
  HashLength, HashSize: DWORD;

begin
  // Retrieve the length (in Byte) of the hash
  HashSize := SizeOf(DWORD);
  Check(CryptGetHashParam(AHashHandle, HP_HASHSIZE, @HashLength, HashSize, 0));

  // Resize the buffer to the blocksize of the used hash algorithm
  SetLength(Result, HashLength);

  // Load the hash value into buffer
  Check(CryptGetHashParam(AHashHandle, HP_HASHVAL, @Result[0], HashLength, 0));
end;

function THash.HashToString(AHashHandle: TCryptHash): string;
begin
  Result := ToHex(HashToBytes(AHashHandle));
end;

function THash.ToHex(const AHash: TBytes): string;
var
  i, Bytes: Integer;

begin
  Bytes := SizeOf(Char);

  // Build a string from buffer
  for i := Low(AHash) to High(AHash) do
    Result := Result + IntToHex(AHash[i], Bytes);

  Result := LowerCase(Result);
end;

function THash.Compute(const AData: TBytes): TBytes;
var
  CryptProvider: TCryptProv;
  HashHandle: TCryptHash;

begin
  Check(CryptAcquireContext(CryptProvider, nil, nil, PROV_RSA_AES,
    CRYPT_VERIFYCONTEXT or CRYPT_MACHINE_KEYSET));

  // Init hash object
  Check(CryptCreateHash(CryptProvider, FHashAlgorithm.GetHashAlgorithm(), 0, 0,
    HashHandle));

  try
    // Create the hash of the string
    Check(CryptHashData(HashHandle, @AData[0], Length(AData), 0));
    Result := HashToBytes(HashHandle);

  finally
    CryptDestroyHash(HashHandle);
    CryptReleaseContext(CryptProvider, 0);
  end;  //of try
end;

function THash.Compute(const AString: string): string;
begin
  Result := ToHex(Compute(BytesOf(AString)));
end;

function THash.Compute(const AFileName: TFileName): string;
var
  CryptProvider: TCryptProv;
  HashHandle: TCryptHash;
  Buffer: array[0..1023] of Byte;
  FileToHash: TFileStream;
  BytesRead: Integer;
  Cancel: Boolean;
  Progress: Int64;

begin
  // Open file
  FileToHash := TFileStream.Create(AFileName, fmOpenRead);

  try
    Check(CryptAcquireContext(CryptProvider, nil, nil, PROV_RSA_AES,
      CRYPT_VERIFYCONTEXT));

    // Init hash object
    Check(CryptCreateHash(CryptProvider, FHashAlgorithm.GetHashAlgorithm(), 0,
      0, HashHandle));

    // Notify start of file hashing
    if Assigned(FOnStart) then
      FOnStart(Self);

    // Read first KB of file into buffer
    BytesRead := FileToHash.Read(Buffer, Length(Buffer));
    Progress := 0;
    Cancel := False;

    // EOF?
    while ((BytesRead <> 0) and not Cancel) do
    begin
      // Progress in bytes
      if Assigned(FOnProgress) then
      begin
        Progress := Progress + BytesRead;
        FOnProgress(Self, Progress, FileToHash.Size, Cancel);
      end;  //of begin

      // Create hash of read bytes in buffer
      Check(CryptHashData(HashHandle, @Buffer[0], BytesRead, 0));

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

function THash.Verify(const AHash, AString: string): Boolean;
begin
  Result := AnsiSameStr(AHash, Compute(AString));
end;

function THash.Verify(const AHash: string; AFileName: TFileName): Boolean;
begin
  Result := AnsiSameStr(AHash, Compute(AFileName));
end;

end.
