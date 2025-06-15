unit xPrototipoAPIServiceService_Impl;

{$I RemObjects.inc}
interface

uses
  System.SysUtils, System.Classes, System.TypInfo,
  uRORTTIAttributes, uROEncoding, uROXMLIntf, uROClientIntf, uROClasses,
  uROTypes, uROServer, uROServerIntf, uROSessions, uRORemoteDataModule, uROArray,
  fServerDataModule, System.JSON, Dialogs, Data.DB, System.Generics.Collections;

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
 type
  TPageProducerClient = class(TObject)
  public
    class function getContent(strTemplate : String; strValues : String; base64Flag : Boolean) : String; static;
end;

type
  TRequest = class(TROComplexType)
  private
    ftable    : string;
    ffields   : string;
    fvalues   : string;
    ffilter   : string;
    freq_name : string;
  published
    property table    : string read ftable write ftable;
    property fields   : string read ffields write ffields;
    property values   : string read fvalues write fvalues;
    property filter   : string read ffilter write ffilter;
    property reqname  : string read freq_name write freq_name;
  end;


type
  TResponse = class(TROComplexType)
  private
    fstatus_code : integer;
    fstatus_desc : string;
    fdata        : string;
  published
    property status_code : integer read fstatus_code write fstatus_code;
    property status_desc : string read fstatus_desc write fstatus_desc;
    property data : string read fdata write fdata;
  end;


const
  __ServiceName ='xPrototipoAPIServiceService';
  __ServiceID = '{09DA171D-8C42-41D4-B92D-FB33247FA9A0}';
type

  [ROService(__ServiceName, __ServiceID)]
  [RONamespace(fServerDataModule.__RODLLibraryNamespace)]
  [ROStandardClassFactory]
//  [ROZeroConfService(__ServiceName)]
  TxPrototipoAPIServiceService = class(TRORemoteDataModule)
  private
  function getList(strJson : string) : string;

  public
    //[ROServiceMethod]
    //procedure NewMethod;
    {$Message Hint 'implement your actual service methods here.'}

    [ROServiceMethod]
    [ROCustom('HttpApiPath', '/select')]
    [ROCustom('HttpApiMethod', 'POST')]
    function select(xRequest : TRequest) : TResponse;

    [ROServiceMethod]
    [ROCustom('HttpApiPath', '/update')]
    [ROCustom('HttpApiMethod', 'POST')]
    function update(xRequest : TRequest) : TResponse;

    [ROServiceMethod]
    [ROCustom('HttpApiPath', '/odessaCrearCB')]
    [ROCustom('HttpApiMethod', 'POST')]
    function odessaCrearCB(xRequest : TRequest) : TResponse;

    [ROServiceMethod]
    [ROCustom('HttpApiPath', '/PBIODS_COR')]
    [ROCustom('HttpApiMethod', 'GET')]
    function PBIODS_COR(xRequest : TRequest) : TResponse;



  end;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}

uses UdmPageProducer;


{ TxPrototipoAPIServiceService }

function TxPrototipoAPIServiceService.getList(strJson: string): string;
  var
    i    : integer;
    obj  : TJSONObject;
    pair : TJSONPair;
    name : string;
    value : string;
    list  : string;
  begin
    obj := TJSONObject.Create;

    try
      obj := TJSONObject.ParseJSONValue(strJson) as TJSONObject;
      i := 0;

      while i < obj.count do
        begin
          pair := TJSONPair(obj.Pairs[i]);
          name := pair.JsonString.Value;
          value := obj.Values[name].Value;
          list := list + name + '=' + value + #13#10;
          inc(i);
        end;
    finally
      obj.Free;
    end;

    result := list;
  end;
//------------------------------------------------------------------------------

function TxPrototipoAPIServiceService.select(xRequest : TRequest) : TResponse;
var
    xResponse   : TResponse;
    strTabla    : string;
    strCampos   : string;
    strFiltro   : string;
    strSelect   : string;
    strReqname  : string;
    filtrosLst  : string;
    filtros     : string;
    xStructure  : TStructure;
    Resultados  : TJSONArray;
    row         : TJSONArray;
    column      : TField;
    ColumnPair  : TJSONPair;
    valu        : Variant;
    slCamposReq : TStringList;
    slCamposXtr : TStringList;
  i: Integer;
  begin
    strReqname := xRequest.reqname;
    strTabla := xRequest.table;
    strCampos := xRequest.fields;
    strFiltro := xRequest.filter;
    Resultados := TJSONArray.Create();
    for xStructure in ServerDataModule.fdefinition.fstructure do
      begin
        if xRequest.reqname = xStructure.fname then
          begin
            if strCampos <> '*' then
            begin
               slCamposReq := TStringList.Create;
               slCamposXtr := TStringList.Create;
               slCamposReq.CommaText := strCampos;
               slCamposXtr.CommaText := xStructure.ffields;
               strCampos := '';
               for i := 0 to slCamposReq.Count -1 do
               begin
                  strCampos := strCampos + slCamposXtr[i] + ',';
                  strCampos := strCampos.Replace('*', ' ',  [rfReplaceAll]);
               end;
               strCampos := strCampos.Substring(0, Length(strCampos) -1);
            end;

            filtrosLst := getList(xRequest.filter);
            filtros    := TPageProducerClient.getContent(xStructure.ffilter, filtrosLst, false).Replace(#13#10, '');
            strSelect := Format('select %s from %s where %s',[strCampos, xStructure.ftable, filtros]);
            ServerDataModule.FDQuery1.SQL.Text := strSelect;
            ServerDataModule.FDQuery1.Open();

            ServerDataModule.FDQuery1.First;


              while not ServerDataModule.FDQuery1.Eof do
              begin
                try
                   row := TJSONArray.Create();
                   for column in ServerDataModule.FDQuery1.Fields do
                   begin
                      valu := ServerDataModule.FDQuery1.FieldByName(column.FieldName).Value;
                      if VarToUnicodeStr( valu )= '' then
                      valu := '';
                     ColumnPair := TJSONPair.Create(column.FieldName,
                     valu);

                     row.Add(ColumnPair.ToString());
                   end;
                   Resultados.AddElement(row);
                   ServerDataModule.FDQuery1.Next;
                except on E:Exception do
                  begin
                    ServerDataModule.FDQuery1.Next;
                  end;
                end;
              end;
          end;
      end;


    xResponse := TResponse.Create;
    xResponse.status_code := 0;
    xResponse.status_desc := 'Exitoso';
    xResponse.data :=  Resultados.ToString();
    result := xResponse;
  end;
//------------------------------------------------------------------------------

function TxPrototipoAPIServiceService.odessaCrearCB(
  xRequest: TRequest): TResponse;
var
    xResponse   : TResponse;
    slFields    : TStringList;
    slValues    : TStringList;
    slOficin    : TStringList;
    strValues   : string;
    strFields   : string;
    strSQL      : string;
    strReqname  : string;
    strCampo      : string;
    xStructure  : TStructure;
    i           : Integer;
    esValido    : Boolean;
    strRespVal  : string;
    strCm       : string;
    strOficina  : string;

    function obtenerDatosOficina(oficina: string): string;
    var
      resultado : string;
    begin
       resultado := '';
       strSQL := Format('select 	codigo_dane, municipio, departamento, region from [gci_sgcb].[sgcb_oficinas_tbl] where codigo_oficina = ''%s''',[oficina]);
       ServerDataModule.FDQuery1.SQL.Text := strSQL;
       try
          ServerDataModule.FDQuery1.SQL.Text := strSQL;
          ServerDataModule.FDQuery1.Close();
          ServerDataModule.FDQuery1.Open();
          if ServerDataModule.FDQuery1.RecordCount > 0 then
          begin
            resultado := resultado + '~municipio~departamento~regional,';
            //resultado := resultado + '~''' +  ServerDataModule.FDQuery1.FieldByName('codigo_dane').AsString + '''~''';
            resultado :=  resultado + '~''' +  ServerDataModule.FDQuery1.FieldByName('municipio').AsString + '''~''';
            resultado := resultado +  ServerDataModule.FDQuery1.FieldByName('departamento').AsString + '''~''';
            resultado := resultado +  ServerDataModule.FDQuery1.FieldByName('region').AsString + '''';
          end else
          begin
            resultado := 'Oficina no creada aún: ' + oficina;
          end;
       except on E:Exception do
         begin
            resultado := 'Error al buscar oficina.' + e.Message;
         end;
       end;
       Result := resultado.Replace(' ','*',[rfReplaceAll]);
    end;

begin
  try
    slFields           := TStringList.Create;
    strFields          := xRequest.fields;
    strFields          := strFields.Replace(' ','*');
    slFields.CommaText := strFields;
    slValues           := TStringList.Create;
    slValues.CommaText := xRequest.values.replace(' ','~');
    strReqname         := xRequest.reqname;
    xResponse          := TResponse.Create;
    esValido           := False;
    strRespVal         := '';
    strValues          := '';
    strCm              := '';
    xResponse.status_code := 204;
    xResponse.data :=  '';
    xResponse.status_desc := 'No se encontró contenido en la solicitud.';
    strOficina         := '';
    slOficin           := TStringList.Create;

    for xStructure in ServerDataModule.fdefinition.fstructure do
    begin
      if xRequest.reqname = xStructure.fflag then
      begin
        strFields := '';
        for i := 0 to slValues.Count -1 do
        begin
          strCampo := slValues[i].Replace('~', ' ');

          if (i = 23) and (UpperCase(strCampo) <> 'NULL') then
          begin
            strCm := slValues[22].Replace('~', ' ') + ',' + slValues[23].Replace('~', ' ');
            strRespVal :=  strRespVal + ServerDataModule.validarCamposCB(i + 1, strCm);
          end
          else
          begin
            strRespVal :=  strRespVal + ServerDataModule.validarCamposCB(i + 1, strCampo);
          end;

          if strCampo <> 'NULL' then
            strValues := strValues + '''' + strCampo + '''' + ','
          else
            strValues := strValues + strCampo + ',';
        end;

        strValues := strValues + xStructure.fname;
        strFields := xStructure.ffields + xStructure.ffilter;
        strCm := obtenerDatosOficina( ServerDataModule.strOficina );
        slOficin.CommaText := strcm;

        if slOficin.Count > 0 then
        begin
          strFields := strFields + slOficin[0].Replace('~',',').Replace('*',' ',[rfReplaceAll]);;
          strValues := strValues + slOficin[1].Replace('~',',').Replace('*',' ',[rfReplaceAll]);;

          if strRespVal = '~~~~~~~~~~~~~~~~~~~~~~' then
          begin
            strSQL := Format('insert into %s (%s) values (%s)',[xStructure.ftable, strFields, strValues]);

            ServerDataModule.FDQuery1.SQL.Text := strSQL;
            try
              ServerDataModule.FDQuery1.ExecSQL();
              if ServerDataModule.FDQuery1.RowsAffected > 0 then
              begin
                xResponse.status_code := 200;
                xResponse.status_desc := 'Corresponsal Creado correctamente.';
              end else
              begin
                xResponse.status_desc := 'Error al crear el corresponsal.';
              end;
            except on E:Exception do
            begin
              xResponse.status_code := 500;
              strRespVal := E.Message.Replace('[FireDAC][Phys][ODBC][Microsoft][ODBC SQL Server Driver][SQL Server]',' ');
              strRespVal := strRespVal.Replace('gci_sgcb.sgcb_corresponsal_rev2_tbl',' ');
              strRespVal := strRespVal.Replace('AK_sgcb_corresponsal_rev2_tbl_identificacion_corresponsal',' ');
              strRespVal := strRespVal.Replace('with unique index',' ');
              strRespVal := strRespVal.Replace('''','');
              strRespVal := strRespVal.Replace('     ','');
              xResponse.status_desc := 'Error al crear el corresponsal.' + strRespVal;
            end;
            end;

          end
          else
          begin
            strRespVal := strRespVal.Replace('~', '');
            xResponse.status_code := 400;
            xResponse.data :=  strRespVal.Replace('  ','');
            xResponse.status_desc := 'Error en uno o varios campos de la solicitud.';
          end;
        end else
        begin
          xResponse.status_code := 400;
          xResponse.data :=  '';
          xResponse.status_desc := 'Error: Oficina no configurada.';
        end;
      end;
    end;
  finally
    FreeAndNil(slValues);
    FreeAndNil(slFields);
    strValues := '';
  end;
  result := xResponse;
end;

//------------------------------------------------------------------------------

   {
function TxPrototipoAPIServiceService.PBIODS_COR(xRequest: TRequest): TResponse;
var
  strSql : string;
  xResponse   : TResponse;
    strTabla    : string;
    strCampos   : string;
    strFiltro   : string;
    strSelect   : string;
    strReqname  : string;
    filtrosLst  : string;
    filtros     : string;
    xStructure  : TStructure;
    Resultados  : TJSONArray;
    row         : TJSONArray;
    column      : TField;
    ColumnPair  : TJSONPair;
    valu        : Variant;
    slCamposReq : TStringList;
    slCamposXtr : TStringList;
begin
  strSql := '';
  strReqname := xRequest.reqname;
  strTabla := xRequest.table;
  strCampos := xRequest.fields;
  strFiltro := xRequest.filter;
  Resultados := TJSONArray.Create();

  strSql := 'select top 2 * from [gci_sgcb].[sgcb_cinta_ath_tbl]';
  ServerDataModule.FDQuery1.SQL.Text := strSql;
  ServerDataModule.FDQuery1.Open();

  ServerDataModule.FDQuery1.First;

  while not ServerDataModule.FDQuery1.Eof do
  begin
    try
       row := TJSONArray.Create();
       for column in ServerDataModule.FDQuery1.Fields do
       begin
          valu := ServerDataModule.FDQuery1.FieldByName(column.FieldName).Value;
          if VarToUnicodeStr( valu )= '' then
          valu := '';
         ColumnPair := TJSONPair.Create(column.FieldName,
         valu);

         row.Add(ColumnPair.ToString());
       end;
       Resultados.AddElement(row);
       ServerDataModule.FDQuery1.Next;
    except on E:Exception do
      begin
        ServerDataModule.FDQuery1.Next;
      end;
    end;
  end;

  xResponse := TResponse.Create;
  xResponse.status_code := 0;
  xResponse.status_desc := 'Exitoso';
  xResponse.data :=  Resultados.ToString();
  result := xResponse;
end;
    }
 {
    function TxPrototipoAPIServiceService.PBIODS_COR(xRequest: TRequest): TResponse;
var
  strSql : string;
  xResponse   : TResponse;
  strTabla    : string;
  strCampos   : string;
  strFiltro   : string;
  strSelect   : string;
  strReqname  : string;
  Resultados  : TJSONArray;
  row         : TJSONObject;
  column      : TField;
  i : Integer;
begin
  strSql := '';
  strReqname := xRequest.reqname;
  strTabla := xRequest.table;
  strCampos := xRequest.fields;
  strFiltro := xRequest.filter;
  Resultados := TJSONArray.Create();

  strSql := 'select  * from [gci_sgcb].[sgcb_cinta_ath_tbl]';
  ServerDataModule.FDQuery1.SQL.Text := strSql;
  ServerDataModule.FDQuery1.Open();

  i    :=   ServerDataModule.FDQuery1.RecordCount;
  i := 0;
  ServerDataModule.FDQuery1.First;

  while not ServerDataModule.FDQuery1.Eof do
  begin
    try
       row := TJSONObject.Create();
       for column in ServerDataModule.FDQuery1.Fields do
       begin
          row.AddPair(TJSONPair.Create(column.FieldName, TJSONString.Create(column.AsString)));
       end;
       Resultados.Add(row);
       ServerDataModule.FDQuery1.Next;
       i := i + 1;
    except
      on E: Exception do
      begin
        // Manejar la excepción si es necesario
        i := i + 1;
        ServerDataModule.FDQuery1.Next;
      end;
    end;
  end;

       }




      function TxPrototipoAPIServiceService.PBIODS_COR(xRequest: TRequest): TResponse;
var
  strSql        : string;
  xResponse     : TResponse;
  strTabla      : string;
  strCampos     : string;
  strFiltro     : string;
  strSelect     : string;
  strReqname    : string;
  Resultados    : TJSONArray;
  row           : TJSONObject;
  column        : TField;
  offset        : Integer;
  fetch         : Integer;
  Archivo       :   TextFile;
  strFieldName  : string;
  strFieldVal   : string;
  strJSON       : string;
  strBD         : string;
  i : Integer;
begin
  strSql := '';
  strReqname := xRequest.reqname;
  strTabla := xRequest.table;
  strCampos := xRequest.fields;
  strFiltro := xRequest.filter;
  Resultados := TJSONArray.Create();
  AssignFile(Archivo, 'cinta_ath.csv');
  offset := 0;
  fetch := 10000; // Número de registros a recuperar por página, ajusta según sea necesario
  strFieldName  := '';
  strFieldVal   := '';
  strJSON       := '[{';
  strBD  := '';
  i := 0;

  Rewrite(Archivo);


  repeat
    strSql := Format('SELECT * FROM [gci_sgcb].[sgcb_cinta_ath_tbl] order by consecutive OFFSET %d ROWS FETCH NEXT %d ROWS ONLY', [offset, fetch]);
    ServerDataModule.FDQuery1.SQL.Text := strSql;
    ServerDataModule.FDQuery1.Open();

    ServerDataModule.FDQuery1.First;



    strSql := 'delete from transacciones_cinta_ath_JSON ';
    //ServerDataModule.FDQuerySQLite.Close;
    //ServerDataModule.FDQuerySQLite.SQL.Text := strSql;
    //ServerDataModule.FDQuerySQLite.ExecSQL;
    //ServerDataModule.FDSQLLiteConnection.Commit;

    while not ServerDataModule.FDQuery1.Eof do
    begin
      try
        row := TJSONObject.Create();
        for column in ServerDataModule.FDQuery1.Fields do
        begin
          strFieldVal := column.AsString;
          strFieldName :=  column.FieldName;
          strBD := strBD +  '"' +  strFieldName + '":"'+ strFieldVal + '",';
          //row.AddPair(TJSONPair.Create(column.FieldName, TJSONString.Create(column.AsString)));
        end;
        //Resultados.Add(row);
        strBD := strBD.Substring(0, Length(strBD) - 1);


        strBD := '{' + strBD + '},';
        Append(archivo);
        WriteLn(archivo, strBD);
        CloseFile(archivo);


        //strSql := Format('insert into transacciones_cinta_ath_JSON(json_line) values(''%s''); ',[strBD]);
        //ServerDataModule.FDQuerySQLite.Close;
        //ServerDataModule.FDQuerySQLite.SQL.Text := strSql;
        //ServerDataModule.FDQuerySQLite.ExecSQL;
        //ServerDataModule.FDSQLLiteConnection.Commit;
        strBD := '';
        i := i + 1;
        ServerDataModule.FDQuery1.Next;
      except
        on E: Exception do
        begin
          // Manejar la excepción si es necesario
          ServerDataModule.FDQuery1.Next;
        end;
      end;
    end;

    offset := offset + fetch;

  until {(ServerDataModule.FDQuery1.Eof) or }(ServerDataModule.FDQuery1.RecordCount < fetch);


  strJSON := '[';
  Reset(Archivo);
  repeat
    Readln(Archivo, strSql);
    strJSON := strJSON + strSql;
  until Eof(Archivo);
  CloseFile(Archivo);
  //DeleteFile('cinta_ath.csv');
  strJSON.Substring(0,Length(strJSON) -1);
  strJSON := strJSON + ']';


  xResponse := TResponse.Create;
  xResponse.status_code := 0;
  xResponse.status_desc := 'Exitoso';
  xResponse.data := strJSON;
  Result := xResponse;
end;





//------------------------------------------------------------------------------

function TxPrototipoAPIServiceService.update(
  xRequest: TRequest): TResponse;
var
    xResponse   : TResponse;
    strTabla    : string;
    strCampos   : string;
    strFiltro   : string;
    strUpdate   : string;
    strReqname  : string;
    camposLst   : string;
    filtrosLst  : string;
    campos      : string;
    filtros     : string;
    xStructure  : TStructure;

begin
  strReqname:= xRequest.reqname;
  strTabla := xRequest.table;
  strCampos := xRequest.fields;
  strFiltro := xRequest.filter;
  xResponse := TResponse.Create;

  for xStructure in ServerDataModule.fdefinition.fstructure do
    begin
      if xRequest.reqname = xStructure.fflag then
      begin
        camposLst  := getList(xRequest.fields);
        campos     := TPageProducerClient.getContent(xStructure.ffields, camposLst, false).Replace(#13#10, '');
        filtrosLst := getList(xRequest.filter);
        filtros    := TPageProducerClient.getContent(xStructure.ffilter, filtrosLst, false).Replace(#13#10, '');

        if pos('is null',filtros) > 1 then
        begin
          filtros := filtros.Replace('''','');
          filtros := filtros.Replace('"','');
          filtros := filtros.Replace('=','');
        end;

        strUpdate := Format('update %s set %s where %s',[xStructure.ftable, campos, filtros]);
        ServerDataModule.FDQuery1.SQL.Text := strUpdate;
        ServerDataModule.FDQuery1.ExecSQL();

        if ServerDataModule.FDQuery1.RowsAffected > 0 then
        begin
           xResponse.status_desc := Format('Actualización exitosa, registros modificados: %d ',[ServerDataModule.FDQuery1.RowsAffected]);
        end else
        begin
          xResponse.status_desc := 'Error realizando la actualización';
        end;
      end;
    end;

    xResponse.status_code := 0;
    xResponse.data :=  '';
    result := xResponse;
  end;
//------------------------------------------------------------------------------

{ TPageProducerClient }

class function TPageProducerClient.getContent(strTemplate, strValues: String; base64Flag : Boolean): String;
  var
    xdmPageProducer : TdmPageProducer;
    strResult       : String;
  begin
    xdmPageProducer := TdmPageProducer.Create(nil);
    strResult       := xdmPageProducer.getContent(strTemplate, strValues, base64Flag);
    xdmPageProducer.Destroy;
    result          := strResult;
  end;
//------------------------------------------------------------------------------

initialization
  RegisterCodeFirstService(TxPrototipoAPIServiceService);
end.
