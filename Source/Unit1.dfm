object Main: TMain
  Left = 191
  Top = 124
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Spider-Man Settings'
  ClientHeight = 351
  ClientWidth = 553
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object VideoGB: TGroupBox
    Left = 8
    Top = 8
    Width = 265
    Height = 145
    Caption = 'Video'
    TabOrder = 1
    object ResLbl: TLabel
      Left = 8
      Top = 23
      Width = 53
      Height = 13
      Caption = 'Resolution:'
    end
    object AspectRatioLbl: TLabel
      Left = 8
      Top = 52
      Width = 64
      Height = 13
      Caption = 'Aspect Ratio:'
    end
    object ColorDepthLbl: TLabel
      Left = 8
      Top = 82
      Width = 59
      Height = 13
      Caption = 'Color Depth:'
    end
    object BrightnessLbl: TLabel
      Left = 8
      Top = 116
      Width = 52
      Height = 13
      Caption = 'Brightness:'
    end
    object BrightnessValLbl: TLabel
      Left = 248
      Top = 115
      Width = 6
      Height = 13
      Caption = '4'
    end
    object ResolutionsCB: TComboBox
      Left = 128
      Top = 20
      Width = 129
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnChange = ResolutionsCBChange
    end
    object AspectRatiosCB: TComboBox
      Left = 128
      Top = 49
      Width = 129
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
    end
    object ColorDepthCB: TComboBox
      Left = 128
      Top = 78
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
    object BrightnessTB: TTrackBar
      Left = 121
      Top = 106
      Width = 127
      Height = 30
      Max = 9
      Position = 4
      TabOrder = 3
      OnChange = BrightnessTBChange
    end
  end
  object CompatibilityGB: TGroupBox
    Left = 280
    Top = 160
    Width = 265
    Height = 145
    Caption = 'Compatibility'
    TabOrder = 2
    object DXWrapperCB: TCheckBox
      Left = 8
      Top = 48
      Width = 249
      Height = 17
      Caption = 'DirectX Compatibility (DxWrapper)'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = DXWrapperCBClick
    end
    object WindowedModeCB: TCheckBox
      Left = 8
      Top = 120
      Width = 249
      Height = 17
      Caption = 'Windowed Mode'
      TabOrder = 1
    end
    object SoundFixCB: TCheckBox
      Left = 8
      Top = 24
      Width = 249
      Height = 17
      Hint = 'Fixes background music stuttering in the Scorpion level.'
      Caption = 'Fix for background music stuttering'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 2
    end
    object FPSLimit30RB: TRadioButton
      Left = 8
      Top = 72
      Width = 249
      Height = 17
      Caption = '30 FPS (issues may occur)'
      Checked = True
      TabOrder = 3
      TabStop = True
    end
    object FPSLimit24RB: TRadioButton
      Left = 8
      Top = 96
      Width = 249
      Height = 17
      Caption = '24 FPS (fully playable)'
      TabOrder = 4
    end
  end
  object PanelButtons: TPanel
    Left = 0
    Top = 310
    Width = 553
    Height = 41
    Align = alBottom
    TabOrder = 0
    object ApplyBtn: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Apply'
      TabOrder = 0
      OnClick = ApplyBtnClick
    end
    object ExitBtn: TButton
      Left = 248
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Exit'
      TabOrder = 1
      OnClick = ExitBtnClick
    end
    object AboutBtn: TButton
      Left = 520
      Top = 8
      Width = 25
      Height = 25
      Caption = '?'
      TabOrder = 2
      OnClick = AboutBtnClick
    end
    object RestoreBtn: TButton
      Left = 88
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Restore'
      TabOrder = 3
      OnClick = RestoreBtnClick
    end
    object SaveBtn: TButton
      Left = 168
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 4
      OnClick = SaveBtnClick
    end
  end
  object GameCB: TGroupBox
    Left = 280
    Top = 8
    Width = 265
    Height = 145
    Caption = 'Game'
    TabOrder = 3
    object ImprovedInterfaceRB: TRadioButton
      Left = 8
      Top = 24
      Width = 249
      Height = 17
      Hint = 'Some UI elements are now centered.'
      Caption = 'Improved Interface (recommended)'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
    end
    object ClassicInterfaceRB: TRadioButton
      Left = 8
      Top = 48
      Width = 249
      Height = 17
      Hint = 
        'Some UI elements stretch across the entire screen, as in the ori' +
        'ginal game.'
      Caption = 'Classic Interface'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object OriginalInterfaceRB: TRadioButton
      Left = 8
      Top = 72
      Width = 249
      Height = 17
      Caption = 'Original Interface (stretched)'
      TabOrder = 2
    end
    object AutoLoadCB: TCheckBox
      Left = 8
      Top = 120
      Width = 225
      Height = 17
      Caption = 'Auto-load first save'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object MenuFixCB: TCheckBox
      Left = 8
      Top = 96
      Width = 249
      Height = 17
      Hint = 
        'Fixes the menu proportions and the rendering of the right side o' +
        'f the frame.'
      Caption = 'Menu fix'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 4
    end
  end
  object ControllerCB: TGroupBox
    Left = 8
    Top = 160
    Width = 265
    Height = 145
    Caption = 'Controller'
    TabOrder = 4
    object VibrationIntensityLbl: TLabel
      Left = 8
      Top = 104
      Width = 86
      Height = 13
      Caption = 'Vibration Intensity:'
    end
    object VibrationIntensityValueLbl: TLabel
      Left = 232
      Top = 104
      Width = 26
      Height = 13
      Caption = '100%'
    end
    object FixControllerButtonsCB: TCheckBox
      Left = 8
      Top = 48
      Width = 249
      Height = 17
      Hint = 
        'Fixes the confirm button and cutscene skipping, and lets you act' +
        'ivate invisibility in the Spidey Unlimited costume (aim + punch)'
      Caption = 'Fix controller buttons'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 1
    end
    object XboxControllerSupportCB: TCheckBox
      Left = 8
      Top = 24
      Width = 249
      Height = 17
      Hint = 
        'The gamepad'#39's "LB/L1" button simulates pressing the "A" key on t' +
        'he keyboard, allowing you to enter a save name.'
      Caption = 'Xbox controller support'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 0
      OnClick = XboxControllerSupportCBClick
    end
    object DamageVibrationCB: TCheckBox
      Left = 8
      Top = 72
      Width = 145
      Height = 17
      Caption = 'Damage vibration'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object VibrationIntensityTB: TTrackBar
      Left = 106
      Top = 100
      Width = 127
      Height = 30
      Position = 10
      TabOrder = 3
      OnChange = VibrationIntensityTBChange
    end
  end
  object XPManifest1: TXPManifest
    Left = 232
    Top = 176
  end
end
