unit xPrototipoAPIServerService_Impl;

{$I RemObjects.inc}

interface

uses
  System.SysUtils, System.Classes, System.TypInfo,
  uRORTTIAttributes, uROEncoding, uROXMLIntf, uROClientIntf, uROClasses,
  uROTypes, uROServer, uROServerIntf, uROSessions, uRORemoteDataModule,
  uROArray,
  fServerDataModule, System.JSON, Data.DB, WinApi.Windows, FireDAC.Stan.Param,
  Data.Win.ADODB;

{$REGION 'brief info for Code-First Services'}
(*
  set library name, uid, namespace, documentation:
  uRORTTIServerSupport.RODLLibraryName := 'LibraryName';
  uRORTTIServerSupport.RODLLibraryID := '{2533A58A-49D9-47CC-B77A-FFD791F425BE}';
  uRORTTIServerSupport.RODLLibraryNamespace := 'namespace';
  uRORTTIServerSupport.RODLLibraryDocumentation := 'documentation';

  mandatory identificators for services/methods/event sinks:
  [ROService('name')] - name parameter is optional
  [ROServiceMethod('name')] - name parameter is optional
  [ROEventSink('name')] - name parameter is optional

  (optional) class factory - service attribute, only one should be used
  [ROStandardClassFactory] - used by default
  [ROSingletonClassFactory]
  [ROSynchronizedSingletonClassFactory]
  [ROPooledClassFactory(PoolSize,PoolBehavior,PreInitializePool)] - only 1st param is mandatore
  [ROPerClientClassFactory(TimeoutSeconds)]

  other (optional) attributes:
  [ROAbstract] - Marks the service as abstract. it cannot be called directly (service only)
  [ROServiceRequiresLogin] - Sets the 'RequiresSession' property to true at runtime. (service only)
  [RORole('role')]  - allow role (service&service methods only)
  [RORole('!role')] - deny role, (service&service methods only)
  [ROSkip] - for excluding type at generting RODL for clientside
  [ROCustom('myname','myvalue')] - custom attributes
  [RODocumentation('documentation')] - documentation
  [ROObsolete] - add "obsolete" message into documentation
  [ROObsolete('custom message')] - add specified message into documentation
  [ROEnumSoapName(EntityName,SoapEntityName)] - soap mapping. multiple (enums only)

  serialization mode for properties, method parameters, arrays and service's functions results
  [ROStreamAs(Ansi)]
  [ROStreamAs(UTF8)]

  backward compatibility attributes:
  [ROSerializeAsAnsiString] - alias for [ROStreamAs(Ansi)]
  [ROSerializeAsUTF8String] - alias for [ROStreamAs(UTF8)]
  [ROSerializeResultAsAnsiString] - alias for [ROStreamAs(Ansi)]
  [ROSerializeResultAsUTF8String] - alias for [ROStreamAs(UTF8)]
*)
{$ENDREGION}
{$REGION 'examples'}
(*
  [ROEnumSoapName('sxFemale','soap_sxFemale')]
  [ROEnumSoapName('sxMale','soap_sxMale')]
  TSex = (
  sxMale,
  sxFemale
  );
  TMyStruct = class(TROComplexType)
  private
  fA: Integer;
  published
  property A :Integer read fA write fA;
  [ROStreamAs(UTF8)]
  property AsUtf8: String read fAsUtf8 write fAsUtf8;
  end;

  TMyStructArray = class(TROArray<TMyStruct>);

  [ROStreamAs(UTF8)]
  TMyUTF8Array = class(TROArray<String>);

  [ROEventSink]
  IMyEvents = interface(IROEventSink)
  ['{75F9A466-518A-4B09-9DC4-9272B1EEFD95}']
  procedure OnMyEvent([ROStreamAs(Ansi)] const aStr: String);
  end;

  [ROService('MyService')]
  TMyService = class(TRORemoteDataModule)
  private
  public
  [ROServiceMethod]
  [ROStreamAs(Ansi)]
  function Echo([ROStreamAs(Ansi)] const aValue: string):string;
  end;

  simple usage of event sinks:
  //ev: IROEventWriter<IMyEvents>;
  ..
  ev := EventRepository.GetWriter<IMyEvents>(Session.SessionID);
  ev.Event.OnMyEvent('Message');

  for using custom class factories, use these attributes:
  [ROSingletonClassFactory]
  [ROSynchronizedSingletonClassFactory]
  [ROPooledClassFactory(PoolSize,PoolBehavior,PreInitializePool)]
  [ROPerClientClassFactory(TimeoutSeconds)]

  or replace
  -----------
  initialization
  RegisterCodeFirstService(TNewService1);
  end.
  -----------
  with
  -----------
  procedure Create_NewService1(out anInstance : IUnknown);
  begin
  anInstance := TNewService1.Create(nil);
  end;

  var
  fClassFactory: IROClassFactory;
  initialization
  fClassFactory := TROClassFactory.Create(__ServiceName, Create_NewService1, TRORTTIInvoker);
  //RegisterForZeroConf(fClassFactory, Format('_TRORemoteDataModule_rosdk._tcp.',[__ServiceName]));
  finalization
  UnRegisterClassFactory(fClassFactory);
  fClassFactory := nil;
  end.
  -----------
*)
{$ENDREGION}

const
  __ServiceName = 'xPrototipoAPIService';
  __ServiceID = '{4174824C-DB53-421F-BD40-E01D4148D579}';

type

  [ROService(__ServiceName, __ServiceID)]
  [RONamespace(fServerDataModule.__RODLLibraryNamespace)]
  [ROStandardClassFactory]
  // [ROZeroConfService(__ServiceName)]
  TxPrototipoAPIServerService = class(TRORemoteDataModule)
    procedure RORemoteDataModuleCreate(Sender: TObject);
  private

  public
    // [ROServiceMethod]
    // procedure NewMethod;
{$MESSAGE Hint 'implement your actual service methods here.'}

    [ROServiceMethod]
    [ROCustom('HttpApiPath', '/GetCaficultores')]
    [ROCustom('HttpApiMethod', 'GET')]
    function GetCaficultores: string;

    [ROServiceMethod]
    [ROCustom('HttpApiPath', '/GetAbonosMonedero')]
    [ROCustom('HttpApiMethod', 'GET')]
    function GetAbonosMonedero: string;

    [ROServiceMethod]
    [ROCustom('HttpApiPath', '/RegistrarAbono')]
    [ROCustom('HttpApiMethod', 'POST')]
    function RegistrarAbono(IdCaficultor: Integer; Valor: Double): string;

    [ROServiceMethod]
    [ROCustom('HttpApiPath', '/RegistrarCaficultor')]
    [ROCustom('HttpApiMethod', 'POST')]
    function RegistrarCaficultor(Nombre: string;
  Identificacion: string; Ciudad: string; TipoProducto: string): string;

  [ROServiceMethod]
    [ROCustom('HttpApiPath', '/ConsultarSaldoMonedero')]
    [ROCustom('HttpApiMethod', 'GET')]
    function ConsultarSaldoMonedero(IdCaficultor: string): string;


  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

uses UdmPageProducer;
{$R *.dfm}
{ TxPrototipoAPIService }

// -----------------------------------------------------------------------------

function DataSetToJSONArray(DataSet: TDataSet): TJSONArray;
var
  I: Integer;
  Field: TField;
  JSONObject: TJSONObject;
begin
  Result := TJSONArray.Create;
  DataSet.First;
  while not DataSet.Eof do
  begin
    JSONObject := TJSONObject.Create;
    for I := 0 to DataSet.Fields.Count - 1 do
    begin
      Field := DataSet.Fields[I];
      case Field.DataType of
        ftString, ftWideString, ftFixedChar, ftMemo:

          JSONObject.AddPair(Field.FieldName,
            TJSONString.Create(Field.AsString));
        ftInteger, ftSmallint, ftWord, ftLargeint:

          JSONObject.AddPair(Field.FieldName,
            TJSONNumber.Create(Field.AsInteger));
        ftFloat, ftCurrency, ftBCD:

          JSONObject.AddPair(Field.FieldName,
            TJSONNumber.Create(Field.AsFloat));
        ftBoolean:

          JSONObject.AddPair(Field.FieldName,
            TJSONBool.Create(Field.AsBoolean));
        ftDate, ftTime, ftDateTime:

          JSONObject.AddPair(Field.FieldName,
            TJSONString.Create(FormatDateTime('yyyy-mm-ddThh:nn:ss.zzz',
            Field.AsDateTime)));
      else

        JSONObject.AddPair(Field.FieldName, TJSONString.Create(Field.AsString));
      end;
    end;
    Result.Add(JSONObject);
    DataSet.Next;
  end;
end;

// -----------------------------------------------------------------------------

function TxPrototipoAPIServerService.GetCaficultores: string;
var
  JSONArray: TJSONArray;
begin
  JSONArray := nil;
  try
    ServerDataModule.FDQuery1.SQL.Text :=
      'SELECT id, nombre, identificacion, ciudad, tipo_producto FROM canal_cafetero.CAFICULTORES';
    ServerDataModule.FDQuery1.Open;

    if ServerDataModule.FDQuery1.RecordCount > 0 then
    begin
      JSONArray := DataSetToJSONArray(ServerDataModule.FDQuery1);
      if Assigned(JSONArray) then
        Result := JSONArray.ToString
      else
        Result := '[]';
    end
    else
    begin
      Result := '[]';
    end;
  finally
    FreeAndNil(JSONArray);

    ServerDataModule.FDQuery1.Close;
  end;
end;

// -----------------------------------------------------------------------------

function TxPrototipoAPIServerService.RegistrarCaficultor(Nombre: string;
  Identificacion: string; Ciudad: string; TipoProducto: string): string;
begin
  Result := '[]';


    try
      ServerDataModule.FDQuery1.Close();
      ServerDataModule.FDQuery1.SQL.Text := EmptyStr;
      ServerDataModule.FDQuery1.SQL.Text :=
        'exec canal_cafetero.SP_RegistrarCaficultor ' +
        QuotedStr( Nombre ) + ',' + QuotedStr( Identificacion ) + ',' + QuotedStr(  Ciudad ) + ',' + QuotedStr( TipoProducto ) + ';';
      ServerDataModule.FDQuery1.ExecSQL;
      Result := '[ok]';
    except
      on E: Exception do
      begin
        OutputDebugString(PChar('Error al registrar abono: ' + E.Message));
        Result := '[Error al registrar abono: ' + E.Message + ']';
      end;
    end;
end;

// -----------------------------------------------------------------------------

function TxPrototipoAPIServerService.ConsultarSaldoMonedero(IdCaficultor: string): string;
var
  SaldoParam: TFDParam;
begin
  Result := '0.00';
  try
    with ServerDataModule.FDQuery1 do
    begin
      Close;
      SQL.Text := 'EXEC canal_cafetero.SP_ConsultarSaldoMonedero :IdCaficultor, :Saldo';

      Params.Clear;

      Params.CreateParam(ftInteger, 'IdCaficultor', ptInput).AsInteger := StrToInt(IdCaficultor);

      SaldoParam := Params.CreateParam(ftFMTBcd, 'Saldo', ptOutput);
      SaldoParam.Precision := 18;
      SaldoParam.NumericScale := 2;

      ExecSQL;

      Result := SaldoParam.AsString;
    end;
  except
    on E: Exception do
    begin
      OutputDebugString(PChar('Error al consultar saldo: ' + E.Message));
      Result := '[Error al consultar saldo: ' + E.Message + ']';
    end;
  end;
end;


// -----------------------------------------------------------------------------

function TxPrototipoAPIServerService.GetAbonosMonedero: string;
var
  JSONArray: TJSONArray;
begin
  JSONArray := nil;

  try
    ServerDataModule.FDQuery1.SQL.Text :=
      'SELECT id, id_caficultor, valor, fecha FROM canal_cafetero.ABONOS_MONEDERO';
    ServerDataModule.FDQuery1.Open;

    if ServerDataModule.FDQuery1.RecordCount > 0 then
    begin
      JSONArray := DataSetToJSONArray(ServerDataModule.FDQuery1);
      if Assigned(JSONArray) then
        Result := JSONArray.ToString
      else
        Result := '[]';
    end
    else
    begin
      Result := '[]';
    end;
  finally
    FreeAndNil(JSONArray);

    ServerDataModule.FDQuery1.Close;
  end;
end;

// ------------------------------------------------------------------------------

function TxPrototipoAPIServerService.RegistrarAbono(IdCaficultor: Integer;
  Valor: Double): string;
begin
  Result := '[]';
  if Valor <= 0 then
  begin
    // raise Exception.Create('No se permiten abonos negativos ni cero.');
    Result := '[No se permiten abonos negativos ni cero]';
  end
  else
  begin

    try
      ServerDataModule.FDQuery1.Close();
      ServerDataModule.FDQuery1.SQL.Text := EmptyStr;
      ServerDataModule.FDQuery1.SQL.Text :=
        'exec canal_cafetero.SP_RegistrarAbonoMonedero ' +
        IntToStr(IdCaficultor) + ',' + FloatToStr(Valor) + ';';
      ServerDataModule.FDQuery1.ExecSQL;
      Result := '[ok]';
    except
      on E: Exception do
      begin
        OutputDebugString(PChar('Error al registrar abono: ' + E.Message));
        Result := '[Error al registrar abono: ' + E.Message + ']';
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TxPrototipoAPIServerService.RORemoteDataModuleCreate(Sender: TObject);
var
  I: Integer;
begin
  I := 0;
end;

initialization

RegisterCodeFirstService(TxPrototipoAPIServerService);

end.
