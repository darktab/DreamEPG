unit UMainTabbedForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UMainForm, FMX.TabControl, FMX.Layouts, FMX.Memo, FMX.ListView.Types,
  FMX.ListView, Data.DB, FMX.ListBox;

type
  TMainTabbedForm = class(TMainForm)
    MainTabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    ChannelListView: TListView;
    ComboBoxServiceList: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure ComboBoxServiceListChange(Sender: TObject);
  private
    function initComboBoxServiceList: String;
    procedure initChannelListView(DefaultServiceReference: String);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainTabbedForm: TMainTabbedForm;

implementation

{$R *.fmx}

procedure TMainTabbedForm.ComboBoxServiceListChange(Sender: TObject);
begin
  inherited;
  // initChannelListView();
end;

procedure TMainTabbedForm.FormShow(Sender: TObject);
var
  DefaultServiceReference: String;
begin
  inherited;
  // initialisation Comboboxservicelist
  DefaultServiceReference := initComboBoxServiceList;
  // initialisation channellistview
  initChannelListView(DefaultServiceReference);
end;

function TMainTabbedForm.initComboBoxServiceList: String;
var
  Field: TField;
begin
  // fill the combobox with all the available services
  self.MainDataModule.DreamRESTResponseDataSetAdapterServiceList.
    FieldDefs.Clear;
  self.MainDataModule.DreamRESTRequestServiceList.Execute;
  ComboBoxServiceList.Clear;
  if not self.MainDataModule.DreamFDMemTableServiceList.Active then
    self.MainDataModule.DreamFDMemTableServiceList.Open;
  self.MainDataModule.DreamFDMemTableServiceList.First;
  while not self.MainDataModule.DreamFDMemTableServiceList.EOF do
  begin
    for Field in self.MainDataModule.DreamFDMemTableServiceList.Fields do
    begin
      if Field.FieldName = 'servicename' then
      begin
        ComboBoxServiceList.Items.Add
          (self.MainDataModule.DreamFDMemTableServiceList.FieldByName
          (Field.FieldName).AsString);
      end;
    end;
    self.MainDataModule.DreamFDMemTableServiceList.Next;
  end;

  // on se positionne sur le premier bouquet
  // et on retourne la référence
  ComboBoxServiceList.ItemIndex := 0;
  self.MainDataModule.DreamFDMemTableServiceList.First;
  for Field in self.MainDataModule.DreamFDMemTableServiceList.Fields do
  begin
    if Field.FieldName = 'servicereference' then
    begin
      Result := self.MainDataModule.DreamFDMemTableServiceList.FieldByName
        (Field.FieldName).AsString;
    end;
  end;
end;

procedure TMainTabbedForm.initChannelListView(DefaultServiceReference: String);
var
  item: TListViewItem;
  Field: TField;
begin
  // fill the list with all channel names
  self.MainDataModule.DreamRESTResponseDataSetAdapterChannelList.
    FieldDefs.Clear;

  // sRef parameter
  self.MainDataModule.DreamRESTRequestChannelList.Params[0].Value :=
    DefaultServiceReference;

  self.MainDataModule.DreamRESTRequestChannelList.Execute;

  ChannelListView.ClearItems;
  if not self.MainDataModule.DreamFDMemTableChannelList.Active then
    self.MainDataModule.DreamFDMemTableChannelList.Open;
  self.MainDataModule.DreamFDMemTableChannelList.First;
  while not self.MainDataModule.DreamFDMemTableChannelList.EOF do
  begin
    for Field in self.MainDataModule.DreamFDMemTableChannelList.Fields do
    begin
      if Field.FieldName = 'servicename' then
      begin
        item := ChannelListView.Items.Add;
        item.Text := self.MainDataModule.DreamFDMemTableChannelList.FieldByName
          (Field.FieldName).AsString;
      end;
    end;
    self.MainDataModule.DreamFDMemTableChannelList.Next;
  end;
end;

end.
