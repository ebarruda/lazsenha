program Senha;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, Senha_Unit1, LResources, Senha_Unit2,
Senha_Unit3;

{$IFDEF WINDOWS}{$R Senha.rc}{$ENDIF}

begin
  {$I Senha.lrs}
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.CreateForm(TFormRegras, FormRegras);
  Application.CreateForm(TFormParabens, FormParabens);
  Application.Run;
end.

