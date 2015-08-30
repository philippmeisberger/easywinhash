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
  ComCtrls, StdCtrls, ExtCtrls, Menus, ShellAPI, Vcl.Taskbar,
  System.Win.TaskbarCore, CryptoAPI, PMCWLanguageFile, FileHashThread, PMCWAbout;

type
  { TMain }
  TMain = class(TForm)
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
    procedure mmInfoClick(Sender: TObject);
    procedure mmReportClick(Sender: TObject);
    procedure mmUpdateClick(Sender: TObject);
  private
    FLang: TLanguageFile;
    procedure OnBeginHashing(Sender: TObject; const AFileSize: Int64);
    procedure OnHashing(Sender: TObject; const AProgress: Int64);
    procedure OnEndHashing(Sender: TThread; const AHash: string);
    procedure OnVerified(Sender: TThread; const AMatches: Boolean);
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
  FLang.BuildLanguageMenu(MainMenu, mmLang);
  FLang.Update();

  // Enable drag & drop support
  DragAcceptFiles(Handle, True);

  // Set title
  //Caption := Application.Title + PLATFORM_ARCH;
end;


{ TMain.FormDestroy

  VCL event that is called when form is being destroyed. }

procedure TMain.FormDestroy(Sender: TObject);
begin
  FLang.Free;
end;

{ TMain.mmUpdateClick

  MainMenu entry that allows users to manually search for updates. }

procedure TMain.mmUpdateClick(Sender: TObject);
begin
  //FUpdateCheck.CheckForUpdate(True);
end;

{ TMain.mmReportClick

  MainMenu entry that allows users to easily report a bug by opening the web
  browser and using the "report bug" formular. }

procedure TMain.mmReportClick(Sender: TObject);
begin
  //OpenUrl(URL_CONTACT);
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


procedure TMain.OnBeginHashing(Sender: TObject; const AFileSize: Int64);
begin
  TaskBar.ProgressMaxValue := AFileSize;
  TaskBar.ProgressValue := 0;
  TaskBar.ProgressState := TTaskBarProgressState.Normal;
  pbProgress.Max := AFileSize;
  pbProgress.Position := 0;
end;


procedure TMain.OnHashing(Sender: TObject; const AProgress: Int64);
begin
  pbProgress.Position := pbProgress.Position + AProgress;
  TaskBar.ProgressValue := TaskBar.ProgressValue + AProgress;
end;


procedure TMain.OnEndHashing(Sender: TThread; const AHash: string);
begin
  eHash.Text := AHash;
  //FTaskBar.ProgressState := TTaskBarProgressState.None;
  MessageBeep(MB_ICONINFORMATION);
  //FlashWindow(Application.Handle, True);
end;


procedure TMain.OnVerified(Sender: TThread; const AMatches: Boolean);
begin
  //FlashWindow(Application.Handle, True);

  if AMatches then
    FLang.ShowMessage('Hash matches!', mtInformation)
  else
    FLang.ShowMessage('Hash does not match!', mtWarning);
end;


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


procedure TMain.bBrowseClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;

begin
  OpenDialog := TOpenDialog.Create(Self);

  try
    if OpenDialog.Execute then
      eFile.Text := OpenDialog.FileName;

  finally
    OpenDialog.Free;
  end;  //of try
end;


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

end.

