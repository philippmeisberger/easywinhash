{ *********************************************************************** }
{                                                                         }
{ EasyWinHash Main Unit                                                   }
{                                                                         }
{ Copyright (c) 2016-2018 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit EasyWinHashMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Menus, Winapi.ShellAPI, Vcl.Buttons, Vcl.ClipBrd, System.Win.TaskbarCore,
  Vcl.Taskbar, System.UITypes, Vcl.ImgList, System.ImageList, FileHashThread,
  PMCW.CryptoAPI, PMCW.LanguageFile, PMCW.Dialogs, PMCW.SysUtils, PMCW.Controls,
  PMCW.Application;

type
  { TMain }
  TMain = class(TMainForm)
    cbxAlgorithm: TComboBox;
    bCalculate: TButton;
    pbProgress: TProgressBar;
    bVerify: TButton;
    MainMenu: TMainMenu;
    mmHelp: TMenuItem;
    mmView: TMenuItem;
    mmLang: TMenuItem;
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
    procedure eFileRightButtonClick(Sender: TObject);
    procedure eHashRightButtonClick(Sender: TObject);
    procedure eFileDblClick(Sender: TObject);
  private
    FThread: TFileHashThread;
    FStartTime: Cardinal;
    procedure WMDropFiles(var AMsg: TWMDropFiles); message WM_DROPFILES;
    procedure OnBeginHashing(Sender: TObject);
    procedure OnHashing(Sender: TThread; AProgress, AFileSize: Int64);
    procedure OnHashingError(Sender: TThread; const AErrorMessage: string);
    procedure OnEndHashing(Sender: TThread; const AHash: string);
    procedure OnVerified(Sender: TThread; const AMatches: Boolean);
  protected
    procedure LanguageChanged(); override;
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
  FLang.AddListener(Self);

  // Build menus
  BuildLanguageMenu(mmLang);
  BuildHelpMenu(mmHelp);

  // Init update notificator
{$IFDEF PORTABLE}
  CheckForUpdate('EasyWinHash', 'easywinhash.exe', 'easywinhash64.exe', 'EasyWinHash.exe');
{$ELSE}
  CheckForUpdate('EasyWinHash', 'easywinhash_setup.exe', '', 'EasyWinHash Setup.exe');
{$ENDIF}

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

procedure TMain.OnBeginHashing(Sender: TObject);
begin
  TaskBar.ProgressValue := 0;
  TaskBar.ProgressState := TTaskBarProgressState.Normal;
  pbProgress.Position := 0;
  pbProgress.State := pbsNormal;
  cbxAlgorithm.Enabled := False;
  eFile.Enabled := False;
  eHash.Enabled := False;
  FStartTime := GetTickCount();
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
  MsRemaining := (GetTickCount() - FStartTime) / AProgress * (AFileSize - AProgress);
  lTimeRemaining.Caption := TimeToStr(MsRemaining / MSecsPerDay);
end;

procedure TMain.OnHashingError(Sender: TThread; const AErrorMessage: string);
begin
  ExceptionDlg(FLang, FLang.GetString([LID_HASH_CALCULATE, LID_IMPOSSIBLE]), AErrorMessage);
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
  inherited LanguageChanged();

  with FLang do
  begin
    mmView.Caption := GetString(LID_VIEW);
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
      ExceptionDlg(FLang, FLang.GetString([LID_HASH_CALCULATE, LID_IMPOSSIBLE]), E.Message);
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
      ExceptionDlg(FLang, FLang.GetString([LID_HASH_VERIFY, LID_IMPOSSIBLE]), E.Message);
  end;  //of try
end;

end.

