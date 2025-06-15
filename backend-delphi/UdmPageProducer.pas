unit UdmPageProducer;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Web.HTTPProd, System.StrUtils;

type
  TdmPageProducer = class(TDataModule)
    PageProducer : TPageProducer;
    procedure PageProducerHTMLTag(Sender: TObject; Tag: TTag; const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    lstMessage  : TStringList;
    FBase64Flag : Boolean;
  public
    { Public declarations }
    function getContent(strTemplate : String; strValues : String; base64Flag : Boolean) : String;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}


{$R *.dfm}

procedure TdmPageProducer.DataModuleCreate(Sender: TObject);
  begin
    lstMessage := TStringList.Create;
  end;

procedure TdmPageProducer.PageProducerHTMLTag(Sender: TObject; Tag: TTag; const TagString: string; TagParams: TStrings; var ReplaceText: string);
  begin
    if FBase64Flag then
      ReplaceText := lstMessage.Values[TagString]
    else
      ReplaceText := lstMessage.Values[TagString];
  end;

function TdmPageProducer.getContent(strTemplate, strValues: String; base64Flag : Boolean): String;
  begin
    lstMessage.Text           := strValues;
    PageProducer.HTMLDoc.Text := strTemplate;
    FBase64Flag               := base64Flag;
    result                    := PageProducer.Content;
  end;

procedure TdmPageProducer.DataModuleDestroy(Sender: TObject);
  begin
    lstMessage.Clear;
    lstMessage.Free;
  end;

end.
