{ *********************************************************************** }
{                                                                         }
{ GHash Main Unit                                                         }
{                                                                         }
{ Copyright (c) 2011-2015 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Menus, ShellAPI, Vcl.Taskbar,
  System.Win.TaskbarCore, CryptoAPI, PMCWLanguageFile, FileHashThread, PMCWAbout;

type
  TForm1 = class(TForm)
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
    procedure FormCreate(Sender: TObject);
    procedure bCalculateClick(Sender: TObject);
    procedure bBrowseClick(Sender: TObject);
    procedure bVerifyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mmAboutClick(Sender: TObject);
  private
    FLang: TLanguageFile;
    FTaskBar: TTaskbar;
    procedure OnBeginHashing(Sender: TObject; const AFileSize: Int64);
    procedure OnHashing(Sender: TObject; const AProgress: Int64);
    procedure OnEndHashing(Sender: TThread; const AHash: string);
    procedure OnVerified(Sender: TThread; const AMatches: Boolean);
    procedure WMDropFiles(var AMsg: TMessage); message WM_DROPFILES;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Setup language
  FLang := TLanguageFile.Create(Self);
  FLang.BuildLanguageMenu(MainMenu, mmLang);
  FLang.Update();

  // Enable drag & drop support
  DragAcceptFiles(Handle, True);
  FTaskBar := TTaskbar.Create(Self);
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  FTaskBar.Free;
  FLang.Free;
end;


procedure TForm1.mmAboutClick(Sender: TObject);
var
  Info: TInfo;

begin
  Application.CreateForm(TInfo, Info);
  Info.ShowModal();
  Info.Free;
end;


procedure TForm1.OnBeginHashing(Sender: TObject; const AFileSize: Int64);
begin
  FTaskBar.ProgressMaxValue := AFileSize;
  FTaskBar.ProgressValue := 0;
  FTaskBar.ProgressState := TTaskBarProgressState.Normal;
  pbProgress.Max := AFileSize;
  pbProgress.Position := 0;
end;


procedure TForm1.OnHashing(Sender: TObject; const AProgress: Int64);
begin
  pbProgress.Position := pbProgress.Position + AProgress;
  FTaskBar.ProgressValue := FTaskBar.ProgressValue + AProgress;
end;


procedure TForm1.OnEndHashing(Sender: TThread; const AHash: string);
begin
  eHash.Text := AHash;
  //FTaskBar.ProgressState := TTaskBarProgressState.None;
  MessageBeep(MB_ICONINFORMATION);
  //FlashWindow(Application.Handle, True);
end;


procedure TForm1.OnVerified(Sender: TThread; const AMatches: Boolean);
begin
  //FlashWindow(Application.Handle, True);

  if AMatches then
    FLang.ShowMessage('Hash matches!', mtInformation)
  else
    FLang.ShowMessage('Hash does not match!', mtWarning);
end;


procedure TForm1.WMDropFiles(var AMsg: TMessage);
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


procedure TForm1.bCalculateClick(Sender: TObject);
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


procedure TForm1.bBrowseClick(Sender: TObject);
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


procedure TForm1.bVerifyClick(Sender: TObject);
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

