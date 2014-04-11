unit UDetailInitThread;

interface

uses
  System.Classes, UDataListView, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter,
  REST.Client, FMX.Dialogs;

type
  TDetailInitThread = class(TThread)
  private
    { Private declarations }
    fDetailRESTRequest: TRESTRequest;
    fMasterDataSet: TDataSet;
    fDetailDataListView: TDataListView;
    fDetailDataStringList: TStringList;

  protected
    procedure Execute; override;
  public
    constructor Create(lMasterDataSet: TDataSet;
      lDetailDataStringList: TStringList; lDetailRESTRequest: TRESTRequest;
      lDetailDataListView: TDataListView; OnTerminate: TNotifyEvent);
    destructor Destroy; override;
    procedure ToSyncExecute;
  end;

implementation

{ TDetailInitThread }

destructor TDetailInitThread.Destroy;
begin

end;

constructor TDetailInitThread.Create(lMasterDataSet: TDataSet;
  lDetailDataStringList: TStringList; lDetailRESTRequest: TRESTRequest;
  lDetailDataListView: TDataListView; OnTerminate: TNotifyEvent);
begin
  inherited Create(false);
  fDetailRESTRequest := lDetailRESTRequest;
  fMasterDataSet := lMasterDataSet;
  fDetailDataStringList := lDetailDataStringList;
  fDetailDataListView := lDetailDataListView;

  // Save the termination event handler.
  Self.OnTerminate := OnTerminate;
  // The thread will free itself when it terminates.
  FreeOnTerminate := True;
end;

procedure TDetailInitThread.ToSyncExecute;
begin
  try
    fDetailRESTRequest.Execute;
  except
    if fMasterDataSet.State = dsBrowse then
    begin
      fMasterDataSet.Close;
    end;
    fDetailRESTRequest.Execute;
  end;

  if assigned(fDetailDataStringList) then
  begin
    fDetailDataListView.init(fDetailDataStringList)
  end
  else
  begin
    fDetailDataListView.init;
  end;
end;

procedure TDetailInitThread.Execute;
begin
  { Place thread code here }
  Synchronize(ToSyncExecute);
end;

end.
