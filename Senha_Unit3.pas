unit Senha_Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type

  { TFormParabens }

  TFormParabens = class(TForm)
    BitBtnOk: TBitBtn;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Shape2: TShape;
    ShapeSeqCorreta1: TShape;
    ShapeSeqCorreta2: TShape;
    ShapeSeqCorreta3: TShape;
    ShapeSeqCorreta4: TShape;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FormParabens: TFormParabens;

implementation

{ TFormParabens }

procedure TFormParabens.FormShow(Sender: TObject);
begin
  //
  // Centraliza Form na tela
  //
  Left := (Screen.Width  div 2) - (Width div 2);
  Top  := (Screen.Height div 2) - (Height div 2);
end;

initialization
  {$I Senha_Unit3.lrs}

end.

