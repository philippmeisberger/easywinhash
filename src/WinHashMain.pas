{ *********************************************************************** }
{                                                                         }
{ WinHash Main Unit                                                       }
{                                                                         }
{ Copyright (c) 2011-2015 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit WinHashMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Menus, ShellAPI, System.Win.TaskbarCore,
  Vcl.Taskbar, CryptoAPI, PMCWLanguageFile, FileHashThread, PMCWOSUtils,
  PMCWUpdater, PMCWAbout;

type
  { TMain }
  TMain = class(TForm, IChangeLanguageListener, IUpdateListener)
    cbxAlgorithm: TComboBox;
    bCalculate: TButton;
    pbProgress: TProgressBar;
    bVerify: TButton;
    bBrowse: TButton;
    eFile: TLabeledEdit;
    eHash: TLabeledEdit;
    MainMenu: TMainMenu;
    mmHelp: TMenuItem;
    mmView: TMenuItem;
    mmLang: TMenuItem;
    mmUpdate: TMenuItem;
    N1: TMenuItem;
    mmAbout: TMenuItem;
    mmInstallCertificate: TMenuItem;
    mmReport: TMenuItem;
    N2: TMenuItem;
    Taskbar: TTaskbar;
    procedure FormCreate(Sender: TObject);
    procedure bCalculateClick(Sender: TObject);
    procedure bBrowseClick(Sender: TObject);
    procedure bVerifyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mmInstallCertificateClick(Sender: TObject);
    procedure mmUpdateClick(Sender: TObject);
    procedure mmReportClick(Sender: TObject);
    procedure mmInfoClick(Sender: TObject);
  private
    FLang: TLanguageFile;
    FUpdateCheck: TUpdateCheck;
    procedure OnBeginHashing(Sender: TObject; const AFileSize: Int64);
    procedure OnHashing(Sender: TObject; const AProgress: Int64);
    procedure OnEndHashing(Sender: TThread; const AHash: string);
    procedure OnVerified(Sender: TThread; const AMatches: Boolean);
    procedure OnUpdate(Sender: TObject; const ANewBuild: Cardinal);
    procedure SetLanguage(Sender: TObject);
    procedure WMDropFiles(var AMsg: TMessage); message WM_DROPFILES;
  end;

var
  Main: TMain;

implementation

{$R *.dfm}

{ TMain }

{ TMain.FormCreate

  VCL event that is called when form is being created. }

procedure TMain.FormCreate(Sender: TObject);
begin
  // Setup language
  FLang := TLanguageFile.Create(Self);
  FLang.Interval := 100;
  FLang.BuildLanguageMenu(MainMenu, mmLang);
  FLang.Update();

  // Init update notificator
  FUpdateCheck := TUpdateCheck.Create(Self, 'WinHash', FLang);

  // Check for update on startup
  //FUpdateCheck.CheckForUpdate(False);

  // Enable drag & drop support
  DragAcceptFiles(Handle, True);

  // Set title
  Caption := Application.Title + PLATFORM_ARCH;
end;


{ TMain.FormDestroy

  VCL event that is called when form is being destroyed. }

procedure TMain.FormDestroy(Sender: TObject);
begin
  FLang.Free;
end;

{ TMain.OnBeginHashing

  Event method that is called when hashing starts . }

procedure TMain.OnBeginHashing(Sender: TObject; const AFileSize: Int64);
begin
  TaskBar.ProgressMaxValue := AFileSize;
  TaskBar.ProgressValue := 0;
  TaskBar.ProgressState := TTaskBarProgressState.Normal;
  pbProgress.Max := AFileSize;
  pbProgress.Position := 0;
end;

{ TMain.OnHashing

  Event method that is called when hashing is in progress. }

procedure TMain.OnHashing(Sender: TObject; const AProgress: Int64);
begin
  pbProgress.Position := pbProgress.Position + AProgress;
  TaskBar.ProgressValue := TaskBar.ProgressValue + AProgress;
end;

{ TMain.OnEndHashing

  Event method that is called when hashing ends. }

procedure TMain.OnEndHashing(Sender: TThread; const AHash: string);
begin
  eHash.Text := AHash;
  //FTaskBar.ProgressState := TTaskBarProgressState.None;
  MessageBeep(MB_ICONINFORMATION);
  //FlashWindow(Application.Handle, True);
end;

{ private TMain.OnUpdate

  Event that is called by TUpdateCheck when an update is available. }

procedure TMain.OnUpdate(Sender: TObject; const ANewBuild: Cardinal);
var
  Updater: TUpdate;

begin
  mmUpdate.Caption := FLang.GetString(24);

  // Ask user to permit download
  if (FLang.ShowMessage(FLang.Format(21, [ANewBuild]), FLang.GetString(22),
    mtConfirmation) = IDYES) then
  begin
    // init TUpdate instance
    Updater := TUpdate.Create(Self, FLang);

    try
      // Set updater options
      with Updater do
      begin
        FileNameLocal := 'WinHash.exe';

      {$IFDEF WIN64}
        FileNameRemote := 'winhash64.exe';
      {$ELSE}
        // Ask user to permit download of 64-Bit version
        if ((TOSVersion.Architecture = arIntelX64) and (FLang.ShowMessage(
          FLang.Format([34, 35], ['WinHash']), mtConfirmation) = IDYES)) then
          FileNameRemote := 'winhash64.exe'
        else
          FileNameRemote := 'winhash.exe';
      {$ENDIF}
      end;  //of begin

      // Successfully downloaded update?
      if Updater.Execute() then
      begin
        // Caption "Search for update"
        mmUpdate.Caption := FLang.GetString(15);
        mmUpdate.Enabled := False;
      end;  //of begin

    finally
      Updater.Free;
    end;  //of try
  end;  //of begin
end;

{ TMain.OnVerified

  Event method that is called when hash has been verified. }

procedure TMain.OnVerified(Sender: TThread; const AMatches: Boolean);
begin
  //FlashWindow(Application.Handle, True);

  if AMatches then
    FLang.ShowMessage('Hash matches!', mtInformation)
  else
    FLang.ShowMessage('Hash does not match!', mtWarning);
end;

{ private TMain.SetLanguage

  Updates all component captions with new language text. }

procedure TMain.SetLanguage(Sender: TObject);
begin
  with FLang do
  begin
    // View menu labels
    mmView.Caption := GetString(10);
    mmLang.Caption := GetString(25);

    // Help menu labels
    mmHelp.Caption := GetString(14);
    mmUpdate.Caption := GetString(15);
    mmInstallCertificate.Caption := GetString(16);
    mmReport.Caption := GetString(26);
    mmAbout.Caption := Format(17, [Application.Title]);

    eFile.EditLabel.Caption := GetString(33) +':';
  end;  //of with
end;

{ TMain.WMDropFiles

  Event method that is called when user drops a file on form. }

procedure TMain.WMDropFiles(var AMsg: TMessage);
var
  BufferSize: Integer;
  FileName: PChar;

begin
  BufferSize := DragQueryFile(AMsg.WParam, 0, nil, 0) + 1;
  FileName := StrAlloc(BufferSize);
  DragQueryFile(AMsg.WParam, 0, FileName, BufferSize);
  eFile.Text := StrPas(FileName);
  DragFinish(AMsg.WParam);
end;

{ TMain.bCalculateClick

  Event method that is called when user wants to start hash calculation. }

procedure TMain.bCalculateClick(Sender: TObject);
begin
  try
    if (eFile.Text = '') then
      raise EAbort.Create('No file selected!');

    with TFileHashThread.Create(eFile.Text, THashAlgorithm(cbxAlgorithm.ItemIndex)) do
    begin
      OnStart := OnBeginHashing;
      OnFinish := OnEndHashing;
      OnProgress := OnHashing;
      Start;
    end;  //of with

  except
    on E: EAbort do
      FLang.EditBalloonTip(eFile.Handle, FLang.GetString(1), E.Message, biWarning);

    on E: Exception do
      FLang.ShowException('Calculation impossible!', E.Message);
  end;  //of try
end;

{ TMain.bBrowseClick

  Event method that is called when user browses for a file. }

procedure TMain.bBrowseClick(Sender: TObject);
var
  FileName: string;

begin
  if PromptForFileName(FileName) then
    eFile.Text := FileName;
end;

{ TMain.bVerifyClick

  Event method that is called when user wants to verify a hash. }

procedure TMain.bVerifyClick(Sender: TObject);
begin
  try
    if (eHash.Text = '') then
      raise EAbort.Create('No hash entered or calculated!');

    with TFileHashThread.Create(eFile.Text, THashAlgorithm(cbxAlgorithm.ItemIndex), eHash.Text) do
    begin
      OnStart := OnBeginHashing;
      OnVerify := OnVerified;
      OnProgress := OnHashing;
      Start;
    end;  //of with

  except
    on E: EAbort do
      FLang.EditBalloonTip(eHash.Handle, FLang.GetString(1), E.Message, biWarning);

    on E: Exception do
      FLang.ShowException('Calculation impossible!', E.Message);
  end;  //of try
end;

{ TMain.mmUpdateClick

  MainMenu entry that allows users to manually search for updates. }

procedure TMain.mmUpdateClick(Sender: TObject);
begin
  FUpdateCheck.CheckForUpdate(True);
end;

{ TMain.mmInstallCertificateClick

  MainMenu entry that allows to install the PM Code Works certificate. }

procedure TMain.mmInstallCertificateClick(Sender: TObject);
var
  Updater: TUpdate;

begin
  Updater := TUpdate.Create(Self, FLang);

  try
    // Certificate already installed?
    if not Updater.CertificateExists() then
      Updater.InstallCertificate()
    else
      FLang.ShowMessage(FLang.GetString(27), mtInformation);

  finally
    Updater.Free;
  end;  //of try
end;

{ TMain.mmReportClick

  MainMenu entry that allows users to easily report a bug by opening the web
  browser and using the "report bug" formular. }

procedure TMain.mmReportClick(Sender: TObject);
begin
  OpenUrl(URL_CONTACT);
end;

{ TMain.mmInfoClick

  MainMenu entry that shows a info page with build number and version history. }

procedure TMain.mmInfoClick(Sender: TObject);
var
  Info: TInfo;

begin
  Application.CreateForm(TInfo, Info);
  Info.ShowModal();
  Info.Free;
end;

end.

