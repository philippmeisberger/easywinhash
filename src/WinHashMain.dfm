object Main: TMain
  Left = 192
  Top = 124
  Caption = 'WinHash'
  ClientHeight = 178
  ClientWidth = 400
  Color = clBtnFace
  Constraints.MinHeight = 236
  Constraints.MinWidth = 416
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    400
    178)
  PixelsPerInch = 96
  TextHeight = 13
  object cbxAlgorithm: TComboBox
    Left = 24
    Top = 132
    Width = 73
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    ItemIndex = 0
    TabOrder = 0
    Text = 'MD5'
    Items.Strings = (
      'MD5'
      'SHA-1'
      'SHA-256'
      'SHA-384'
      'SHA-512')
  end
  object bCalculate: TButton
    Left = 301
    Top = 129
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Berechnen'
    TabOrder = 1
    OnClick = bCalculateClick
  end
  object pbProgress: TProgressBar
    Left = 24
    Top = 106
    Width = 352
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Smooth = True
    Step = 1
    TabOrder = 2
  end
  object bVerify: TButton
    Left = 164
    Top = 130
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = #220'berpr'#252'fen'
    TabOrder = 3
    OnClick = bVerifyClick
  end
  object bBrowse: TButton
    Left = 342
    Top = 30
    Width = 33
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 4
    OnClick = bBrowseClick
  end
  object eFile: TLabeledEdit
    Left = 24
    Top = 32
    Width = 312
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 28
    EditLabel.Height = 13
    EditLabel.Caption = 'Datei:'
    TabOrder = 5
  end
  object eHash: TLabeledEdit
    Left = 24
    Top = 74
    Width = 352
    Height = 21
    Anchors = [akLeft, akRight]
    EditLabel.Width = 28
    EditLabel.Height = 13
    EditLabel.Caption = 'Hash:'
    TabOrder = 6
  end
  object MainMenu: TMainMenu
    Left = 256
    Top = 128
    object mmView: TMenuItem
      Caption = 'Ansicht'
      object mmLang: TMenuItem
        Caption = 'Sprache w'#228'hlen'
      end
    end
    object mmHelp: TMenuItem
      Caption = 'Hilfe'
      object mmUpdate: TMenuItem
        Caption = 'Nach Update suchen'
        OnClick = mmUpdateClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mmInstallCertificate: TMenuItem
        Caption = 'Zertifikat installieren'
      end
      object mmReport: TMenuItem
        Caption = 'Fehler melden'
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mmAbout: TMenuItem
        Caption = #220'ber ...'
      end
    end
  end
  object Taskbar: TTaskbar
    TaskBarButtons = <>
    TabProperties = []
    Left = 112
    Top = 128
  end
end
