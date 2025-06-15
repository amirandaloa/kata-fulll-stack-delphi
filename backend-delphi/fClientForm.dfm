object ClientForm: TClientForm
  Left = 372
  Top = 277
  Width = 400
  Height = 340
  Caption = 'RemObjects Client'
  ClientHeight = 64
  ClientWidth = 228
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Style = []
  ParentFont = True
  OldCreateOrder = False
  PixelsPerInch = 96
  Position = poScreenCenter
  TextHeight = 14
  object Channel: TROWinInetHTTPChannel
    Left = 8
    Top = 8
    TargetUrl = 'http://127.0.0.1:8099/JSON'
  end  
  object Message: TROJSONMessage
    Left = 36
    Top = 8
  end
  object RORemoteService: TRORemoteService
    Message = Message
    Channel = Channel
    ServiceName = 'xPrototipoAPIServiceService'
    Left = 64
    Top = 8
  end
end
