object MainDataModule: TMainDataModule
  OldCreateOrder = False
  Height = 435
  Width = 529
  object DreamRESTClient: TRESTClient
    Authenticator = DreamHTTPBasicAuthenticator
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    AcceptEncoding = 'identity'
    BaseURL = 'http://vuduo2.fritz.box/api'
    Params = <>
    HandleRedirects = True
    Left = 128
    Top = 24
  end
  object DreamRESTRequestChannelList: TRESTRequest
    Client = DreamRESTClient
    Params = <
      item
        name = 'sRef'
      end>
    Resource = 'getservices'
    Response = DreamRESTResponseChannelList
    Left = 368
    Top = 112
  end
  object DreamRESTResponseChannelList: TRESTResponse
    Left = 368
    Top = 176
  end
  object DreamRESTResponseDataSetAdapterChannelList: TRESTResponseDataSetAdapter
    Active = True
    Dataset = DreamFDMemTableChannelList
    FieldDefs = <>
    Response = DreamRESTResponseChannelList
    OnBeforeOpenDataSet = DreamRESTResponseDataSetAdapterChannelListBeforeOpenDataSet
    RootElement = 'services'
    Left = 368
    Top = 240
  end
  object DreamHTTPBasicAuthenticator: THTTPBasicAuthenticator
    Username = 'root'
    Password = 'tsukubakek'
    Left = 320
    Top = 24
  end
  object DreamFDMemTableChannelList: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'servicereference'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'servicename'
        DataType = ftString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 368
    Top = 304
  end
  object DreamRESTRequestServiceList: TRESTRequest
    Client = DreamRESTClient
    Params = <>
    Resource = 'getservices'
    Response = DreamRESTResponseServiceList
    Left = 88
    Top = 104
  end
  object DreamRESTResponseServiceList: TRESTResponse
    Left = 88
    Top = 168
  end
  object DreamRESTResponseDataSetAdapterServiceList: TRESTResponseDataSetAdapter
    Active = True
    Dataset = DreamFDMemTableServiceList
    FieldDefs = <>
    Response = DreamRESTResponseServiceList
    OnBeforeOpenDataSet = DreamRESTResponseDataSetAdapterServiceListBeforeOpenDataSet
    RootElement = 'services'
    Left = 88
    Top = 232
  end
  object DreamFDMemTableServiceList: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'servicereference'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'servicename'
        DataType = ftString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 88
    Top = 296
  end
end
