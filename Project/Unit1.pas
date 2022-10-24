﻿unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Label2Click(Sender: TObject);
    procedure Label2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label2MouseLeave(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label3MouseLeave(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label4MouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Unit4, Unit3;
// Кнопка "Играть"
procedure TForm1.Label2Click(Sender: TObject);
begin

  Application.CreateForm(TForm4, Form4);
  Form4.Show;
  Form1.Hide;

end;

procedure TForm1.Label2MouseLeave(Sender: TObject);
begin

  Label2.Font.Color := clwhite;

end;

procedure TForm1.Label2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

  Label2.Font.Color := clyellow;

end;
// Кнопка "Справка"
procedure TForm1.Label3Click(Sender: TObject);
begin

  Form3.Show;
  Form1.Hide;

end;

procedure TForm1.Label3MouseLeave(Sender: TObject);
begin

  Label3.Font.Color := clwhite;

end;

procedure TForm1.Label3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

  Label3.Font.Color := clyellow;

end;
// Кнопка "Выход"
procedure TForm1.Label4Click(Sender: TObject);
begin

  Application.Terminate;

end;

procedure TForm1.Label4MouseLeave(Sender: TObject);
begin

  Label4.Font.Color := clwhite;

end;

procedure TForm1.Label4MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

  Label4.Font.Color := clyellow;

end;

end.
