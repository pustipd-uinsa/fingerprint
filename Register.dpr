program Register;

uses
  Vcl.Forms,
  UnDaftar in 'UnDaftar.pas' {FrmDaftar},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Pendaftaran Sidik Jari';
  TStyleManager.TrySetStyle('Luna');
  Application.CreateForm(TFrmDaftar, FrmDaftar);
  Application.Run;
end.
