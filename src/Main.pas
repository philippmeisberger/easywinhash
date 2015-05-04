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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, XPMan, ExtCtrls, AddDialogs, AddCommCtrl,
  Crypt, FileHashThread, Menus;

type
  TForm1 = class(TForm)
    cbxAlgorithm: TComboBox;
    bCalculate: TButton;
    pbProgress: TProgressBar;
    bVerify: TButton;
    XPManifest: TXPManifest;
    bBrowse: TButton;
    eFile: TLabeledEdit;
    eHash: TLabeledEdit;
    MainMenu: TMainMenu;
    mmHelp: TMenuItem;
    mmView: TMenuItem;
    mmLang: TMenuItem;
    mmUpdate: TMenuItem;
    N1: TMenuItem;
    ber1: TMenuItem;
    mmDownloadCert: TMenuItem;
    mmReport: TMenuItem;
    N2: TMenuItem;
    procedure bCalculateClick(Sender: TObject);
    procedure bBrowseClick(Sender: TObject);
    procedure bVerifyClick(Sender: TObject);
    procedure cbxAlgorithmClick(Sender: TObject);
  private
    FHashAlgorithm: THashAlgorithm;
    procedure OnBeginHashing(Sender: TObject; const AFileSize: Cardinal);
    procedure OnHashing(Sender: TObject; const AProgress: Cardinal);
    procedure OnEndHashing(Sender: TThread; const AHash: string);
    procedure OnVerified(Sender: TThread; const AMatches: Boolean);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.OnBeginHashing(Sender: TObject; const AFileSize: Cardinal);
begin
  pbProgress.Max := AFileSize;
  pbProgress.Position := 0;
end;


procedure TForm1.OnHashing(Sender: TObject; const AProgress: Cardinal);
begin
  pbProgress.Position := pbProgress.Position + AProgress;
end;


procedure TForm1.OnEndHashing(Sender: TThread; const AHash: string);
begin
  eHash.Text := AHash;
end;

procedure TForm1.OnVerified(Sender: TThread; const AMatches: Boolean);
begin
  SetForegroundWindow(Handle);
  
  if AMatches then
    ShowTaskDialog(Self, 'GHash', '', 'Hash matches!', [cbOk], tiInformation)
  else
    ShowTaskDialog(Self, 'GHash', '', 'Hash does not match!', [cbOk], tiWarning);
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
      Resume;
    end;  //of with

  except
    on E: EAbort do
      Edit_ShowBalloonTip(eFile.Handle, Application.Title, E.Message, biWarning);

    on E: Exception do
      ShowException(Self, 'Calculation impossible!', '', E.Message);
  end;  //of try
end;


procedure TForm1.bBrowseClick(Sender: TObject);
var
  OpenDialog: TFileOpenDialog;

begin
  OpenDialog := TFileOpenDialog.Create(Self);

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
      raise EAbort.Create('No file selected!');

    with TFileHashThread.Create(eFile.Text, FHashAlgorithm, eHash.Text) do
    begin
      OnStart := OnBeginHashing;
      OnVerify := OnVerified;
      OnProgress := OnHashing;
      Resume;
    end;  //of with

  except
    on E: EAbort do
      Edit_ShowBalloonTip(eHash.Handle, Application.Title, E.Message, biWarning);

    on E: Exception do
      ShowException(Self, 'Calculation impossible!', '', E.Message);
  end;  //of try
end;

procedure TForm1.cbxAlgorithmClick(Sender: TObject);
begin
  FHashAlgorithm := THashAlgorithm(cbxAlgorithm.ItemIndex);
end;

end.

