﻿unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TPlayer = record // Танк игрока
    Turn: integer; // 1 - Вверх, 2 - Направо, 3 - Вниз, 4 - Влево
    Speed: integer; // Скорость
    Health: integer; // Здоровье
    X, Y: integer; // Координаты
    Anim: integer; // Номер кадра анимации
    Cooldown: integer; // Кулдаун
    Move: boolean; // F - Не движется, T - Движется
    qUp, qRight, qDown, qLeft: boolean; // F - Не нажаты, T - нажаты
  end;

  TOpponent = record // Танк противника
    Turn: integer; // 1 - Вверх, 2 - Направо, 3 - Вниз, 4 - Влево
    Speed: integer; // Скорость
    Health: integer; // Здоровье
    X, Y: integer; // Координаты
    Anim: integer; // Номер кадра анимации
    Cooldown: integer; // Кулдаун
    Visible: boolean; // F - Невидим, T - Видим
  end;

  TBullet = record // Пуля
    Turn: integer; // 1 - Вверх, 2 - Направо, 3 - Вниз, 4 - Влево
    Speed: integer; // Скорость
    X, Y: integer; // Координаты
    Author: integer; // 0 - Никто, 1 - Игрок, 2 - Противник
    Visible: boolean; // F - Невидим, T - Видим
  end;

  TForm4 = class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

  // Текстуры танков и объектов
  PlrTex: array[1..4, 1..2] of TBitmap;
  ObjTex: array[1..2] of TBitmap;
  OppTex: array[1..4, 1..2] of TBitmap;
  BulTex: TBitmap;
  BaseTex: TBitmap;

  Opp: array[1..10] of TOpponent; // Массив танков противника
  Bul: array[1..30] of TBullet; // Массив пуль
  base: array[0..9, 0..9] of integer; // Массив координат базы
  obj: array[0..32, 0..32] of integer; // Массив координат объектов
  Buf: TBitmap; // Буфер
  Plr: TPlayer; // Танк игрока
  path: string; // Путь к исполняемому файлу
  q: integer; // Количество появленных танков противника
  t: integer; // Таймер появленных танков противника
  destroyed: integer; // Количество уничтоженных танков противника
  procedure AI; // Искусственный интеллект

implementation

{$R *.dfm}

uses Unit1;

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  Action := caFree;

end;

procedure TForm4.FormCreate(Sender: TObject);
begin

  // Путь к исполняемому файлу
  path := ExtractFileDir(Application.ExeName);

  // Буфер
  Buf := TBitmap.Create;
  Buf.Width := 512;
  Buf.Height := 512;

  // Текстуры танка игрока
  for var i := 1 to 4 do
  for var j := 1 to 2 do
  begin
    PlrTex[i, j] := TBitmap.Create;
    PlrTex[i, j].Transparent := true;
    PlrTex[i, j].TransparentColor := clblack;
    PlrTex[i, j].LoadFromFile(path + '\textures\plr_' + inttostr(i) + '_' + inttostr(j) + '.bmp')
  end;

  // Текстуры танков противника
  for var i := 1 to 4 do
  for var j := 1 to 2 do
  begin
    OppTex[i, j] := TBitmap.Create;
    OppTex[i, j].Transparent := true;
    OppTex[i, j].TransparentColor := clblack;
    OppTex[i, j].LoadFromFile(path + '\textures\opp_' + inttostr(i) + '_' + inttostr(j) + '.bmp')
  end;

  // Текстура пуль
  BulTex := TBitmap.Create;
  BulTex.Transparent := true;
  BulTex.TransparentColor := clblack;
  BulTex.LoadFromFile(path + '\textures\bul.bmp');

  // Текстура базы
  BaseTex := TBitmap.Create;
  BaseTex.Transparent := true;
  BaseTex.TransparentColor := clblack;
  BaseTex.LoadFromFile(path + '\textures\base.bmp');

  // Текстуры объектов
  for var i := 1 to 2 do
  begin
    ObjTex[i] := TBitmap.Create;
    ObjTex[i].LoadFromFile(path + '\textures\obj_' + inttostr(i) + '.bmp');
  end;

  // Характеристика танка игрока
  Plr.Turn := 1;
  Plr.Speed := 4;
  Plr.Health := 1;
  Plr.X := 4 * 64;
  Plr.Y := 7 * 64;
  Plr.Anim := 1;
  Plr.Cooldown := 0;
  Plr.qUp := false;
  Plr.qRight := false;
  Plr.qDown := false;
  Plr.qLeft := false;

  // Характеристика пуль
  for var i := 1 to 30 do
  begin
    Bul[i].Speed := 12;
    Bul[i].X := -1;
    Bul[i].Y:= -1;
    Bul[i].Author := 0;
  end;

  // Характеристика танков противника
  for var i := 1 to 10 do
  begin
    Opp[i].Turn := 3;
    Opp[i].Health := 0;
    Opp[i].Speed := 4;
    Opp[i].Anim := 1;
    Opp[i].Cooldown := 0;
  end;

  // Обнуление координат базы
  for var i := 0 to 9 do
  for var j := 0 to 9 do
  base[i, j] := 0;

  // Обнуление объектов
  for var i := 0 to 32 do
  for var j := 0 to 32 do
  obj[i, j] := 0;

  // Координаты базы
  base[3, 7] := 1;

  // Генерация объектов
  Randomize;
  var n := 0;
  var m := 0;
  while (n <= 20) do
  begin
    var x2 := random(8) * 4;
    var y2 := random(8) * 4;
    m := Random(2) + 1;

    for var i := x2 to x2 + 3 do
    for var j := y2 to y2 + 3 do
    obj[i, j] := m;

    Inc(n);
  end;

  // Удаление объектов, сгенерированных на базе и танке игрока
  for n := 3 to 4 do
  for var i := n * 4 to n * 4 + 3 do
  for var j := 7 * 4 to 7 * 4 + 3 do
  obj[i, j] := 0;

  // Удаление объектов, сгенерированных на танках противника
  n := 0;
  for var i := n * 4 to n * 4 + 3 do
  for var j := 0 to 3 do
  obj[i, j] := 0;

  n := 7;
  for var i := n * 4 to n * 4 + 3 do
  for var j := 0 to 3 do
  obj[i, j] := 0;

  // Появление танков противника
  Opp[1].Health := 1;
  Opp[1].X := 0;
  Opp[1].Y := 0;
  Opp[1].Visible := true;

  Opp[2].Health := 1;
  Opp[2].X := 7 * 64;
  Opp[2].Y := 0;
  Opp[2].Visible := true;

  // Количество заготовленных танков противника
  q := 2;

  // Обнуление таймера танков противника
  t := 0;

  // Обнуление уничтоженных танков
  destroyed := 0;

  // Новый уровень
  if Timer1.Enabled = false then Timer1.Enabled := true;

end;

procedure TForm4.FormDestroy(Sender: TObject);
begin

  Form4 := nil;

end;

procedure TForm4.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  // Возврат в меню
  if Key = VK_Escape then
  begin
    Form1.Show;
    Form4.Close;
  end;

  // Управление танком
  if Key = VK_Up then
  begin
    Plr.Turn := 1;
    Plr.Move := true;
    Plr.qUp := true;
  end;

  if Key = VK_Right then
  begin
    Plr.Turn := 2;
    Plr.Move := true;
    Plr.qRight := true;
  end;

  if Key = VK_Down then
  begin
    Plr.Turn := 3;
    Plr.Move := true;
    Plr.qDown := true;
  end;

  if Key = VK_Left then
  begin
    Plr.Turn := 4;
    Plr.Move := true;
    Plr.qLeft := true;
  end;

  // Атака танка
  if (key = VK_Space) and (Plr.Cooldown = 0) then
  begin
    Plr.Cooldown := 20;
    for var i := 1 to 30 do
    begin
      if Bul[i].Visible = false then
      begin
        Bul[i].Visible := true;
        case Plr.Turn of
        1: begin
           Bul[i].X := Plr.X;
           Bul[i].Y := Plr.Y - 32;
           end;
        2: begin
           Bul[i].X := Plr.X + 32;
           Bul[i].Y := Plr.Y;
           end;
        3: begin
           Bul[i].X := Plr.X;
           Bul[i].Y := Plr.Y + 32;
           end;
        4: begin
           Bul[i].X := Plr.X - 32;
           Bul[i].Y := Plr.Y;
           end;
        end;
        Bul[i].Turn := Plr.Turn;
        Bul[i].Author := 1;
        break;
      end;
    end;
  end;

end;

procedure TForm4.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  // Остановка анимации танка
  if Key = VK_Up then
    Plr.qUp := false;

  if Key = VK_Right then
    Plr.qRight := false;

  if Key = VK_Down then
    Plr.qDown := false;

  if Key = VK_Left then
    Plr.qLeft := false;

end;

procedure TForm4.Timer1Timer(Sender: TObject);
begin

  AI;

  // Отрисовка карты
  Buf.Canvas.Brush.Color := clblack;
  Buf.Canvas.Rectangle(0, 0, 512, 512);

  // Отрисовка танка игрока
  Buf.Canvas.Draw(Plr.X, Plr.Y, PlrTex[Plr.Turn, Plr.Anim]);

  // Движение танка игрока
  if Plr.Move = true then
  begin

    if (Plr.Turn = 1) and (Plr.Y - Plr.Speed >= 0)
    and (base[Plr.X div 64, (Plr.Y - Plr.Speed) div 64] = 0) and (base[(Plr.X + 63) div 64, (Plr.Y - Plr.Speed) div 64] = 0)
    and (obj[Plr.X div 16, (Plr.Y - Plr.Speed) div 16] = 0) and (obj[(Plr.X + 63) div 16, (Plr.Y - Plr.Speed) div 16] = 0) then
    Plr.Y := Plr.Y - Plr.Speed;

    if (Plr.Turn = 2) and (Plr.X + Plr.Speed + 63 <= 512)
    and (base[(Plr.X + Plr.Speed + 63) div 64, Plr.Y div 64] = 0) and (base[(Plr.X + Plr.Speed + 63) div 64, (Plr.Y + 63) div 64] = 0)
    and (obj[(Plr.X + Plr.Speed + 63) div 16, Plr.Y div 16] = 0) and (obj[(Plr.X + Plr.Speed + 63) div 16, (Plr.Y + 63) div 16] = 0) then
    Plr.X := Plr.X + Plr.Speed;

    if (Plr.Turn = 3) and (Plr.Y + Plr.Speed + 63 <= 512)
    and (base[Plr.X div 64, (Plr.Y + Plr.Speed + 63) div 64] = 0) and (base[(Plr.X + 63) div 64, (Plr.Y + Plr.Speed + 63) div 64] = 0)
    and (obj[Plr.X div 16, (Plr.Y + Plr.Speed + 63) div 16] = 0) and (obj[(Plr.X + 63) div 16, (Plr.Y + Plr.Speed + 63) div 16] = 0) then
    Plr.Y := Plr.Y + Plr.Speed;

    if (Plr.Turn = 4) and (Plr.X - Plr.Speed >= 0)
    and (base[(Plr.X - Plr.Speed) div 64, Plr.Y div 64] = 0) and (base[(Plr.X - Plr.Speed) div 64, (Plr.Y + 63) div 64] = 0)
    and (obj[(Plr.X - Plr.Speed) div 16, Plr.Y div 16] = 0) and (obj[(Plr.X - Plr.Speed) div 16, (Plr.Y + 63) div 16] = 0) then
    Plr.X := Plr.X - Plr.Speed;

  end;

  // Отрисовка анимации танка игрока
  if Plr.Move = true then
  begin
    Plr.Anim := Plr.Anim + 1;
    if Plr.Anim > 2 then Plr.Anim := 1;
  end;

  if (Plr.qUp = false) and (Plr.qRight = false)
  and (Plr.qDown = false) and (Plr.qLeft = false) then
  Plr.Move := false;

  // Отрисовка танков противника
  for var i := 1 to 10 do
  if (Opp[i].Health > 0) and (Opp[i].Visible = true) then
  Buf.Canvas.Draw(Opp[i].X, Opp[i].Y, OppTex[ Opp[i].Turn, Opp[i].Anim ]);

  // Генерация танков противника
  Inc(t);
  if (t = 200) and (q < 10) then
  begin
    t := 0;
    Inc(q);

    if (q = 3) or (q = 5) or (q = 7) or (q = 9) then
    Opp[q].X := 0;

    if (q = 4) or (q = 6) or (q = 8) or (q = 10) then
    Opp[q].X := 7 * 64;

    Opp[q].Y := 0;
    Opp[q].Health := 1;
    Opp[q].Visible := true;
  end;

  // Уменьшение кулдауна
  if Plr.Cooldown > 0 then Dec(Plr.Cooldown);

  for var i := 1 to 10 do
  if Opp[i].Cooldown > 0 then Dec(Opp[i].Cooldown);

  // Отрисовка пуль
  for var i := 1 to 30 do
  begin
    if Bul[i].Visible = true then
    begin
      Buf.Canvas.Draw(Bul[i].X, Bul[i].Y, BulTex);
      case Bul[i].Turn of
        1: Bul[i].Y := Bul[i].Y - Bul[i].Speed;
        2: Bul[i].X := Bul[i].X + Bul[i].Speed;
        3: Bul[i].Y := Bul[i].Y + Bul[i].Speed;
        4: Bul[i].X := Bul[i].X - Bul[i].Speed;
      end;
    end;
  end;

  // Коллизии пуль
  for var i := 1 to 30 do
  begin

    // Коллизия границ карты
    if (Bul[i].Visible = true)
    and (Bul[i].X + 32 < 0) or (Bul[i].X + 32 > 8 * 64)
    or (Bul[i].Y + 32 < 0) or (Bul[i].Y + 32 > 8 * 64) then
    Bul[i].Visible := false;

    // Коллизия базы и игрока
    if (Bul[i].Visible = true)
    and (base[(Bul[i].X + 32) div 64, (Bul[i].Y + 32) div 64] = 1)
    or ( ((Plr.X + 32) div 16 = (Bul[i].X + 32) div 16 )
    and ((Plr.Y + 32) div 16 = (Bul[i].Y + 32) div 16)
    and (Bul[i].Author = 2) ) then
    begin
      Bul[i].Visible := false;
      Timer1.Enabled := false;
      showMessage('Поражение!');
      Form4.Close;
      Form1.Show;
    end;

    // Коллизия кирпичей
    if obj[(Bul[i].X + 32) div 16, (Bul[i].Y + 32) div 16] = 1 then
    begin
      var n := obj[(Bul[i].X + 32) div 16, (Bul[i].Y + 32) div 16];

      if (Bul[i].Turn = 1) or (Bul[i].Turn = 3) then
      begin
        for var j := (Bul[i].X div 16) to ((Bul[i].X + 63) div 16) do
        if (j >= 0) and (j <= 32) and (n = obj[j, (Bul[i].Y + 32) div 16])  then
        obj[j, (Bul[i].Y + 32) div 16] := 0;
      end;

      if (Bul[i].Turn = 2) or (Bul[i].Turn = 4) then
      begin
        for var j := (Bul[i].Y div 16) to ((Bul[i].Y + 63) div 16) do
        if (j >= 0) and (j <= 32) and (n = obj[(Bul[i].X + 32) div 16, j] )  then
        obj[ (Bul[i].X + 32) div 16, j] := 0;
      end;

      Bul[i].Visible := false;
    end;

    // Коллизия стали
    if obj[(Bul[i].X + 32) div 16, (Bul[i].Y + 32) div 16] = 2 then Bul[i].Visible := false;

    // Коллизия танков противника
    if (Bul[i].Visible = true) then
    begin
      for var j := 1 to 10 do
      begin
        if (Opp[j].Visible = true) and (Bul[i].Author = 1) and (Opp[j].Health > 0)
        and ((Opp[j].X + 32) div 16 = (Bul[i].X + 32) div 16)
        and ((Opp[j].Y + 32) div 16 = (Bul[i].Y + 32) div 16) then
        begin
          Bul[i].Visible := false;
          Opp[j].Visible := false;
          Dec(Opp[j].Health);
          if (Opp[j].Health <= 0) then
          begin
            destroyed := destroyed + 1;
            Label2.Caption := inttostr(destroyed);
          end;
        end;
      end;
    end;

  end;

  // Отрисовка базы
  for var i := 0 to 9 do
  for var j := 0 to 9 do
  if base[i, j] = 1 then
  Buf.Canvas.Draw(i * 64, j * 64, BaseTex);

  // Отрисовка объектов
  for var i := 0 to 32 do
  for var j := 0 to 32 do
  if obj[i, j] > 0 then Buf.Canvas.Draw(i *16, j * 16, ObjTex[ obj[i, j] ]);

  // Победа!
  if destroyed = 10 then
  begin
    Timer1.Enabled := false;
    showMessage('Победа!');
    Form4.Close;
    Form1.Show;
  end;

  // Отрисовка буфера
  Form4.Canvas.Draw(0, 0, Buf);

end;

procedure AI;
begin

  for var i := 1 to 10 do
  begin

    if (Opp[i].Health > 0) and (Opp[i].Visible = true) then
    begin

      // Анимация танков
      Inc(Opp[i].Anim);
      if Opp[i].Anim > 2 then Opp[i].Anim := 1;

      // Движение вверх
      if (Opp[i].Turn = 1)
      and (Opp[i].Y - Opp[i].Speed >= 0)
      and (base[Opp[i].X div 64, (Opp[i].Y - Opp[i].Speed) div 64] = 0) and (base[(Opp[i].X + 63) div 64, (Opp[i].Y - Opp[i].Speed) div 64] = 0)
      and (obj[Opp[i].X div 16, (Opp[i].Y - Opp[i].Speed) div 16] = 0) and (obj[(Opp[i].X + 63) div 16, (Opp[i].Y - Opp[i].Speed) div 16] = 0) then
      Opp[i].Y := Opp[i].Y - Opp[i].Speed;

      // Движение вправо
      if (Opp[i].Turn = 2)
      and (Opp[i].X + Opp[i].Speed <= 7 * 64)
      and (base[(Opp[i].X + Opp[i].Speed + 63) div 64, Opp[i].Y div 64] = 0) and (base[(Opp[i].X + Opp[i].Speed + 63) div 64, (Opp[i].Y + 63) div 64] = 0)
      and (obj[(Opp[i].X + Opp[i].Speed + 63) div 16, Opp[i].Y div 16] = 0) and (obj[(Opp[i].X + Opp[i].Speed + 63) div 16, (Opp[i].Y + 63) div 16] = 0) then
      Opp[i].X := Opp[i].X + Opp[i].Speed;

      // Движение вниз
      if (Opp[i].Turn = 3)
      and (Opp[i].Y + Opp[i].Speed <= 7 * 64)
      and (base[Opp[i].X div 64, (Opp[i].Y + Opp[i].Speed + 63) div 64] = 0) and (base[(Opp[i].X + 63) div 64, (Opp[i].Y + Opp[i].Speed + 63) div 64] = 0)
      and (obj[Opp[i].X div 16, (Opp[i].Y + Opp[i].Speed + 63) div 16] = 0) and (obj[(Opp[i].X + 63) div 16, (Opp[i].Y + Opp[i].Speed + 63) div 16] = 0) then
      Opp[i].Y := Opp[i].Y + Opp[i].Speed;

      // Движение влево
      if (Opp[i].Turn = 4)
      and (Opp[i].X - Opp[i].Speed >= 0)
      and (base[(Opp[i].X - Opp[i].Speed) div 64, Opp[i].Y div 64] = 0) and (base[(Opp[i].X - Opp[i].Speed) div 64, (Opp[i].Y + 63) div 64] = 0)
      and (obj[(Opp[i].X - Opp[i].Speed) div 16, Opp[i].Y div 16] = 0) and (obj[(Opp[i].X - Opp[i].Speed) div 16, (Opp[i].Y + 63) div 16] = 0) then
      Opp[i].X := Opp[i].X - Opp[i].Speed;

      // Поворот
      if ( (Opp[i].Turn = 1) and (Opp[i].Y - Opp[i].Speed < 0) )
      or ( (Opp[i].Turn = 2) and (Opp[i].X + Opp[i].Speed > 7 * 64) )
      or ( (Opp[i].Turn = 3) and (Opp[i].Y + Opp[i].Speed > 7 * 64) )
      or ( (Opp[i].Turn = 4) and (Opp[i].X - Opp[i].Speed < 0) )

      or ( (Opp[i].Turn = 1) and (base[Opp[i].X div 64, (Opp[i].Y - Opp[i].Speed) div 64] <> 0) )
      or ( (Opp[i].Turn = 2) and (base[(Opp[i].X + Opp[i].Speed + 63) div 64, Opp[i].Y div 64] <> 0) )
      or ( (Opp[i].Turn = 3) and (base[Opp[i].X div 64, (Opp[i].Y + Opp[i].Speed + 63) div 64] <> 0) )
      or ( (Opp[i].Turn = 4) and (base[(Opp[i].X - Opp[i].Speed) div 64, Opp[i].Y div 64] <> 0) )

      or ( (Opp[i].Turn = 1) and (base[(Opp[i].X + 63) div 64, (Opp[i].Y - Opp[i].Speed) div 64] <> 0) )
      or ( (Opp[i].Turn = 2) and (base[(Opp[i].X + Opp[i].Speed + 63) div 64, (Opp[i].Y + 63) div 64] <> 0) )
      or ( (Opp[i].Turn = 3) and (base[(Opp[i].X + 63) div 64, (Opp[i].Y + Opp[i].Speed + 63) div 64] <> 0) )
      or ( (Opp[i].Turn = 4) and (base[(Opp[i].X - Opp[i].Speed) div 64, (Opp[i].Y + 63) div 64] <> 0) )

      or ( (Opp[i].Turn = 1) and (obj[Opp[i].X div 16, (Opp[i].Y - Opp[i].Speed) div 16] <> 0) )
      or ( (Opp[i].Turn = 2) and (obj[(Opp[i].X + Opp[i].Speed + 63) div 16, Opp[i].Y div 16] <> 0) )
      or ( (Opp[i].Turn = 3) and (obj[Opp[i].X div 16, (Opp[i].Y + Opp[i].Speed + 63) div 16] <> 0) )
      or ( (Opp[i].Turn = 4) and (obj[(Opp[i].X - Opp[i].Speed) div 16, Opp[i].Y div 16] <> 0) )

      or ( (Opp[i].Turn = 1) and (obj[(Opp[i].X + 63) div 16, (Opp[i].Y - Opp[i].Speed) div 16] <> 0) )
      or ( (Opp[i].Turn = 2) and (obj[(Opp[i].X + Opp[i].Speed + 63) div 16, (Opp[i].Y + 63) div 16] <> 0) )
      or ( (Opp[i].Turn = 3) and (obj[(Opp[i].X + 63) div 16, (Opp[i].Y + Opp[i].Speed + 63) div 16] <> 0) )
      or ( (Opp[i].Turn = 4) and (obj[(Opp[i].X - Opp[i].Speed) div 16, (Opp[i].Y + 63) div 16] <> 0) ) then
      Opp[i].Turn := Random(4) + 1;

      // Уменьшение кулдауна
      if Opp[i].Cooldown > 0 then Dec(Opp[i].Cooldown);

      // Атака танков
      if Opp[i].Cooldown = 0 then
      begin
        Opp[i].Cooldown := 50;
        for var j := 1 to 30 do
        begin
          if Bul[j].Visible = false then
          begin
            Bul[j].Visible := true;
            case Opp[i].Turn of
            1: begin
               Bul[j].X := Opp[i].X;
               Bul[j].Y := Opp[i].Y - 32;
               end;
            2: begin
               Bul[j].X := Opp[i].X + 32;
               Bul[j].Y := Opp[i].Y;
               end;
            3: begin
               Bul[j].X := Opp[i].X;
               Bul[j].Y := Opp[i].Y + 32;
               end;
            4: begin
               Bul[j].X := Opp[i].X - 32;
               Bul[j].Y := Opp[i].Y;
               end;
            end;
            Bul[j].Turn := Opp[i].Turn;
            Bul[j].Author := 2;
            break;
          end;
        end;
      end;

    end;

  end;

end;

end.
