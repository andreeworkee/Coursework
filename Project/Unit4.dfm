object Form4: TForm4
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Form4'
  ClientHeight = 486
  ClientWidth = 408
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  TextHeight = 15
  object Label1: TLabel
    Left = 61
    Top = 440
    Width = 236
    Height = 20
    Caption = #1059#1085#1080#1095#1090#1086#1078#1077#1085#1086':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -20
    Font.Name = 'Barcade Brawl'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 324
    Top = 440
    Width = 14
    Height = 20
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -20
    Font.Name = 'Barcade Brawl'
    Font.Style = []
    ParentFont = False
  end
  object Timer1: TTimer
    Interval = 40
    OnTimer = Timer1Timer
    Left = 16
    Top = 16
  end
end
