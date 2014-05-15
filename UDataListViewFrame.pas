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
  private
    { Private declarations }
    fDataSet: TDataSet;
    fRESTRequestList: TRESTRequest;
    fRESTRequestDelete: TRESTRequest;
    fRESTResponseDelete: TRESTResponse;
    fRESTResponseAdd: TRESTResponse;

    procedure initDataListView;
  public
    { Public declarations }
    procedure init(lDataSet: TDataSet; lRESTRequestList: TRESTRequest;
      lRESTRequestDelete: TRESTRequest; lRESTResponseDelete: TRESTResponse;
      lRESTResponseAdd: TRESTResponse);
  end;

implementation

{$R *.fmx}

procedure TDataListViewFrame.init(lDataSet: TDataSet;
  lRESTRequestList: TRESTRequest; lRESTRequestDelete: TRESTRequest;
  lRESTResponseDelete: TRESTResponse; lRESTResponseAdd: TRESTResponse);
begin
  fDataSet := lDataSet;
  fRESTRequestList := lRESTRequestList;
  fRESTRequestDelete := lRESTRequestDelete;
  fRESTResponseDelete := lRESTResponseDelete;
  fRESTResponseAdd := lRESTResponseAdd;

  initDataListView;
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
  fRESTRequestDelete.Params[0].Value :=
    fDataSet.FieldByName('serviceref').AsString;
  fRESTRequestDelete.Params[1].Value := fDataSet.FieldByName('begin').AsString;
  fRESTRequestDelete.Params[2].Value := fDataSet.FieldByName('end').AsString;
  try
    fRESTRequestDelete.Execute;
  except
    MessageDlg('Can''t find your decoder! Please check your settings!',
      System.UITypes.TMsgDlgType.mtError, [System.UITypes.TMsgDlgBtn.mbOK], 0);
    exit;
  end;

  if fRESTResponseDelete.StatusCode = 200 then
  begin
    lJSONObject := TJSONObject.ParseJSONValue(fRESTResponseDelete.Content)
      as TJSONObject;
    if (lJSONObject.Get(1).JsonValue is TJSONTrue) then
    begin
      MessageDlg(lJSONObject.Get(0).JsonValue.Value,
        System.UITypes.TMsgDlgType.mtInformation,
        [System.UITypes.TMsgDlgBtn.mbOK], 0);
      ACanDelete := True;
    end
    else
    begin
      MessageDlg('Timer could not be deleted!',
        System.UITypes.TMsgDlgType.mtError,
        [System.UITypes.TMsgDlgBtn.mbOK], 0);
      ACanDelete := False;
    end;
  end
  else
  begin
    MessageDlg('The following error occurred: ' + fRESTResponseAdd.StatusText,
      System.UITypes.TMsgDlgType.mtError, [System.UITypes.TMsgDlgBtn.mbOK], 0);
    ACanDelete := False;
  end;
end;

procedure TDataListViewFrame.initDataListView;
var
  lTimersDetailStringlist: TStringList;
begin
  // spinner on
  DataListView.Enabled := False;
  RefreshSpeedButton.Visible := False;
  DataAniIndicator.Visible := True;
  DataAniIndicator.Enabled := True;
  // initialisation des timers
  try
    fRESTRequestList.Execute;
  except
    exit;
  end;
  DataListView.DataSet := fDataSet;
  DataListView.DataFieldName := 'name';
  lTimersDetailStringlist := TStringList.Create;
  lTimersDetailStringlist.Add('servicename');
  lTimersDetailStringlist.Add('realbegin');
  try
    DataListView.init(lTimersDetailStringlist);
  except
    FreeAndNil(lTimersDetailStringlist);
  end;
  FreeAndNil(lTimersDetailStringlist);

  // spinner off
  DataAniIndicator.Visible := False;
  DataAniIndicator.Enabled := False;
  DataListView.Enabled := True;
  RefreshSpeedButton.Visible := True;

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
