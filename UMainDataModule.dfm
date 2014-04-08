object MainDataModule: TMainDataModule
  OldCreateOrder = False
  Height = 435
  Width = 749
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
    Left = 344
    Top = 104
  end
  object DreamRESTResponseChannelList: TRESTResponse
    Left = 344
    Top = 168
  end
  object DreamRESTResponseDataSetAdapterChannelList: TRESTResponseDataSetAdapter
    Dataset = DreamFDMemTableChannelList
    FieldDefs = <>
    Response = DreamRESTResponseChannelList
    OnBeforeOpenDataSet = DreamRESTResponseDataSetAdapterChannelListBeforeOpenDataSet
    RootElement = 'services'
    Left = 344
    Top = 232
  end
  object DreamHTTPBasicAuthenticator: THTTPBasicAuthenticator
    Username = 'root'
    Password = 'tsukubakek'
    Left = 320
    Top = 24
  end
  object DreamFDMemTableChannelList: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 344
    Top = 296
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
    Dataset = DreamFDMemTableServiceList
    FieldDefs = <>
    Response = DreamRESTResponseServiceList
    OnBeforeOpenDataSet = DreamRESTResponseDataSetAdapterServiceListBeforeOpenDataSet
    RootElement = 'services'
    Left = 88
    Top = 232
  end
  object DreamFDMemTableServiceList: TFDMemTable
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
  object DreamRESTRequestTextEPG: TRESTRequest
    Client = DreamRESTClient
    Params = <
      item
        name = 'sRef'
      end>
    Resource = 'epgservice'
    Response = DreamRESTResponseTextEPG
    Left = 600
    Top = 104
  end
  object DreamRESTResponseTextEPG: TRESTResponse
    Left = 600
    Top = 168
  end
  object DreamRESTResponseDataSetAdapterTextEPG: TRESTResponseDataSetAdapter
    Dataset = DreamFDMemTableTextEPG
    FieldDefs = <>
    Response = DreamRESTResponseTextEPG
    OnBeforeOpenDataSet = DreamRESTResponseDataSetAdapterTextEPGBeforeOpenDataSet
    RootElement = 'events'
    Left = 600
    Top = 232
  end
  object DreamFDMemTableTextEPG: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 600
    Top = 296
  end
  object DreamRESTRequestAddTimer: TRESTRequest
    Client = DreamRESTClient
    Params = <
      item
        name = 'sRef'
      end
      item
        name = 'eventid'
      end
      item
        name = 'dirname'
        Value = '/hdd/movie/'
      end>
    Resource = 'timeraddbyeventid'
    Response = DreamRESTResponseAddTimer
    Left = 77
    Top = 392
  end
  object DreamRESTResponseAddTimer: TRESTResponse
    Left = 77
    Top = 456
  end
end
