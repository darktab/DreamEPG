unit UDataListViewFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView, UDataListView, DBXJSON;

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
  public
    { Public declarations }
    procedure initDataListView;
  end;

implementation

{$R *.fmx}

uses UMainDataModule;

procedure TDataListViewFrame.DataListViewDeleteChangeVisible(Sender: TObject;
  AValue: Boolean);
begin
  if (DataListView.ItemCount = 0) then
  begin
    DataListView.EditMode := False;
    if DeleteSpeedButton.IsPressed then
    begin
      DeleteSpeedButton.IsPressed := False;
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
    MainDataModule.DreamFDMemTableTimerList.RecNo := DataListView.ItemIndex + 1;
  except

  end;
  MainDataModule.DreamRESTRequestDeleteTimer.Params[0].Value :=
    MainDataModule.DreamFDMemTableTimerList.FieldByName('serviceref').AsString;
  MainDataModule.DreamRESTRequestDeleteTimer.Params[1].Value :=
    MainDataModule.DreamFDMemTableTimerList.FieldByName('begin').AsString;
  MainDataModule.DreamRESTRequestDeleteTimer.Params[2].Value :=
    MainDataModule.DreamFDMemTableTimerList.FieldByName('end').AsString;
  try
    MainDataModule.DreamRESTRequestDeleteTimer.Execute;
  except
    MessageDlg('Can''t find your decoder! Please check your settings!',
      System.UITypes.TMsgDlgType.mtError, [System.UITypes.TMsgDlgBtn.mbOK], 0);
    exit;
  end;

  if MainDataModule.DreamRESTResponseDeleteTimer.StatusCode = 200 then
  begin
    lJSONObject := TJSONObject.ParseJSONValue
      (MainDataModule.DreamRESTResponseDeleteTimer.Content) as TJSONObject;
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
    MessageDlg('The following error occurred: ' +
      MainDataModule.DreamRESTResponseAddTimer.StatusText,
      System.UITypes.TMsgDlgType.mtError, [System.UITypes.TMsgDlgBtn.mbOK], 0);
    ACanDelete := False;
  end;
end;

procedure TDataListViewFrame.initDataListView;
var
  lTimersDetailStringlist: TStringList;
begin
  // initialisation des timers
  try
    MainDataModule.DreamRESTRequestTimerList.Execute;
  except
    exit;
  end;
  DataListView.DataSet := MainDataModule.DreamFDMemTableTimerList;
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
  DataListView.EditMode := not DataListView.EditMode;
end;

end.
