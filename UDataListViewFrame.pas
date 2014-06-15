unit UDataListViewFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView, UDataListView, DBXJSON, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter,
  REST.Client;

type
  TDataListViewFrame = class(TFrame)
    DataListView: TDataListView;
    TopToolBar: TToolBar;
    TopToolBarLabel: TLabel;
    RefreshSpeedButton: TSpeedButton;
    DeleteSpeedButton: TSpeedButton;
    DataAniIndicator: TAniIndicator;
    procedure DeleteSpeedButtonClick(Sender: TObject);
    procedure RefreshSpeedButtonClick(Sender: TObject);
    procedure DataListViewDeleteChangeVisible(Sender: TObject; AValue: Boolean);
    procedure DataListViewDeleteItem(Sender: TObject; AIndex: Integer);
    procedure DataListViewDeletingItem(Sender: TObject; AIndex: Integer;
      var ACanDelete: Boolean);
    procedure DataListViewItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Private declarations }
    fDataSet: TDataSet;
    fRESTRequestList: TRESTRequest;
    fRESTRequestDelete: TRESTRequest;
    fRESTResponseDelete: TRESTResponse;

    fDetailStringlist: TStringList;
    fDataFieldName: String;

    procedure initDataListView;
    procedure startSpinner;
    procedure stopSpinner;
  public
    { Public declarations }
    procedure init(lDataSet: TDataSet; lRESTRequestList: TRESTRequest;
      lRESTRequestDelete: TRESTRequest; lRESTResponseDelete: TRESTResponse;
      lDataFieldName: String; lDetailStringlist: TStringList);
  end;

implementation

{$R *.fmx}

procedure TDataListViewFrame.init(lDataSet: TDataSet;
  lRESTRequestList: TRESTRequest; lRESTRequestDelete: TRESTRequest;
  lRESTResponseDelete: TRESTResponse; lDataFieldName: String;
  lDetailStringlist: TStringList);
begin
  fDataSet := lDataSet;
  fRESTRequestList := lRESTRequestList;
  fRESTRequestDelete := lRESTRequestDelete;
  fRESTResponseDelete := lRESTResponseDelete;

  fDataFieldName := lDataFieldName;
  fDetailStringlist := lDetailStringlist;

  initDataListView;
end;

procedure TDataListViewFrame.stopSpinner;
begin
  // spinner off
  DataAniIndicator.Visible := False;
  DataAniIndicator.Enabled := False;
  DataListView.Enabled := True;
  RefreshSpeedButton.Visible := True;
end;

procedure TDataListViewFrame.startSpinner;
begin
  // spinner on
  DataListView.Enabled := False;
  RefreshSpeedButton.Visible := False;
  DataAniIndicator.Visible := True;
  DataAniIndicator.Enabled := True;
  Application.ProcessMessages;
end;

procedure TDataListViewFrame.DataListViewDeleteChangeVisible(Sender: TObject;
  AValue: Boolean);
begin
  if (DataListView.ItemCount = 0) then
  begin
    DataListView.EditMode := False;
    if DeleteSpeedButton.StyleLookup = 'donetoolbutton' then
    begin
      DeleteSpeedButton.StyleLookup := 'trashtoolbutton';
    end;
  end;

  // enable delete button only if more than 1 item in list
  DeleteSpeedButton.Enabled := (DataListView.ItemCount <> 0);

  // Stop the spinner
  stopSpinner;
end;

procedure TDataListViewFrame.DataListViewDeleteItem(Sender: TObject;
  AIndex: Integer);
begin
  // il faut réinitialiser la timerlist pour éviter
  // des désynchronisations entre la listview et le dataset
  try
    if AIndex < DataListView.ItemCount then
    begin
      initDataListView;
    end;
  except

  end;
end;

procedure TDataListViewFrame.DataListViewDeletingItem(Sender: TObject;
  AIndex: Integer; var ACanDelete: Boolean);
var
  lJSONObject: TJSONObject;
  lJSONPair: TJSONPair;
begin
  inherited;
  try
    fDataSet.RecNo := DataListView.ItemIndex + 1;
  except

  end;

  // start the spinner
  startSpinner;

  // ShowMessage(UTF8ToWideString(fDataSet.FieldByName('serviceref').AsString));
  // Exit;
  // fRESTRequestDelete.Params[0].Value := UTF8EncodeToShortString
  // (fDataSet.FieldByName('serviceref').AsString);
  fRESTRequestDelete.Params[0].Value := UTF8EncodeToShortString
    (fDataSet.FieldByName('serviceref').AsString);

  if (fRESTRequestDelete.Params.Count = 3) then
  begin
    fRESTRequestDelete.Params[1].Value := fDataSet.FieldByName('begin')
      .AsString;
    fRESTRequestDelete.Params[2].Value := fDataSet.FieldByName('end').AsString;
  end;
  try
    fRESTRequestDelete.Execute;
  except
    // stop the spinner
    stopSpinner;

    MessageDlg('Event could not be deleted!' + CHR(13) +
      'Please delete on decoder!', System.UITypes.TMsgDlgType.mtError,
      [System.UITypes.TMsgDlgBtn.mbOK], 0);
  end;

  if fRESTResponseDelete.StatusCode = 200 then
  begin
    lJSONObject := TJSONObject.ParseJSONValue(fRESTResponseDelete.Content)
      as TJSONObject;
    if (lJSONObject.Get(1).JsonValue is TJSONTrue) then
    begin
      // stop the spinner
      stopSpinner;

      MessageDlg(lJSONObject.Get(0).JsonValue.Value,
        System.UITypes.TMsgDlgType.mtInformation,
        [System.UITypes.TMsgDlgBtn.mbOK], 0);
      ACanDelete := True;
    end
    else
    begin
      // stop the spinner
      stopSpinner;

      MessageDlg('Event could not be deleted!',
        System.UITypes.TMsgDlgType.mtError,
        [System.UITypes.TMsgDlgBtn.mbOK], 0);
      ACanDelete := False;
    end;
  end
  else
  begin
    // stop the spinner
    stopSpinner;

    // MessageDlg('The following error occurred: ' +
    // fRESTResponseDelete.StatusText, System.UITypes.TMsgDlgType.mtError,
    // [System.UITypes.TMsgDlgBtn.mbOK], 0);
    ACanDelete := False;
  end;
end;

procedure TDataListViewFrame.DataListViewItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  fDataSet.RecNo := DataListView.ItemIndex + 1;
end;

procedure TDataListViewFrame.initDataListView;
begin
  // start the spinner
  startSpinner;
  // initialisation des timers
  try
    fRESTRequestList.Execute;
  except
    Exit;
  end;
  DataListView.DataSet := fDataSet;
  DataListView.DataFieldName := fDataFieldName;

  try
    DataListView.init(fDetailStringlist);
  except
    FreeAndNil(fDetailStringlist);
  end;

  // stop the spinner
  stopSpinner;

  // enable delete button only if more than 1 item in list
  DeleteSpeedButton.Enabled := (DataListView.ItemCount <> 0);
end;

procedure TDataListViewFrame.RefreshSpeedButtonClick(Sender: TObject);
begin
  inherited;
  initDataListView;
end;

procedure TDataListViewFrame.DeleteSpeedButtonClick(Sender: TObject);
begin
  inherited;
  if DeleteSpeedButton.StyleLookup = 'trashtoolbutton' then
  begin
    DeleteSpeedButton.StyleLookup := 'donetoolbutton';
    DeleteSpeedButton.Width := 60;
  end
  else
  begin
    DeleteSpeedButton.StyleLookup := 'trashtoolbutton';
    DeleteSpeedButton.Width := 44;
  end;
  DataListView.EditMode := not DataListView.EditMode;
end;

end.
