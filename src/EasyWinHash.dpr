program EasyWinHash;

{$R 'changelog.res' 'changelog.rc'}
{$R 'description.res' 'description.rc'}

uses
  Forms,
  WinHashMain in 'WinHashMain.pas' {Main};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'EasyWinHash';
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
