unit UDataComboListViewFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, UDataComboBox, FMX.ListView.Types, FMX.ListView, UDataListView,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

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
    fDetailDataSet: TDataSet;
    fDetailDataFieldName: String;
    fMasterDetailLinkFieldName: String;

  public
    { Public declarations }
    procedure init(lMasterDataSet: TDataSet; lMasterDataFieldName: string;
      lDetailDataSet: TDataSet; lDetailDataFieldName: string;
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
  lMasterDataFieldName: string; lDetailDataSet: TDataSet;
  lDetailDataFieldName: string; lMasterDetailLinkFieldName: String);
begin
  fMasterDataSet := lMasterDataSet;
  TopDataComboBox.DataSet := fMasterDataSet;
  fMasterDataFieldName := lMasterDataFieldName;
  fDetailDataSet := lDetailDataSet;
  DataListView.DataSet := lDetailDataSet;
  fDetailDataFieldName := lDetailDataFieldName;

  init(lMasterDetailLinkFieldName);
end;

procedure TDataComboListViewFrame.init(lMasterDetailLinkFieldName: String);
var
  Field: TField;
  // lDefaultServiceReference: String;
begin

  fMasterDetailLinkFieldName := lMasterDetailLinkFieldName;
  TopDataComboBox.init;

  // for Field in fMasterDataSet.Fields do
  // begin
  // if Field.FieldName = fMasterDataFieldName then
  // begin
  // lDefaultServiceReference := fMasterDataSet.FieldByName
  // (Field.FieldName).AsString;
  // end;
  /// end;

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
