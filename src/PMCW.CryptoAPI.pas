{ *********************************************************************** }
{                                                                         }
{ Windows CryptoAPI Unit v1.2                                             }
{                                                                         }
{ Copyright (c) 2011-2017 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit PMCW.CryptoAPI;

{$IFDEF FPC}{$mode delphiunicode}{$ENDIF}

interface

uses
  Windows, Classes, SysUtils, Math, Winapi.WinCrypt;

type
  /// <summary>
  ///   WinCrypt exception class.
  /// </summary>
  EWinCryptError = class(EOSError);

  /// <summary>
  ///   General flags for the Base64 encoding/decoding.
  /// </summary>
  TBase64Option = (

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
  ///   <c>TBase64</c> provides methods for Base64 encoding and decoding.
  /// </summary>
  TBase64 = class(TObject)
  private
    FOption: TBase64Option;
  public
    /// <summary>
    ///   Constructor for creating a <c>TBase64</c> instance.
    /// </summary>
    /// <param name="AOption">
    ///   Optional: A <see cref="TBase64Flag"/> special encoding flag that
    ///   influences the output.
    /// </param>
    constructor Create(AOption: TBase64Option = bfDefault);

    /// <summary>
    ///   Decodes a Base64 encoded array of bytes.
    /// </summary>
    /// <param name="AData">
    ///   The array of bytes.
    /// </param>
    /// <returns>
    ///   An decoded array of bytes.
    /// </returns>
    function Decode(const AData: TBytes): TBytes; overload;

    /// <summary>
    ///   Decodes a Base64 string.
    /// </summary>
    /// <param name="ABase64">
    ///   The string.
    /// </param>
    /// <returns>
    ///   The decoded string.
    /// </returns>
    function Decode(const ABase64: string): string; overload;

    /// <summary>
    ///   Decodes a Base64 encoded stream.
    /// </summary>
    /// <param name="AInputStream">
    ///   The Base64 encoded stream.
    /// </param>
    /// <param name="AOutputStream">
    ///   The decoded stream.
    /// </param>
    procedure Decode(const AInputStream, AOutputStream: TStream); overload;

    /// <summary>
    ///   Decodes a Base64 string to an array of bytes.
    /// </summary>
    /// <param name="ABase64">
    ///   The Base64 string.
    /// </param>
    /// <returns>
    ///   The decoded array of bytes.
    /// </returns>
    function DecodeStringToBytes(const ABase64: string): TBytes;

    /// <summary>
    ///   Encodes an array of bytes.
    /// </summary>
    /// <param name="AData">
    ///   The array of bytes.
    /// </param>
    /// <returns>
    ///   The Base64 encoded array of bytes.
    /// </returns>
    function Encode(const AData: TBytes): TBytes; overload;

    /// <summary>
    ///   Encodes stream.
    /// </summary>
    /// <param name="AInputStream">
    ///   The stream.
    /// </param>
    /// <param name="AOutputStream">
    ///   The Base64 encoded stream.
    /// </param>
    procedure Encode(const AInputStream, AOutputStream: TStream); overload;

    /// <summary>
    ///   Encodes a string.
    /// </summary>
    /// <param name="AString">
    ///   The string.
    /// </param>
    /// <returns>
    ///   The Base64 encoded string.
    /// </returns>
    function Encode(const AString: string): string; overload;

    /// <summary>
    ///   Encodes an array of bytes.
    /// </summary>
    /// <param name="AData">
    ///   The array of bytes.
    /// </param>
    /// <returns>
    ///   The Base64 encoded string.
    /// </returns>
    function EncodeBytesToString(const AData: TBytes): string; overload;

    /// <summary>
    ///   Encodes binary data.
    /// </summary>
    /// <param name="AData">
    ///   Pointer to a buffer.
    /// </param>
    /// <param name="ASize">
    ///   Size of buffer in bytes.
    /// </param>
    /// <returns>
    ///   The Base64 encoded string.
    /// </returns>
    function EncodeBytesToString(const AData: Pointer; ASize: Integer): string; overload;

    /// <summary>
    ///   A <see cref="TBase64Flag"/> special encoding flag that influences the
    ///   output.
    /// </summary>
    property Option: TBase64Option read FOption write FOption;
  end;

  /// <summary>
  ///   Binary data.
  /// </summary>
  TCryptoBytes = TBytes;

  TCryptoBytesHelper = record helper for TCryptoBytes
    /// <summary>
    ///   Checks if the specified bytes are equal to the current bytes.
    /// </summary>
    /// <param name="ABytes">
    ///   The bytes to check.
    /// </param>
    /// <returns>
    ///   <c>True</c> if equal or <c>False</c> otherwise.
    /// </returns>
    function Equals(const ABytes: TCryptoBytes): Boolean;

    /// <summary>
    ///   Creates a binary representation of a hex string value.
    /// </summary>
    /// <param name="AHexString">
    ///   The hexadecimal string value.
    /// </param>
    /// <returns>
    ///   The binary value.
    /// </returns>
    function FromHex(const AHexString: string): TCryptoBytes;

    /// <summary>
    ///   Creates a hexadecimal representation from a binary buffer.
    /// </summary>
    /// <returns>
    ///   The hexadecimal string.
    /// </returns>
    function ToHex(): string;
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
    function GenerateRandom(ALength: Cardinal): TCryptoBytes;  overload;

    /// <summary>
    ///   Generates random data of specified length.
    /// </summary>
    /// <param name="ABuffer">
    ///   The buffer to fill with random data.
    /// </param>
    /// <param name="ALength">
    ///   The buffer length in bytes.
    /// </param>
    procedure GenerateRandom(const ABuffer: Pointer; ALength: Cardinal); overload;

    /// <summary>
    ///   Generates random data of specified length.
    /// </summary>
    /// <param name="ABuffer">
    ///   The buffer to fill with random data.
    /// </param>
    /// <param name="ALength">
    ///   The buffer length in bytes.
    /// </param>
    procedure GenerateRandom(const ABuffer: TBytes; ALength: Cardinal); overload;

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
    ///   Computes the hash of a stream.
    /// </summary>
    /// <param name="AStream">
    ///   The stream.
    /// </param>
    /// <returns>
    ///   The hash.
    /// </returns>
    function Compute(const AStream: TStream): TCryptoBytes; overload;

    /// <summary>
    ///   Computes the hash of a buffer.
    /// </summary>
    /// <param name="AData">
    ///   Pointer to a buffer.
    /// </param>
    /// <param name="ALength">
    ///   Size of buffer in bytes.
    /// </param>
    /// <returns>
    ///   The hash.
    /// </returns>
    function Compute(const AData: Pointer; ASize: Cardinal): TCryptoBytes; overload;

    /// <summary>
    ///   Computes the hash of a byte array.
    /// </summary>
    /// <param name="AData">
    ///   The bytes to be hashed.
    /// </param>
    /// <param name="ALength">
    ///   Optional: Number of bytes in <c>AData</c>.
    /// </param>
    /// <returns>
    ///   The hash.
    /// </returns>
    function Compute(const AData: TCryptoBytes; ALength: Cardinal = 0): TCryptoBytes; overload;

    /// <summary>
    ///   Computes a hash of a file.
    /// </summary>
    /// <param name="AFileName">
    ///   The absolute path to a file.
    /// </param>
    /// <returns>
    ///   The hash.
    /// </returns>
    function ComputeFromFile(const AFileName: TFileName): TCryptoBytes;

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
  E: EWinCryptError;

begin
  if not AStatus then
  begin
    LastError := GetLastError();

    if (LastError <> ERROR_SUCCESS) then
    begin
      E := EWinCryptError.Create(SysErrorMessage(LastError));
      E.ErrorCode := LastError;
      raise E {$IFNDEF FPC}at ReturnAddress{$ENDIF};
    end;  //of begin
  end;  //of begin
end;

type
  TBase64OptionHelper = record helper for TBase64Option
    function GetFlag(): DWORD;
  end;

{ TBase64OptionHelper }

function TBase64OptionHelper.GetFlag(): DWORD;
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

function TCryptoBase.GenerateRandom(ALength: Cardinal): TCryptoBytes;
begin
  if (ALength > 0) then
  begin
    SetLength(Result, ALength);
    GenerateRandom(@Result[0], ALength);
  end;  //of begin
end;

procedure TCryptoBase.GenerateRandom(const ABuffer: Pointer; ALength: Cardinal);
var
  CryptProvider: TCryptProv;

begin
  if (ALength = 0) then
    Exit;

  Check(CryptAcquireContext(CryptProvider, nil, nil, PROV_RSA_AES, CRYPT_VERIFYCONTEXT));

  try
    Check(CryptGenRandom(CryptProvider, ALength, ABuffer));

  finally
    CryptReleaseContext(CryptProvider, 0);
  end;  //of try
end;

procedure TCryptoBase.GenerateRandom(const ABuffer: TBytes; ALength: Cardinal);
begin
  GenerateRandom(@ABuffer[0], ALength);
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

constructor TBase64.Create(AOption: TBase64Option = bfDefault);
begin
  inherited Create;
  FOption := AOption;
end;

function TBase64.Decode(const AData: TBytes): TBytes;
begin
  Result := DecodeStringToBytes(StringOf(AData));
end;

procedure TBase64.Decode(const AInputStream, AOutputStream: TStream);
var
  InputStream: TStringStream;
  Buffer: TBytes;

begin
  InputStream := TStringStream.Create;

  try
    InputStream.LoadFromStream(AInputStream);
    Buffer := DecodeStringToBytes(InputStream.ReadString(InputStream.Size));
    AOutputStream.WriteBuffer(Buffer, Length(Buffer));

  finally
    InputStream.Free;
  end;  //of try
end;

function TBase64.Decode(const ABase64: string): string;
begin
  Result := StringOf(DecodeStringToBytes(ABase64));
end;

function TBase64.DecodeStringToBytes(const ABase64: string): TBytes;
var
  BufferSize, Skipped, Flags: DWORD;

begin
  if (ABase64 = '') then
    Exit;

  // Retrieve and set required buffer size
  Check(CryptStringToBinary(PChar(ABase64), Length(ABase64), FOption.GetFlag(),
    nil, BufferSize, Skipped, Flags));

  SetLength(Result, BufferSize);

  // Decode string
  Check(CryptStringToBinary(PChar(ABase64), Length(ABase64), FOption.GetFlag(),
    @Result[0], BufferSize, Skipped, Flags));
end;

function TBase64.Encode(const AData: TBytes): TBytes;
begin
  Result := BytesOf(EncodeBytesToString(AData));
end;

procedure TBase64.Encode(const AInputStream, AOutputStream: TStream);
var
  InputStream: TMemoryStream;
  OutputStream: TStringStream;

begin
  InputStream := TMemoryStream.Create;
  OutputStream := TStringStream.Create;

  try
    InputStream.LoadFromStream(AInputStream);
    OutputStream.WriteString(EncodeBytesToString(InputStream.Memory, InputStream.Size));
    OutputStream.SaveToStream(AOutputStream);

  finally
    OutputStream.Free;
    InputStream.Free;
  end;  //of try
end;

function TBase64.Encode(const AString: string): string;
begin
  Result := EncodeBytesToString(BytesOf(AString));
end;

function TBase64.EncodeBytesToString(const AData: Pointer; ASize: Integer): string;
var
  BufferSize, Flags: DWORD;

begin
  Flags := CRYPT_STRING_NOCRLF or FOption.GetFlag();

  // Retrieve and set required buffer size
  Check(CryptBinaryToString(AData, ASize, Flags, nil, BufferSize));
  SetLength(Result, BufferSize);

  // Encode string
  Check(CryptBinaryToString(AData, ASize, Flags, PChar(Result), BufferSize));

  // Remove null-terminator
  Result := PChar(Result);
end;

function TBase64.EncodeBytesToString(const AData: TBytes): string;
begin
  if (Length(AData) > 0) then
    Result := EncodeBytesToString(Pointer(AData), Length(AData))
  else
    Result := '';
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


{ TCryptoBytesHelper }

function TCryptoBytesHelper.Equals(const ABytes: TCryptoBytes): Boolean;
begin
  if (Length(ABytes) = Length(Self)) then
    Result := CompareMem(Pointer(Self), Pointer(ABytes), Length(Self))
  else
    Result := False;
end;

function TCryptoBytesHelper.FromHex(const AHexString: string): TCryptoBytes;
begin
  SetLength(Result, Length(AHexString) div SizeOf(Char));
  HexToBin(PChar(UpperCase(AHexString)), Pointer(Result), Length(Result));
end;

function TCryptoBytesHelper.ToHex(): string;
begin
  SetLength(Result, Length(Self) * SizeOf(Char));
  BinToHex(Pointer(Self), PChar(Result), Length(Self));
  Result := LowerCase(Result);
end;


{ THash }

constructor THash.Create(AHashAlgorithm: THashAlgorithm);
begin
  inherited Create;
  FHashAlgorithm := AHashAlgorithm;
end;

function THash.Compute(const AStream: TStream): TCryptoBytes;
const
  ONE_KB = 1024;

var
  CryptProvider: TCryptProv;
  HashHandle: TCryptHash;
  Buffer: TBytes;
  BytesRead: Integer;
  Cancel: Boolean;
  Progress: Int64;
  HashDataLength, HashSize: DWORD;

begin
  NotifyOnStart();

  try
    // Use dynamic buffer with at least 1KB
    SetLength(Buffer, Max(ONE_KB, AStream.Size div ONE_KB));

    // Init hash
    Check(CryptAcquireContext(CryptProvider, nil, nil, PROV_RSA_AES, CRYPT_VERIFYCONTEXT));
    Check(CryptCreateHash(CryptProvider, FHashAlgorithm.GetHashAlgorithm(), 0,
      0, HashHandle));

    try
      // Read first block into buffer
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

        // Read next block into buffer
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

function THash.Compute(const AData: Pointer; ASize: Cardinal): TCryptoBytes;
var
  Stream: TMemoryStream;

begin
  Stream := TMemoryStream.Create;

  try
    Stream.WriteBuffer(AData^, ASize);
    Stream.Position := 0;
    Result := Compute(Stream);

  finally
    Stream.Free;
  end;  //of try
end;

function THash.Compute(const AData: TCryptoBytes; ALength: Cardinal = 0): TCryptoBytes;
var
  Size: Cardinal;

begin
  if (ALength = 0) then
    Size := Length(AData)
  else
    Size := ALength;

  Result := Compute(@AData[0], Size)
end;

function THash.ComputeFromFile(const AFileName: TFileName): TCryptoBytes;
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
