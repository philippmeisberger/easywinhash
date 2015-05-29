{ *********************************************************************** }
{                                                                         }
{ PM Code Works Additional Common Controls Unit                           }
{                                                                         }
{ Copyright (c) 2011-2015 P.Meisberger (PM Code Works)                    }
{                                                                         }
{ *********************************************************************** }

unit PMCW.CommCtrl;

interface

uses
  Winapi.CommCtrl;

type
  { Balloon tip icon }
  TBalloonIcon = (biNone, biInfo, biWarning, biError, biInfoLarge,
    biWarningLarge, biErrorLarge);

function Edit_ShowBalloonTip(AEditHandle: THandle; ATitle, AText: WideString;
  AIcon: TBalloonIcon = biInfo): Boolean; overload;

implementation

{ Edit_ShowBalloonTip

  Shows a balloon tip inside an edit field with more comfortable usage. }

function Edit_ShowBalloonTip(AEditHandle: THandle; ATitle, AText: WideString;
  AIcon: TBalloonIcon = biInfo): Boolean;
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

  Result := Winapi.CommCtrl.Edit_ShowBalloonTip(AEditHandle, BalloonTip);
end;

end.
