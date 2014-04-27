object MainDataModule: TMainDataModule
  OldCreateOrder = False
  Height = 538
  Width = 749
  object DreamRESTClient: TRESTClient
    Authenticator = DreamHTTPBasicAuthenticator
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    AcceptEncoding = 'identity'
    Params = <>
    HandleRedirects = True
    Left = 176
    Top = 40
  end
  object DreamRESTRequestChannelList: TRESTRequest
    Client = DreamRESTClient
    Params = <
      item
        name = 'sRef'
      end>
    Resource = 'getservices'
    Response = DreamRESTResponseChannelList
    Timeout = 4000
    Left = 328
    Top = 104
  end
  object DreamRESTResponseChannelList: TRESTResponse
    Left = 328
    Top = 168
  end
  object DreamRESTResponseDataSetAdapterChannelList: TRESTResponseDataSetAdapter
    Dataset = DreamFDMemTableChannelList
    FieldDefs = <>
    Response = DreamRESTResponseChannelList
    OnBeforeOpenDataSet = DreamRESTResponseDataSetAdapterChannelListBeforeOpenDataSet
    RootElement = 'services'
    Left = 328
    Top = 248
  end
  object DreamHTTPBasicAuthenticator: THTTPBasicAuthenticator
    Username = 'root'
    Password = 'tsukubakek'
    Left = 320
    Top = 40
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
    Left = 328
    Top = 320
  end
  object DreamRESTRequestServiceList: TRESTRequest
    Client = DreamRESTClient
    Params = <>
    Resource = 'getservices'
    Response = DreamRESTResponseServiceList
    Timeout = 4000
    Left = 72
    Top = 104
  end
  object DreamRESTResponseServiceList: TRESTResponse
    Left = 72
    Top = 168
  end
  object DreamRESTResponseDataSetAdapterServiceList: TRESTResponseDataSetAdapter
    Dataset = DreamFDMemTableServiceList
    FieldDefs = <>
    Response = DreamRESTResponseServiceList
    OnBeforeOpenDataSet = DreamRESTResponseDataSetAdapterServiceListBeforeOpenDataSet
    RootElement = 'services'
    Left = 72
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
    Left = 72
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
    Timeout = 5000
    Left = 608
    Top = 104
  end
  object DreamRESTResponseTextEPG: TRESTResponse
    Left = 608
    Top = 168
  end
  object DreamRESTResponseDataSetAdapterTextEPG: TRESTResponseDataSetAdapter
    Dataset = DreamFDMemTableTextEPG
    FieldDefs = <>
    Response = DreamRESTResponseTextEPG
    OnBeforeOpenDataSet = DreamRESTResponseDataSetAdapterTextEPGBeforeOpenDataSet
    RootElement = 'events'
    Left = 608
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
    Left = 608
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
    Timeout = 5000
    Left = 77
    Top = 392
  end
  object DreamRESTResponseAddTimer: TRESTResponse
    Left = 77
    Top = 456
  end
  object DreamRESTRequestTimerList: TRESTRequest
    Client = DreamRESTClient
    Params = <>
    Resource = 'timerlist'
    Response = DreamRESTResponseTimerList
    Timeout = 5000
    Left = 344
    Top = 459
  end
  object DreamRESTResponseTimerList: TRESTResponse
    Left = 336
    Top = 404
  end
  object DreamRESTResponseDataSetAdapterTimerList: TRESTResponseDataSetAdapter
    Active = True
    Dataset = DreamFDMemTableTimerList
    FieldDefs = <>
    Response = DreamRESTResponseTimerList
    OnBeforeOpenDataSet = DreamRESTResponseDataSetAdapterTimerListBeforeOpenDataSet
    RootElement = 'timers'
    Left = 496
    Top = 396
  end
  object DreamFDMemTableTimerList: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'begin'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'description'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'tags'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'firsttryprepare'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'toggledisabled'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'dontsave'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'backoff'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'disabled'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'asrefs'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'repeated'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'servicename'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'duration'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'dirname'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'realend'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'descriptionextended'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'name'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'startprepare'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'realbegin'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'end'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'eit'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'vpsplugin_overwrite'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'afterevent'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'justplay'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'serviceref'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'filename'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'toggledisabledimg'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'state'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'logentries'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'nextactivation'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'vpsplugin_time'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'cancelled'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'vpsplugin_enabled'
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
    Left = 496
    Top = 460
  end
  object DreamRESTRequestDeleteTimer: TRESTRequest
    Client = DreamRESTClient
    Params = <
      item
        name = 'sRef'
      end
      item
        name = 'begin'
      end
      item
        name = 'end'
      end>
    Resource = 'timerdelete'
    Response = DreamRESTResponseDeleteTimer
    Timeout = 5000
    Left = 197
    Top = 392
  end
  object DreamRESTResponseDeleteTimer: TRESTResponse
    Left = 197
    Top = 456
  end
end
