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
  Classes, WinCrypt;

type
  TCalculatedHashEvent = procedure(Sender: TThread; const AHash: string) of object;
  TVerifiedHashEvent = procedure(Sender: TThread; const AMatches: Boolean) of object;

  { TFileHashThread }
  TFileHashThread = class(TThread)
  private
    FHash: THash;
    FMatches: Boolean;
    FBytes, FBytesRead: Cardinal;
    FOnStart, FOnProgress: TProgressEvent;
    FOnFinish: TCalculatedHashEvent;
    FOnVerify: TVerifiedHashEvent;
    FFileName, FHashValue: string;
    procedure DoNotifyOnStart();
    procedure DoNotifyOnFinish();
    procedure DoNotifyOnProgress();
    procedure DoNotifyOnVerified();
    procedure OnStartHashing(Sender: TObject; const AFileSize: Int64);
    procedure OnHashing(Sender: TObject; const ABytesRead: Int64);
  protected
    procedure Execute; override;
  public
    constructor Create(const AFileName: string; AHashAlgorithm: THashAlgorithm;
      AHashValue: string = '');
    destructor Destroy; override;
    { external }
    property OnFinish: TCalculatedHashEvent read FOnFinish write FOnFinish;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property OnStart: TProgressEvent read FOnStart write FOnStart;
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

  with FHash do
  begin
    OnStart := OnStartHashing;
    OnProgress := OnHashing;
  end;  //of with
end;

{ public TFileHashThread.Create

  Destructor for destroying a TFileHashThread instance. }

destructor TFileHashThread.Destroy;
begin
  FHash.Free;
  inherited Destroy;
end;

procedure TFileHashThread.DoNotifyOnStart;
begin
  if Assigned(FOnStart) then
    FOnStart(Self, FBytes);
end;

procedure TFileHashThread.DoNotifyOnFinish;
begin
  if Assigned(FOnFinish) then
    FOnFinish(Self, FHashValue);
end;

procedure TFileHashThread.DoNotifyOnProgress;
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, FBytesRead);
end;

procedure TFileHashThread.DoNotifyOnVerified();
begin
  if Assigned(FOnVerify) then
    FOnVerify(Self, FMatches);
end;

procedure TFileHashThread.OnStartHashing(Sender: TObject; const AFileSize: Int64);
begin
  // Show progress in KB
  FBytes := AFileSize div 1024;
  Synchronize(DoNotifyOnStart);
end;

procedure TFileHashThread.OnHashing(Sender: TObject; const ABytesRead: Int64);
begin
  // Show progress in KB
  FBytesRead := ABytesRead div 1024;
  Synchronize(DoNotifyOnProgress);
end;

{ protected TFileHashThread.Execute

  Calculates a hash from a file. }

procedure TFileHashThread.Execute;
begin
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
end;

end.
