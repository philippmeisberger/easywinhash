{ *********************************************************************** }
{                                                                         }
{ FileHashThread                                                          }
{                                                                         }
{ Copyright (c) 2016 Philipp Meisberger (PM Code Works)                   }
{                                                                         }
{ *********************************************************************** }

unit FileHashThread;

interface

uses
  Classes, SysUtils, PMCW.CryptoAPI;

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
    FBytesRead: Int64;
    FOnStart,
    FOnCancel: TNotifyEvent;
    FOnProgress: TProgressEvent;
    FOnFinish,
    FOnError: TStringResultEvent;
    FOnVerify: TVerifiedHashEvent;
    FFileName: TFileName;
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
    /// <summary>
    ///   Constructor for creating a <c>TFileHashThread</c> instance.
    /// <summary>
    /// <param name="AFileName">
    ///   The absolute path to a file.
    /// </param>
    /// <param name="AHashAlgorithm">
    ///   The hash algorithm to use.
    /// </param>
    /// <param name="AHashValue">
    ///   A hash value. If this is set the hash gets verified else it gets
    ///   calculated.
    /// </param>
    constructor Create(const AFileName: TFileName; AHashAlgorithm: THashAlgorithm;
      AHashValue: string = '');

    /// <summary>
    ///   Destructor for destroying a <c>TFileHashThread</c> instance.
    /// <summary>
    destructor Destroy; override;

    /// <summary>
    ///   Event that is called when hash calculation has been canceled.
    /// </summary>
    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;

    /// <summary>
    ///   Event that is called when hash calculation failed.
    /// </summary>
    property OnError: TStringResultEvent read FOnError write FOnError;

    /// <summary>
    ///   Event that is called when hash calculation has finished.
    /// </summary>
    property OnFinish: TStringResultEvent read FOnFinish write FOnFinish;

    /// <summary>
    ///   Event that is called during hash calculation.
    /// </summary>
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;

    /// <summary>
    ///   Event that is called when hash calculation has started.
    /// </summary>
    property OnStart: TNotifyEvent read FOnStart write FOnStart;

    /// <summary>
    ///   Event that is called when hash has been verified.
    /// </summary>
    property OnVerify: TVerifiedHashEvent read FOnVerify write FOnVerify;
  end;

implementation

{ TFileHashThread }

constructor TFileHashThread.Create(const AFileName: TFileName;
  AHashAlgorithm: THashAlgorithm; AHashValue: string = '');
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FFileName := AFileName;
  FHashValue := AHashValue;
  FHash := THash.Create(AHashAlgorithm);
  FHash.OnProgress := OnHashing;
end;

destructor TFileHashThread.Destroy;
begin
  FHash.Free;
  inherited Destroy;
end;

procedure TFileHashThread.DoNotifyOnCancel();
begin
  if Assigned(FOnCancel) then
    FOnCancel(Self);
end;

procedure TFileHashThread.DoNotifyOnError();
begin
  if Assigned(FOnError) then
    FOnError(Self, FErrorMessage);
end;

procedure TFileHashThread.DoNotifyOnFinish();
begin
  if Assigned(FOnFinish) then
    FOnFinish(Self, FHashValue);
end;

procedure TFileHashThread.DoNotifyOnProgress();
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, FBytesRead, FBytes);
end;

procedure TFileHashThread.DoNotifyOnStart();
begin
  if Assigned(FOnStart) then
    FOnStart(Self);
end;

procedure TFileHashThread.DoNotifyOnVerified();
begin
  if Assigned(FOnVerify) then
    FOnVerify(Self, FMatches);
end;

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

procedure TFileHashThread.Execute;
begin
  Synchronize(DoNotifyOnStart);

  try
    if (FHashValue <> '') then
      FMatches := FHash.Verify(FHashValue, FFileName)
    else
      FHashValue := FHash.Compute(FFileName);

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
