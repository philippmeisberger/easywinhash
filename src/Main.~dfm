object Form1: TForm1
  Left = 192
  Top = 124
  Width = 369
  Height = 221
  Caption = 'GHash'
  Color = clBtnFace
  Constraints.MinHeight = 221
  Constraints.MinWidth = 369
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    353
    163)
  PixelsPerInch = 96
  TextHeight = 13
  object cbxAlgorithm: TComboBox
    Left = 24
    Top = 128
    Width = 73
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = 'MD5'
    OnClick = cbxAlgorithmClick
    Items.Strings = (
      'MD5'
      'SHA-1'
      'SHA-256'
      'SHA-384'
      'SHA-512')
  end
  object bCalculate: TButton
    Left = 256
    Top = 126
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Berechnen'
    TabOrder = 1
    OnClick = bCalculateClick
  end
  object pbProgress: TProgressBar
    Left = 24
    Top = 102
    Width = 305
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 2
  end
  object bVerify: TButton
    Left = 140
    Top = 126
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = #220'berpr'#252'fen'
    TabOrder = 3
    OnClick = bVerifyClick
  end
  object bBrowse: TButton
    Left = 296
    Top = 32
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
    Width = 265
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 28
    EditLabel.Height = 13
    EditLabel.Caption = 'Datei:'
    TabOrder = 5
  end
  object eHash: TLabeledEdit
    Left = 24
    Top = 72
    Width = 305
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 28
    EditLabel.Height = 13
    EditLabel.Caption = 'Hash:'
    TabOrder = 6
  end
  object XPManifest: TXPManifest
    Left = 320
  end
  object MainMenu: TMainMenu
    Left = 288
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
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mmDownloadCert: TMenuItem
        Caption = 'Zertifikat herunterladen'
      end
      object mmReport: TMenuItem
        Caption = 'Fehler melden'
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object ber1: TMenuItem
        Caption = #220'ber ...'
      end
    end
  end
end
