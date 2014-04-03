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

    fMasterDetailLinkFieldName: String;

  public
    { Public declarations }
    procedure init(lMasterDataSet: TDataSet; lMasterDataFieldName: string;
      lMasterRESTRequest: TRESTRequest;
      lMasterRESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
      lDetailDataSet: TDataSet; lDetailDataFieldName: string;
      lDetailRESTRequest: TRESTRequest;
      lDetailRESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
      lMasterDetailLinkFieldName: String); overload;
    procedure init(lMasterDetailLinkFieldName: String); overload;
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
  lDetailRESTRequest: TRESTRequest;
  lDetailRESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
  lMasterDetailLinkFieldName: String);
begin
  fMasterDataSet := lMasterDataSet;
  TopDataComboBox.DataSet := fMasterDataSet;
  fMasterDataFieldName := lMasterDataFieldName;
  fMasterRESTRequest := lMasterRESTRequest;
  fMasterRESTResponseDataSetAdapter := lMasterRESTResponseDataSetAdapter;

  fDetailDataSet := lDetailDataSet;
  DataListView.DataSet := lDetailDataSet;
  fDetailDataFieldName := lDetailDataFieldName;
  fDetailRESTRequest := lDetailRESTRequest;
  fDetailRESTResponseDataSetAdapter := lDetailRESTResponseDataSetAdapter;

  init(lMasterDetailLinkFieldName);
end;

procedure TDataComboListViewFrame.init(lMasterDetailLinkFieldName: String);
var
  Field: TField;
  lDefaultServiceReference: String;
begin

  fMasterDetailLinkFieldName := lMasterDetailLinkFieldName;

  // fill the combobox with all the available services
  fMasterRESTResponseDataSetAdapter.FieldDefs.Clear;
  fMasterRESTRequest.Execute;

  TopDataComboBox.init;

  for Field in fMasterDataSet.Fields do
  begin
    if Field.FieldName = fMasterDetailLinkFieldName then
    begin
      lDefaultServiceReference := fMasterDataSet.FieldByName
        (Field.FieldName).AsString;
    end;
  end;

  fDetailRESTResponseDataSetAdapter.FieldDefs.Clear;

  // sRef parameter
  fDetailRESTRequest.Params[0].Value := lDefaultServiceReference;

  fDetailRESTRequest.Execute;

  DataListView.init;

end;

procedure TDataComboListViewFrame.TopNextButtonClick(Sender: TObject);
begin
  if TopDataComboBox.Items.Count > 1 then
  begin

    try
      TopDataComboBox.ItemIndex := TopDataComboBox.ItemIndex + 1;
    finally

    end;

  end;
end;

procedure TDataComboListViewFrame.TopPrevButtonClick(Sender: TObject);
begin
  if TopDataComboBox.Items.Count > 1 then
  begin

    try
      TopDataComboBox.ItemIndex := TopDataComboBox.ItemIndex - 1;
    finally

    end;

  end;
end;

end.
