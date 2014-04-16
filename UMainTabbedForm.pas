unit UMainTabbedForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UMainForm, FMX.TabControl, FMX.Layouts, FMX.Memo, FMX.ListView.Types,
  FMX.ListView, FMX.Edit, Data.DB, FMX.ListBox, UDataComboListViewFrame,
  UBackDataComboListViewFrame, System.Actions, FMX.ActnList, FireDAC.UI.Intf,
  FireDAC.FMXUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI,
  System.Bindings.Expression,
  System.Bindings.Helper,
  UDataListView,
  UWorking,
  USettings;

type
  TMainTabbedForm = class(TMainForm)
    MainTabControl: TTabControl;
    MultiEPGTabItem: TTabItem;
    TextEPGTabItem: TTabItem;
    TimersTabItem: TTabItem;
    SettingsTabItem: TTabItem;
    DataComboListViewFrameChannelList: TDataComboListViewFrame;
    TextEPGTabControl: TTabControl;
    TextEPGMasterTabItem: TTabItem;
    TextEPGDetailTabItem: TTabItem;
    TextEPGBackDataComboListViewFrame: TBackDataComboListViewFrame;
    TextEPGActionList: TActionList;
    ToDetailChangeTabAction: TChangeTabAction;
    ToMasterChangeTabAction: TChangeTabAction;
    TextEPGInfoTabItem: TTabItem;
    TextEPGInfoToolBar: TToolBar;
    TextEPGBackButton: TButton;
    TextEPGTitleLabel: TLabel;
    ToInfoChangeTabAction: TChangeTabAction;
    TextEPGInfoLabel: TLabel;
    TextEPGInfoMemo: TMemo;
    TextEPGInfoRecordButton: TButton;
    TextEPGDateTimeLabel: TLabel;
    TimersTopToolBar: TToolBar;
    TimersTopToolBarLabel: TLabel;
    TimersDataListView: TDataListView;
    SettingsListBox: TListBox;
    TopToolBar: TToolBar;
    SettingsTopToolBarLabel: TLabel;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    BoxAdressEdit: TEdit;
    UsernameEdit: TEdit;
    PasswordEdit: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure ComboBoxServiceListChange(Sender: TObject);
    procedure DataComboListViewFrameChannelListDataListViewItemClick
      (const Sender: TObject; const AItem: TListViewItem);
    procedure TextEPGBackDataComboListViewFrameDataListViewItemClick
      (const Sender: TObject; const AItem: TListViewItem);
    procedure TextEPGInfoRecordButtonClick(Sender: TObject);
    procedure TimersDataListViewDeletingItem(Sender: TObject; AIndex: Integer;
      var ACanDelete: Boolean);
    procedure TextEPGBackDataComboListViewFrameDataListViewSearchChange
      (Sender: TObject);
    procedure BoxAddressEditChange(Sender: TObject);
    procedure UsernameEditChange(Sender: TObject);
    procedure PasswordEditChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    fSettings: TSettings;

    procedure initTimerDataListView;
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent);
    destructor Destroy;
  end;

var
  MainTabbedForm: TMainTabbedForm;

implementation

uses
  UMainDataModule;

{$R *.fmx}

constructor TMainTabbedForm.Create(AOwner: TComponent);
begin
  inherited;
  // fSettings := TSettings.Create;
end;

destructor TMainTabbedForm.Destroy;
begin
  inherited;
  if Assigned(fSettings) then
  begin
    FreeAndNil(fSettings);
  end;
end;

// -------------------------
// BoxAddress change
// -------------------------
procedure TMainTabbedForm.BoxAddressEditChange(Sender: TObject);
begin
  inherited;
  fSettings.BoxAddress := (Sender as TEdit).Text;
end;

// -------------------------
// Username change
// -------------------------
procedure TMainTabbedForm.UsernameEditChange(Sender: TObject);
begin
  inherited;
  fSettings.Username := (Sender as TEdit).Text;
end;

// -------------------------
// Password change
// -------------------------
procedure TMainTabbedForm.PasswordEditChange(Sender: TObject);
begin
  inherited;
  fSettings.Password := (Sender as TEdit).Text;
end;

// ----------------------
// check settings
// ----------------------
procedure TMainTabbedForm.Button1Click(Sender: TObject);
begin
  inherited;
  fSettings.write;
end;

procedure TMainTabbedForm.Button2Click(Sender: TObject);
begin
  inherited;
  fSettings.read;
end;

procedure TMainTabbedForm.ComboBoxServiceListChange(Sender: TObject);
begin
  inherited;
  // initChannelListView();
end;

procedure TMainTabbedForm.FormShow(Sender: TObject);
var
  lDefaultServiceReference: string;
  lBindingExpression: TBindingExpression;
begin
  inherited;
  // initialisation des settings
  fSettings := TSettings.Create;

  // initialisation des channels
  self.DataComboListViewFrameChannelList.init
    (MainDataModule.DreamFDMemTableServiceList, 'servicename',
    MainDataModule.DreamRESTRequestServiceList,
    MainDataModule.DreamRESTResponseDataSetAdapterServiceList,
    MainDataModule.DreamFDMemTableChannelList, 'servicename',
    MainDataModule.DreamRESTRequestChannelList,
    MainDataModule.DreamRESTResponseDataSetAdapterChannelList,
    'servicereference');

  // initialisation des timers
  initTimerDataListView;
end;

procedure TMainTabbedForm.TextEPGBackDataComboListViewFrameDataListViewItemClick
  (const Sender: TObject; const AItem: TListViewItem);
begin
  inherited;
  TextEPGBackDataComboListViewFrame.DataListViewItemClick(Sender, AItem);
  TextEPGTitleLabel.Text := MainDataModule.DreamFDMemTableTextEPG.FieldByName
    ('sname').AsString;
  TextEPGInfoLabel.Text := MainDataModule.DreamFDMemTableTextEPG.FieldByName
    ('title').AsString;
  TextEPGDateTimeLabel.Text := MainDataModule.DreamFDMemTableTextEPG.FieldByName
    ('date').AsString + ': ' + MainDataModule.DreamFDMemTableTextEPG.FieldByName
    ('begin').AsString + ' - ' + MainDataModule.DreamFDMemTableTextEPG.
    FieldByName('end').AsString;;
  TextEPGInfoMemo.Text := MainDataModule.DreamFDMemTableTextEPG.FieldByName
    ('longdesc').AsString;
  ToInfoChangeTabAction.ExecuteTarget(self);
end;

// ------------------------
// Access to Searchbox
// ------------------------
procedure TMainTabbedForm.
  TextEPGBackDataComboListViewFrameDataListViewSearchChange(Sender: TObject);
var
  I: Integer;
  SearchBox: TSearchBox;
  List: TListView;
begin
  inherited;
  List := Sender as TListView;
  for I := 0 to List.Controls.Count - 1 do
    if List.Controls[I].ClassType = TSearchBox then
    begin
      SearchBox := TSearchBox(List.Controls[I]);
      Break;
    end;
end;

// ------------------------
// Schedule a recording
// ------------------------
procedure TMainTabbedForm.TextEPGInfoRecordButtonClick(Sender: TObject);
begin
  inherited;
  MainDataModule.DreamRESTRequestAddTimer.Params[0].Value :=
    MainDataModule.DreamFDMemTableTextEPG.FieldByName('sref').AsString;
  MainDataModule.DreamRESTRequestAddTimer.Params[1].Value :=
    MainDataModule.DreamFDMemTableTextEPG.FieldByName('id').AsString;

  MainDataModule.DreamRESTRequestAddTimer.Execute;
  if MainDataModule.DreamRESTResponseAddTimer.StatusCode = 200 then
  begin
    ShowMessage('Timer successfully scheduled!');
    initTimerDataListView;
  end
  else
  begin
    MessageDlg('The following error occurred: ' +
      MainDataModule.DreamRESTResponseAddTimer.StatusText,
      System.UITypes.TMsgDlgType.mtError, [System.UITypes.TMsgDlgBtn.mbOK], 0);
  end;

end;

// ------------------------
// delete a timer
// ------------------------
procedure TMainTabbedForm.TimersDataListViewDeletingItem(Sender: TObject;
  AIndex: Integer; var ACanDelete: Boolean);
begin
  inherited;
  try
    MainDataModule.DreamFDMemTableTimerList.RecNo :=
      TimersDataListView.ItemIndex + 1;
  except

  end;
  MainDataModule.DreamRESTRequestDeleteTimer.Params[0].Value :=
    MainDataModule.DreamFDMemTableTimerList.FieldByName('serviceref').AsString;
  MainDataModule.DreamRESTRequestDeleteTimer.Params[1].Value :=
    MainDataModule.DreamFDMemTableTimerList.FieldByName('begin').AsString;
  MainDataModule.DreamRESTRequestDeleteTimer.Params[2].Value :=
    MainDataModule.DreamFDMemTableTimerList.FieldByName('end').AsString;
  MainDataModule.DreamRESTRequestDeleteTimer.Execute;

  if MainDataModule.DreamRESTResponseDeleteTimer.StatusCode = 200 then
  begin
    ShowMessage('Timer successfully deleted!');
    ACanDelete := true;
  end
  else
  begin
    MessageDlg('The following error occurred: ' +
      MainDataModule.DreamRESTResponseAddTimer.StatusText,
      System.UITypes.TMsgDlgType.mtError, [System.UITypes.TMsgDlgBtn.mbOK], 0);
    ACanDelete := False;
  end;
end;

procedure TMainTabbedForm.initTimerDataListView;
var
  lTimersDetailStringlist: TStringList;
begin
  // initialisation des timers
  MainDataModule.DreamRESTRequestTimerList.Execute;
  TimersDataListView.DataSet := MainDataModule.DreamFDMemTableTimerList;
  TimersDataListView.DataFieldName := 'name';
  lTimersDetailStringlist := TStringList.Create;
  lTimersDetailStringlist.Add('servicename');
  lTimersDetailStringlist.Add('realbegin');
  try
    TimersDataListView.init(lTimersDetailStringlist);
  except
  end;
  FreeAndNil(lTimersDetailStringlist);
end;

procedure TMainTabbedForm.DataComboListViewFrameChannelListDataListViewItemClick
  (const Sender: TObject; const AItem: TListViewItem);
var
  lDetailStringList: TStringList;
begin
  inherited;
  ToDetailChangeTabAction.ExecuteTarget(self);

  lDetailStringList := TStringList.Create;

  lDetailStringList.Add('date');
  lDetailStringList.Add('begin');
  lDetailStringList.Add('end');

  self.TextEPGBackDataComboListViewFrame.init
    (MainDataModule.DreamFDMemTableChannelList, 'servicename',
    MainDataModule.DreamRESTRequestChannelList,
    MainDataModule.DreamRESTResponseDataSetAdapterChannelList,
    MainDataModule.DreamFDMemTableTextEPG, 'title', lDetailStringList,
    MainDataModule.DreamRESTRequestTextEPG,
    MainDataModule.DreamRESTResponseDataSetAdapterTextEPG, 'servicereference');

  FreeAndNil(lDetailStringList);

end;

end.
