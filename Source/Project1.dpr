program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Main},
  Unit2 in 'Unit2.pas' {SavesForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TSavesForm, SavesForm);
  Application.Run;
end.
