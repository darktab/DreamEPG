unit UDetailInitThread;

interface

uses
  System.Classes, UDataListView, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, System.UITypes,
  REST.Client, FMX.Dialogs, SysUtils, FMX.StdCtrls;

type
  TDetailInitThread = class(TThread)
  private
    { Private declarations }
    fExceptionMessage: string;

    fDetailRESTRequest: TRESTRequest;
    fMasterDataSet: TDataSet;
    fDetailDataListView: TDataListView;
    fDetailDataStringList: TStringList;

    fAniIndicator: TAniIndicator;

  protected
    procedure Execute; override;
  public
    property ExceptionMessage: string read fExceptionMessage;

    constructor Create(lAni: TAniIndicator; lMasterDataSet: TDataSet;
      lDetailDataStringList: TStringList; lDetailRESTRequest: TRESTRequest;
      lDetailDataListView: TDataListView; OnTerminate: TNotifyEvent);
    destructor Destroy; override;
    procedure ToSyncExecute;
  end;

implementation

uses UWorking, UMainTabbedForm;

{ TDetailInitThread }

destructor TDetailInitThread.Destroy;
begin

end;

constructor TDetailInitThread.Create(lAni: TAniIndicator;
  lMasterDataSet: TDataSet; lDetailDataStringList: TStringList;
  lDetailRESTRequest: TRESTRequest; lDetailDataListView: TDataListView;
  OnTerminate: TNotifyEvent);
begin
  inherited Create(false);

  fAniIndicator := lAni;
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
    fAniIndicator.Visible := false;
    // WorkingForm.WorkingMsg('Loading ...', false);
    MainTabbedForm.Show;
  except
    fAniIndicator.Visible := false;
    // WorkingForm.WorkingMsg('Loading ...', false);
    MainTabbedForm.Show;

    MessageDlg('No Data found!', System.UITypes.TMsgDlgType.mtInformation,
      [System.UITypes.TMsgDlgBtn.mbOK], 0);

  end;

end;

procedure TDetailInitThread.Execute;
begin
  { Place thread code here }
  try
    Synchronize(ToSyncExecute);
  except
    on Ex: Exception do
    begin

      fExceptionMessage := Ex.Message;

    end;
  end;
end;

end.
