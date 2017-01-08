unit PMCW.CryptoAPI.Tests;

interface

uses
  TestFramework, SysUtils, Classes, PMCW.CryptoAPI;

const
  ExpectedStringValue = 'EasyWinHash';
  TestFile            = '..\..\data\EasyWinHash.png';

type
  TBase64Test = class(TTestCase)
  const
    Base64Value = 'RWFzeVdpbkhhc2g=';
  strict private
    FBase64: TBase64;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestDecode;
    procedure TestEncode;
  end;

  THashTest = class(TTestCase)
  strict private
    FHash: THash;
    FOnStart,
    FOnFinished: Boolean;
    FProgress,
    FProgressMax: Int64;
    procedure OnStart(Sender: TObject);
    procedure OnFinish(Sender: TObject);
    procedure OnProgress(Sender: TObject; const AProgress, AProgressMax: Int64;
      var ACancel: Boolean);
  protected
    procedure CheckHash(AAlgorithm: THashAlgorithm; const AExpected: string;
      const AFileName: TFileName = '');
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestMd5;
    procedure TestSha160;
    procedure TestSha256;
    procedure TestSha384;
    procedure TestSha512;
  end;

implementation

{ TBase64Test }

procedure TBase64Test.SetUp;
begin
  FBase64 := TBase64.Create;
end;

procedure TBase64Test.TearDown;
begin
  FreeAndNil(FBase64);
end;

procedure TBase64Test.TestDecode;
begin
  CheckEquals(ExpectedStringValue, FBase64.Decode(Base64Value), 'Base64 string decoding does not work');
  CheckEquals(ExpectedStringValue, StringOf(FBase64.Decode(BytesOf(Base64Value))), 'Base64 binary decoding does not work');
end;

procedure TBase64Test.TestEncode;
begin
  CheckEquals(Base64Value, FBase64.Encode(ExpectedStringValue), 'Base64 string encoding does not work');
  CheckEquals(Base64Value, StringOf(FBase64.Encode(BytesOf(ExpectedStringValue))), 'Base64 binary encoding does not work');
end;


{ THashTest }

procedure THashTest.SetUp;
begin
  FHash := THash.Create(haMd5);

  with FHash do
  begin
    OnStart := Self.OnStart;
    OnFinish := Self.OnFinish;
    OnProgress := Self.OnProgress;
  end;  //of with
end;

procedure THashTest.TearDown;
begin
  FreeAndNil(FHash);
end;

procedure THashTest.OnFinish(Sender: TObject);
begin
  CheckFalse(FOnFinished, 'OnFinished already occured');
  CheckTrue(FOnStart, 'OnStart did not occur');
  FOnFinished := True;
end;

procedure THashTest.OnProgress(Sender: TObject; const AProgress,
  AProgressMax: Int64; var ACancel: Boolean);
begin
  FProgress := AProgress;
  FProgressMax := AProgressMax;
end;

procedure THashTest.OnStart(Sender: TObject);
begin
  CheckFalse(FOnStart, 'OnStart already occured');
  FOnStart := True;
end;

procedure THashTest.CheckHash(AAlgorithm: THashAlgorithm;
  const AExpected: string; const AFileName: TFileName = '');
var
  Expected, Calculated: TCryptoBytes;

begin
  FHash.Algorithm := AAlgorithm;
  Expected := Expected.FromHex(AExpected);

  if (AFileName <> '') then
  begin
    Calculated := FHash.ComputeFromFile(AFileName);
    CheckEquals(AExpected, Calculated.ToHex(), 'Hash value of file differs from expected');
  end  //of begin
  else
  begin
    Calculated := FHash.Compute(BytesOf(ExpectedStringValue));
    CheckEquals(AExpected, Calculated.ToHex(), 'Hash value differs from expected');
  end;  //of if

  Check(Calculated.Equals(Expected), 'Calculated hash value is not equal to expected');
  CheckEquals(FProgress, FProgressMax, 'Current progress differs from maximum progress');
  CheckTrue(FOnFinished, 'OnFinish did not occur');

  // Reset
  FOnStart := False;
  FOnFinished := False;
  FProgress := 0;
  FProgressMax := 0;
end;

procedure THashTest.TestMd5;
begin
  CheckHash(haMd5, '6aed3a2d6e7e6bca54f3f367ca929ea2');
  CheckHash(haMd5, 'cadcf3161ddb96d76c5fde0ec75a7f9f', TestFile);
end;

procedure THashTest.TestSha160;
begin
  CheckHash(haSha, '9d4ff2dcf479aa855438518916790a5507356827');
  CheckHash(haSha, '6b60b6f18bf865591c52283ced5c6566d2847df2', TestFile);
end;

procedure THashTest.TestSha256;
begin
  CheckHash(haSha256, '1672c87cbad9695951c4f7f5f7ae48c89116201c1557a1a472df139eb3ef4589');
  CheckHash(haSha256, 'c088bef5c19644218b2fde660c9e2a3682d1ed1dc71dafe457ac8019b6a4ee04', TestFile);
end;

procedure THashTest.TestSha384;
begin
  CheckHash(haSha384, '62ed9305c6f301a7eb04ff93408fe5b4b1f1a85d57df1607520054a7c91bfeb14ad92e99084c22ae8da2fc74f9282e69');
  CheckHash(haSha384, '49083bfc9f7f771e54f72b117d85645d45e31e554ecf8020fb837a5c7d34cf9b6ec849d52226b07fce297428d8a33192', TestFile);
end;

procedure THashTest.TestSha512;
begin
  CheckHash(haSha512, '263da3844dfbf579f2435598f5d4ea3c41d6dc061544bc0e86795672cf48da466ae1a527fdc7f7504fc6ba5f680d539de95b93e40eddf429305386f6281ea695');
  CheckHash(haSha512, 'cb2e99f459eeb06a836420a4b74731259bca0db608cc21d4a597289dbf6cf411cbe7b65c8c005dd9e9b225bb0b07083c08ad867294a82977045de38c5cbc7136', TestFile);
end;

initialization
  RegisterTest(TBase64Test.Suite);
  RegisterTest(THashTest.Suite);
end.

