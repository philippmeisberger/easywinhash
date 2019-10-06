#define MyAppName "EasyWinHash"
#define MyAppURL "http://www.pm-codeworks.de"
#define MyAppExeName "EasyWinHash.exe"
#define MyAppExePath32 "..\bin\Win32\Release\"
#define MyAppExePath64 "..\bin\Win64\Release\"
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
LicenseFile=..\LICENSE.txt
OutputDir=.
OutputBaseFilename=easywinhash_setup
Compression=lzma2
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
UninstallDisplayIcon={app}\{#MyAppExeName}
VersionInfoVersion={#FileVersion}
SignTool=MySignTool sign /v /n "PM Code Works" /tr http://timestamp.globalsign.com/scripts/timstamp.dll /td SHA256 /fd SHA256 $f

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "contextmenucalculate"; Description: "{cm:ContextMenuCalculate}"; GroupDescription: "{cm:ContextMenu}"
Name: "contextmenuverify"; Description: "{cm:ContextMenuVerify}"; GroupDescription: "{cm:ContextMenu}"

[Files]
Source: "{#MyAppExePath32}{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion; Check: not Is64BitInstallMode
Source: "{#MyAppExePath64}{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion; Check: Is64BitInstallMode

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[InstallDelete]
; Delete old start menu group
Type: filesandordirs; Name: "{group}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: postinstall shellexec skipifsilent

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
english.ContextMenu=Integrate {#MyAppName} into contextmenu
french.ContextMenu=Intégrer {#MyAppName} dans le menu contextuel
german.ContextMenu={#MyAppName} ins Kontextmenü integrieren

english.ContextMenuCalculate=Calculate hash
french.ContextMenuCalculate=Calculer le hachage
german.ContextMenuCalculate=Hashwert berechnen

english.ContextMenuVerify=Verify hash
french.ContextMenuVerify=Vérifier le hachage
german.ContextMenuVerify=Hashwert überprüfen

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
