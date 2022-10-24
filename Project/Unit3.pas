﻿unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure Label1Click(Sender: TObject);
    procedure Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label1MouseLeave(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Label7MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label7MouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses Unit1, ABOUT;
 // Кнопка "Меню"
procedure TForm3.Label1Click(Sender: TObject);
begin

  Form1.Show;
  Form3.Hide;

end;

procedure TForm3.Label1MouseLeave(Sender: TObject);
begin

  Label1.Font.Color := clwhite;

end;

procedure TForm3.Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

  Label1.Font.Color := clyellow;

end;
// Кнопка "О программе"
procedure TForm3.Label7Click(Sender: TObject);
begin

  AboutBox.ShowModal;

end;

procedure TForm3.Label7MouseLeave(Sender: TObject);
begin

  Label7.Font.Color := clwhite;

end;

procedure TForm3.Label7MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

  Label7.Font.Color := clyellow;

end;

end.
