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

procedure TForm1.btnSaveClick(Sender: TObject);
begin
  if (saveDialog.Execute) then
  begin
    imgMod.Picture.SaveToFile(saveDialog.FileName);
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

