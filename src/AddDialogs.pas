{ *********************************************************************** }
{                                                                         }
{ PM Code Works Additional Dialogs Unit                                   }
{                                                                         }
{ Copyright (c) 2011-2015 P.Meisberger (PM Code Works)                    }
{                                                                         }
{ *********************************************************************** }

unit AddDialogs;

interface

uses
  Windows, Classes, Forms, SysUtils, StdCtrls, Controls, Graphics, CommCtrl,
  ShellAPI, Dialogs, TaskDlg, Messages, CommDlg;

function InputCombo(AOwner: TComponent; ACaption, APrompt: string; AList: TStrings;
  var AValue: string): Boolean;

function ShowAddRegistryDialog(ARegFilePath: string): Boolean;

const
  { Custom button default values }
  CUSTOM_BUTTON1 = 100;
  CUSTOM_BUTTON2 = CUSTOM_BUTTON1 + 1;
  CUSTOM_BUTTON3 = CUSTOM_BUTTON1 + 2;
  CUSTOM_BUTTON4 = CUSTOM_BUTTON1 + 3;
  CUSTOM_BUTTON5 = CUSTOM_BUTTON1 + 4;
  CUSTOM_BUTTON6 = CUSTOM_BUTTON1 + 5;

  { Radio button default values }
  RADIO_BUTTON1 = 200;
  RADIO_BUTTON2 = RADIO_BUTTON1 + 1;
  RADIO_BUTTON3 = RADIO_BUTTON1 + 2;
  RADIO_BUTTON4 = RADIO_BUTTON1 + 3;
  RADIO_BUTTON5 = RADIO_BUTTON1 + 4;
  RADIO_BUTTON6 = RADIO_BUTTON1 + 5;

type
  { TCommonButton }
  TCommonButton = (cbOk, cbYes, cbNo, cbCancel, cbRetry, cbClose);
  TCommonButtons = set of TCommonButton;

  { TTaskDialogIcon }
  TTaskDialogIcon = (tiBlank, tiWarning, tiQuestion, tiError, tiInformation,
    tiShield, tiShieldBanner, tiShieldWarning, tiShieldWarningBanner,
    tiShieldQuestion, tiShieldError, tiShieldErrorBanner, tiShieldOk,
    tiShieldOkBanner
  );

  { TTaskDialogOption }
  TTaskDialogOption = (doHyperlinks, doUseMainIcon, doUseFooterIcon,
    doCancel, doCommandLinks, doCommandLinksNoIcon, doExpandFooter,
    doExpandDefault, doVerify, doProgressBar, doProgressBarMarquee, doCallBackTimer,
    doRelativeToWindow, doRtlLayout, doRadioButtonNoDefault, doMinimize);
  TTaskDialogOptions = set of TTaskDialogOption;

  { TTaskDialogElement }
  TTaskDialogElement = (teContent, teInstruction);

  { TTaskDialogProgressState }
  //TTaskDialogProgressState = (psNormal, psPaused, psCanceled);

  { TProgressEvent }
  //TProgressEvent = procedure(Sender: TObject; var APosition: Integer;
  //  var AState: TTaskDialogProgressState) of object;

  { TTaskDialog }
  TTaskDialog = class(TCommonDialog)
  private
    FTitle, FInstruction, FContent, FFooter, FVerificationText: WideString;
    FExpandedInformation, FExpandedControlText, FCollapsedControlText: WideString;
    FButtons: TCommonButtons;
    FIcon, FFooterIcon: TTaskDialogIcon;
    FOptions: TTaskDialogOptions;
    FCustomButtons, FRadioButtons: TStringList;
    FModalResult, FRadioButtonResult, FDefaultButton, FDefaultRadioButton: Integer;
    FVerifyResult: Boolean;
    //FOnProgress: TProgressEvent;
    //function CallbackHandler(hWnd: HWND; Message: UINT; wParam: WPARAM;
    //  lParam: LPARAM; dwRefData: PDWORD): HRESULT stdcall;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClickButton(AButtonId: Cardinal);
    procedure ClickRadioButton(ARadioButtonId: Cardinal);
    procedure ClickVerification(AChecked: Boolean; ASetFocus: Boolean = False);
    procedure EnableButton(AButtonId: Cardinal; AEnable: Boolean);
    procedure EnableRadioButton(ARadioButtonId: Cardinal; AEnable: Boolean);
    function Execute(): Boolean; override;
    procedure SetElevationRequiredState(AButtonId: Cardinal; ARequired: Boolean = True);
    procedure UpdateElementText(ATaskDialogElement: TTaskDialogElement;
      ANewText: WideString);
    procedure UpdateIcon(ANewIcon: TTaskDialogIcon);
    { external }
    property CollapsedControlText: WideString read FCollapsedControlText write FCollapsedControlText;
    property CommonButtons: TCommonButtons read FButtons write FButtons;
    property Content: WideString read FContent write FContent;
    property CustomButtons: TStringList read FCustomButtons write FCustomButtons;
    property DefaultButton: Integer read FDefaultButton write FDefaultButton;
    property DefaultRadioButton: Integer read FDefaultRadioButton write FDefaultRadioButton;
    property ExpandedControlText: WideString read FExpandedControlText write FExpandedControlText;
    property ExpandedInformation: WideString read FExpandedInformation write FExpandedInformation;
    property Footer: WideString read FFooter write FFooter;
    property FooterIcon: TTaskDialogIcon read FFooterIcon write FFooterIcon;
    property Icon: TTaskDialogIcon read FIcon write FIcon;
    property Instruction: WideString read FInstruction write FInstruction;
    property ModalResult: Integer read FModalResult;
    //property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property Options: TTaskDialogOptions read FOptions write FOptions;
    property RadioButtons: TStringList read FRadioButtons write FRadioButtons;
    property RadioButtonResult: Integer read FRadioButtonResult;
    property Title: WideString read FTitle write FTitle;
    property VerifyResult: Boolean read FVerifyResult;
    property VerificationText: WideString read FVerificationText write FVerificationText;
  end;

  { TFileOpenDialog }
  TFileOpenDialog = class(TOpenDialog)
  protected
    function DoExecute(Func: Pointer): Bool;
  public
    function Execute(): Boolean; override;
  end;
  
  { TFileSaveDialog }
  TFileSaveDialog = class(TFileOpenDialog)
  public
    function Execute(): Boolean; override;
  end;

const
  { Enumeration to button translator }
  TDCommonButton: array[TCommonButton] of Byte = (
    TDCBF_OK_BUTTON,
    TDCBF_YES_BUTTON,
    TDCBF_NO_BUTTON,
    TDCBF_CANCEL_BUTTON,
    TDCBF_RETRY_BUTTON,
    TDCBF_CLOSE_BUTTON
  );

  { Enumeration to icon translator }
  TDIcon: array[TTaskDialogIcon] of Word = (
    TD_ICON_BLANK,
    TD_ICON_WARNING,
    TD_ICON_QUESTION,
    TD_ICON_ERROR,
    TD_ICON_INFORMATION,
    TD_ICON_SHIELD,
    TD_ICON_SHIELD_BANNER,
    TD_ICON_SHIELD_WARNING,
    TD_ICON_SHIELD_WARNING_BANNER,
    TD_ICON_SHIELD_QUESTION,
    TD_ICON_SHIELD_ERROR,
    TD_ICON_SHIELD_ERROR_BANNER,
    TD_ICON_SHIELD_OK,
    TD_ICON_SHIELD_OK_BANNER
  );

  { Enumeration to option translator }
  TDOption: array[TTaskDialogOption] of Word = (
    TDF_ENABLE_HYPERLINKS,
    TDF_USE_HICON_MAIN,
    TDF_USE_HICON_FOOTER,
    TDF_ALLOW_DIALOG_CANCELLATION,
    TDF_USE_COMMAND_LINKS,
    TDF_USE_COMMAND_LINKS_NO_ICON,
    TDF_EXPAND_FOOTER_AREA,
    TDF_EXPANDED_BY_DEFAULT,
    TDF_VERIFICATION_FLAG_CHECKED,
    TDF_SHOW_PROGRESS_BAR,
    TDF_SHOW_MARQUEE_PROGRESS_BAR,
    TDF_CALLBACK_TIMER,
    TDF_POSITION_RELATIVE_TO_WINDOW,
    TDF_RTL_LAYOUT,
    TDF_NO_DEFAULT_RADIO_BUTTON,
    TDF_CAN_BE_MINIMIZED
  );

  { Enumeration to element translator }
  TDElement: array[TTaskDialogElement] of Byte = (
    TDE_CONTENT,
    TDE_MAIN_INSTRUCTION
  );


function TaskDialogCallback(hWnd: HWND; uNotification: UINT; wParam: WPARAM;
  lParam: LPARAM; dwRefData: PDWORD): HRESULT; stdcall;

function ShowTaskDialog(AOwner: TComponent; ATitle, AInstruction,
  AContent: WideString; ACommonButtons: TCommonButtons; AIcon: TTaskDialogIcon;
  AOptions: TTaskDialogOptions = []): Integer;

procedure ShowException(AOwner: TComponent; AInstruction, AContent,
  AInformation: WideString; AOptions: TTaskDialogOptions = [doExpandFooter]);


implementation

{ InputCombo

  Shows a dialog with a pre defined TComboBox list item selection. Similar to
  the InputQuery dialog. }

function InputCombo(AOwner: TComponent; ACaption, APrompt: string;
  AList: TStrings; var AValue: string): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Combo: TComboBox;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;

  function GetCharSize(Canvas: TCanvas): TPoint;
  var
    i: Integer;
    Buffer: array[0..51] of Char;

  begin
    for i := 0 to 25 do
      Buffer[i] := Chr(i + Ord('A'));

    for i := 0 to 25 do
      Buffer[i + 26] := Chr(i + Ord('a'));

    GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(result));
    result.X := result.X div 52;
  end;

begin
  Result := False;

  // Init TForm
  Form := TForm.Create(Application);

  try
    with Form do
    begin
      Canvas.Font := Font;
      DialogUnits := GetCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      Position := poScreenCenter;
    end;  //of with

    // Init TLabel
    Prompt := TLabel.Create(Form);

    with Prompt do
    begin
      Parent := Form;
      Caption := APrompt;
      Left := MulDiv(8, DialogUnits.X, 4);
      Top := MulDiv(8, DialogUnits.Y, 8);
      Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
      WordWrap := True;
    end;  //of with

    // Init TComboBox
    Combo := TComboBox.Create(Form);

    with Combo do
    begin
      Parent := Form;
      Style := csDropDownList;
      Items.AddStrings(AList);
      ItemIndex := 0;
      Left := Prompt.Left;
      Top := Prompt.Top + Prompt.Height + 5;
      Width := MulDiv(164, DialogUnits.X, 4);
    end;  //of with

    ButtonTop := Combo.Top + Combo.Height + 15;
    ButtonWidth := MulDiv(50, DialogUnits.X, 4);
    ButtonHeight := MulDiv(14, DialogUnits.Y, 8);

    // Init "OK" TButton
    with TButton.Create(Form) do
    begin
      Parent := Form;
      Caption := 'OK';
      ModalResult := mrOk;
      Default := True;
      SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
        ButtonHeight);
    end;  //of with

    // Init "Cancel" TButton
    with TButton.Create(Form) do
    begin
      Parent := Form;
      Caption := 'Cancel';
      ModalResult := mrCancel;
      Cancel := True;
      SetBounds(MulDiv(92, DialogUnits.X, 4), Combo.Top + Combo.Height + 15,
        ButtonWidth, ButtonHeight);
      Form.ClientHeight := Top + Height + 13;
    end;  //of with

    // "OK" clicked?
    if (Form.ShowModal = mrOk) then
    begin
      AValue := Combo.Text;
      Result := True;
    end;  //of begin

  finally
    Form.Free;
  end;  // of try
end;

{ ShowAddRegistryDialog

  Shows an dialog where user has the choice to add a *.reg file.  }

function ShowAddRegistryDialog(ARegFilePath: string): Boolean;
var
  RegFilePath: string;

begin
  if (ARegFilePath = '') then
    raise Exception.Create('Missing parameter with a .reg file!');

  if (ARegFilePath[1] <> '"') then
    RegFilePath := '"'+ ARegFilePath +'"'
  else
    RegFilePath := ARegFilePath;

  Result := BOOL(ShellExecute(0, 'open', PChar('regedit.exe'), PChar(RegFilePath),
    nil, SW_SHOWNORMAL));
end;

{ TaskDialogCallback

  Receives notification events from TaskDialog. }

function TaskDialogCallback(hWnd: HWND; uNotification: UINT; wParam: WPARAM;
  lParam: LPARAM; dwRefData: PDWORD): HRESULT;
begin
  case uNotification of
    //TDN_CREATED:
    //TDN_NAVIGATED:             
    //TDN_BUTTON_CLICKED:

    TDN_HYPERLINK_CLICKED:
      ShellExecuteW(hWnd, 'open', PWideChar(lParam), nil, nil, SW_SHOWNORMAL);

    //TDN_TIMER:
    //TDN_DESTROYED:
    //TDN_RADIO_BUTTON_CLICKED:
    //TDN_DIALOG_CONSTRUCTED:
    //TDN_VERIFICATION_CLICKED:
    //TDN_HELP:
    //TDN_EXPANDO_BUTTON_CLICKED:
  end;  //of case

  Result := S_OK;
end;


{ TTaskDialog }

{ public TTaskDialog.Create

  Constructor for creating a TTaskDialog instance. }

constructor TTaskDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCustomButtons := TStringList.Create();
  FRadioButtons := TStringList.Create();
end;

{ public TTaskDialog.Destroy

  Destructor for destroying a TTaskDialog instance. }

destructor TTaskDialog.Destroy;
begin
  FRadioButtons.Free;
  FCustomButtons.Free;
  inherited Destroy;
end;

{function TTaskDialog.CallbackHandler(hWnd: HWND; Message: UINT; wParam: WPARAM;
  lParam: LPARAM; dwRefData: PDWORD): HRESULT;
begin

end;}

{ public TTaskDialog.ClickButton

  Invokes the click event of a button. }

procedure TTaskDialog.ClickButton(AButtonId: Cardinal);
begin
  SendMessage(GetParent(Handle), TDM_CLICK_BUTTON, WParam(AButtonId), 0);
end;

{ public TTaskDialog.ClickRadioButton

  Invokes the click event of a radio button. }

procedure TTaskDialog.ClickRadioButton(ARadioButtonId: Cardinal);
begin
  if (FRadioButtons.Count > 0) then
    SendMessage(GetParent(Handle), TDM_CLICK_RADIO_BUTTON, WParam(ARadioButtonId), 0);
end;

{ public TTaskDialog.ClickVerification

  Invokes the click event of the verification checkbox. }

procedure TTaskDialog.ClickVerification(AChecked: Boolean; ASetFocus: Boolean = False);
begin
  if (FVerificationText <> '') then
    SendMessage(GetParent(Handle), TDM_CLICK_VERIFICATION, WParam(Ord(AChecked)),
      LParam(Ord(ASetFocus)));
end;

{ public TTaskDialog.EnableButton

  Enables or disables a button. }

procedure TTaskDialog.EnableButton(AButtonId: Cardinal; AEnable: Boolean);
begin
  SendMessage(GetParent(Handle), TDM_ENABLE_BUTTON, WParam(AButtonId),
    LParam(Ord(AEnable)));
end;

{ public TTaskDialog.EnableRadioButton

  Enables or disables a radio button. }

procedure TTaskDialog.EnableRadioButton(ARadioButtonId: Cardinal; AEnable: Boolean);
begin
  SendMessage(GetParent(Handle), TDM_ENABLE_RADIO_BUTTON, WParam(ARadioButtonId),
    LParam(Ord(AEnable)));
end;

{ public TTaskDialog.Execute

  Executes a configured TaskDialog. }

function TTaskDialog.Execute(): Boolean;
var
  Dialog: TTaskDialogConfig;
  Option: TTaskDialogOption;
  Button: TCommonButton;
  i: Integer;
  CustomButtons, RadioButtons: array of TTaskDialogButton;

begin
  FillChar(Dialog, SizeOf(Dialog), 0);

  with Dialog do
  begin
    cbSize := SizeOf(Dialog);
    hwndParent := Handle;

    // Setup icons
    pszMainIcon := MAKEINTRESOURCEW(TDIcon[FIcon]);
    pszFooterIcon := MAKEINTRESOURCEW(TDIcon[FFooterIcon]);

    // Setup options
    for Option := Low(Option) to High(Option) do
      if (Option in FOptions) then
        dwFlags := dwFlags + Cardinal(TDOption[Option]);

    // Setup custom buttons
    if (FCustomButtons.Count > 0) then
    begin
      SetLength(CustomButtons, FCustomButtons.Count);

      for i := 0 to FCustomButtons.Count - 1 do
        with CustomButtons[i] do
        begin
          nButtonId := CUSTOM_BUTTON1 + i;
          pszButtonText := StringToOleStr(FCustomButtons[i]);
        end;  //of with

      cButtons := Length(CustomButtons);
      pButtons := @CustomButtons[0];
    end  //of begin
    else
      // Setup common buttons
      for Button := Low(Button) to High(Button) do
        if (Button in FButtons) then
          dwCommonButtons := dwCommonButtons + Cardinal(TDCommonButton[Button]);

    nDefaultButton := FDefaultButton;

    // Setup radio buttons
    if (FRadioButtons.Count > 0) then
    begin
      SetLength(RadioButtons, FRadioButtons.Count);

      for i := 0 to FRadioButtons.Count - 1 do
        with RadioButtons[i] do
        begin
          nButtonId := RADIO_BUTTON1 + i;
          pszButtonText := StringToOleStr(FRadioButtons[i]);
        end;  //of with

      cRadioButtons := Length(RadioButtons);
      pRadioButtons := @RadioButtons[0];
      nDefaultRadioButton := FDefaultRadioButton;
    end;  //of begin

    // Enable nofication message receiving
    pfCallback := TaskDialogCallback;

    // Setup text
    pszWindowTitle := PWideChar(FTitle);
    pszMainInstruction := PWideChar(FInstruction);
    pszContent := PWideChar(FContent);
    pszExpandedInformation := PWideChar(FExpandedInformation);
    pszExpandedControlText := PWideChar(FExpandedControlText);
    pszCollapsedControlText := PWideChar(FCollapsedControlText);
    pszVerificationText := PWideChar(FVerificationText);
    pszFooterText := PWideChar(FFooter);
  end;  //of with

  Result := Succeeded(TaskDialogIndirect(@Dialog, @FModalResult,
    @FRadioButtonResult, @FVerifyResult));
end;

{ public TTaskDialog.SetElevationRequiredState

  Sets the UAC shield icon to a button. }

procedure TTaskDialog.SetElevationRequiredState(AButtonId: Cardinal;
  ARequired: Boolean = True);
begin
  SendMessage(GetParent(Handle), TDM_SET_BUTTON_ELEVATION_REQUIRED_STATE,
    WParam(AButtonId), LParam(ARequired));
end;

{ public TTaskDialog.UpdateElementText

  Updates the text of either instruction or content. }

procedure TTaskDialog.UpdateElementText(ATaskDialogElement: TTaskDialogElement;
  ANewText: WideString);
begin
  SendMessage(GetParent(Handle), TDM_UPDATE_ELEMENT_TEXT,
    WParam(TDElement[ATaskDialogElement]), LParam(PWideChar(ANewText)));
end;

{ public TTaskDialog.UpdateIcon

  Updates the icon of either instruction or content. }

procedure TTaskDialog.UpdateIcon(ANewIcon: TTaskDialogIcon);
begin
  if not ((doUseMainIcon in FOptions) and (doUseFooterIcon in FOptions)) then
    SendMessage(GetParent(Handle), TDM_UPDATE_ICON, 0,
      LParam(MAKEINTRESOURCEW(TDIcon[ANewIcon])));
end;


{ ShowTaskDialog

  Shows the new task dialog of Windows Vista. }

function ShowTaskDialog(AOwner: TComponent; ATitle, AInstruction,
  AContent: WideString; ACommonButtons: TCommonButtons; AIcon: TTaskDialogIcon;
  AOptions: TTaskDialogOptions = []): Integer;
var
  TaskDialog: TTaskDialog;

begin
  Result := -1;
  TaskDialog := TTaskDialog.Create(AOwner);

  try
    with TaskDialog do
    begin
      Title := ATitle;
      Instruction := AInstruction;
      Content := AContent;
      CommonButtons := ACommonButtons;
      Icon := AIcon;
      Options := AOptions;

      if ((AIcon = tiWarning) and (cbNo in ACommonButtons)) then
        DefaultButton := IDNO;
    end;  //of with

    if not TaskDialog.Execute() then
      raise Exception.Create(SysErrorMessage(GetLastError()));

    Result := TaskDialog.ModalResult;

  finally
    TaskDialog.Free;
  end;  //of try
end;

{ ShowException

  Shows an exception with additional information. }

procedure ShowException(AOwner: TComponent; AInstruction, AContent,
  AInformation: WideString; AOptions: TTaskDialogOptions = [doExpandFooter]);
var
  TaskDialog: TTaskDialog;

begin
  TaskDialog := TTaskDialog.Create(AOwner);

  try
    with TaskDialog do
    begin
      Instruction := AInstruction;
      Content := AContent;
      CommonButtons := [cbClose];
      Icon := tiError;
      ExpandedInformation := AInformation;
      Options := AOptions;
    end;  //of with

    if not TaskDialog.Execute() then
      raise Exception.Create(AInstruction +': '+ AContent + sLinebreak + AInformation);

  finally
    TaskDialog.Free;
  end;  //of try
end;

{ TFileOpenDialog }

{ protected TFileOpenDialog.DoExecute

  Performs either the GetOpenFileName or GetSaveFileName function. }

function TFileOpenDialog.DoExecute(Func: Pointer): Bool;
const
  OpenOptions: array [TOpenOption] of DWORD = (
    OFN_READONLY, OFN_OVERWRITEPROMPT, OFN_HIDEREADONLY,
    OFN_NOCHANGEDIR, OFN_SHOWHELP, OFN_NOVALIDATE, OFN_ALLOWMULTISELECT,
    OFN_EXTENSIONDIFFERENT, OFN_PATHMUSTEXIST, OFN_FILEMUSTEXIST,
    OFN_CREATEPROMPT, OFN_SHAREAWARE, OFN_NOREADONLYRETURN,
    OFN_NOTESTFILECREATE, OFN_NONETWORKBUTTON, OFN_NOLONGNAMES,
    OFN_EXPLORER, OFN_NODEREFERENCELINKS, OFN_ENABLEINCLUDENOTIFY,
    OFN_ENABLESIZING, OFN_DONTADDTORECENT, OFN_FORCESHOWHIDDEN);

  OpenOptionsEx: array [TOpenOptionEx] of DWORD = (OFN_EX_NOPLACESBAR);

var
  OpenFileName: TOpenFilenameA;
  szFile: array[0..MAX_PATH] of Char;
  Option: TOpenOption;
  OptionEx: TOpenOptionEx;

begin
  FillChar(OpenFileName, SizeOf(OpenFileName), 0);

  with OpenFileName do
  begin
    lStructSize := SizeOf(OpenFileName);
    hwndOwner := Application.Handle;
    lpstrFile := szFile;
    nMaxFile := SizeOf(szFile);
    lpstrTitle := PChar(Title);
    lpstrInitialDir := PChar(InitialDir);
    StrPCopy(lpstrFile, FileName);
    lpstrFilter := PChar(Filter);
    nFilterIndex := FilterIndex;
    lpstrDefExt := PChar(DefaultExt);

    // Setup options
    for Option := Low(Option) to High(Option) do
      if (Option in Options) then
        Flags := Flags or OpenOptions[Option];

    for OptionEx := Low(OptionEx) to High(OptionEx) do
      if (OptionEx in OptionsEx) then
        FlagsEx := FlagsEx or OpenOptionsEx[OptionEx];
  end;

  Result := TaskModalDialog(Func, OpenFileName);

  if Result then
    Self.FileName := StrPas(OpenFileName.lpstrFile);
end;

{ public TFileOpenDialog.Execute

  Performs GetOpenFileName function. }

function TFileOpenDialog.Execute: Boolean;
begin
  Result := DoExecute(@GetOpenFileName);
end;


{ TFileSaveDialog }

{ public TFileSaveDialog.Execute

  Performs GetSaveFileName function. }

function TFileSaveDialog.Execute(): Boolean;
begin
  Result := DoExecute(@GetSaveFileName);
end;

end.
