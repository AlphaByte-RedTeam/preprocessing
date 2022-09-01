unit preprocessing;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnUpload: TButton;
    imgSrc: TImage;
    imgMod: TImage;
    imgSrcLabel: TLabel;
    openDialog: TOpenDialog;
    saveDialog: TSaveDialog;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

end.

