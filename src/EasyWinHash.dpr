program EasyWinHash;

{$R *.dres}

uses
  Vcl.Forms,
  EasyWinHashMain in 'EasyWinHashMain.pas' {Main};

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  Application.Initialize;
  Application.Title := 'EasyWinHash';
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
