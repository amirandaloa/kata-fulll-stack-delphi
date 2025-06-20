unit fClientForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  uROClient, uROClientIntf, uRORemoteService, uROJSONMessage, 
  uROWinInetHTTPChannel;

type
  TClientForm = class(TForm)
    Message: TROJSONMessage;
    Channel: TROWinInetHTTPChannel;
    RORemoteService: TRORemoteService;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClientForm: TClientForm;

implementation

{
  The unit xPrototipoAPIServiceLibrary_Intf.pas will be generated by the RemObjects preprocessor the first time you
  compile your server application. Make sure to do that before trying to compile the client.

  To invoke your server simply typecast your server to the name of the service interface like this:

      (RORemoteService as IxPrototipoAPIServiceService).Sum(1,2)
}

uses xPrototipoAPIServiceLibrary_Intf; 

{$R *.dfm}

end.
