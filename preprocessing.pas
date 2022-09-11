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
    btnErosi: TButton;
    btnDilasi: TButton;
    imgSrc: TImage;
    imgMod: TImage;
    imgSrcLabel: TLabel;
    imgModLabel: TLabel;
    openDialog: TOpenDialog;
    saveDialog: TSaveDialog;
    procedure btnBinaryClick(Sender: TObject);
    procedure btnDilasiClick(Sender: TObject);
    procedure btnGrayClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSharpClick(Sender: TObject);
    procedure btnSmoothClick(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
    procedure btnErosiClick(Sender: TObject);
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
  bmpR, bmpG, bmpB, bmpRR, bmpGG, bmpBB, bmpBiner: array[-1..1000, -1..1000] of integer;
  hasilR, hasilG, hasilB, hasilBiner : array[0..1000, 0..1000] of integer;
  filter : array[-1..1,-1..1] of real;
  SE : array [-1..1,-1..1] of Integer;

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

   for y := 0 to imgMod.Height-1 do
   begin
    for x := 0 to imgMod.Width-1 do
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
   for y := 0 to imgMod.Height-1 do
  begin
    for x := 0 to imgMod.Width-1 do
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
  for y:=0 to imgMod.Height-1 do
  begin
    for x:=0 to imgMod.Width-1 do
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
  for y:=0 to imgMod.Height-1 do
  begin
    for x:=0 to imgMod.Width-1 do
    begin
      gray := (bmpR[x, y] + bmpG[x, y] + bmpB[x, y]) div 3;
      if (gray <= 127) then
      begin
        bmpBiner[x,y] := 0;
        imgMod.Canvas.Pixels[x, y] := RGB(0, 0, 0);
      end

      else
      begin
        bmpBiner[x,y] := 1;
        imgMod.Canvas.Pixels[x, y] := RGB(255, 255, 255);
      end;
    end;
  end;
end;

procedure TForm1.btnDilasiClick(Sender: TObject);
var
  i, j, k, l  : integer;
  temp : boolean;
  objek, latar : integer;
begin
  //objek berwarna hitam
  objek := 1;
  latar := 0;

  for j := -1 to 1 do
  begin
    for i := -1 to 1 do
    begin
      SE[i,j] := 1;
    end;
  end;

  for j:=0 to imgSrc.Height-1 do
  begin
    for i:=0 to imgSrc.Width-1 do
    begin
          temp := True;
          for l:=-1 to 1 do
          begin
            for k:=-1 to 1 do
            begin
              if (SE[k,l]>=0) then
              begin
                Temp := Temp AND (bmpBiner[i+k,j+l]=SE[k,l]);
              end;
            end;
          end;
          if temp then
            hasilBiner[i,j] := objek
          else
            hasilBiner[i,j] := latar;
          imgMod.Canvas.Pixels[i,j]:= RGB(hasilBiner[i,j]*255, hasilBiner[i,j]*255, hasilBiner[i,j]*255);
          end;
    end;

  for j:=0 to imgSrc.Height-1 do
  begin
    for i:=0 to imgSrc.Width-1 do
    begin
      bmpBiner[i,j] := hasilBiner[i,j];
      if j=0 then
      begin
        bmpR[i,-1] := bmpR[i,j];
        bmpG[i,-1] := bmpG[i,j];
        bmpB[i,-1] := bmpB[i,j];
      end;
      if j=imgSrc.Height-1 then
      begin
        bmpR[i,j+1] := bmpR[i,j];
        bmpG[i,j+1] := bmpG[i,j];
        bmpB[i,j+1] := bmpB[i,j];
      end;
      if i=0 then
      begin
        bmpR[-1,j] := bmpR[i,j];
        bmpG[-1,j] := bmpG[i,j];
        bmpB[-1,j] := bmpB[i,j];
      end;
      if i=imgSrc.Width-1 then
      begin
        bmpR[i+1,j] := bmpR[i,j];
        bmpG[i+1,j] := bmpG[i,j];
        bmpB[i+1,j] := bmpB[i,j];
      end;
    end;
  end;
end;

procedure TForm1.btnUploadClick(Sender: TObject);
var
  i, j: integer;
begin
  if (openDialog.Execute) then
  begin
    imgSrc.Picture.LoadFromFile(openDialog.FileName);
    imgMod.Picture.LoadFromFile(openDialog.FileName);
    for j:=0 to imgSrc.Height-1 do
    begin
      for i:=0 to imgSrc.Width-1 do
      begin
        bmpR[i,j] := getRValue(imgSrc.Canvas.Pixels[i,j]);
        bmpG[i,j] := getGValue(imgSrc.Canvas.Pixels[i,j]);
        bmpB[i,j] := getBValue(imgSrc.Canvas.Pixels[i,j]);
        bmpRR[i,j] := getRValue(imgSrc.Canvas.Pixels[i,j]);
        bmpGG[i,j] := getGValue(imgSrc.Canvas.Pixels[i,j]);
        bmpBB[i,j] := getBValue(imgSrc.Canvas.Pixels[i,j]);

        if j=0 then
        begin
          bmpR[i,-1] := bmpR[i,j];
          bmpG[i,-1] := bmpG[i,j];
          bmpB[i,-1] := bmpB[i,j];
        end;
        if j=imgSrc.Height-1 then
        begin
          bmpR[i,j+1] := bmpR[i,j];
          bmpG[i,j+1] := bmpG[i,j];
          bmpB[i,j+1] := bmpB[i,j];
        end;
        if i=0 then
        begin
          bmpR[-1,j] := bmpR[i,j];
          bmpG[-1,j] := bmpG[i,j];
          bmpB[-1,j] := bmpB[i,j];
        end;
        if i=imgSrc.Width-1 then
        begin
          bmpR[i+1,j] := bmpR[i,j];
          bmpG[i+1,j] := bmpG[i,j];
          bmpB[i+1,j] := bmpB[i,j];
        end;
      end;
    end;
  end;
end;

procedure TForm1.btnErosiClick(Sender: TObject);
var
  i, j, k, l  : integer;
  temp : boolean;
  objek, latar : integer;
begin
  //objek berwarna hitam
  objek := 1;
  latar := 0;

  for j := -1 to 1 do
  begin
    for i := -1 to 1 do
    begin
      SE[i,j] := 1;
    end;
  end;

  for j:=0 to imgSrc.Height-1 do
  begin
    for i:=0 to imgSrc.Width-1 do
    begin
          temp := False;
          for l:=-1 to 1 do
          begin
            for k:=-1 to 1 do
            begin
              if (SE[k,l]>=0) then
              begin
                Temp := Temp OR (bmpBiner[i+k,j+l]=SE[k,l]);
              end;
            end;
          end;
          if temp then
            hasilBiner[i,j] := objek
          else
            hasilBiner[i,j] := latar;
          imgMod.Canvas.Pixels[i,j]:= RGB(hasilBiner[i,j]*255, hasilBiner[i,j]*255, hasilBiner[i,j]*255);
          end;
    end;

  for j:=0 to imgSrc.Height-1 do
  begin
    for i:=0 to imgSrc.Width-1 do
    begin
      bmpBiner[i,j] := hasilBiner[i,j];
      if j=0 then
      begin
        bmpR[i,-1] := bmpR[i,j];
        bmpG[i,-1] := bmpG[i,j];
        bmpB[i,-1] := bmpB[i,j];
      end;
      if j=imgSrc.Height-1 then
      begin
        bmpR[i,j+1] := bmpR[i,j];
        bmpG[i,j+1] := bmpG[i,j];
        bmpB[i,j+1] := bmpB[i,j];
      end;
      if i=0 then
      begin
        bmpR[-1,j] := bmpR[i,j];
        bmpG[-1,j] := bmpG[i,j];
        bmpB[-1,j] := bmpB[i,j];
      end;
      if i=imgSrc.Width-1 then
      begin
        bmpR[i+1,j] := bmpR[i,j];
        bmpG[i+1,j] := bmpG[i,j];
        bmpB[i+1,j] := bmpB[i,j];
      end;
    end;
  end;
end;

end.

