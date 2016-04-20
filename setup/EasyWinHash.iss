#define MyAppName "EasyWinHash"
#define MyAppURL "http://www.pm-codeworks.de"
#define MyAppExeName "EasyWinHash.exe"
#define MyAppExePath32 "..\bin\Win32\"
#define MyAppExePath64 "..\bin\Win64\"
#define FileVersion GetFileVersion(MyAppExePath32 + MyAppExeName)
#define ProductVersion GetFileProductVersion(MyAppExePath32 + MyAppExeName)

[Setup]
AppId={{B2EFCA05-451F-4778-BF38-264C7F4CCA91}
AppName={#MyAppName}
AppVersion={#FileVersion}
AppVerName={#MyAppName} {#ProductVersion}
AppCopyright=Philipp Meisberger
AppPublisher=PM Code Works
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}/easywinhash.html
CreateAppDir=yes
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableDirPage=auto
DisableProgramGroupPage=yes
LicenseFile=..\LICENCE.txt
OutputDir=.
OutputBaseFilename=easywinhash_setup
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
UninstallDisplayIcon={app}\{#MyAppExeName}
VersionInfoVersion=2.5
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
Source: "{#MyAppExePath32}{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion; Check: not Is64BitInstallMode
Source: "{#MyAppExePath64}{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion; Check: Is64BitInstallMode

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram, {#MyAppName}}"; Flags: postinstall shellexec

[Registry]
Root: HKCR; Subkey: "*\shell\CalculateHash"; Flags: dontcreatekey uninsdeletekey
Root: HKCR; Subkey: "*\shell\CalculateHash"; ValueType: string; ValueName: "Icon"; ValueData: "{app}\{#MyAppExeName}"; Tasks: "contextmenucalculate"
Root: HKCR; Subkey: "*\shell\CalculateHash"; ValueType: string; ValueName: "MUIVerb"; ValueData: "{cm:ContextMenuCalculate}"; Tasks: "contextmenucalculate"
Root: HKCR; Subkey: "*\shell\CalculateHash"; ValueType: string; ValueName: "SubCommands"; ValueData: "EasyWinHash.Calculate.MD5;EasyWinHash.Calculate.SHA-1;EasyWinHash.Calculate.SHA-256;EasyWinHash.Calculate.SHA-384;EasyWinHash.Calculate.SHA-512"; Tasks: "contextmenucalculate"

Root: HKCR; Subkey: "*\shell\VerifyHash"; Flags: dontcreatekey uninsdeletekey
Root: HKCR; Subkey: "*\shell\VerifyHash"; ValueType: string; ValueName: "Icon"; ValueData: "{app}\{#MyAppExeName}"; Tasks: "contextmenuverify"
Root: HKCR; Subkey: "*\shell\VerifyHash"; ValueType: string; ValueName: "MUIVerb"; ValueData: "{cm:ContextMenuVerify}"; Tasks: "contextmenuverify"
Root: HKCR; Subkey: "*\shell\VerifyHash"; ValueType: string; ValueName: "SubCommands"; ValueData: "EasyWinHash.Verify.MD5;EasyWinHash.Verify.SHA-1;EasyWinHash.Verify.SHA-256;EasyWinHash.Verify.SHA-384;EasyWinHash.Verify.SHA-512"; Tasks: "contextmenuverify"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Calculate.MD5"; Flags: dontcreatekey uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Calculate.MD5"; ValueType: string; ValueName: ""; ValueData: "MD5"; Tasks: "contextmenucalculate"
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Calculate.MD5\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a MD5 -f ""%1"""; Tasks: "contextmenucalculate"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Calculate.SHA-1"; Flags: dontcreatekey uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Calculate.SHA-1"; ValueType: string; ValueName: ""; ValueData: "SHA-1"; Tasks: "contextmenucalculate"
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Calculate.SHA-1\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a SHA-1 -f ""%1"""; Tasks: "contextmenucalculate"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Calculate.SHA-256"; Flags: dontcreatekey uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Calculate.SHA-256"; ValueType: string; ValueName: ""; ValueData: "SHA-256"; Tasks: "contextmenucalculate"
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Calculate.SHA-256\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a SHA-256 -f ""%1"""; Tasks: "contextmenucalculate"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Calculate.SHA-384"; Flags: dontcreatekey uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Calculate.SHA-384"; ValueType: string; ValueName: ""; ValueData: "SHA-384"; Tasks: "contextmenucalculate"
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Calculate.SHA-384\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a SHA-384 -f ""%1"""; Tasks: "contextmenucalculate"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Calculate.SHA-512"; Flags: dontcreatekey uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Calculate.SHA-512"; ValueType: string; ValueName: ""; ValueData: "SHA-512"; Tasks: "contextmenucalculate"
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Calculate.SHA-512\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a SHA-512 -f ""%1"""; Tasks: "contextmenucalculate"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Verify.MD5"; Flags: dontcreatekey uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Verify.MD5"; ValueType: string; ValueName: ""; ValueData: "MD5"; Tasks: "contextmenuverify"
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Verify.MD5\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a MD5 -f ""%1"" -h"; Tasks: "contextmenuverify"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Verify.SHA-1"; Flags: dontcreatekey uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Verify.SHA-1"; ValueType: string; ValueName: ""; ValueData: "SHA-1"; Tasks: "contextmenuverify"
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Verify.SHA-1\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a SHA-1 -f ""%1"" -h"; Tasks: "contextmenuverify"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Verify.SHA-256"; Flags: dontcreatekey uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Verify.SHA-256"; ValueType: string; ValueName: ""; ValueData: "SHA-256"; Tasks: "contextmenuverify"
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Verify.SHA-256\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a SHA-256 -f ""%1"" -h"; Tasks: "contextmenuverify"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Verify.SHA-384"; Flags: dontcreatekey uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Verify.SHA-384"; ValueType: string; ValueName: ""; ValueData: "SHA-384"; Tasks: "contextmenuverify"
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Verify.SHA-384\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a SHA-384 -f ""%1"" -h"; Tasks: "contextmenuverify"

Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Verify.SHA-512"; Flags: dontcreatekey uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Verify.SHA-512"; ValueType: string; ValueName: ""; ValueData: "SHA-512"; Tasks: "contextmenuverify"
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\EasyWinHash.Verify.SHA-512\command"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName} -a SHA-512 -f ""%1"" -h"; Tasks: "contextmenuverify"

[Messages]
BeveledLabel=Inno Setup

[CustomMessages]
ContextMenu=Integrate {#MyAppName} into contextmeu
ContextMenuCalculate=Calculate hash
ContextMenuVerify=Verify hash

[Code]
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
