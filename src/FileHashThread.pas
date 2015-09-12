{ *********************************************************************** }
{                                                                         }
{ FileHashThread                                                          }
{                                                                         }
{ Copyright (c) 2011-2015 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit FileHashThread;

interface

uses
  Classes, CryptoAPI;

type
  TCalculatedHashEvent = procedure(Sender: TThread; const AHash: string) of object;
  TVerifiedHashEvent = procedure(Sender: TThread; const AMatches: Boolean) of object;
  TProgressEvent = procedure(Sender: TThread; AProgress, AFileSize: Int64) of object;

  { TFileHashThread }
  TFileHashThread = class(TThread)
  private
    FHash: THash;
    FMatches: Boolean;
    FBytes,
    FBytesRead: Cardinal;
    FOnStart,
    FOnCancel: TNotifyEvent;
    FOnProgress: TProgressEvent;
    FOnFinish: TCalculatedHashEvent;
    FOnVerify: TVerifiedHashEvent;
    FFileName,
    FHashValue: string;
    FCancel: Boolean;
    procedure DoNotifyOnCancel();
    procedure DoNotifyOnStart();
    procedure DoNotifyOnFinish();
    procedure DoNotifyOnProgress();
    procedure DoNotifyOnVerified();
    procedure OnHashing(Sender: TObject; const AProgress, AProgressMax: Int64;
      var ACancel: Boolean);
  protected
    procedure Execute; override;
  public
    constructor Create(const AFileName: string; AHashAlgorithm: THashAlgorithm;
      AHashValue: string = '');
    destructor Destroy; override;
    { external }
    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;
    property OnFinish: TCalculatedHashEvent read FOnFinish write FOnFinish;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
    property OnVerify: TVerifiedHashEvent read FOnVerify write FOnVerify;
  end;

implementation

{ TFileHashThread }

{ public TFileHashThread.Create

  Constructor for creating a TFileHashThread instance. }

constructor TFileHashThread.Create(const AFileName: string;
  AHashAlgorithm: THashAlgorithm; AHashValue: string = '');
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FFileName := AFileName;
  FHashValue := AHashValue;
  FHash := THash.Create(AHashAlgorithm);
  FHash.OnProgress := OnHashing;
end;

{ public TFileHashThread.Create

  Destructor for destroying a TFileHashThread instance. }

destructor TFileHashThread.Destroy;
begin
  FHash.Free;
  inherited Destroy;
end;

{ private TFileHashThread.DoNotifyOnFinish

  Synchronizable event method that is called when hashing of a file has been
  canceled. }

procedure TFileHashThread.DoNotifyOnCancel();
begin
  if Assigned(FOnCancel) then
    FOnCancel(Self);
end;

{ private TFileHashThread.DoNotifyOnFinish

  Synchronizable event method that is called when hashing of a file has
  finished. }

procedure TFileHashThread.DoNotifyOnFinish();
begin
  if Assigned(FOnFinish) then
    FOnFinish(Self, FHashValue);
end;

{ private TFileHashThread.DoNotifyOnProgress

  Synchronizable event method that is called when hashing of a file is in
  progress. }

procedure TFileHashThread.DoNotifyOnProgress();
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, FBytesRead, FBytes);
end;

{ private TFileHashThread.DoNotifyOnStart

  Synchronizable event method that is called when hashing of a file starts. }

procedure TFileHashThread.DoNotifyOnStart();
begin
  if Assigned(FOnStart) then
    FOnStart(Self);
end;

{ private TFileHashThread.DoNotifyOnVerified

  Synchronizable event method that is called when hash of a file has been
  verified. }

procedure TFileHashThread.DoNotifyOnVerified();
begin
  if Assigned(FOnVerify) then
    FOnVerify(Self, FMatches);
end;

{ private TFileHashThread.OnHashing

  Event method that is called when hashing of a file is in progress. }

procedure TFileHashThread.OnHashing(Sender: TObject; const AProgress,
  AProgressMax: Int64; var ACancel: Boolean);
begin
  // Show progress in KB
  if (FBytes = 0) then
    FBytes := AProgressMax div 1024;

  FBytesRead := AProgress div 1024;
  ACancel := Terminated;
  Synchronize(DoNotifyOnProgress);
end;

{ protected TFileHashThread.Execute

  Calculates a hash from a file. }

procedure TFileHashThread.Execute;
begin
  Synchronize(DoNotifyOnStart);

  if (FHashValue <> '') then
  begin
    FMatches := FHash.VerifyFileHash(FHashValue, FFileName);
    Synchronize(DoNotifyOnVerified);
  end  //of begin
  else
  begin
    FHashValue := FHash.HashFile(FFileName);
    Synchronize(DoNotifyOnFinish);
  end;  //of if

  if Terminated then
    Synchronize(DoNotifyOnCancel);
end;

end.
