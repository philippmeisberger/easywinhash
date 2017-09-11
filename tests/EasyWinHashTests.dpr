program EasyWinHashTests;
{

  Delphi DUnit-Testprojekt
  -------------------------
  Dieses Projekt enth�lt das DUnit-Test-Framework und die GUI/Konsolen-Test-Runner.
  F�gen Sie den Bedingungen in den Projektoptionen "CONSOLE_TESTRUNNER" hinzu,
  um den Konsolen-Test-Runner zu verwenden.  Ansonsten wird standardm��ig der
  GUI-Test-Runner verwendet.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  PMCW.CryptoAPI.Tests in 'PMCW.CryptoAPI.Tests.pas';

{$R *.RES}

begin
  ReportMemoryLeaksOnShutdown := True;
  DUnitTestRunner.RunRegisteredTests;
end.

