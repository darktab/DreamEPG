unit UMainTabbedForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UMainForm, FMX.TabControl, FMX.Layouts, FMX.Memo, FMX.ListView.Types,
  FMX.ListView, Data.DB, FMX.ListBox, UDataComboListViewFrame;

type
  TMainTabbedForm = class(TMainForm)
    MainTabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    DataComboListViewFrameChannelList: TDataComboListViewFrame;
    procedure FormShow(Sender: TObject);
    procedure ComboBoxServiceListChange(Sender: TObject);
  private
    function initServiceList: String;
    procedure initChannelList(DefaultServiceReference: String);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainTabbedForm: TMainTabbedForm;

implementation

uses
  UMainDataModule;

{$R *.fmx}

procedure TMainTabbedForm.ComboBoxServiceListChange(Sender: TObject);
begin
  inherited;
  // initChannelListView();
end;

procedure TMainTabbedForm.FormShow(Sender: TObject);
var
  lDefaultServiceReference: string;
begin
  inherited;
  // initialisation Comboboxservicelist
  lDefaultServiceReference := initServiceList;
  // initialisation channellistview
  initChannelList(lDefaultServiceReference);

  self.DataComboListViewFrameChannelList.init
    (MainDataModule.DreamFDMemTableServiceList, 'servicename',
    MainDataModule.DreamFDMemTableChannelList, 'servicename',
    'servicereference');
end;

function TMainTabbedForm.initServiceList: String;
var
  Field: TField;
begin
  // fill the combobox with all the available services
  MainDataModule.DreamRESTResponseDataSetAdapterServiceList.FieldDefs.Clear;
  MainDataModule.DreamRESTRequestServiceList.Execute;

  for Field in MainDataModule.DreamFDMemTableServiceList.Fields do
  begin
    if Field.FieldName = 'servicereference' then
    begin
      Result := MainDataModule.DreamFDMemTableServiceList.FieldByName
        (Field.FieldName).AsString;
    end;
  end;
end;

procedure TMainTabbedForm.initChannelList(DefaultServiceReference: String);
var
  item: TListViewItem;
  Field: TField;
begin
  // fill the list with all channel names
  MainDataModule.DreamRESTResponseDataSetAdapterChannelList.FieldDefs.Clear;

  // sRef parameter
  MainDataModule.DreamRESTRequestChannelList.Params[0].Value :=
    DefaultServiceReference;

  MainDataModule.DreamRESTRequestChannelList.Execute;

end;

end.
