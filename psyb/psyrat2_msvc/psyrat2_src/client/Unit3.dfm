object Form3: TForm3
  Left = 805
  Top = 110
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Information'
  ClientHeight = 269
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object txtCpuInfo: TMemo
    Left = 0
    Top = 0
    Width = 289
    Height = 201
    BevelInner = bvNone
    BevelOuter = bvNone
    ReadOnly = True
    TabOrder = 0
  end
  object btnUninstall: TButton
    Left = 0
    Top = 203
    Width = 145
    Height = 23
    Caption = 'Uninstall Server'
    TabOrder = 1
    OnClick = btnUninstallClick
  end
  object Button1: TButton
    Left = 0
    Top = 227
    Width = 145
    Height = 23
    Caption = 'Get Info'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 144
    Top = 227
    Width = 145
    Height = 23
    Caption = 'Clear'
    TabOrder = 3
    OnClick = Button3Click
  end
  object btnRestart: TButton
    Left = 144
    Top = 203
    Width = 145
    Height = 23
    Caption = 'Restart Server'
    TabOrder = 4
    OnClick = btnRestartClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 250
    Width = 289
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    SimplePanel = False
  end
end
