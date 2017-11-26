{ *********************************************************************** }
{                                                                         }
{ EasyWinHash Main Unit                                                   }
{                                                                         }
{ Copyright (c) 2016-2017 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit EasyWinHashMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Menus, Winapi.ShellAPI, Vcl.Buttons, Vcl.ClipBrd, System.Win.TaskbarCore,
  Vcl.Taskbar, System.UITypes, Vcl.ImgList, System.ImageList, FileHashThread,
  PMCW.CryptoAPI, PMCW.CA, PMCW.LanguageFile, PMCW.Dialogs, PMCW.Dialogs.Updater,
  PMCW.Dialogs.About, PMCW.SysUtils;

type
  { TMain }
  TMain = class(TForm, IChangeLanguageListener)
    cbxAlgorithm: TComboBox;
    bCalculate: TButton;
    pbProgress: TProgressBar;
    bVerify: TButton;
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
    ButtonImages: TImageList;
    eHash: TButtonedEdit;
    eFile: TButtonedEdit;
    lHash: TLabel;
    lFile: TLabel;
    lTimeRemaining: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure bCalculateClick(Sender: TObject);
    procedure bVerifyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mmInstallCertificateClick(Sender: TObject);
    procedure mmUpdateClick(Sender: TObject);
    procedure mmReportClick(Sender: TObject);
    procedure mmAboutClick(Sender: TObject);
    procedure eFileRightButtonClick(Sender: TObject);
    procedure eHashRightButtonClick(Sender: TObject);
    procedure eFileDblClick(Sender: TObject);
  private
    FLang: TLanguageFile;
    FUpdateCheck: TUpdateCheck;
    FThread: TFileHashThread;
    FStartTime: Cardinal;
    procedure WMDropFiles(var AMsg: TWMDropFiles); message WM_DROPFILES;
    procedure OnBeginHashing(Sender: TObject);
    procedure OnHashing(Sender: TThread; AProgress, AFileSize: Int64);
    procedure OnHashingError(Sender: TThread; const AErrorMessage: string);
    procedure OnEndHashing(Sender: TThread; const AHash: string);
    procedure OnVerified(Sender: TThread; const AMatches: Boolean);
    procedure OnUpdate(Sender: TObject; const ANewBuild: Cardinal);
    { IChangeLanguageListener }
    procedure LanguageChanged();
  end;

var
  Main: TMain;

implementation

{$I LanguageIDs.inc}
{$R *.dfm}

{ TMain }

procedure TMain.FormCreate(Sender: TObject);
var
  i, AlgorithmIndex: Integer;

begin
  // Setup languages
  FLang := TLanguageFile.Create(100);

  with FLang do
  begin
    AddListener(Self);
    BuildLanguageMenu(mmLang);
  end;  //of with

  // Init update notificator
  FUpdateCheck := TUpdateCheck.Create('EasyWinHash', FLang);

  with FUpdateCheck do
  begin
    OnUpdate := Self.OnUpdate;
  {$IFNDEF DEBUG}
    CheckForUpdate();
  {$ENDIF}
  end;  //of with

  // Enable drag & drop support
  DragAcceptFiles(Handle, True);

  // Parse arguments
  i := 1;

  while (i <= ParamCount()) do
  begin
    if ((ParamStr(i) = '-a') or (ParamStr(i) = '--algorithm')) then
    begin
      AlgorithmIndex := cbxAlgorithm.Items.IndexOf(ParamStr(i+1));

      if (AlgorithmIndex <> -1) then
        cbxAlgorithm.ItemIndex := AlgorithmIndex;

      Inc(i, 2);
      Continue;
    end;  //of begin

    if ((ParamStr(i) = '-f') or (ParamStr(i) = '--file')) then
    begin
      eFile.Text := ParamStr(i+1);

      if (ParamCount() <= 4) then
      begin
        bCalculate.Click;
        Break;
      end;  //of begin

      Inc(i, 2);
      Continue;
    end;  //of begin

    if ((ParamStr(i) = '-h') or (ParamStr(i) = '--hash')) then
    begin
      eHash.Text := ParamStr(i+1);

      // No hash specified: Use clipboard!
      if (eHash.Text = '') then
        eHash.Text := Clipboard.AsText;

      bVerify.Click;
      Break;
    end;  //of begin

    if ((ParamStr(i) = '--help') or (ParamStr(i) <> '')) then
    begin
      TaskMessageDlg(Application.Title +' usage', Application.Title +'.exe '+
        '[--algorithm | --file | --hash | --help]'+ sLineBreak +
        '  --algorithm [MD5 | SHA-1 | SHA-256 | SHA-384 | SHA-512]'+ sLineBreak +
        '  --file FILENAME'+ sLineBreak +
        '  --hash HASHVALUE', mtCustom, [mbOk], 0);
      Break;
    end;  //of begin

    Inc(i);
  end;  //of begin
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  FUpdateCheck.Free;
  FLang.Free;
end;

procedure TMain.OnBeginHashing(Sender: TObject);
begin
  TaskBar.ProgressValue := 0;
  TaskBar.ProgressState := TTaskBarProgressState.Normal;
  pbProgress.Position := 0;
  pbProgress.State := pbsNormal;
  cbxAlgorithm.Enabled := False;
  eFile.Enabled := False;
  eHash.Enabled := False;
  FStartTime := TThread.GetTickCount();
  lTimeRemaining.Visible := True;
end;

procedure TMain.OnHashing(Sender: TThread; AProgress, AFileSize: Int64);
var
  MsRemaining: Double;

begin
  // Use file size in KB to deny range error if file > 2GB
  if (AFileSize > MaxInt) then
  begin
    pbProgress.Max := AFileSize div 1024;
    pbProgress.Position := AProgress div 1024;
  end  //of begin
  else
  begin
    // Use file size in bytes to show progress for files < 1MB
    pbProgress.Max := AFileSize;
    pbProgress.Position := AProgress;
  end;  //of if

  Taskbar.ProgressMaxValue := AFileSize;
  TaskBar.ProgressValue := AProgress;

  // Calculate remaining time
  MsRemaining := (TThread.GetTickCount() - FStartTime) / AProgress * (AFileSize - AProgress);
  lTimeRemaining.Caption := TimeToStr(MsRemaining / MSecsPerDay);
end;

procedure TMain.OnHashingError(Sender: TThread; const AErrorMessage: string);
begin
  FLang.ShowException(FLang.GetString([LID_HASH_CALCULATE, LID_IMPOSSIBLE]), AErrorMessage);
  OnEndHashing(nil, '');
end;

procedure TMain.OnEndHashing(Sender: TThread; const AHash: string);
begin
  FThread := nil;
  cbxAlgorithm.Enabled := True;
  eFile.Enabled := True;
  eHash.Enabled := True;
  lTimeRemaining.Visible := False;

  bCalculate.Caption := FLang.GetString(LID_HASH_CALCULATE);
  bCalculate.Cancel := False;
  bCalculate.Enabled := True;

  bVerify.Caption := FLang.GetString(LID_HASH_VERIFY);
  bVerify.Cancel := False;
  bVerify.Enabled := True;

  if AHash.IsEmpty then
    Exit;

  eHash.Text := AHash;
  eHash.SetFocus;

  // No error?
  if (TaskBar.ProgressState = TTaskBarProgressState.Normal) then
    TaskBar.ProgressState := TTaskBarProgressState.None;

  if (WindowState = wsMinimized) then
    FlashWindow(Handle, False);

  MessageBeep(MB_ICONINFORMATION);
end;

procedure TMain.OnUpdate(Sender: TObject; const ANewBuild: Cardinal);
var
  Updater: TUpdateDialog;

begin
  mmUpdate.Caption := FLang.GetString(LID_UPDATE_DOWNLOAD);

  // Ask user to permit download
  if (TaskMessageDlg(FLang.Format(LID_UPDATE_AVAILABLE, [ANewBuild]),
    FLang[LID_UPDATE_CONFIRM_DOWNLOAD], mtConfirmation, mbYesNo, 0) = idYes) then
  begin
    Updater := TUpdateDialog.Create(Self, FLang);

    try
      with Updater do
      begin
      {$IFDEF PORTABLE}
        FileNameLocal := 'EasyWinHash.exe';
      {$IFDEF WIN64}
        FileNameRemote := 'easywinhash64.exe';
      {$ELSE}
        FileNameRemote := 'easywinhash.exe';
      {$ENDIF}
      {$ELSE}
        FileNameLocal := 'EasyWinHash Setup.exe';
        FileNameRemote := 'easywinhash_setup.exe';
      {$ENDIF}
      end;  //of begin

      // Successfully downloaded update?
      if Updater.Execute() then
      begin
        // Caption "Search for update"
        mmUpdate.Caption := FLang.GetString(LID_UPDATE_SEARCH);
        mmUpdate.Enabled := False;
      {$IFNDEF PORTABLE}
        Updater.LaunchSetup();
      {$ENDIF}
      end;  //of begin

    finally
      Updater.Free;
    end;  //of try
  end;  //of begin
end;

procedure TMain.OnVerified(Sender: TThread; const AMatches: Boolean);
begin
  if AMatches then
    MessageDlg(FLang.GetString(LID_HASH_MATCHES), mtInformation, [mbOK], 0)
  else
  begin
    Taskbar.ProgressState := TTaskBarProgressState.Error;
    pbProgress.State := pbsError;
    MessageDlg(FLang.GetString(LID_HASH_DOES_NOT_MATCH), mtWarning, [mbOK], 0);
  end;  //of if
end;

procedure TMain.LanguageChanged();
begin
  with FLang do
  begin
    // View menu labels
    mmView.Caption := GetString(LID_VIEW);
    mmLang.Caption := GetString(LID_SELECT_LANGUAGE);

    // Help menu labels
    mmHelp.Caption := GetString(LID_HELP);
    mmUpdate.Caption := GetString(LID_UPDATE_SEARCH);
    mmInstallCertificate.Caption := GetString(LID_CERTIFICATE_INSTALL);
    mmReport.Caption := GetString(LID_REPORT_BUG);
    mmAbout.Caption := Format(LID_ABOUT, [Application.Title]);

    // Buttons and labels
    lFile.Caption := '&'+ GetString(LID_FILE) +':';
    lHash.Caption := '&'+ GetString(LID_HASH) +':';
    eFile.RightButton.Hint := GetString(LID_BROWSE_FOR_FILE);
    eHash.RightButton.Hint := GetString(LID_COPY_TO_CLIPBOARD);
    bVerify.Caption := GetString(LID_HASH_VERIFY);
    bCalculate.Caption := GetString(LID_HASH_CALCULATE);
  end;  //of with
end;

procedure TMain.WMDropFiles(var AMsg: TWMDropFiles);
var
  BufferSize: Integer;
  FileName: string;

begin
  BufferSize := DragQueryFile(AMsg.Drop, 0, nil, 0) + 1;
  SetLength(FileName, BufferSize);
  DragQueryFile(AMsg.Drop, 0, PChar(FileName), BufferSize);
  eFile.Text := FileName;
  DragFinish(AMsg.Drop);
end;

procedure TMain.bCalculateClick(Sender: TObject);
begin
  try
    if Assigned(FThread) then
    begin
      FThread.Terminate();
      Taskbar.ProgressState := TTaskBarProgressState.Error;
      pbProgress.State := pbsError;
      Exit;
    end;  //of begin

    // No file selected?
    if (eFile.Text = '') then
    begin
      eFile.ShowBalloonTip(FLang.GetString(LID_WARNING), FLang.GetString(LID_NO_FILE_SELECTED), biWarning);
      Exit;
    end;  //of begin

    FThread := TFileHashThread.Create(eFile.Text, THashAlgorithm(cbxAlgorithm.ItemIndex));

    with FThread do
    begin
      OnStart := OnBeginHashing;
      OnFinish := OnEndHashing;
      OnProgress := OnHashing;
      OnError := OnHashingError;
      Start;
    end;  //of with

    // Caption "Cancel"
    bCalculate.Caption := FLang.GetString(LID_CANCEL);
    bCalculate.Cancel := True;
    bVerify.Enabled := False;

  except
    on E: Exception do
      FLang.ShowException(FLang.GetString([LID_HASH_CALCULATE, LID_IMPOSSIBLE]), E.Message);
  end;  //of try
end;

procedure TMain.eHashRightButtonClick(Sender: TObject);
begin
  Clipboard.AsText := eHash.Text;
end;

procedure TMain.eFileDblClick(Sender: TObject);
begin
  if (eFile.Text = '') then
    eFileRightButtonClick(Sender);
end;

procedure TMain.eFileRightButtonClick(Sender: TObject);
var
  FileName: string;

begin
  if PromptForFileName(FileName) then
  begin
    eFile.Text := FileName;
    TaskBar.ProgressState := TTaskBarProgressState.None;
    TaskBar.ProgressValue := 0;
    pbProgress.State := pbsNormal;
    pbProgress.Position := 0;
  end;  //of begin
end;

procedure TMain.bVerifyClick(Sender: TObject);
begin
  try
    if Assigned(FThread) then
    begin
      FThread.Terminate();
      Taskbar.ProgressState := TTaskBarProgressState.Error;
      pbProgress.State := pbsError;
      Exit;
    end;  //of begin

    // No hash entered?
    if (eHash.Text = '') then
    begin
      eHash.ShowBalloonTip(FLang.GetString(LID_WARNING), FLang.GetString(LID_NO_HASH_ENTERED), biWarning);
      Exit;
    end;  //of begin

    // No file selected?
    if (eFile.Text = '') then
    begin
      eFile.ShowBalloonTip(FLang.GetString(LID_WARNING), FLang.GetString(LID_NO_FILE_SELECTED), biWarning);
      Exit;
    end;  //of begin

    FThread := TFileHashThread.Create(eFile.Text, THashAlgorithm(cbxAlgorithm.ItemIndex),
      eHash.Text);

    with FThread do
    begin
      OnStart := OnBeginHashing;
      OnFinish := OnEndHashing;
      OnVerify := OnVerified;
      OnProgress := OnHashing;
      OnError := OnHashingError;
      Start;
    end;  //of with

    // Caption "Cancel"
    bVerify.Caption := FLang.GetString(LID_CANCEL);
    bVerify.Cancel := True;
    bCalculate.Enabled := False;

  except
    on E: Exception do
      FLang.ShowException(FLang.GetString([LID_HASH_VERIFY, LID_IMPOSSIBLE]), E.Message);
  end;  //of try
end;

procedure TMain.mmUpdateClick(Sender: TObject);
begin
  FUpdateCheck.NotifyNoUpdate := True;
  FUpdateCheck.CheckForUpdate();
end;

procedure TMain.mmInstallCertificateClick(Sender: TObject);
begin
  try
    // Certificate already installed?
    if CertificateExists() then
    begin
      MessageDlg(FLang.GetString(LID_CERTIFICATE_ALREADY_INSTALLED),
        mtInformation, [mbOK], 0);
    end  //of begin
    else
      InstallCertificate();

  except
    on E: EOSError do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;  //of try
end;

procedure TMain.mmReportClick(Sender: TObject);
begin
  OpenUrl(URL_CONTACT);
end;

procedure TMain.mmAboutClick(Sender: TObject);
var
  AboutDialog: TAboutDialog;
  Description, Changelog: TResourceStream;

begin
  AboutDialog := TAboutDialog.Create(Self);
  Description := TResourceStream.Create(HInstance, RESOURCE_DESCRIPTION, RT_RCDATA);
  Changelog := TResourceStream.Create(HInstance, RESOURCE_CHANGELOG, RT_RCDATA);

  try
    AboutDialog.Title := StripHotkey(mmAbout.Caption);
    AboutDialog.Description.LoadFromStream(Description);
    AboutDialog.Changelog.LoadFromStream(Changelog);
    AboutDialog.Execute();

  finally
    Changelog.Free;
    Description.Free;
    AboutDialog.Free;
  end;  //of begin
end;

end.

