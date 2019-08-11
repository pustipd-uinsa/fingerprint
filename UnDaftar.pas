unit UnDaftar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, Vcl.ExtDlgs, Vcl.ExtCtrls,jpeg,
  Vcl.OleServer, FlexCodeSDK_TLB,OleCtrls, Vcl.Grids, Vcl.DBGrids,Inifiles,
  ZAbstractConnection, ZConnection;

type
  TFrmDaftar = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Edit3: TEdit;
    Button1: TButton;
    Label5: TLabel;
    Label6: TLabel;
    ZqLookup: TZQuery;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Image1: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    Label7: TLabel;
    Label8: TLabel;
    Button2: TButton;
    FPReg: TFinFPReg;
    Label9: TLabel;
    Label10: TLabel;
    ZQExec: TZQuery;
    Button3: TButton;
    DBGrid1: TDBGrid;
    ZQList: TZQuery;
    DataSource1: TDataSource;
    ZConnection1: TZConnection;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FPRegFPRegistrationImage(Sender: TObject);
    procedure FPRegFPRegistrationStatus(ASender: TObject; Status: TOleEnum);
    procedure FPRegFPRegistrationTemplate(ASender: TObject;
      const FPTemplate: WideString);
    procedure FPRegFPSamplesNeeded(ASender: TObject; Samples: SmallInt);
    procedure Button3Click(Sender: TObject);
  private
     Fsn:string;
     FActivation:string;
     FVerification:string;
     procedure ClearForm;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDaftar: TFrmDaftar;
 Template : WideString;

implementation

{$R *.dfm}

procedure TFrmDaftar.Button1Click(Sender: TObject);
begin
  OpenPictureDialog1.Execute;
  Edit3.Text := OpenPictureDialog1.FileName;
  if FileExists(Edit3.Text) then
   Image1.Picture.LoadFromFile(Edit3.Text);
end;

procedure TFrmDaftar.Button2Click(Sender: TObject);
begin
   if (Edit1.Text<>'') and
   (Edit2.Text<>'') and
   (combobox2.Text<>'') and
   (combobox1.Text<>'')
    then
   begin

   //FPReg.DeviceInfo('F700J002856', '1BB-C25-151-8CC-ED8', '0T59-D2F5-3DD8-048D-472C-36MK');
    FPReg.DeviceInfo(Fsn, FActivation, FVerification);

     FPReg.FPRegistrationStart('Mr. President');
     FPReg.PictureSamplePath:=ExtractFilePath(Application.ExeName)+'\FPTemp.BMP';
     FPReg.PictureSampleWidth:=Image1.Width*15;
     FPReg.PictureSampleHeight:=Image1.Height*15;
   end else
     MessageDlg('Lengkapi Dulu Data Diatas',mtError,[mbok],1)
end;

procedure TFrmDaftar.Button3Click(Sender: TObject);
begin
 ClearForm;
end;

procedure TFrmDaftar.ClearForm;
begin
   Edit1.Text :='';
   Edit2.Text :='';
   Edit3.Text :='';
   ComboBox1.Text:='';
   ComboBox3.Text :='';
   Image1.Picture := nil;
   ComboBox2.Text :='';
end;

procedure TFrmDaftar.FormCreate(Sender: TObject);
var s :String;
 IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try
  FSn := IniFile.ReadString('finger','sn','');
  FVerification := IniFile.ReadString('finger','verification','');
  FActivation := IniFile.ReadString('finger','activation','');

  ZConnection1.HostName := IniFile.ReadString('connection','host','localhost');
  ZConnection1.Password := IniFile.ReadString('connection','password','');
  ZConnection1.Database := IniFile.ReadString('connection','database','fingerprint');
  ZConnection1.Connect;
  finally
    IniFile.Free;
  end;
  ZQList.Open;
  ZqLookup.close;
  ZqLookup.SQL.Text:= 'select id,nama_unit from m_unit';
  ZqLookup.open;
  ZqLookup.first;
  while not ZqLookup.eof do
  begin
      ComboBox1.Items.Add(ZqLookup.Fields[1].AsString);
      ZqLookup.Next;

  end;
  s:='DT';
  ComboBox2.Items.AddObject('Dosen Tetap PNS',TObject(s));
  s:='DT';
  ComboBox2.Items.AddObject('Dosen Tidak Tetap',TObject(s));
  s:='PT';
  ComboBox2.Items.AddObject('Pegawai Tetap PNS',TObject(s));
    s:='PPT';
  ComboBox2.Items.AddObject('Pegawai Tidak Tetap',TObject(s));
  ZqLookup.close;
  ZqLookup.SQL.Text:= 'select grade_id from grade';
  ZqLookup.open;
  ZqLookup.first;
  while not ZqLookup.eof do
  begin
      ComboBox3.Items.Add(ZqLookup.Fields[0].AsString);
      ZqLookup.Next;

  end;


end;

procedure TFrmDaftar.FPRegFPRegistrationImage(Sender: TObject);
begin
Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'\FPTemp.BMP');
end;

procedure TFrmDaftar.FPRegFPRegistrationStatus(ASender: TObject;
  Status: TOleEnum);
  var id_uk :string;

begin

    if status=0 then
    begin
         ZqLookup.Close;
      ZqLookup.SQL.Text:= 'select id from m_unit where nama_unit='+QuotedStr(ComboBox1.Text);
      ZqLookup.open;
      id_uk := ZqLookup.Fields[0].AsString;

      ZqLookup.Close;
      ZqLookup.SQL.Text:= 'select max(id)+1 from pegawai';
      ZqLookup.open;



      ZQExec.SQL.Text := 'insert into pegawai (id,nip,nama,template,unit_kerja,status,grade_id) values  '+
       ' ( :id,:nip,:nama,:template,:unit_kerja,:status,:grade_id) ';
      ZQExec.ParamByName('id').AsInteger := ZqLookup.fields[0].AsInteger;
      ZQExec.ParamByName('nip').AsString  := edit1.Text;
      ZQExec.ParamByName('nama').AsString := Edit2.Text;
      ZQExec.ParamByName('unit_kerja').asstring :=  id_uk;
      ZQExec.ParamByName('status').AsString := string( ComboBox2.Items.Objects[ComboBox2.ItemIndex] );
      ZQExec.ParamByName('grade_id').AsString := ComboBox3.Text;
      ZQExec.ParamByName('template').AsString  := Template;
      ZQExec.ExecSQL;

      if fileexists(Edit3.Text) then
      begin
      ZQExec.SQL.Text := 'insert into foto_pegawai values (:id,:nip,:foto)   ';
      ZQExec.ParamByName('id').AsInteger := ZqLookup.fields[0].AsInteger;
      ZQExec.ParamByName('nip').AsString  := edit1.Text;
      ZQExec.ParamByName('foto').LoadFromFile(Edit3.Text,ftBlob);
      ZQExec.ExecSQL;


      end;


      MessageDlg('Data Berhasil Disimpan',mtInformation,[mbok],1);
      ClearForm;
      ZQList.Close;
      ZQList.Open;

    end
    else     if status=9 then
      MessageDlg('Koneksi Mesin Finger Tidak Valid Harap Periksa Sekali Lagi',mtError,[mbok],1);

end;

procedure TFrmDaftar.FPRegFPRegistrationTemplate(ASender: TObject;
  const FPTemplate: WideString);
begin
  Template :=FPTemplate;
end;

procedure TFrmDaftar.FPRegFPSamplesNeeded(ASender: TObject; Samples: SmallInt);
begin
  Label10.Caption := 'Scan Jari Ke '+IntToStr(Samples)+' X ';
end;

end.
