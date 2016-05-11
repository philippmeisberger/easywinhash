program EasyWinHash;

{$R 'changelog.res' 'changelog.rc'}
{$R 'description.res' 'description.rc'}

uses
  Vcl.Forms,
  EasyWinHashMain in 'EasyWinHashMain.pas' {Main};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'EasyWinHash';
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
