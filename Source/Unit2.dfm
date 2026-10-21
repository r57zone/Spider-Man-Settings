object SavesForm: TSavesForm
  Left = 192
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Saves'
  ClientHeight = 330
  ClientWidth = 671
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object CurrentCostumeLbl: TLabel
    Left = 472
    Top = 8
    Width = 80
    Height = 13
    Caption = 'Current costume:'
  end
  object LevelsLV: TListView
    Left = 8
    Top = 8
    Width = 457
    Height = 281
    Columns = <
      item
        Caption = 'Stage'
        Width = 42
      end
      item
        Caption = 'Level'
        Width = 380
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = LevelsLVDblClick
  end
  object CompleteGmeBtn: TButton
    Left = 88
    Top = 296
    Width = 105
    Height = 25
    Caption = 'Complete the game'
    TabOrder = 1
    OnClick = CompleteGmeBtnClick
  end
  object ExitBtn: TButton
    Left = 8
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 2
    OnClick = ExitBtnClick
  end
  object CurCostumeCB: TComboBox
    Left = 472
    Top = 24
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    OnChange = CurCostumeCBChange
  end
  object UnlockedCostumesGB: TGroupBox
    Left = 472
    Top = 56
    Width = 193
    Height = 265
    Caption = 'Unlocked costumes:'
    TabOrder = 4
    object CostumeSpiderManCB: TCheckBox
      Left = 8
      Top = 24
      Width = 177
      Height = 17
      Caption = 'Spider-Man'
      TabOrder = 0
      OnClick = CostumeSpiderManCBClick
    end
    object CostumeSpiderMan2099CB: TCheckBox
      Left = 8
      Top = 48
      Width = 177
      Height = 17
      Caption = 'Spider-Man 2099'
      TabOrder = 1
      OnClick = CostumeSpiderMan2099CBClick
    end
    object CostumeSymbioteSpiderManCB: TCheckBox
      Left = 8
      Top = 72
      Width = 177
      Height = 17
      Caption = 'Symbiote Spider-Man'
      TabOrder = 2
      OnClick = CostumeSymbioteSpiderManCBClick
    end
    object CostumeCaptainUniverseCB: TCheckBox
      Left = 8
      Top = 96
      Width = 177
      Height = 17
      Caption = 'Captain Universe'
      TabOrder = 3
      OnClick = CostumeCaptainUniverseCBClick
    end
    object CostumeSpideyUnlimitedCB: TCheckBox
      Left = 8
      Top = 120
      Width = 177
      Height = 17
      Caption = 'Spidey Unlimited'
      TabOrder = 4
      OnClick = CostumeSpideyUnlimitedCBClick
    end
    object CostumeAmazingBagManCB: TCheckBox
      Left = 8
      Top = 144
      Width = 177
      Height = 17
      Caption = 'Amazing Bag Man'
      TabOrder = 5
      OnClick = CostumeAmazingBagManCBClick
    end
    object CostumeScarletSpideyCB: TCheckBox
      Left = 8
      Top = 168
      Width = 177
      Height = 17
      Caption = 'Scarlet Spidey'
      TabOrder = 6
      OnClick = CostumeScarletSpideyCBClick
    end
    object CostumeBenReillyCB: TCheckBox
      Left = 8
      Top = 192
      Width = 177
      Height = 17
      Caption = 'Ben Reilly'
      TabOrder = 7
      OnClick = CostumeBenReillyCBClick
    end
    object CostumeQuickChangeSpideyCB: TCheckBox
      Left = 8
      Top = 216
      Width = 177
      Height = 17
      Caption = 'Quick Change Spidey'
      TabOrder = 8
      OnClick = CostumeQuickChangeSpideyCBClick
    end
    object CostumePeterParkerCB: TCheckBox
      Left = 8
      Top = 240
      Width = 177
      Height = 17
      Caption = 'Peter Parker'
      TabOrder = 9
      OnClick = CostumePeterParkerCBClick
    end
  end
end
