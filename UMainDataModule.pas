unit UMainDataModule;

interface

uses
  System.SysUtils, System.Classes, IPPeerClient, REST.Response.Adapter,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  REST.Authenticator.Basic, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TMainDataModule = class(TDataModule)
    DreamRESTClient: TRESTClient;
    DreamRESTRequestChannelList: TRESTRequest;
    DreamRESTResponseChannelList: TRESTResponse;
    DreamRESTResponseDataSetAdapterChannelList: TRESTResponseDataSetAdapter;
    DreamHTTPBasicAuthenticator: THTTPBasicAuthenticator;
    DreamFDMemTableChannelList: TFDMemTable;
    DreamRESTRequestServiceList: TRESTRequest;
    DreamRESTResponseServiceList: TRESTResponse;
    DreamRESTResponseDataSetAdapterServiceList: TRESTResponseDataSetAdapter;
    DreamFDMemTableServiceList: TFDMemTable;
    DreamRESTRequestTextEPG: TRESTRequest;
    DreamRESTResponseTextEPG: TRESTResponse;
    DreamRESTResponseDataSetAdapterTextEPG: TRESTResponseDataSetAdapter;
    DreamFDMemTableTextEPG: TFDMemTable;
    procedure DreamRESTResponseDataSetAdapterChannelListBeforeOpenDataSet
      (Sender: TObject);
    procedure DreamRESTResponseDataSetAdapterServiceListBeforeOpenDataSet
      (Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainDataModule: TMainDataModule;

implementation

{ %CLASSGROUP 'FMX.Controls.TControl' }

{$R *.dfm}

procedure TMainDataModule.
  DreamRESTResponseDataSetAdapterChannelListBeforeOpenDataSet(Sender: TObject);
begin
  self.DreamFDMemTableChannelList.CreateDataSet;
end;

procedure TMainDataModule.
  DreamRESTResponseDataSetAdapterServiceListBeforeOpenDataSet(Sender: TObject);
begin
  self.DreamFDMemTableServiceList.CreateDataSet;
end;

end.
