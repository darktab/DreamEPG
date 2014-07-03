unit UDataComboListViewFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, UDataComboBox, FMX.ListView.Types, FMX.ListView, UDataListView,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter,
  REST.Client, UDetailInitThread, FMX.Objects;

type
  TDataComboListViewFrame = class(TFrame)
    TopToolBar: TToolBar;
    TopPrevButton: TButton;
    TopNextButton: TButton;
    TopDataComboBox: TDataComboBox;
    DataListView: TDataListView;
    TopMasterToolBar: TToolBar;
    TopMasterLabel: TLabel;
    DataAniIndicator: TAniIndicator;
    procedure TopPrevButtonClick(Sender: TObject);
    procedure TopNextButtonClick(Sender: TObject);
    procedure TopDataComboBoxChange(Sender: TObject);
    procedure DataListViewItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure DataListViewButtonClick(const Sender: TObject;
      const AItem: TListViewItem; const AObject: TListItemSimpleControl);
    procedure DoneInitDetail(Sender: TObject); virtual;
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    fNoDataFoundToggle: Boolean;

    fMasterDataSet: TDataSet;
    fMasterDataFieldName: String;
    fMasterRESTRequest: TRESTRequest;
    fMasterRESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;

    fDetailDataSet: TDataSet;
    fDetailDataFieldName: String;
    fDetailRESTRequest: TRESTRequest;
    fDetailRESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;

    fDetailDataStringList: TStringList;

    fMasterDetailLinkFieldName: String;

    // fWorkingForm: TWorkingForm;
    fDetailInitThread: TDetailInitThread;
    procedure stopSpinner;
    procedure startSpinner;

  public
    { Public declarations }
    procedure init(lMasterDataSet: TDataSet; lMasterDataFieldName: string;
      lMasterRESTRequest: TRESTRequest;
      lMasterRESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
      lDetailDataSet: TDataSet; lDetailDataFieldName: string;
      lDetailDataStringList: TStringList; lDetailRESTRequest: TRESTRequest;
      lDetailRESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
      lMasterDetailLinkFieldName: String); overload;
    procedure init(lMasterDataSet: TDataSet; lMasterDataFieldName: string;
      lMasterRESTRequest: TRESTRequest;
      lMasterRESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
      lDetailDataSet: TDataSet; lDetailDataFieldName: string;
      lDetailRESTRequest: TRESTRequest;
      lDetailRESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
      lMasterDetailLinkFieldName: String); overload;
    procedure init(lMasterDetailLinkFieldName: String); overload;
    procedure initDataListView; virtual;
    procedure initTopDataComboBox;
    Constructor Create(AOwner: TComponent); override;

  published
    { Published declarations }
    Property MasterDetailLinkFieldName: String read fMasterDetailLinkFieldName
      write fMasterDetailLinkFieldName;
  end;

implementation

uses
  UWorking;
{$R *.fmx}

constructor TDataComboListViewFrame.Create(AOwner: TComponent);
begin
  // Execute the parent (TObject) constructor first
  inherited; // Call the parent Create method

  // if not Assigned(WorkingForm) then
  // begin
  // WorkingForm := TWorkingForm.Create(self);
  // WorkingForm.Parent := self;
  // end;
end;

procedure TDataComboListViewFrame.startSpinner;
begin
  // Call the working spinner
  DataListView.Enabled := false;
  DataAniIndicator.Visible := true;
  DataAniIndicator.Enabled := true;
end;

procedure TDataComboListViewFrame.stopSpinner;
begin
  DataAniIndicator.Visible := false;
  DataAniIndicator.Enabled := false;
  DataListView.Enabled := true;
end;

procedure TDataComboListViewFrame.DoneInitDetail(Sender: TObject);
begin
  // For some nebulous reason this is triggered twice
  // which we do not want
  fNoDataFoundToggle := not fNoDataFoundToggle;
  if (fDetailInitThread.ExceptionMessage <> '') and fNoDataFoundToggle then
  begin
    MessageDlg('No Data found!', System.UITypes.TMsgDlgType.mtInformation,
      [System.UITypes.TMsgDlgBtn.mbOK], 0);
  end;

  // fDetailInitThread := nil;
  // WorkingForm.WorkingMsg('Loading ...', false);

  self.Show;
end;

// --------------------------------------------------
// To ensure the Working spinner is always centered
// --------------------------------------------------
procedure TDataComboListViewFrame.FrameResize(Sender: TObject);
begin
  // if Assigned(WorkingForm) then
  // begin
  // FreeAndNil(WorkingForm);
  // WorkingForm := TWorkingForm.Create(self);
  // WorkingForm.Parent := self;
  // end;
end;

procedure TDataComboListViewFrame.init(lMasterDataSet: TDataSet;
  lMasterDataFieldName: string; lMasterRESTRequest: TRESTRequest;
  lMasterRESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
  lDetailDataSet: TDataSet; lDetailDataFieldName: string;
  lDetailDataStringList: TStringList; lDetailRESTRequest: TRESTRequest;
  lDetailRESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
  lMasterDetailLinkFieldName: String);
begin
  fDetailDataStringList := lDetailDataStringList;

  init(lMasterDataSet, lMasterDataFieldName, lMasterRESTRequest,
    lMasterRESTResponseDataSetAdapter, lDetailDataSet, lDetailDataFieldName,
    lDetailRESTRequest, lDetailRESTResponseDataSetAdapter,
    lMasterDetailLinkFieldName);
end;

procedure TDataComboListViewFrame.init(lMasterDataSet: TDataSet;
  lMasterDataFieldName: string; lMasterRESTRequest: TRESTRequest;
  lMasterRESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
  lDetailDataSet: TDataSet; lDetailDataFieldName: string;
  lDetailRESTRequest: TRESTRequest;
  lDetailRESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
  lMasterDetailLinkFieldName: String);
begin
  fMasterDataSet := lMasterDataSet;
  TopDataComboBox.DataSet := fMasterDataSet;
  fMasterDataFieldName := lMasterDataFieldName;
  TopDataComboBox.DataFieldName := lMasterDataFieldName;
  fMasterRESTRequest := lMasterRESTRequest;
  fMasterRESTResponseDataSetAdapter := lMasterRESTResponseDataSetAdapter;

  fDetailDataSet := lDetailDataSet;
  DataListView.DataSet := lDetailDataSet;
  fDetailDataFieldName := lDetailDataFieldName;
  DataListView.DataFieldName := lDetailDataFieldName;
  fDetailRESTRequest := lDetailRESTRequest;
  fDetailRESTResponseDataSetAdapter := lDetailRESTResponseDataSetAdapter;

  init(lMasterDetailLinkFieldName);
end;

// -----------------------------------
// Sync Dataset with itemnumber
// -----------------------------------
procedure TDataComboListViewFrame.DataListViewButtonClick(const Sender: TObject;
  const AItem: TListViewItem; const AObject: TListItemSimpleControl);
begin
  fDetailDataSet.RecNo := DataListView.ItemIndex + 1;
end;

procedure TDataComboListViewFrame.DataListViewItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  fDetailDataSet.RecNo := DataListView.ItemIndex + 1;
end;

procedure TDataComboListViewFrame.initTopDataComboBox;
var
  lidx: integer;
begin
  if not fMasterDataSet.Active then
  begin
    fMasterRESTResponseDataSetAdapter.FieldDefs.Clear;
    fMasterRESTRequest.Execute;
    TopDataComboBox.init;
  end
  else
  begin
    lidx := fMasterDataSet.RecNo;
    // speed optimisation
    if TopDataComboBox.Items.Count = 0 then
    begin
      TopDataComboBox.init;
    end;
    fMasterDataSet.RecNo := lidx;
    TopDataComboBox.ItemIndex := lidx - 1;
  end;

  if TopDataComboBox.Items.Count > 1 then
  begin
    TopPrevButton.Visible := true;
    TopNextButton.Visible := true;
  end
  else
  begin
    TopPrevButton.Visible := false;
    TopNextButton.Visible := false;
  end;

end;

procedure TDataComboListViewFrame.initDataListView;
var
  lDefaultServiceReference: String;
begin

  lDefaultServiceReference := fMasterDataSet.FieldByName
    (fMasterDetailLinkFieldName).AsString;

  if fDetailDataSet.Active then
  begin
    fDetailRESTResponseDataSetAdapter.ClearDataSet;
    fDetailRESTResponseDataSetAdapter.Active := false;
    fDetailDataSet.Close;
  end;

  fDetailRESTResponseDataSetAdapter.FieldDefs.Clear;

  // sRef parameter
  fDetailRESTRequest.Params[0].Value := lDefaultServiceReference;

  // start the spinner
  startSpinner;
  // WorkingForm.WorkingMsg('Loading ...', true);
  Application.ProcessMessages;
  // fDetailInitThread := TDetailInitThread.Create(DataAniIndicator,
  // fMasterDataSet, fDetailDataStringList, fDetailRESTRequest, DataListView,
  // DoneInitDetail);
  // fDetailInitThread.OnTerminate := DoneInitDetail;
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
      DataListView.init(fDetailDataStringList);
    end
    else
    begin
      DataListView.init;
    end;
  except

    // stop the spinner
    stopSpinner;

    MessageDlg('No Data found!', System.UITypes.TMsgDlgType.mtInformation,
      [System.UITypes.TMsgDlgBtn.mbOK], 0);

  end;
  // stop the spinner
  stopSpinner;

end;

procedure TDataComboListViewFrame.init(lMasterDetailLinkFieldName: String);
begin

  fMasterDetailLinkFieldName := lMasterDetailLinkFieldName;

  initTopDataComboBox;
  // initDataListView;
end;

procedure TDataComboListViewFrame.TopDataComboBoxChange(Sender: TObject);
begin
  fMasterDataSet.RecNo := TopDataComboBox.ItemIndex + 1;

  TopNextButton.Enabled :=
    not(TopDataComboBox.ItemIndex = (TopDataComboBox.Items.Count - 1));
  TopPrevButton.Enabled := not(TopDataComboBox.ItemIndex = 0);

  try
    initDataListView;
  except

  end;

end;

procedure TDataComboListViewFrame.TopNextButtonClick(Sender: TObject);
begin
  if TopDataComboBox.Items.Count > 1 then
  begin
    TopDataComboBox.ItemIndex := TopDataComboBox.ItemIndex + 1;
  end;
end;

procedure TDataComboListViewFrame.TopPrevButtonClick(Sender: TObject);
begin
  if TopDataComboBox.Items.Count > 1 then
  begin
    TopDataComboBox.ItemIndex := TopDataComboBox.ItemIndex - 1;
  end;
end;

end.
