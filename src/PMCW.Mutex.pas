{ *********************************************************************** }
{                                                                         }
{ PM Code Works Windows Mutex Unit v1.2                                   }
{                                                                         }
{ Copyright (c) 2011-2015 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit PMCW.Mutex;

interface

uses
  Windows, Forms;

implementation

var
  Handle: THandle;
  FileName: string;

initialization

  FileName := Application.Title;
  Handle := CreateMutex(nil, True, PChar(FileName));

  if (GetLastError() = ERROR_ALREADY_EXISTS) then
  begin
    Application.MessageBox('Another instance of '+ FileName +' already exists!',
      FileName, MB_ICONWARNING);
    Application.Terminate;
  end;  //of begin


finalization

  if (Handle <> 0) then
    CloseHandle(Handle);

end.
