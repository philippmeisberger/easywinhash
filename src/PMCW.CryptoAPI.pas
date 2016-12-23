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
  ///   General flags for the Base64 encoding/decoding.
  /// </summary>
  TBase64Flag = (

    /// <summary>
    ///   Base64, with certificate beginning and ending headers.
    /// </summary>
    bfHeader,

    /// <summary>
    ///   Base64, without headers.
    /// </summary>
    bfDefault,

    /// <summary>
    ///   Pure binary copy.
    /// </summary>
    bfBinary,

    /// <summary>
    ///   Base64, with request beginning and ending headers.
    /// </summary>
    bfRequestHeader,

    /// <summary>
    ///   Hexadecimal only.
    /// </summary>
    bfHex,

    /// <summary>
    ///   Hexadecimal, with ASCII character display.
    /// </summary>
    bfHexAscii,

    /// <summary>
    ///   Base64, with X.509 CRL beginning and ending headers.
    /// </summary>
    bfX509CrlHeader,

    /// <summary>
    ///   Hexadecimal, with address display.
    /// </summary>
    bfHexAddr,

    /// <summary>
    ///   Hexadecimal, with ASCII character and address display.
    /// </summary>
    bfHexAsciiAddr,

    /// <summary>
    ///   A raw hexadecimal string.
    /// </summary>
    /// <remarks>
    ///   Windows Server 2003 and Windows XP: This value is not supported.
    /// </remarks>
    bfHexRaw,

    /// <summary>
    ///   Enforce strict decoding of ASN.1 text formats.
    /// </summary>
    /// <remarks>
    ///   Some ASN.1 binary BLOBS can have the first few bytes of the BLOB
    ///   incorrectly interpreted as Base64 text. In this case, the rest of the
    ///   text is ignored. Use this flag to enforce complete decoding of the BLOB.
    /// </remarks>
    bfStrict
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
  ///   The base class for WinCrypt operations.
  /// </summary>
  TCryptoBase = class abstract(TObject)
  private
    FOnStart,
    FOnFinish: TNotifyEvent;
  protected
    FOnProgress: TProgressEvent;

    /// <summary>
    ///   Issues the <see cref="OnStart"/> event.
    /// </summary>
    procedure NotifyOnStart();

    /// <summary>
    ///   Issues the <see cref="OnFinish"/> event.
    /// </summary>
    procedure NotifyOnFinish();
  public
    /// <summary>
    ///   Generates random data of specified length.
    /// </summary>
    /// <param name="ALength">
    ///   The length in bytes.
    /// </param>
    /// <returns>
    ///   Random bytes.
    /// </returns>
    function GenerateRandom(ALength: Cardinal): TBytes;

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
    /// <summary>
    ///   Gets the used algorithm identifier.
    /// </summary>
    /// <returns>
    ///   The ID.
    /// </returns>
    function GetHashAlgorithm(): TAlgId;
  end;

  TBytesHelper = record helper for TBytes
    /// <summary>
    ///   Creates a binary representation of a hex string value.
    /// </summary>
    /// <param name="AHexString">
    ///   The hexadecimal string value.
    /// </param>
    procedure FromHex(const AHexString: string);

    /// <summary>
    ///   Creates a hexadecimal representation from a binary hash value.
    /// </summary>
    /// <returns>
    ///   The hexadecimal string value.
    /// </returns>
    function ToHex(): string;
  end;

  /// <summary>
  ///  <c>THash</c> provides methods to compute hash values.
  /// </summary>
  /// <remarks>
  ///   Uses the older WinCrypt API since Windows XP.
  /// </remarks>
  THash = class(TCryptoBase)
  private
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
    ///   Computes a hash of a stream.
    /// </summary>
    /// <param name="AStream">
    ///   The stream.
    /// </param>
    /// <returns>
    ///   The hash.
    /// </returns>
    function Compute(const AStream: TStream): TBytes; overload;

    /// <summary>
    ///   Computes a hash of a byte array.
    /// </summary>
    /// <param name="AData">
    ///   The bytes to be hashed.
    /// </param>
    /// <returns>
    ///   The hash.
    /// </returns>
    function Compute(const AData: TBytes): TBytes; overload;

    /// <summary>
    ///   Computes a hash of a file.
    /// </summary>
    /// <param name="AFileName">
    ///   The absolute path to a file.
    /// </param>
    /// <returns>
    ///   The hash.
    /// </returns>
    function ComputeFile(const AFileName: TFileName): TBytes;

    /// <summary>
    ///   Gets or sets the used hash algorithm.
    /// </summary>
    property Algorithm: THashAlgorithm read FHashAlgorithm write FHashAlgorithm;
  end;

implementation

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

type
  TBase64FlagHelper = record helper for TBase64Flag
    function GetFlag(): DWORD;
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
    bfX509CrlHeader: Result := CRYPT_STRING_BASE64X509CRLHEADER;
    bfHexAddr:       Result := CRYPT_STRING_HEXADDR;
    bfHexAsciiAddr:  Result := CRYPT_STRING_HEXASCIIADDR;
    bfHexRaw:        Result := CRYPT_STRING_HEXRAW;
    bfStrict:        Result := CRYPT_STRING_STRICT;
    else             Result := CRYPT_STRING_BASE64;
  end;  //of case
end;


{ TCryptoBase }

function TCryptoBase.GenerateRandom(ALength: Cardinal): TBytes;
var
  CryptProvider: TCryptProv;

begin
  if (ALength = 0) then
    Exit;

  Check(CryptAcquireContext(CryptProvider, nil, nil, PROV_RSA_AES,
    CRYPT_VERIFYCONTEXT));

  try
    SetLength(Result, ALength);
    Check(CryptGenRandom(CryptProvider, ALength, @Result[0]));

  finally
    CryptReleaseContext(CryptProvider, 0);
  end;  //of try
end;

procedure TCryptoBase.NotifyOnFinish();
begin
  if Assigned(FOnFinish) then
    FOnFinish(Self);
end;

procedure TCryptoBase.NotifyOnStart();
begin
  if Assigned(FOnStart) then
    FOnStart(Self);
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


{ THashAlgorithmHelper }

function THashAlgorithmHelper.GetHashAlgorithm(): TAlgId;
begin
  case Self of
    haMd5:    Result := CALG_MD5;
    haSha:    Result := CALG_SHA_160;
    haSha256: Result := CALG_SHA_256;
    haSha384: Result := CALG_SHA_384;
    haSha512: Result := CALG_SHA_512;
    else      raise EWinCryptError.Create('Unsupported hash algorithm!');
  end;  //of case
end;


{ TBytesHelper }

procedure TBytesHelper.FromHex(const AHexString: string);
var
  BytesOfChar: Byte;
  i, j: Integer;

begin
  BytesOfChar := SizeOf(Char);
  SetLength(Self, Length(AHexString) div BytesOfChar);
  j := 1;

  for i := Low(Self) to High(Self) do
  begin
    Self[i] := StrToInt('$'+ Copy(AHexString, j, BytesOfChar));
    Inc(j, BytesOfChar);
  end;  //of for
end;

function TBytesHelper.ToHex(): string;
var
  BytesOfChar: Byte;
  i: Integer;

begin
  Result := '';
  BytesOfChar := SizeOf(Char);

  // Build a string from buffer
  for i := Low(Self) to High(Self) do
    Result := Result + IntToHex(Self[i], BytesOfChar);

  Result := LowerCase(Result);
end;


{ THash }

constructor THash.Create(AHashAlgorithm: THashAlgorithm);
begin
  inherited Create;
  FHashAlgorithm := AHashAlgorithm;
end;

function THash.Compute(const AStream: TStream): TBytes;
var
  CryptProvider: TCryptProv;
  HashHandle: TCryptHash;
  Buffer: array[0..1023] of Byte;
  BytesRead: Integer;
  Cancel: Boolean;
  Progress: Int64;
  HashDataLength, HashSize: DWORD;

begin
  NotifyOnStart();

  try
    Check(CryptAcquireContext(CryptProvider, nil, nil, PROV_RSA_AES,
      CRYPT_VERIFYCONTEXT));

    // Init hash
    Check(CryptCreateHash(CryptProvider, FHashAlgorithm.GetHashAlgorithm(), 0,
      0, HashHandle));

    try
      // Read first KB into buffer
      BytesRead := AStream.Read(Buffer, Length(Buffer));
      Progress := 0;
      Cancel := False;

      // EOF?
      while ((BytesRead <> 0) and not Cancel) do
      begin
        // Progress in bytes
        if Assigned(FOnProgress) then
        begin
          Progress := Progress + BytesRead;
          FOnProgress(Self, Progress, AStream.Size, Cancel);
        end;  //of begin

        // Create hash of read bytes in buffer
        Check(CryptHashData(HashHandle, @Buffer[0], BytesRead, 0));

        // Read next KB into buffer
        BytesRead := AStream.Read(Buffer, Length(Buffer));
      end;  //of while

      if not Cancel then
      begin
        // Get hash value from handle
        HashSize := SizeOf(DWORD);
        Check(CryptGetHashParam(HashHandle, HP_HASHSIZE, @HashDataLength, HashSize, 0));
        SetLength(Result, HashDataLength);
        Check(CryptGetHashParam(HashHandle, HP_HASHVAL, @Result[0], HashDataLength, 0));
      end;  //of begin

    finally
      CryptDestroyHash(HashHandle);
      CryptReleaseContext(CryptProvider, 0);
    end;  //of try

  finally
    NotifyOnFinish();
  end;  //of try
end;

function THash.Compute(const AData: TBytes): TBytes;
var
  Data: TBytesStream;

begin
  Data := TBytesStream.Create(AData);

  try
    Result := Compute(Data);

  finally
    Data.Free;
  end;  //of try
end;

function THash.ComputeFile(const AFileName: TFileName): TBytes;
var
  FileToHash: TFileStream;

begin
  FileToHash := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);

  try
    Result := Compute(FileToHash);

  finally
    FileToHash.Free;
  end;  //of try
end;

end.
