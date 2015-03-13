{
 Jogo da Senha (Mastermind) versao 1.0.3
 Implementado no Lazarus por: Ericson Benjamim
 Contato: ericsonbenjamim@yahoo.com.br
 Data: 07 de Agosto de 2009
 Atualizado: 01 de Novembro de 2009
 Licenca: GPL
}
unit Senha_Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Menus, StdCtrls, ColorBox, Buttons, LCLType;

type

  { TFormPrincipal }

  TFormPrincipal = class(TForm)
    ButtonProxima: TButton;
    ButtonNovo:  TButton;
    Label1:      TLabel;
    Label10:     TLabel;
    Label2:      TLabel;
    Label3:      TLabel;
    Label4:      TLabel;
    Label5:      TLabel;
    Label6:      TLabel;
    Label7:      TLabel;
    Label8:      TLabel;
    Label9:      TLabel;
    LabelPontuacao: TLabel;
    LabelTentativa: TLabel;
    MainMenuSenha: TMainMenu;
    MenuItemRegras: TMenuItem;
    MenuItemSair: TMenuItem;
    MenuItemNovo: TMenuItem;
    MenuItemJogo: TMenuItem;
    Shape1:      TShape;
    Shape2:      TShape;
    ShapeSeqCorreta1: TShape;
    ShapeSeqCorreta2: TShape;
    ShapeSeqCorreta3: TShape;
    Shape3:      TShape;
    ShapeSeqCorreta4: TShape;
    Shape4:      TShape;
    Shape5:      TShape;
    Shape6:      TShape;
    Shape7:      TShape;
    Shape8:      TShape;
    Shape9:      TShape;
    Shape10:     TShape;
    Shape11:     TShape;
    Shape12:     TShape;
    Shape13:     TShape;
    Shape14:     TShape;
    Shape15:     TShape;
    Shape16:     TShape;
    Shape17:     TShape;
    Shape18:     TShape;
    Shape19:     TShape;
    Shape20:     TShape;
    ShapeCor1:   TShape;
    ShapeCor2:   TShape;
    ShapeCor3:   TShape;
    ShapeCor4:   TShape;
    ShapeCor5:   TShape;
    ShapeCor6:   TShape;
    ShapeCor7:   TShape;
    ShapeCor8:   TShape;
    ShapeFundoCinza2: TShape;
    ShapeFundoCinza1: TShape;
    ShapeFundoBranco1: TShape;
    ShapeFundoBranco2: TShape;
    ShapeLinha1: TShape;
    ShapeLinha2: TShape;
    ShapeLinha3: TShape;
    ShapeLinha4: TShape;
    ShapeSeqCorreta5: TShape;
    ShapeSeqCorreta6: TShape;
    ShapeSeqCorreta7: TShape;
    procedure ButtonNovoClick(Sender: TObject);
    procedure ButtonProximaClick(Sender: TObject);
    procedure MenuItemNovoClick(Sender: TObject);
    procedure MenuItemRegrasClick(Sender: TObject);
    procedure MenuItemSairClick(Sender: TObject);
    procedure ShapeStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure ShapePinoDragDrop(Sender, Source: TObject; X, Y: integer);
    procedure ShapePinoDragOver(Sender, Source: TObject; X, Y: integer;
      State: TDragState; var Accept: boolean);
  private
    { private declarations }
  public
    { public declarations }
    CorSorteada:     array [1..4] of TColor;
    CorSorteadaPino: array [1..4] of TColor;
    ShapeSeqCorreta: array [1..4] of TShape;
    procedure AfterConstruction; override;
    procedure NovoJogo(Pontuacao: word);
    procedure SorteiaCoresDosPinos;
    procedure SorteiaPinosIndicadores;
  end;

  TShapePino = class(TShape)
  private
    { private declarations }
  public
    { public declarations }
    Conectado: boolean;
    Linha:     byte;
  end;

  { TMyDragObject }

  TMyDragObject = class(TDragControlObject)
  private
    FDragImages: TDragImageList;
  protected
    function GetDragImages: TDragImageList; override;
  public
    constructor Create(AControl: TControl); override;
    destructor Destroy; override;
  end;

var
  FormPrincipal:  TFormPrincipal;
  LinhaAtual:     byte;
  TamanhoShape:   byte;
  ShapeVetorPino: array [1..10, 1..4] of TShapePino;
  ShapeVetorPinoPonto: array [1..10, 1..4] of TShape;

implementation

uses Senha_Unit2, Senha_Unit3;

{ TMyDragObject }


// Adaptado a partir de $(LazarusDir)/examples/dragimagelist


function TMyDragObject.GetDragImages: TDragImageList;
begin
  Result := FDragImages;
end;

constructor TMyDragObject.Create(AControl: TControl);
var
  Bitmap: TBitmap;
begin
  inherited Create(AControl);
  FDragImages := TDragImageList.Create(AControl);
  AlwaysShowDragImages := True;

  // Cria uma imagem que sera usada no arrastar/soltar

  Bitmap := TBitmap.Create;
  Bitmap.Width := TamanhoShape;
  Bitmap.Height := TamanhoShape;
  Bitmap.Canvas.Brush.Color := TShape(AControl).Brush.Color;
  Bitmap.Transparent := True;
  Bitmap.TransparentColor := clBlack;
  Bitmap.Canvas.Ellipse(0, 0, TamanhoShape, TamanhoShape);

  // Desenha imagem durante arrastar/soltar

  if AControl is TWinControl then
    (AControl as TWinControl).PaintTo(Bitmap.Canvas, 0, 0);

  FDragImages.Width  := Bitmap.Width;
  FDragImages.Height := Bitmap.Height;
  FDragImages.Add(Bitmap, nil);
  FDragImages.DragHotspot := Point(Bitmap.Width, Bitmap.Height);
  FDragImages.BlendColor  := TShape(AControl).Brush.Color; // Atribui cor do shape
  Bitmap.Free;
end;

destructor TMyDragObject.Destroy;
begin
  FDragImages.Free;
  inherited Destroy;
end;

{ TFormPrincipal }

procedure TFormPrincipal.SorteiaCoresDosPinos;
var
  Indice: byte;
const
  CorDisponivel: array [0..7] of TColor = (clWhite, clYellow, clRed, clMaroon,
    clFuchsia, clLime, clBlue, clAqua);
begin
  Randomize;
  for Indice := 1 to 4 do
  begin
    CorSorteada[Indice] := CorDisponivel[Random(8)];
  end;
end;

procedure TFormPrincipal.AfterConstruction;
var
  Linha, Coluna: byte;
  Xpino, Ypino:  word;
begin
  TamanhoShape := ShapeCor1.Width; // Utilizado na elipse do arrastar/soltar
  LinhaAtual   := 1;
  ShapeFundoBranco1.Pen.Style := psClear;
  ShapeFundoBranco2.Pen.Style := psClear;

  // Atribui o metodo aos shapes

  ShapeCor1.OnStartDrag := @ShapeStartDrag;
  ShapeCor2.OnStartDrag := @ShapeStartDrag;
  ShapeCor3.OnStartDrag := @ShapeStartDrag;
  ShapeCor4.OnStartDrag := @ShapeStartDrag;
  ShapeCor5.OnStartDrag := @ShapeStartDrag;
  ShapeCor6.OnStartDrag := @ShapeStartDrag;
  ShapeCor7.OnStartDrag := @ShapeStartDrag;
  ShapeCor8.OnStartDrag := @ShapeStartDrag;

  for Coluna := 1 to 4 do
    case Coluna of
      1: ShapeSeqCorreta[Coluna] := ShapeSeqCorreta1;
      2: ShapeSeqCorreta[Coluna] := ShapeSeqCorreta2;
      3: ShapeSeqCorreta[Coluna] := ShapeSeqCorreta3;
      4: ShapeSeqCorreta[Coluna] := ShapeSeqCorreta4;
    end;

  // Desenha os pinos a serem coloridos

  Ypino := 13;
  for Linha := 10 downto 1 do
  begin
    Xpino := 17;
    for Coluna := 1 to 4 do
    begin
      ShapeVetorPino[Linha, Coluna] := TShapePino.Create(Self);
      with ShapeVetorPino[Linha, Coluna] do
      begin
        parent   := self;
        Shape    := stCircle;
        Left     := Xpino;
        Top      := Ypino;
        Width    := 55;
        Height   := 41;
        Brush.Color := clGray;
        Conectado := False;
        OnDragOver := @ShapePinoDragOver; // Atribui o metodo ao componente
        OnDragDrop := @ShapePinoDragDrop; // Atribui o metodo ao componente
        OnStartDrag := @ShapeStartDrag; // Atribui o metodo ao componente
        DragMode := dmAutomatic; // Para ativar arrastar/soltar
        Xpino    := Xpino + 60;
        Refresh;
      end;
      ShapeVetorPino[Linha, Coluna].Linha := Linha;
    end;
    Ypino := Ypino + 45;
  end;

  // Desenha os pinos que representam os pontos

  Ypino := 14;
  for Linha := 10 downto 1 do
  begin
    for Coluna := 1 to 4 do
    begin
      ShapeVetorPinoPonto[Linha, Coluna] := TShape.Create(Self);
      with ShapeVetorPinoPonto[Linha, Coluna] do
      begin
        parent := self;
        Shape  := stCircle;
        Width  := 22;
        Height := 17;
        Brush.Color := clGray;
        case Coluna of
          1:
          begin
            Left := 281;
            Top  := Ypino;
          end;
          2:
          begin
            Left := 302;
            Top  := Ypino;
          end;
          3:
          begin
            Left := 281;
            Top  := Ypino + 22;
          end;
          4:
          begin
            Left := 302;
            Top  := Ypino + 22;
          end;
        end;
        Refresh;
      end;
    end;
    Ypino := Ypino + 45;
  end;
end;

procedure TFormPrincipal.ShapeStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  // usuario comecou a arrastar o shape
  // cria seu proprio TDragControlObject,
  // o qual provera a imagem durante o arrastar/soltar
  DragObject := TMyDragObject.Create(Sender as TControl);
end;

procedure TFormPrincipal.ShapePinoDragDrop(Sender, Source: TObject; X, Y: integer);
begin

  // Atribui a cor da imagem criada durante o arrastar/soltar para o shape de destino

  if (TShapePino(Sender).Linha = LinhaAtual) and
    (TShape(Source).Brush.Color <> clGray) then
  begin
    TShapePino(Sender).Conectado   := True;
    TShapePino(Sender).Brush.Color := TMyDragObject(Source).FDragImages.BlendColor;
  end;
end;

procedure TFormPrincipal.ShapePinoDragOver(Sender, Source: TObject;
  X, Y: integer; State: TDragState; var Accept: boolean);
begin

  // Faz o shape aceitar um objeto arrastado para o mesmo

  Accept := True;
end;

procedure TFormPrincipal.NovoJogo(Pontuacao: word);
var
  Linha, Coluna: byte;
begin

  // Deixa todos os pinos na cor cinza

  for Linha := 1 to 10 do
    for Coluna := 1 to 4 do
    begin
      ShapeVetorPino[Linha, Coluna].Brush.Color      := clGray;
      ShapeVetorPinoPonto[Linha, Coluna].Brush.Color := clGray;
    end;
  for Coluna := 1 to 4 do
    ShapeSeqCorreta[Coluna].Brush.Color := clGray;

  LinhaAtual := 1;
  ShapeFundoBranco1.Height := 44;
  ShapeFundoBranco1.Width := 238;
  ShapeFundoBranco1.Left := 16;
  ShapeFundoBranco1.Top := 416;
  ShapeFundoBranco1.Visible := True;
  ShapeFundoBranco2.Height := 44;
  ShapeFundoBranco2.Width := 43;
  ShapeFundoBranco2.Left := 281;
  ShapeFundoBranco2.Top := 416;
  ShapeFundoBranco2.Visible := True;

  ShapeCor1.Enabled := True;
  ShapeCor2.Enabled := True;
  ShapeCor3.Enabled := True;
  ShapeCor4.Enabled := True;
  ShapeCor5.Enabled := True;
  ShapeCor6.Enabled := True;
  ShapeCor7.Enabled := True;
  ShapeCor8.Enabled := True;

  SorteiaCoresDosPinos;
  LabelTentativa.Caption := '0';
  LabelPontuacao.Caption := IntToStr(Pontuacao);
end;

procedure TFormPrincipal.MenuItemNovoClick(Sender: TObject);
begin
  NovoJogo(0);
end;

procedure TFormPrincipal.MenuItemRegrasClick(Sender: TObject);
begin
  FormRegras.ShowModal;
end;

procedure TFormPrincipal.MenuItemSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFormPrincipal.ButtonNovoClick(Sender: TObject);
begin
  NovoJogo(0);
end;

procedure TFormPrincipal.SorteiaPinosIndicadores;
var
  Indice: byte;
  Pino:   array [1..4] of byte;
begin

  // Sorteia a posicao dos pinos indicadores

  for Indice := 1 to 4 do
  begin
    Pino[Indice] := Indice;
    CorSorteadaPino[Indice] := 0;
  end;
  Randomize;
  for Indice := 1 to 4 do
    while (CorSorteadaPino[Indice] = 0) do
    begin
      CorSorteadaPino[Indice] := Random(4) + 1;

      // Testa se a posicao ainda nao foi usada

      if Pino[CorSorteadaPino[Indice]] = 0 then
        CorSorteadaPino[Indice] := 0
      else
        Pino[CorSorteadaPino[Indice]] := 0;
    end;
end;

procedure TFormPrincipal.ButtonProximaClick(Sender: TObject);
var
  Coluna, // Percorre os pinos configurados pelo jogador
  Indice:     byte; // Percorre os pinos sorteados pelo computador
  Verificado: array [1..4] of byte;
  // Evita que o mesmo pino seja verificado mais de uma vez
begin

  // Verifica se ainda falta conectar algum pino

  for Coluna := 1 to 4 do
    if ShapeVetorPino[LinhaAtual, Coluna].Brush.Color = clGray then
    begin
      ShowMessage('Não deixe nenhum pino vazio.');
      Exit;
    end;

  Inc(LinhaAtual);
  LabelTentativa.Caption := IntToStr(LinhaAtual - 1);

  // Verifica quantos pontos o jogador fez na linha anterior

  SorteiaPinosIndicadores;
  for Indice := 1 to 4 do
    Verificado[Indice] := 0; // Zera os pinos verificados
  if (LinhaAtual >= 2) and (LinhaAtual <= 11) then
  begin
    for Indice := 1 to 4 do
      if CorSorteada[Indice] = ShapeVetorPino[LinhaAtual - 1, Indice].Brush.Color then
      begin

        // Cor e pino estao corretos

        if Verificado[Indice] <> 0 then
          // Se o pino foi verificado entao desmarca a verificacao anterior
          ShapeVetorPinoPonto[LinhaAtual - 1, Verificado[Indice]].Brush.Color := clGray;
        Verificado[Indice] := CorSorteadaPino[Indice]; // Marca o pino como verificado
        ShapeVetorPinoPonto[LinhaAtual - 1, CorSorteadaPino[Indice]].Brush.Color :=
          clBlack;
      end
      else
        for Coluna := 1 to 4 do
          if (Coluna <> Indice) and (Verificado[Coluna] = 0) then
            // Continua se o pino ainda nao foi verificado
            if CorSorteada[Indice] = ShapeVetorPino[LinhaAtual - 1,
              Coluna].Brush.Color then
            begin

              // Cor esta correta, mas a posicao do pino nao esta

              Verificado[Coluna] := CorSorteadaPino[Indice];
              // Marca o pino como verificado
              ShapeVetorPinoPonto[LinhaAtual - 1, CorSorteadaPino[Indice]].Brush.Color :=
                clWhite;
              break;
            end;

    // Verifica se acertou a combinação

    if (ShapeVetorPino[LinhaAtual - 1, 1].Brush.Color = CorSorteada[1]) and
      (ShapeVetorPino[LinhaAtual - 1, 2].Brush.Color = CorSorteada[2]) and
      (ShapeVetorPino[LinhaAtual - 1, 3].Brush.Color = CorSorteada[3]) and
      (ShapeVetorPino[LinhaAtual - 1, 4].Brush.Color = CorSorteada[4]) then
    begin
      for Indice := 1 to 4 do
        ShapeSeqCorreta[Indice].Brush.Color := CorSorteada[Indice];
      LabelPontuacao.Caption := IntToStr(StrToIntDef(LabelPontuacao.Caption, 0) + 1);

      // Parabeniza o jogador e mostra a sequencia correta

      FormParabens.ShapeSeqCorreta1.Brush.Color := ShapeSeqCorreta1.Brush.Color;
      FormParabens.ShapeSeqCorreta2.Brush.Color := ShapeSeqCorreta2.Brush.Color;
      FormParabens.ShapeSeqCorreta3.Brush.Color := ShapeSeqCorreta3.Brush.Color;
      FormParabens.ShapeSeqCorreta4.Brush.Color := ShapeSeqCorreta4.Brush.Color;
      FormParabens.ShowModal;
      NovoJogo(StrToIntDef(LabelPontuacao.Caption, 0));
      Exit;
    end;
  end;

  if LinhaAtual = 11 then
  begin
    for Indice := 1 to 4 do
      ShapeSeqCorreta[Indice].Brush.Color := CorSorteada[Indice];
    ShowMessage('Infelizmente você não conseguiu descobrir a combinação.');
    NovoJogo(0);
    Exit;
  end;

  if LinhaAtual <= 10 then
  begin

    // Expande o fundo branco (para cima)

    ShapeFundoBranco1.Height := ShapeFundoBranco1.Height + 45;
    ShapeFundoBranco1.Top    := ShapeFundoBranco1.Top - 45;
    ShapeFundoBranco2.Height := ShapeFundoBranco2.Height + 45;
    ShapeFundoBranco2.Top    := ShapeFundoBranco2.Top - 45;
  end;
end;

initialization
  {$I Senha_Unit1.lrs}

end.

