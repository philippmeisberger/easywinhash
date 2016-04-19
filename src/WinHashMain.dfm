object Main: TMain
  Left = 192
  Top = 124
  Caption = 'EasyWinHash'
  ClientHeight = 177
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
    177)
  PixelsPerInch = 96
  TextHeight = 13
  object lHash: TLabel
    Left = 24
    Top = 64
    Width = 28
    Height = 13
    Caption = 'Hash:'
    FocusControl = eHash
  end
  object lFile: TLabel
    Left = 24
    Top = 16
    Width = 28
    Height = 13
    Caption = 'Datei:'
    FocusControl = eFile
  end
  object cbxAlgorithm: TComboBox
    Left = 24
    Top = 144
    Width = 73
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    ItemIndex = 0
    TabOrder = 2
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
    Top = 144
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Berechnen'
    TabOrder = 4
    OnClick = bCalculateClick
  end
  object pbProgress: TProgressBar
    Left = 24
    Top = 114
    Width = 352
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Smooth = True
    Step = 1
    TabOrder = 5
  end
  object bVerify: TButton
    Left = 164
    Top = 144
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = #220'berpr'#252'fen'
    TabOrder = 3
    OnClick = bVerifyClick
  end
  object eHash: TButtonedEdit
    Left = 24
    Top = 78
    Width = 351
    Height = 21
    Anchors = [akLeft, akRight]
    Images = ButtonImages
    ParentShowHint = False
    RightButton.DisabledImageIndex = 0
    RightButton.HotImageIndex = 0
    RightButton.ImageIndex = 0
    RightButton.PressedImageIndex = 0
    RightButton.Visible = True
    ShowHint = True
    TabOrder = 1
    OnRightButtonClick = eHashRightButtonClick
  end
  object eFile: TButtonedEdit
    Left = 24
    Top = 30
    Width = 351
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    AutoSelect = False
    Images = ButtonImages
    ParentShowHint = False
    RightButton.DisabledImageIndex = 1
    RightButton.HotImageIndex = 1
    RightButton.ImageIndex = 1
    RightButton.PressedImageIndex = 1
    RightButton.Visible = True
    ShowHint = True
    TabOrder = 0
    OnRightButtonClick = eFileRightButtonClick
  end
  object MainMenu: TMainMenu
    Left = 304
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
        OnClick = mmInstallCertificateClick
      end
      object mmReport: TMenuItem
        Caption = 'Fehler melden'
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mmAbout: TMenuItem
        Caption = #220'ber ...'
        OnClick = mmInfoClick
      end
    end
  end
  object Taskbar: TTaskbar
    TaskBarButtons = <>
    TabProperties = []
    Left = 168
  end
  object ButtonImages: TImageList
    Left = 232
    Bitmap = {
      494C010102000C00340010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      00000000000000000000000000000000000000000000CDD3DE00B7C9D600B6C7
      D600B7C8D700B7C8D700B7C8D700B7C9D700B7C9D800B7C8D800B5C7D600B5C7
      D600B5C7D600B7CBD900CFD5DD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFF8F30027679900005188000D47
      6E0006446B0007426A0006406700053F6400033E6200043B5F0021597E00225B
      80002155780000447500316C9A00FFFFFB000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D1D1D10062626200FCFCFC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFB002F7DB1005E8AA400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0089857B008781
      7A00B9AB9E00416D85004284B500FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B8B8B8006161610000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFDFA00307CAF005183A200FAF0
      E900E6E7E700E5E6E600E6E7E700EBEBEB00F3F3F300FFFFFF0083888500BCBB
      BB00878179002C5B77004284B400FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D5D5
      D50060606000F7F7F70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFDFA002F7CAE005187A700FEF4
      ED00E8E9EA00E3E3E300E3E3E300E1E1E100E2E2E200F2F2F200DEDFDE00DEE1
      DF00CFCBC1002F5E79004283B400FFFFFF00000000000000000000000000DDDD
      DD006F6F6F0060606000606060005F5F5F0097979700F8F8F800BDBDBD005D5D
      5D00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFDFA002F7BAF005389A900FFF6
      EF00E3E4E400D2D1D100D4D4D400D2D3D300D4D4D400E9E9E900F4F4F400FCFC
      FD00FFFFFA003C6B85004082B200FFFFFF000000000000000000B1B1B1005E5E
      5E00DADADA00F6F6F60000000000F0F0F000AAAAAA006666660086868600FBFB
      FB00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFDFA002F7CB000538AAC00FFF6
      EF00E5E5E600D4D5D500D6D7D700D6D6D600D4D4D400D0D1D100CCCCCC00D0D1
      D200FEF4ED003B6B88004082B000FFFFFF0000000000CDCDCD00656565000000
      00000000000000000000000000000000000000000000E8E8E80069696900F8F8
      F800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFDF9002F7CAF00538BAF00FFF7
      EF00E6E8E800D5D5D500D7D7D700D6D6D600D6D6D600D5D5D500D8D8D800E8E9
      E900F7EEE7003C6F8C004082B100FFFFFF000000000063636300F5F5F5000000
      00000000000000000000000000000000000000000000000000009A9A9A00ADAD
      AD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFDF9002F7CAF00538EB100FFF7
      EF00E7E9E900D8D8D800D9DBDB00D9DADA00D8D9D900D7D8D800D8D9D900ECEC
      EC00F8F0E8003C708F004080B000FFFFFF00E3E3E30071717100000000000000
      0000000000000000000000000000000000000000000000000000DADADA007A7A
      7A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFDF9002F7DAF00538FB500FFF6
      EF00E7E9E900D8D9D900DBDCDC00DBDBDB00D8DADA00D8D9D900D3D4D400E8E9
      E900F9F0E9003D7292004081B000FFFFFF00DDDDDD0087878700000000000000
      0000000000000000000000000000000000000000000000000000E2E2E2007E7E
      7E00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFDF9002F7CB0005392B600FFF6
      EE00E6E8E800D2D3D300D5D6D600D5D6D600D5D6D600D6D6D600D3D4D400D8DA
      DB00FEF3EC003D7596004080AE00FFFFFF00E7E7E7006D6D6D00000000000000
      0000000000000000000000000000000000000000000000000000D5D5D5007E7E
      7E00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFDF9002F7DB0005393B800FFF4
      EC00F1F3F300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00EFF1
      F100FCF1E9003D769700407FAE00FFFFFF000000000062626200F6F6F6000000
      000000000000000000000000000000000000000000000000000099999900AEAE
      AE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFDF9002F7DAF005596BD00FFFD
      F600DADCDD0071747400797E7E00797D7D00787D7D00787D7D0072757500DDDE
      DF00FFFAF3003F7A9E004080AD00FFFFFF0000000000DCDCDC005F5F5F00FEFE
      FE000000000000000000000000000000000000000000DEDEDE005E5E5E00FAFA
      FA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFBF600267BB1005196BE00FFE1
      C800C0B8AF0095A3A300A8B5B500A7B3B300A7B2B200A7B3B3008B979800C7BE
      B300FADFC7003A769800397DAE00FFFFFF000000000000000000ACACAC005B5B
      5B00D9D9D9000000000000000000000000009D9D9D0053535300F4F4F4000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF008094AD00376DA0002B66
      A6004D6B92009C9D96008E9B9B008F9D9D00909E9E008F9D9D009F9F98004C6A
      98002C65A3003973A6007F9BB100FFFFFF00000000000000000000000000EDED
      ED0074747400636363006868680062626200A0A0A00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00F3F1F100494E4E00777E7E00777E7E00494C4C00F6F4F500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FBFBFB00F6F6F600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF008001FFFC000000000000FFF800000000
      0000FFF3000000000000FFE3000000000000E00F000000000000C20F00000000
      00009F8F0000000000009FCF0000000000003FCF0000000000003FCF00000000
      00003FCF0000000000009FCF0000000000008F8F000000000000C71F00000000
      0000E07F000000000000F9FF0000000000000000000000000000000000000000
      000000000000}
  end
end
