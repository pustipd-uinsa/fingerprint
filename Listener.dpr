program Listener;

uses
  Vcl.Forms,
  uCEFApplication, System.sysutils,
  UnUtama in '..\UnUtama.pas' {Form1};

{$R *.res}

var cefpath :string;

begin
  GlobalCEFApp := TCefApplication.Create;
  cefpath := ExtractFilePath( Application.ExeName);
    GlobalCEFApp.FrameworkDirPath     := cefpath;
    GlobalCEFApp.ResourcesDirPath     := cefpath;
    GlobalCEFApp.LocalesDirPath       := cefpath+'\locales';

  if GlobalCEFApp.StartMainProcess then
    begin
      Application.Initialize;
      Application.MainFormOnTaskbar := True;
      Application.CreateForm(TForm1, Form1);
      Application.Run;
    end;

  GlobalCEFApp.Free;
  end.
