object Form10: TForm10
  Left = 354
  Top = 115
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Process Manager'
  ClientHeight = 409
  ClientWidth = 279
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lstProcs: TListView
    Left = 8
    Top = 8
    Width = 265
    Height = 345
    Columns = <
      item
        Caption = 'Process Name'
        Width = 175
      end
      item
        Caption = 'PID'
      end>
    SmallImages = Form1.ImageList1
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Button1: TButton
    Left = 8
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Refresh'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 192
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Kill Selected'
    TabOrder = 2
    OnClick = Button2Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 390
    Width = 279
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    SimplePanel = False
  end
end
