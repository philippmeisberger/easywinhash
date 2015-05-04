{ *********************************************************************** }
{                                                                         }
{ PM Code Works Additional Common Controls Unit                           }
{                                                                         }
{ Copyright (c) 2011-2015 P.Meisberger (PM Code Works)                    }
{                                                                         }
{ *********************************************************************** }

unit AddCommCtrl;

interface

uses
  Windows;

const
  { Balloon tip icons }
  TTI_NONE          = 0;
  TTI_INFO          = 1;
  TTI_WARNING       = 2;
  TTI_ERROR         = 3;
  TTI_INFO_LARGE    = 4;
  TTI_WARNING_LARGE = 5;
  TTI_ERROR_LARGE   = 6;

  { Edit control messages }
  ECM_FIRST         = $1500;
  EM_SETCUEBANNER   = ECM_FIRST + 1;
  EM_GETCUEBANNER   = ECM_FIRST + 2;

function Edit_GetCueBannerText(hEdit: HWND; lpcwText: WideString; cchText: LongInt): BOOL;
function Edit_SetCueBannerText(hEdit: HWND; lpcwText: WideString): BOOL;

type
  _tagEDITBALLOONTIP = record
    cbStruct: DWORD;
    pszTitle,
    pszText: PWideChar;
    ttiIcon: Integer;
  end;
  EDITBALLOONTIP  = _tagEDITBALLOONTIP;
  TEditBalloonTip = _tagEDITBALLOONTIP;
  PEditBalloonTip = ^TEditBalloonTip;

  { Balloon tip icon }
  TBalloonIcon = (biNone, biInfo, biWarning, biError, biInfoLarge,
    biWarningLarge, biErrorLarge);

const
  EM_SHOWBALLOONTIP = ECM_FIRST + 3;
  EM_HIDEBALLOONTIP = ECM_FIRST + 4;

function Edit_ShowBalloonTip(hEdit: HWND; pEditBalloonTip: PEditBalloonTip): BOOL; overload;
function Edit_ShowBalloonTip(AEditHandle: THandle; ATitle, AText: WideString;
  AIcon: TBalloonIcon = biInfo): BOOL; overload;
function Edit_HideBalloonTip(hEdit: HWND): BOOL;

const
  { Button control messages }
  BCM_FIRST         = $1600;
  BCM_SETSHIELD     = BCM_FIRST + $000C;

function Button_SetElevationRequiredState(hButton: HWND; fRequired: BOOL = True): BOOL;

const
  { Combobox control messages }
  CBM_FIRST             = $1700;

implementation

{ Edit_ShowBalloonTip

  Shows a balloon tip inside an edit field. }

function Edit_ShowBalloonTip(hEdit: HWND; pEditBalloonTip: PEditBalloonTip): BOOL;
begin
  Result := BOOL(SendMessage(hEdit, EM_SHOWBALLOONTIP, 0, LParam(pEditBalloonTip)));
end;

{ Edit_ShowBalloonTip

  Shows a balloon tip inside an edit field with more comfortable usage. }

function Edit_ShowBalloonTip(AEditHandle: THandle; ATitle, AText: WideString;
  AIcon: TBalloonIcon = biInfo): BOOL;
var
  BalloonTip: TEditBalloonTip;

begin
  FillChar(BalloonTip, SizeOf(BalloonTip), 0);

  with BalloonTip do
  begin
    cbStruct := SizeOf(BalloonTip);
    pszTitle := PWideChar(ATitle);
    pszText := PWideChar(AText);
    ttiIcon := Ord(AIcon);
  end;  //of with

  Result := Edit_ShowBalloonTip(AEditHandle, @BalloonTip);
end;

{ Edit_HideBalloonTip

  Hides the balloon tip inside an edit field. }

function Edit_HideBalloonTip(hEdit: HWND): BOOL;
begin
  Result := BOOL(SendMessage(hEdit, EM_HIDEBALLOONTIP, 0, 0));
end;

{ Edit_SetCueBannerText

  Sets a cue text for an edit field. }

function Edit_SetCueBannerText(hEdit: HWND; lpcwText: WideString): BOOL;
begin
  Result := BOOL(SendMessage(hEdit, EM_SETCUEBANNER, 0, LParam(lpcwText)));
end;

{ Edit_SetCueBannerText

  Gets the cue text from an edit field. }

function Edit_GetCueBannerText(hEdit: HWND; lpcwText: WideString; cchText: LongInt): BOOL;
begin
  Result := BOOL(SendMessage(hEdit, EM_GETCUEBANNER, WParam(lpcwText), LParam(cchText)));
end;

{ Button_SetElevationRequiredState

  Adds the Windows UAC shield to a button. }

function Button_SetElevationRequiredState(hButton: HWND; fRequired: BOOL = True): BOOL;
begin
  Result := BOOL(SendMessage(hButton, BCM_SETSHIELD, 0, Ord(fRequired)));
end;

end.
