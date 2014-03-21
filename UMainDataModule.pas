unit UMainDataModule;

interface

uses
  System.SysUtils, System.Classes, IPPeerClient, REST.Response.Adapter,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  REST.Authenticator.Basic;

type
  TMainDataModule = class(TDataModule)
    DreamRESTClient: TRESTClient;
    DreamRESTRequestChannelList: TRESTRequest;
    DreamRESTResponseChannelList: TRESTResponse;
    DreamRESTResponseDataSetAdapterChannelList: TRESTResponseDataSetAdapter;
    DreamHTTPBasicAuthenticator: THTTPBasicAuthenticator;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  MainDataModule: TMainDataModule;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
