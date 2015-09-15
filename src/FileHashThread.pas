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
  Classes, SysUtils, CryptoAPI;

type
  TStringResultEvent = procedure(Sender: TThread; const AHash: string) of object;
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
    FOnFinish,
    FOnError: TStringResultEvent;
    FOnVerify: TVerifiedHashEvent;
    FFileName,
    FHashValue,
    FErrorMessage: string;
    procedure DoNotifyOnCancel();
    procedure DoNotifyOnError();
    procedure DoNotifyOnFinish();
    procedure DoNotifyOnProgress();
    procedure DoNotifyOnStart();
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
    property OnError: TStringResultEvent read FOnError write FOnError;
    property OnFinish: TStringResultEvent read FOnFinish write FOnFinish;
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

{ private TFileHashThread.DoNotifyOnCancel

  Synchronizable event method that is called when hashing of a file has been
  canceled. }

procedure TFileHashThread.DoNotifyOnCancel();
begin
  if Assigned(FOnCancel) then
    FOnCancel(Self);
end;

{ private TFileHashThread.DoNotifyOnError

  Synchronizable event method that is called when an error has occured. }

procedure TFileHashThread.DoNotifyOnError();
begin
  if Assigned(FOnError) then
    FOnError(Self, FErrorMessage);
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

  try
    if (FHashValue <> '') then
      FMatches := FHash.VerifyFileHash(FHashValue, FFileName)
    else
      FHashValue := FHash.HashFile(FFileName);

    if Terminated then
      Synchronize(DoNotifyOnCancel)
    else
      if (FHashValue <> '') then
        Synchronize(DoNotifyOnVerified);

    Synchronize(DoNotifyOnFinish);

  except
    on E: Exception do
    begin
      FErrorMessage := E.ClassName +': '+ E.Message;
      Synchronize(DoNotifyOnError);
    end;
  end;  //of try
end;

end.
