﻿unit About;

interface

uses WinApi.Windows, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TAboutBox = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Image1: TImage;
    procedure Label1Click(Sender: TObject);
    procedure Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label1MouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}

uses Unit3;
// Кнопка "ОК"
procedure TAboutBox.Label1Click(Sender: TObject);
begin

  Form3.Show;
  AboutBox.Close;

end;

procedure TAboutBox.Label1MouseLeave(Sender: TObject);
begin

  Label1.Font.Color := clwhite;

end;

procedure TAboutBox.Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

  Label1.Font.Color := clyellow;

end;

end.
 
