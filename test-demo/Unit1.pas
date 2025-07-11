unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,    IdGlobal,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, Vcl.ExtCtrls;

type
  TSensorData = record
    Id:        Integer;
    Temp:      Double;
    Humidity:  Double;
  end;
  TForm1 = class(TForm)
    Button1: TButton;
    IdTCPClient1: TIdTCPClient;
    Timer1: TTimer;
    Edit1: TEdit;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure SendRaw(const S: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;       Data: TSensorData;

implementation

{$R *.dfm}
   procedure TForm1.SendRaw(const S: string);
begin
  // Indy 默认字符集是 ANSI；如果 server 期望 UTF‑8，可改成 Write(TIdBytes)
  IdTCPClient1.IOHandler.Write(S+ #13#10, IndyTextEncoding_UTF8);  // 自动附加 \r\n？
  // 为保持与你 C 端一致，这里不让 Indy 自动加 CRLF，而是 S 里本身带
end;
procedure TForm1.Timer1Timer(Sender: TObject);
begin
Button1Click(self);
end;

procedure TForm1.Button1Click(Sender: TObject);
     const
  PROTOCOL_TEMP_HUMIDITY = '0x01';       const
  PROTOCOL_HEARTBEAT = '0x07';
begin


    Data.Id       := StrToInt(Edit1.Text);
    Data.Temp     := 25.5*random(99);
    Data.Humidity := 60.2;





var
  Json: string;

  Json :=
    Format('{"type":"%s","id":%d,"temperature":%.1f,"humidity":%.1f}',
      [PROTOCOL_TEMP_HUMIDITY, Data.Id, Data.Temp, Data.Humidity]);
  SendRaw(Json);


    // 5 秒后发心跳
//    Sleep(1000);






//  if WithId then
    Json := Format('{"type":"%s","id":%d}', [PROTOCOL_HEARTBEAT, Data.Id])   ;

  //  Json := Format('{"type":"%s"}', [PROTOCOL_HEARTBEAT]);
  SendRaw(Json);


end;



procedure TForm1.Button2Click(Sender: TObject);
begin
timer1.Enabled:=true;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
//  v := TJsonSender.Create('192,168,3,62', 8888);  // IP 按实际修改


  IdTCPClient1.Host := '192.168.3.64'; //这里模拟访问目标网址   这里模拟访问目标网址
   //  IdTCPClient1.Host := '192.168.0.100'; //这里模拟访问目标网址
IdTCPClient1.Port := 8888;

IdTCPClient1.Connect;
end;

end.
