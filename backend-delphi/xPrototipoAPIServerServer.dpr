program xPrototipoAPIServerServer;

uses
  uROComInit,
  uROComboService,
  Forms,
  fServerDataModule in 'fServerDataModule.pas' {ServerDataModule: TDataModule},
  fServerForm in 'fServerForm.pas' {ServerForm},
  xPrototipoAPIServerService_Impl in 'xPrototipoAPIServerService_Impl.pas' {xPrototipoAPIServerService: TRORemoteDataModule},
  UdmPageProducer in 'UdmPageProducer.pas' {dmPageProducer: TDataModule};

{$R *.res}

begin
{
  if ROStartService('xPrototipoAPIServerServer', 'xPrototipoAPIServerServer') then begin
    ROService.CreateForm(TServerDataModule, ServerDataModule);
    ROService.Run;
    Exit;
  end;
  }

  Application.Initialize;
  Application.CreateForm(TServerDataModule, ServerDataModule);
  Application.CreateForm(TServerForm, ServerForm);
  Application.Run;
end.
