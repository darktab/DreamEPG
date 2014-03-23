unit UMainTabbedForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UMainForm, FMX.TabControl, FMX.Layouts, FMX.Memo, FMX.ListView.Types,
  FMX.ListView, Data.DB;

type
  TMainTabbedForm = class(TMainForm)
    MainTabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    ChannelListView: TListView;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainTabbedForm: TMainTabbedForm;

implementation

{$R *.fmx}

procedure TMainTabbedForm.FormShow(Sender: TObject);
var
  Field: TField;
  item: TListViewItem;
  channelIndex: Integer;
begin
  inherited;
  // self.MainDataModule.DreamRESTRequestChannelList.Resource := 'about';
  self.MainDataModule.DreamRESTResponseDataSetAdapterChannelList.
    FieldDefs.Clear;
  self.MainDataModule.DreamRESTRequestChannelList.Execute;
  // Writeln(self.MainDataModule.DreamRESTResponseChannelList.Content);
  ChannelListView.ClearItems;

  //for     size(self.MainDataModule.DreamFDMemTableChannelList
  for Field in self.MainDataModule.DreamFDMemTableChannelList.Fields do
  begin

    item := ChannelListView.Items.Add;

    item.Text := Field.FieldName + ' = ' +
      self.MainDataModule.DreamFDMemTableChannelList.FieldByName
      (Field.FieldName).AsString;

  end;
end;

end.
