unit preprocessing;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnBinary: TButton;
    btnSmooth: TButton;
    btnSharp: TButton;
    btnUpload: TButton;
    btnGray: TButton;
    btnSave: TButton;
    imgSrc: TImage;
    imgMod: TImage;
    imgSrcLabel: TLabel;
    imgModLabel: TLabel;
    openDialog: TOpenDialog;
    saveDialog: TSaveDialog;
    procedure btnBinaryClick(Sender: TObject);
    procedure btnGrayClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSharpClick(Sender: TObject);
    procedure btnSmoothClick(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

uses Windows;

var
  bmpR, bmpG, bmpB: array[0..1000, 0..1000] of byte;
  bmpBiner: array[0..1000, 0..1000] of boolean;
  hasilR, hasilG, hasilB    : array[0..1000, 0..1000] of integer;
  filter : array[-1..1,-1..1] of real;

procedure TForm1.btnSaveClick(Sender: TObject);
begin
  if (saveDialog.Execute) then
  begin
    imgMod.Picture.SaveToFile(saveDialog.FileName);
  end;
end;

procedure TForm1.btnSharpClick(Sender: TObject);
var
   x, y : integer;
   i, j :integer;
   tempR, tempG, tempB : real;
begin
   for y:=-1 to 1 do
   begin
     for x := -1 to 1 do
     begin
       filter[x,y] := -1
     end;
   end;
   filter[0,0] := 9;

   for y := 0 to imgSrc.Height-1 do
  begin
    for x := 0 to imgSrc.Width-1 do
    begin
      tempR := 0;
      tempG := 0;
      tempB := 0;
      for j := -1 to 1 do
      begin
        for i := -1 to 1 do
        begin
          tempR := tempR + filter[i,j] * bmpR[x-1,y-j];
          tempG := tempG + filter[i,j] * bmpG[x-1,y-j];
          tempB := tempB + filter[i,j] * bmpB[x-1,y-j];
        end;
      end;

      hasilR[x,y] := round(tempR);
      hasilG[x,y] := round(tempG);
      hasilB[x,y] := round(tempB);

      if hasilR[x,y] > 255 then
         hasilR[x,y] := 255
      else
      if hasilR[x,y] < 0 then
         hasilR[x,y] := 0;

      if hasilG[x,y] > 255 then
         hasilG[x,y] := 255
      else
      if hasilG[x,y] < 0 then
         hasilG[x,y] := 0;

      if hasilB[x,y] > 255 then
         hasilB[x,y] := 255
      else
      if hasilB[x,y] < 0 then
         hasilB[x,y] := 0;

    end;
  end;
  imgMod.Height := imgSrc.Height;
  imgMod.Width  := imgSrc.Width;

  for y := 0 to imgMod.Height-1 do
  begin
    for x := 0 to imgMod.Width-1 do
    begin
      imgMod.Canvas.Pixels[x,y] := RGB(hasilR[x,y],hasilG[x,y],hasilB[x,y]);
    end;
  end;

end;

procedure TForm1.btnSmoothClick(Sender: TObject);
var
  x, y, i, j :integer;
  tempR, tempG, tempB : real;
begin
   for y := 0 to imgSrc.Height-1 do
  begin
    for x := 0 to imgSrc.Width-1 do
    begin
      tempR := 0;
      tempG := 0;
      tempB := 0;
      for j := -1 to 1 do
      begin
        for i := -1 to 1 do
        begin
          tempR := tempR + 0.11 * bmpR[x-1,y-j];
          tempG := tempG + 0.11 * bmpG[x-1,y-j];
          tempB := tempB + 0.11 * bmpB[x-1,y-j];
        end;
      end;

      hasilR[x,y] := round(tempR);
      hasilG[x,y] := round(tempG);
      hasilB[x,y] := round(tempB);

      if hasilR[x,y] > 255 then
         hasilR[x,y] := 255
      else
      if hasilR[x,y] < 0 then
         hasilR[x,y] := 0;

      if hasilG[x,y] > 255 then
         hasilG[x,y] := 255
      else
      if hasilG[x,y] < 0 then
         hasilG[x,y] := 0;

      if hasilB[x,y] > 255 then
         hasilB[x,y] := 255
      else
      if hasilB[x,y] < 0 then
         hasilB[x,y] := 0;

    end;
  end;
  imgMod.Height := imgSrc.Height;
  imgMod.Width  := imgSrc.Width;

  for y := 0 to imgMod.Height-1 do
  begin
    for x := 0 to imgMod.Width-1 do
    begin
      imgMod.Canvas.Pixels[x,y] := RGB(hasilR[x,y],hasilG[x,y],hasilB[x,y]);
    end;
  end;
end;

procedure TForm1.btnGrayClick(Sender: TObject);
var
  x, y: integer;
  gray: byte;
begin
  for y:=0 to imgSrc.Height-1 do
  begin
    for x:=0 to imgSrc.Width-1 do
    begin
      gray := (bmpR[x, y] + bmpG[x, y] + bmpB[x, y]) div 3;
      imgMod.Canvas.Pixels[x, y] := RGB(gray, gray, gray);
    end;
  end;
end;

procedure TForm1.btnBinaryClick(Sender: TObject);
var
  x, y : integer;
  gray : byte;
begin
  for y:=0 to imgSrc.Height-1 do
  begin
    for x:=0 to imgSrc.Width-1 do
    begin
      gray := (bmpR[x, y] + bmpG[x, y] + bmpB[x, y]) div 3;
      if (gray <= 127) then
      begin
        bmpBiner[x,y] := False;
        imgMod.Canvas.Pixels[x, y] := RGB(0, 0, 0);
      end

      else
      begin
        bmpBiner[x,y] := True;
        imgMod.Canvas.Pixels[x, y] := RGB(255, 255, 255);
      end;
    end;
  end;
end;

procedure TForm1.btnUploadClick(Sender: TObject);
var
  x, y: integer;
begin
  if (openDialog.Execute) then
  begin
    imgSrc.Picture.LoadFromFile(openDialog.FileName);
    for y:=0 to imgSrc.Height-1 do
    begin
      for x:=0 to imgSrc.Width-1 do
      begin
        bmpR[x, y] := getRValue(imgSrc.Canvas.Pixels[x, y]);
        bmpG[x, y] := getGValue(imgSrc.Canvas.Pixels[x, y]);
        bmpB[x, y] := getBValue(imgSrc.Canvas.Pixels[x, y]);
      end;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

end.

