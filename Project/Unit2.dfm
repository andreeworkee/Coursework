object Form2: TForm2
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Battle City'
  ClientHeight = 256
  ClientWidth = 512
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object Label1: TLabel
    Left = 32
    Top = 112
    Width = 459
    Height = 40
    Caption = 'Battle City'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -40
    Font.Name = 'Barcade Brawl'
    Font.Style = []
    ParentFont = False
  end
  object Timer1: TTimer
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 12
    Top = 12
  end
end
