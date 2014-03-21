object MainDataModule: TMainDataModule
  OldCreateOrder = False
  Height = 290
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
    Params = <>
    Resource = 'about'
    Response = DreamRESTResponseChannelList
    Left = 128
    Top = 96
  end
  object DreamRESTResponseChannelList: TRESTResponse
    Left = 128
    Top = 160
  end
  object DreamRESTResponseDataSetAdapterChannelList: TRESTResponseDataSetAdapter
    FieldDefs = <>
    Left = 128
    Top = 224
  end
  object DreamHTTPBasicAuthenticator: THTTPBasicAuthenticator
    Username = 'root'
    Password = 'tsukubakek'
    Left = 320
    Top = 24
  end
end
