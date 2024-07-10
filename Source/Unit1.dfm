object Main: TMain
  Left = 192
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Spider-Man Settings'
  ClientHeight = 197
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object VideoGB: TGroupBox
    Left = 8
    Top = 8
    Width = 265
    Height = 150
    Caption = 'Video'
    TabOrder = 1
    object ResLbl: TLabel
      Left = 8
      Top = 20
      Width = 53
      Height = 13
      Caption = 'Resolution:'
    end
    object AspectRatioLbl: TLabel
      Left = 8
      Top = 52
      Width = 59
      Height = 13
      Caption = 'Aspect ratio:'
    end
    object ColorDepthLbl: TLabel
      Left = 8
      Top = 84
      Width = 57
      Height = 13
      Caption = 'Color depth:'
    end
    object BrightnessLbl: TLabel
      Left = 8
      Top = 118
      Width = 52
      Height = 13
      Caption = 'Brightness:'
    end
    object BrightnessValLbl: TLabel
      Left = 248
      Top = 117
      Width = 6
      Height = 13
      Caption = '4'
    end
    object ResolutionsCB: TComboBox
      Left = 128
      Top = 16
      Width = 129
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnChange = ResolutionsCBChange
    end
    object AspectRatiosCB: TComboBox
      Left = 128
      Top = 48
      Width = 129
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
    end
    object ColorDepthCB: TComboBox
      Left = 128
      Top = 80
      Width = 129
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 1
      TabOrder = 2
      Text = '32'
      Items.Strings = (
        '16'
        '32')
    end
    object TrackBar1: TTrackBar
      Left = 121
      Top = 112
      Width = 127
      Height = 33
      Max = 9
      Position = 4
      TabOrder = 3
      OnChange = TrackBar1Change
    end
  end
  object ApplyBtn: TButton
    Left = 8
    Top = 164
    Width = 75
    Height = 25
    Caption = 'Apply'
    TabOrder = 0
    OnClick = ApplyBtnClick
  end
  object ExitBtn: TButton
    Left = 88
    Top = 164
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 2
    OnClick = ExitBtnClick
  end
  object AboutBtn: TButton
    Left = 248
    Top = 164
    Width = 25
    Height = 25
    Caption = '?'
    TabOrder = 3
    OnClick = AboutBtnClick
  end
  object XPManifest1: TXPManifest
    Left = 104
    Top = 48
  end
end
