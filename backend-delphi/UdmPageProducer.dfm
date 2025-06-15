object dmPageProducer: TdmPageProducer
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 115
  Width = 187
  object PageProducer: TPageProducer
    OnHTMLTag = PageProducerHTMLTag
    Left = 48
    Top = 16
  end
end
