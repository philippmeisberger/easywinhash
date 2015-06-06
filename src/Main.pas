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
  ComCtrls, StdCtrls, ExtCtrls, Menus, ShellAPI, Vcl.Taskbar, WinCrypt,
  FileHashThread, PMCW.Dialogs, System.Win.TaskbarCore;

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
    mmDownloadCert: TMenuItem;
    mmReport: TMenuItem;
    N2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure bCalculateClick(Sender: TObject);
    procedure bBrowseClick(Sender: TObject);
    procedure bVerifyClick(Sender: TObject);
    procedure cbxAlgorithmClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FHashAlgorithm: THashAlgorithm;
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
  // Enable drag & drop support
  DragAcceptFiles(Handle, True);
  FTaskBar := TTaskbar.Create(Self);
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  FTaskBar.Free;
end;


procedure TForm1.OnBeginHashing(Sender: TObject; const AFileSize: Int64);
begin
  FTaskBar.ProgressMaxValue := AFileSize;
  FTaskBar.ProgressState := TTaskBarProgressState.Normal;
  FTaskBar.ProgressValue := 0;
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
  FTaskBar.ProgressState := TTaskBarProgressState.None;
  FlashWindow(Application.Handle, True);
end;


procedure TForm1.OnVerified(Sender: TThread; const AMatches: Boolean);
begin
  FlashWindow(Application.Handle, True);

  if AMatches then
    ShowTaskDialog(Self, 'GHash', '', 'Hash matches!', [tcbOk], tdiInformation)
  else
    ShowTaskDialog(Self, 'GHash', '', 'Hash does not match!', [tcbOk], tdiWarning);
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

    with TFileHashThread.Create(eFile.Text, FHashAlgorithm) do
    begin
      OnStart := OnBeginHashing;
      OnFinish := OnEndHashing;
      OnProgress := OnHashing;
      Start;
    end;  //of with

  except
    //on E: EAbort do
      //Edit_ShowBalloonTip(eFile.Handle, 'Warning', E.Message, biWarning);

    on E: Exception do
      ShowException(Self, 'Calculation impossible!', '', E.Message);
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

    with TFileHashThread.Create(eFile.Text, FHashAlgorithm, eHash.Text) do
    begin
      OnStart := OnBeginHashing;
      OnVerify := OnVerified;
      OnProgress := OnHashing;
      Start;
    end;  //of with

  except
    //on E: EAbort do
    //  Edit_ShowBalloonTip(eHash.Handle, 'Warning', E.Message, biWarning);

    on E: Exception do
      ShowException(Self, 'Calculation impossible!', '', E.Message);
  end;  //of try
end;

procedure TForm1.cbxAlgorithmClick(Sender: TObject);
begin
  FHashAlgorithm := THashAlgorithm(cbxAlgorithm.ItemIndex);
end;

end.

