unit fServerDataModule;

{$I RemObjects.inc}

interface

uses
  SysUtils, Classes,
  {RemObjects:} uROClient, uROClientIntf, uROServer, uROSessions, uROMessage,
  uROComponent,
  uROBaseConnection, uROJSONMessage, uROIndyHTTPServer, uROServerIntf,
  uROCustomRODLReader, System.TypInfo, uROHTTPDispatch, uROHttpApiDispatcher,
  uROCustomHTTPServer, uROBaseHTTPServer, IdBaseComponent, IdComponent,
  IdUDPBase, IdUDPClient, Rest.Json, IdCoderMIME, System.StrUtils, IdGlobal,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.ConsoleUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSSQL, System.Json, System.RegularExpressions, Dialogs,
  Data.DbxSqlite, Data.SqlExpr, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, IDCONTEXT, IdHeaderList, IDHTTP,
  Data.Win.ADODB;

type
  TStructure = class
    fname: string;
    ftable: string;
    ffields: string;
    ffilter: string;
    fflag: string;
  end;

type
  TDefiniton = class
    fstructure: array of TStructure;
  end;

const
  __RODLLibraryName = 'xPrototipoAPILibrary';
  __RODLLibraryNamespace = 'xPrototipoAPILibrary';
  __RODLLibraryID = '{CCF1B2C3-EB85-4B78-99C1-0239B2E752B2}';
  __RODLLibraryDocumentation = '';
  RegExpEmail = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExpId = '^[0-9]{5,12}$';
  RegExpDig = '^[0-9]{%d}$';

type
  TResponse = class
    fstatus_code: integer;
    fstatus_desc: string;
    fresult_message: string;
    fprocess_time: string;
  end;

type
  TServerDataModule = class(TDataModule)
    Server: TROIndyHTTPServer;
    Message: TROJSONMessage;
    ROHttpApiDispatcher1: TROHttpApiDispatcher;
    ToolsUDP: TIdUDPClient;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDStoredProc1: TFDStoredProc;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure ServerInternalIndyServerHeadersAvailable(AContext: TIdContext;
      const AUri: string; AHeaders: TIdHeaderList;
      var VContinueProcessing: Boolean);
    procedure ServerCustomResponseEvent(const aTransport: IROHTTPTransport;
      const aRequestStream, aResponseStream: TStream;
      const aResponse: IROHTTPResponse; var aHandled: Boolean);
  private


  public
    { Public declarations }

    fdefinition: TDefiniton;

  end;

var
  ServerDataModule: TServerDataModule;
  ConfigJSON: TJSONObject;
  strConfig: string;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

uses
  uRORTTIServerSupport;

// -----------------------------------------------------------------------------

procedure TServerDataModule.ServerCustomResponseEvent(const aTransport
  : IROHTTPTransport; const aRequestStream, aResponseStream: TStream;
  const aResponse: IROHTTPResponse; var aHandled: Boolean);
var
  buffer: TBytes;
  requestText: string;
begin
  // Agregar headers CORS de forma válida

  aResponse.Headers['Access-Control-Allow-Origin'] := '*';
  aResponse.Headers['Access-Control-Allow-Methods'] :=
    'GET, POST, PUT, DELETE, OPTIONS';
  aResponse.Headers['Access-Control-Allow-Headers'] :=
    'Content-Type, Authorization';
  aResponse.Headers['Access-Control-Max-Age'] := '3600';

  // Leer el contenido del request como string
  SetLength(buffer, aRequestStream.Size);
  aRequestStream.Position := 0;
  if aRequestStream.Size > 0 then
    aRequestStream.ReadBuffer(buffer[0], Length(buffer));

  requestText := TEncoding.UTF8.GetString(buffer);

  // Detectar si es una petición OPTIONS
  if Pos('OPTIONS', UpperCase(requestText)) > 0 then
  begin
    aResponse.Headers['Content-Type'] := 'text/plain';
    aResponse.Headers['Content-Length'] := '0';
    aHandled := True;
  end;
end;

// -----------------------------------------------------------------------------

procedure TServerDataModule.ServerInternalIndyServerHeadersAvailable
  (AContext: TIdContext; const AUri: string; AHeaders: TIdHeaderList;
  var VContinueProcessing: Boolean);
begin
  // Configurar cabeceras CORS para todas las respuestas  desde la página
  AHeaders.Values['Access-Control-Allow-Origin'] := '*';
  AHeaders.Values['Access-Control-Allow-Methods'] :=
    'GET, POST, PUT, DELETE, OPTIONS';
  AHeaders.Values['Access-Control-Allow-Headers'] :=
    'Content-Type, Authorization';
  AHeaders.Values['Access-Control-Max-Age'] := '3600';

  if AHeaders.Values['Method'] = 'OPTIONS' then
  begin
    VContinueProcessing := False;
  end;
end;

// ------------------------------------------------------------------------------

procedure TServerDataModule.DataModuleCreate(Sender: TObject);
var
  lstArchivo: TstringList;
  strArchivo: string;
  slConfig: TstringList;

begin
  if not FDConnection1.Connected then
    FDConnection1.Connected := True;
  Server.OnCustomResponseEvent := ServerCustomResponseEvent;
  Server.Active := True;
end;

// -----------------------------------------------------------------------------

initialization

uRORTTIServerSupport.RODLLibraryName := __RODLLibraryName;
uRORTTIServerSupport.RODLLibraryID := __RODLLibraryID;
uRORTTIServerSupport.RODLLibraryNamespace := __RODLLibraryNamespace;
uRORTTIServerSupport.RODLLibraryDocumentation := __RODLLibraryDocumentation;

end.
