unit UMainTabbedForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UMainForm, FMX.TabControl, FMX.Layouts, FMX.Memo, FMX.ListView.Types,
  FMX.ListView, Data.DB, FMX.ListBox, UDataComboListViewFrame,
  UBackDataComboListViewFrame, System.Actions, FMX.ActnList;

type
  TMainTabbedForm = class(TMainForm)
    MainTabControl: TTabControl;
    TabItem1: TTabItem;
    TextEPGTabItem: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    DataComboListViewFrameChannelList: TDataComboListViewFrame;
    TextEPGTabControl: TTabControl;
    TextEPGMasterTabItem: TTabItem;
    TextEPGDetailTabItem: TTabItem;
    TextEPGBackDataComboListViewFrame: TBackDataComboListViewFrame;
    TextEPGActionList: TActionList;
    ToDetailChangeTabAction: TChangeTabAction;
    ToMasterChangeTabAction: TChangeTabAction;
    procedure FormShow(Sender: TObject);
    procedure ComboBoxServiceListChange(Sender: TObject);
    procedure DataComboListViewFrameChannelListDataListViewItemClick
      (const Sender: TObject; const AItem: TListViewItem);
  private
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
  self.DataComboListViewFrameChannelList.init
    (MainDataModule.DreamFDMemTableServiceList, 'servicename',
    MainDataModule.DreamRESTRequestServiceList,
    MainDataModule.DreamRESTResponseDataSetAdapterServiceList,
    MainDataModule.DreamFDMemTableChannelList, 'servicename',
    MainDataModule.DreamRESTRequestChannelList,
    MainDataModule.DreamRESTResponseDataSetAdapterChannelList,
    'servicereference');
end;

procedure TMainTabbedForm.DataComboListViewFrameChannelListDataListViewItemClick
  (const Sender: TObject; const AItem: TListViewItem);
begin
  inherited;
  ToDetailChangeTabAction.ExecuteTarget(self);

  self.TextEPGBackDataComboListViewFrame.init
    (MainDataModule.DreamFDMemTableChannelList, 'servicename',
    MainDataModule.DreamRESTRequestChannelList,
    MainDataModule.DreamRESTResponseDataSetAdapterChannelList,
    MainDataModule.DreamFDMemTableTextEPG, 'title',
    MainDataModule.DreamRESTRequestTextEPG,
    MainDataModule.DreamRESTResponseDataSetAdapterTextEPG, 'servicereference');

end;

end.
