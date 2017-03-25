{ *********************************************************************** }
{                                                                         }
{ PM Code Works Dialogs Unit                                              }
{                                                                         }
{ Copyright (c) 2011-2017 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit PMCW.Dialogs;

interface

uses
  Winapi.Windows, Winapi.CommCtrl, Vcl.StdCtrls;

type
  /// <summary>
  ///   Possible icons in the balloon tip.
  /// </summary>
  TBalloonIcon = (
    biNone, biInfo, biWarning, biError, biInfoLarge, biWarningLarge, biErrorLarge
  );

  TCustomEditHelper = class helper for TCustomEdit
    /// <summary>
    ///   Shows a balloon tip.
    /// </summary>
    /// <param name="ATitle">
    ///   The title to display.
    /// </param>
    /// <param name="AText">
    ///   The text to display.
    /// </param>
    /// <param name="AIcon">
    ///   Optional: A <see cref="TBalloonIcon"/> icon to use.
    /// </param>
    /// <returns>
    ///   <c>True</c> if balloon tip was shown successful or <c>False</c>
    ///   otherwise.
    /// </returns>
    function ShowBalloonTip(const ATitle, AText: string;
      AIcon: TBalloonIcon = biInfo): Boolean;
  end;

implementation

{ TCustomEditHelper }

function TCustomEditHelper.ShowBalloonTip(const ATitle, AText: string;
  AIcon: TBalloonIcon = biInfo): Boolean;
var
  BalloonTip: TEditBalloonTip;

begin
  ZeroMemory(@BalloonTip, SizeOf(TEditBalloonTip));

  with BalloonTip do
  begin
    cbStruct := SizeOf(TEditBalloonTip);
    pszTitle := PChar(ATitle);
    pszText := PChar(AText);
    ttiIcon := Ord(AIcon);
  end;  //of with

  Result := Edit_ShowBalloonTip(Handle, BalloonTip);
end;

end.
