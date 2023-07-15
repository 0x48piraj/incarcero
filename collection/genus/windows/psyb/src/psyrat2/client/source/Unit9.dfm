object Form9: TForm9
  Left = 482
  Top = 132
  Width = 407
  Height = 404
  Caption = 'Screenshot Manager'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 396
    Height = 297
    Proportional = True
  end
  object Button1: TButton
    Left = 138
    Top = 320
    Width = 121
    Height = 25
    Caption = 'Get Screenshot'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 300
    Width = 396
    Height = 16
    Min = 0
    Max = 100
    TabOrder = 1
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 358
    Width = 399
    Height = 19
    Panels = <
      item
        Width = 140
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
end
