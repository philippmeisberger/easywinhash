#define MyAppName "WinHash"
#define MyAppURL "http://www.pm-codeworks.de"
#define MyAppExeName "WinHash.exe"
#define MyAppExePath "..\bin\win32\"
#define URLVersionDirectory "WinHash"
#define FileVersion GetFileVersion(MyAppExeName)
#define ProductVersion GetFileProductVersion(MyAppExePath + MyAppExeName)

#define VersionFile FileOpen("version.txt")
#define Build FileRead(VersionFile)
#expr FileClose(VersionFile)
#undef VersionFile

[Setup]
AppId={{B2EFCA05-451F-4778-BF38-264C7F4CCA91}
AppName={#MyAppName}
AppVersion={#FileVersion}
AppVerName={#MyAppName} {#ProductVersion} (32-Bit)
AppCopyright=Philipp Meisberger
AppPublisher=PM Code Works
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}/winhash.html
CreateAppDir=yes
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableDirPage=auto
DisableProgramGroupPage=yes
LicenseFile=eula.txt
OutputDir=.
OutputBaseFilename=winhash_setup
Compression=lzma
SolidCompression=yes
UninstallDisplayIcon={app}\{#MyAppExeName}
VersionInfoVersion=2.3
SignTool=Sign {srcexe}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "contextmenucalculate"; Description: "{cm:ContextMenuCalculate}"; GroupDescription: "{cm:ContextMenu}"
Name: "contextmenuverify"; Description: "{cm:ContextMenuVerify}"; GroupDescription: "{cm:ContextMenu}"

[Files]
Source: "{#MyAppExePath}{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "Updater.exe"; DestDir: "{tmp}"; Flags: dontcopy
Source: "version.txt"; DestDir: "{tmp}"; Flags: dontcopy

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram, {#MyAppName}}"; Flags: postinstall shellexec

[Registry]
Root: HKCU; Subkey: "SOFTWARE\PM Code Works\{#MyAppName}"; ValueType: string; ValueName: "Architecture"; ValueData: "x86"; Flags: uninsdeletevalue
Root: HKCU; Subkey: "SOFTWARE\PM Code Works\{#MyAppName}"; ValueType: string; ValueName: "Build"; ValueData: "{#Build}"; Flags: uninsdeletevalue
Root: HKCU; Subkey: "SOFTWARE\PM Code Works\{#MyAppName}"; Flags: uninsdeletekey
Root: HKCU; Subkey: "SOFTWARE\PM Code Works"; Flags: uninsdeletekeyifempty

Root: HKCR; Subkey: "*\shell\CalculateHash"; Flags: dontcreatekey uninsdeletekey
Root: HKCR; Subkey: "*\shell\CalculateHash"; ValueType: string; ValueName: "Icon"; ValueData: "{app}\{#MyAppExeName}"; Tasks: "contextmenucalculate"
Root: HKCR; Subkey: "*\shell\CalculateHash"; ValueType: string; ValueName: "MUIVerb"; ValueData: "{cm:ContextMenuCalculate}"; Tasks: "contextmenucalculate"
Root: HKCR; Subkey: "*\shell\CalculateHash"; ValueType: string; ValueName: "SubCommands"; ValueData: "WinHash.Calculate.MD5;WinHash.Calculate.SHA-1;WinHash.Calculate.SHA-256;WinHash.Calculate.SHA-384;WinHash.Calculate.SHA-512"; Tasks: "contextmenucalculate"

Root: HKCR; Subkey: "*\shell\VerifyHash"; Flags: dontcreatekey uninsdeletekey   
Root: HKCR; Subkey: "*\shell\VerifyHash"; ValueType: string; ValueName: "Icon"; ValueData: "{app}\{#MyAppExeName}"; Tasks: "contextmenuverify"
Root: HKCR; Subkey: "*\shell\VerifyHash"; ValueType: string; ValueName: "MUIVerb"; ValueData: "{cm:ContextMenuVerify}"; Tasks: "contextmenuverify"
Root: HKCR; Subkey: "*\shell\VerifyHash"; ValueType: string; ValueName: "SubCommands"; ValueData: "WinHash.Verify.MD5;WinHash.Verify.SHA-1;WinHash.Verify.SHA-256;WinHash.Verify.SHA-384;WinHash.Verify.SHA-512"; Tasks: "contextmenuverify"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Calculate.MD5"; Flags: dontcreatekey uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Calculate.MD5\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a MD5 -f ""%1"""; Tasks: "contextmenucalculate"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Calculate.SHA-1"; Flags: dontcreatekey uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Calculate.SHA-1\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a SHA-1 -f ""%1"""; Tasks: "contextmenucalculate"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Calculate.SHA-256"; Flags: dontcreatekey uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Calculate.SHA-256\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a SHA-256 -f ""%1"""; Tasks: "contextmenucalculate"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Calculate.SHA-384"; Flags: dontcreatekey uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Calculate.SHA-384\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a SHA-384 -f ""%1"""; Tasks: "contextmenucalculate"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Calculate.SHA-512"; Flags: dontcreatekey uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Calculate.SHA-512\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a SHA-512 -f ""%1"""; Tasks: "contextmenucalculate"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Verify.MD5"; Flags: dontcreatekey uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Verify.MD5\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a MD5 -f ""%1"" -h"; Tasks: "contextmenuverify"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Verify.SHA-1"; Flags: dontcreatekey uninsdeletekey; Tasks: "contextmenuverify"
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Verify.SHA-1\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a SHA-1 -f ""%1"" -h"; Tasks: "contextmenuverify"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Verify.SHA-256"; Flags: dontcreatekey uninsdeletekey; Tasks: "contextmenuverify"
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Verify.SHA-256\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a SHA-256 -f ""%1"" -h"; Tasks: "contextmenuverify"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Verify.SHA-384"; Flags: dontcreatekey uninsdeletekey; Tasks: "contextmenuverify"
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Verify.SHA-384\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a SHA-384 -f ""%1"" -h"; Tasks: "contextmenuverify"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Verify.SHA-512"; Flags: dontcreatekey uninsdeletekey; Tasks: "contextmenuverify"   
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\WinHash.Verify.SHA-512\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a SHA-512 -f ""%1"" -h"; Tasks: "contextmenuverify"

[Messages]
BeveledLabel=Inno Setup

[CustomMessages]
ContextMenu=Integrate Winhash into contextmeu
ContextMenuCalculate=Calculate hash
ContextMenuVerify=Verify hash

[Code]
const 
  WM_Close = $0010;

procedure CloseWindow(AAppName: string);
var
  WinID: Integer;

begin                                                              
  WinID := FindWindowByWindowName(AAppName);
  
  if (WinID <> 0) then
    SendMessage(WinID, WM_CLOSE, 0, 0);
end;

procedure UrlLabelClick(Sender: TObject);
var
  ErrorCode : Integer;

begin
  ShellExec('open', ExpandConstant('{#MyAppURL}'), '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;


procedure InitializeWizard;
var
  UrlLabel: TNewStaticText;
  CancelBtn: TButton;

begin
  CancelBtn := WizardForm.CancelButton;
  UrlLabel := TNewStaticText.Create(WizardForm);
  UrlLabel.Top := CancelBtn.Top + (CancelBtn.Height div 2) -(UrlLabel.Height div 2);
  UrlLabel.Left := WizardForm.ClientWidth - CancelBtn.Left - CancelBtn.Width;
  UrlLabel.Caption := 'www.pm-codeworks.de';
  UrlLabel.Font.Style := UrlLabel.Font.Style + [fsUnderline];
  UrlLabel.Cursor := crHand;
  UrlLabel.Font.Color := clHighlight;
  UrlLabel.OnClick := @UrlLabelClick;
  UrlLabel.Parent := WizardForm;
end;


function InitializeSetup(): Boolean;
var 
  CurBuild: Cardinal;
  ErrorCode: Integer;
  Build, TempDir: string;

begin
  Result := True;
  CurBuild := 0;

  // Upgrade installation?  
  if RegValueExists(HKCU, 'SOFTWARE\PM Code Works\{#MyAppName}', 'Build') then
  begin    
    if RegQueryStringValue(HKCU, 'SOFTWARE\PM Code Works\{#MyAppName}', 'Build', Build) then
    try  
      CurBuild := StrToInt(Build);
    
    except
      CurBuild := 0;
    end;  //of try

    // Newer build already installed?
    if ({#Build} < CurBuild) then                                         
    begin
      MsgBox('Es ist bereits eine neuere Version von {#MyAppName} installiert!' +#13+ 'Das Setup wird beendet!', mbINFORMATION, MB_OK);
      Result := False;                                                            
    end;  //of begin

    // Copy Updater and version file to tmp directory
    ExtractTemporaryFile('Updater.exe');                                
    ExtractTemporaryFile('version.txt');

    // Get user temp dir
    TempDir := ExpandConstant('{localappdata}\Temp\');

    // Launch Updater
    ShellExec('open', ExpandConstant('{tmp}\Updater.exe'), '-d {#URLVersionDirectory} -s '+ TempDir +' -i {#emit SetupSetting("OutputBaseFilename")}.exe -o "{#MyAppName} Setup.exe"', '', SW_SHOW, ewWaitUntilTerminated, ErrorCode);  
  
    // Update successful?
    if (ErrorCode = 0) then
    begin
      // Launch downloaded setup
      ShellExec('open', '"'+ TempDir +'{#MyAppName} Setup.exe"', '', TempDir, SW_SHOW, ewNoWait, ErrorCode);
      
      // Terminate current setup
      Result := False
    end;  //of begin
  end;  //of if         
end;

function PrepareToInstall(var NeedsRestart: Boolean): string;
var
  Arch, Uninstall: string;
  ErrorCode: Integer;

begin
  // Be sure that no instance of program is running!
  CloseWindow('{#MyAppName}');
      
  // Install 32 Bit version over 64 Bit?
  if (RegQueryStringValue(HKCU, 'SOFTWARE\PM Code Works\{#MyAppName}', 'Architecture', Arch) and (Arch <> 'x86')) then
    // Uninstall 64 Bit version first
    if (RegQueryStringValue(HKEY_LOCAL_MACHINE_64, ExpandConstant('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1'), 'UninstallString', Uninstall)) then
    begin
      if (MsgBox('Sie haben die 64-Bit Version von {#MyAppName} installiert und versuchen die 32-Bit Version zu installieren. Die 64-Bit Version wird dabei deinstalliert! Wirklich fortfahren?', mbConfirmation, MB_YESNO) = IDYES) then     
        // Uninstall 32 Bit version
        ShellExec('open', Uninstall, '/SILENT', '', SW_SHOW, ewWaitUntilTerminated, ErrorCode)
      else
        Result := 'Die 64-Bit Version bleibt installiert!'
    end;  //of begin
end;
