unit UDataComboListViewFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, UDataComboBox, FMX.ListView.Types, FMX.ListView, UDataListView,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter,
  REST.Client;

type
  TDataComboListViewFrame = class(TFrame)
    TopToolBar: TToolBar;
    TopPrevButton: TButton;
    TopNextButton: TButton;
    TopDataComboBox: TDataComboBox;
    DataListView: TDataListView;
    procedure TopPrevButtonClick(Sender: TObject);
    procedure TopNextButtonClick(Sender: TObject);
    procedure TopDataComboBoxChange(Sender: TObject);
    procedure DataListViewItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure DataListViewButtonClick(const Sender: TObject;
      const AItem: TListViewItem; const AObject: TListItemSimpleControl);
  private
    { Private declarations }
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
    procedure initTopDataComboBox;

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
    procedure initDataListView;
    Constructor Create(AOwner: TComponent); override;

  published
    { Published declarations }
    Property MasterDetailLinkFieldName: String read fMasterDetailLinkFieldName
      write fMasterDetailLinkFieldName;
  end;

implementation

{$R *.fmx}

constructor TDataComboListViewFrame.Create(AOwner: TComponent);
begin
  // Execute the parent (TObject) constructor first
  inherited; // Call the parent Create method

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
  Field: TField;
  lDefaultServiceReference: String;
begin
  for Field in fMasterDataSet.Fields do
  begin
    if Field.FieldName = fMasterDetailLinkFieldName then
    begin
      lDefaultServiceReference := fMasterDataSet.FieldByName
        (Field.FieldName).AsString;
    end;
  end;

  if fDetailDataSet.Active then
  begin
    fDetailRESTResponseDataSetAdapter.ClearDataSet;
    fDetailRESTResponseDataSetAdapter.Active := false;
    fDetailDataSet.Close;
  end;

  fDetailRESTResponseDataSetAdapter.FieldDefs.Clear;

  // sRef parameter
  fDetailRESTRequest.Params[0].Value := lDefaultServiceReference;

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

end;

procedure TDataComboListViewFrame.init(lMasterDetailLinkFieldName: String);
begin

  fMasterDetailLinkFieldName := lMasterDetailLinkFieldName;

  initTopDataComboBox;
  initDataListView;
end;

procedure TDataComboListViewFrame.TopDataComboBoxChange(Sender: TObject);
begin
  fMasterDataSet.RecNo := TopDataComboBox.ItemIndex + 1;
  try
    initDataListView;
  except

  end;

end;

procedure TDataComboListViewFrame.TopNextButtonClick(Sender: TObject);
begin
  if TopDataComboBox.Items.Count > 1 then
  begin

    try
      TopDataComboBox.ItemIndex := TopDataComboBox.ItemIndex + 1;
    except

    end;

  end;
end;

procedure TDataComboListViewFrame.TopPrevButtonClick(Sender: TObject);
begin
  if TopDataComboBox.Items.Count > 1 then
  begin

    try
      TopDataComboBox.ItemIndex := TopDataComboBox.ItemIndex - 1;
    except

    end;

  end;
end;

end.
