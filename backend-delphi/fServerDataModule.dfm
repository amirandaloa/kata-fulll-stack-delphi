object ServerDataModule: TServerDataModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 300
  Width = 420
  object Server: TROIndyHTTPServer
    Dispatchers = <
      item
        Name = 'Message'
        Message = Message
        Enabled = True
        PathInfo = 'JSON'
      end>
    SendClientAccessPolicyXml = captAllowAll
    SendCrossOriginHeader = True
    IndyServer.Bindings = <>
    IndyServer.DefaultPort = 50334
    IndyServer.KeepAlive = True
    IndyServer.OnHeadersAvailable = ServerInternalIndyServerHeadersAvailable
    Port = 50334
    KeepAlive = True
    Left = 48
    Top = 8
  end
  object Message: TROJSONMessage
    Envelopes = <>
    ExtendedExceptionClass = 'ROJSONException'
    Left = 144
    Top = 8
  end
  object ROHttpApiDispatcher1: TROHttpApiDispatcher
    Server = Server
    Path = '/api/'
    Left = 256
    Top = 8
  end
  object ToolsUDP: TIdUDPClient
    Host = '127.0.0.1'
    Port = 43128
    Left = 48
    Top = 64
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=MSSQL'
      'Database=KATA_FULLSTACK_DELPHI'
      '****'
      'User_Name=sa'
      'Server=DESKTOP-O4N1EHA\SQLEXPRESS')
    LoginPrompt = False
    Left = 152
    Top = 72
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 264
    Top = 72
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 88
    Top = 128
  end
  object FDStoredProc1: TFDStoredProc
    Connection = FDConnection1
    Left = 216
    Top = 160
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLNCLI11.1;Persist Security Info=False;User ID=sa;Init' +
      'ial Catalog=KATA_FULLSTACK_DELPHI;password=*;Data Source=D' +
      'ESKTOP-O4N1EHA\SQLEXPRESS;Use Procedure for Prepare=1;Auto Trans' +
      'late=True;Packet Size=4096;Workstation ID=DESKTOP-O4N1EHA;Initia' +
      'l File Name="";Use Encryption for Data=False;Tag with column col' +
      'lation when possible=False;MARS Connection=False;DataTypeCompati' +
      'bility=0;Trust Server Certificate=False;Server SPN="";Applicatio' +
      'n Intent=READWRITE'
    LoginPrompt = False
    Provider = 'SQLNCLI11.1'
    Left = 56
    Top = 208
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 280
    Top = 224
  end
end
