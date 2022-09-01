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
    procedure btnSaveClick(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
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

end.

