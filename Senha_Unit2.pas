unit Senha_Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type

  { TFormRegras }

  TFormRegras = class(TForm)
    BitBtnOk: TBitBtn;
    ImageSenha: TImage;
    MemoSenha: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FormRegras: TFormRegras;

implementation

{ TFormRegras }


procedure TFormRegras.FormShow(Sender: TObject);
begin
  //
  // Centraliza Form na tela
  //
  Left := (Screen.Width  div 2) - (Width div 2);
  Top  := (Screen.Height div 2) - (Height div 2);
end;

initialization
  {$I Senha_Unit2.lrs}

end.

