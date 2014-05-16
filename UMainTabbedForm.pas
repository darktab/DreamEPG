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
  USettings,
  FMX.StdActns, FMX.Objects, System.Math,
  DBXJSON, UDataListViewFrame;

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
    TopToolBar: TToolBar;
    SettingsTopToolBarLabel: TLabel;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    ListBoxItem1: TListBoxItem;
    BoxAdressEdit: TEdit;
    ListBoxItem2: TListBoxItem;
    UsernameEdit: TEdit;
    ListBoxItem3: TListBoxItem;
    PasswordEdit: TEdit;
    VersionLabel: TLabel;
    TextEPGInfoBottomRectangle: TRectangle;
    VertScrollBox: TVertScrollBox;
    MainLayout: TLayout;
    TimersDataListViewFrame: TDataListViewFrame;
    DataAniIndicator: TAniIndicator;
    procedure FormShow(Sender: TObject);
    procedure ComboBoxServiceListChange(Sender: TObject);
    procedure DataComboListViewFrameChannelListDataListViewItemClick
      (const Sender: TObject; const AItem: TListViewItem);
    procedure TextEPGBackDataComboListViewFrameDataListViewItemClick
      (const Sender: TObject; const AItem: TListViewItem);
    procedure TextEPGInfoRecordButtonClick(Sender: TObject);
    procedure TextEPGBackDataComboListViewFrameDataListViewSearchChange
      (Sender: TObject);
    procedure BoxAddressEditChange(Sender: TObject);
    procedure UsernameEditChange(Sender: TObject);
    procedure PasswordEditChange(Sender: TObject);
    procedure MainTabControlChange(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure TextEPGBackDataComboListViewFrameTopDataComboBoxChange
      (Sender: TObject);
    procedure TextEPGDetailSpeedButtonClick(Sender: TObject);

  private
    fSettings: TSettings;
    FKBBounds: TRectF;
    fKBOffset: Integer;
    FNeedOffset: Boolean;

    procedure initSettings;
    procedure initChannelListView;
    procedure initTimersListView;

    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
    procedure startSpinner;
    procedure stopSpinner;

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

procedure TMainTabbedForm.startSpinner;
begin
  // spinner on
  DataAniIndicator.Visible := True;
  DataAniIndicator.Enabled := True;
  Application.ProcessMessages;
end;

procedure TMainTabbedForm.stopSpinner;
begin
  // spinner on
  DataAniIndicator.Visible := False;
  DataAniIndicator.Enabled := False;
end;

procedure TMainTabbedForm.initChannelListView;
begin
  // initialisation des channels
  self.DataComboListViewFrameChannelList.init
    (MainDataModule.DreamFDMemTableServiceList, 'servicename',
    MainDataModule.DreamRESTRequestServiceList,
    MainDataModule.DreamRESTResponseDataSetAdapterServiceList,
    MainDataModule.DreamFDMemTableChannelList, 'servicename',
    MainDataModule.DreamRESTRequestChannelList,
    MainDataModule.DreamRESTResponseDataSetAdapterChannelList,
    'servicereference');
end;

procedure TMainTabbedForm.initTimersListView;
begin
  // initialisation de la timerlist
  self.TimersDataListViewFrame.init(MainDataModule.DreamFDMemTableTimerList,
    MainDataModule.DreamRESTRequestTimerList,
    MainDataModule.DreamRESTRequestDeleteTimer,
    MainDataModule.DreamRESTResponseDeleteTimer,
    MainDataModule.DreamRESTResponseAddTimer);
end;

// -------------------------------
// Initialisation des settings
// -------------------------------
procedure TMainTabbedForm.initSettings;
begin
  try
    fSettings.read;
    BoxAdressEdit.Text := fSettings.BoxAddress;
    UsernameEdit.Text := fSettings.Username;
    PasswordEdit.Text := fSettings.Password;
    MainDataModule.DreamRESTClient.BaseURL := 'http://' +
      fSettings.BoxAddress + '/api';
    MainDataModule.DreamHTTPBasicAuthenticator.Username := fSettings.Username;
    MainDataModule.DreamHTTPBasicAuthenticator.Password := fSettings.Password;
  except
    MainTabControl.OnChange := nil;
    self.MainTabControl.ActiveTab := SettingsTabItem;
    MainTabControl.OnChange := MainTabControlChange;
    raise;
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

procedure TMainTabbedForm.ComboBoxServiceListChange(Sender: TObject);
begin
  inherited;
  // initChannelListView();
end;

procedure TMainTabbedForm.FormCreate(Sender: TObject);
begin
  inherited;
  VertScrollBox.OnCalcContentBounds := CalcContentBoundsProc;
end;

procedure TMainTabbedForm.CalcContentBoundsProc(Sender: TObject;
  var ContentBounds: TRectF);
begin
  if FNeedOffset and (FKBBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom,
      2 * ClientHeight - FKBBounds.Top);
  end;
end;

procedure TMainTabbedForm.FormFocusChanged(Sender: TObject);
begin
  inherited;
  UpdateKBBounds;
end;

procedure TMainTabbedForm.FormResize(Sender: TObject);
begin
  inherited;
  if self.Height > self.Width then
  begin
    fKBOffset := 50;
  end
  else
  begin
    fKBOffset := -200;
  end;
end;

procedure TMainTabbedForm.FormShow(Sender: TObject);
var
  lDefaultServiceReference: string;
  lBindingExpression: TBindingExpression;
begin
  inherited;
  fKBOffset := 50;
  fSettings := TSettings.Create;
  self.TextEPGBackDataComboListViewFrame.DataListView.ItemAppearanceObjects.
    ItemObjects.Text.Width := Round(0.75 * self.Width);

  try
    // initialisation des settings
    initSettings;
    // initialisation de la channel list
    initChannelListView;
    // initialisation des timers
    initTimersListView;
    // show du premier tab
    MainTabControl.ActiveTab := TextEPGTabItem;

  except
    // ShowMessage('Please take a moment to fill in these settings!');
  end;

end;

procedure TMainTabbedForm.UpdateKBBounds;
var
  LFocused: TControl;
  LFocusRect: TRectF;
begin
  FNeedOffset := False;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
    LFocusRect.Offset(VertScrollBox.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(FKBBounds))) and
      (LFocusRect.Bottom > FKBBounds.Top) then
    begin
      FNeedOffset := True;
      MainLayout.Align := TAlignLayout.alHorizontal;
      VertScrollBox.RealignContent;
      Application.ProcessMessages;
      VertScrollBox.ViewportPosition := PointF(VertScrollBox.ViewportPosition.X,
        LFocusRect.Bottom - FKBBounds.Top + fKBOffset);
    end;
  end;
  if not FNeedOffset then
    RestorePosition;

end;

procedure TMainTabbedForm.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  inherited;
  FKBBounds.Create(0, 0, 0, 0);
  FNeedOffset := False;
  RestorePosition;
end;

procedure TMainTabbedForm.RestorePosition;
begin
  VertScrollBox.ViewportPosition := PointF(VertScrollBox.ViewportPosition.X, 0);
  MainLayout.Align := TAlignLayout.alClient;
  VertScrollBox.RealignContent;
end;

procedure TMainTabbedForm.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  inherited;
  FKBBounds := TRectF.Create(Bounds);
  FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
  FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
  UpdateKBBounds;
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

// -----------------------------------------------------------
// Synchronisation entre la chaine sélectionnée
// et la combobox si on change la sélection dans la combobox
// ----------------------------------------------------------

procedure TMainTabbedForm.TextEPGBackDataComboListViewFrameTopDataComboBoxChange
  (Sender: TObject);
begin
  inherited;
  TextEPGBackDataComboListViewFrame.TopDataComboBoxChange(Sender);

  if TextEPGBackDataComboListViewFrame.TopDataComboBox.ItemIndex <>
    DataComboListViewFrameChannelList.DataListView.Selected.Index then
  begin
    DataComboListViewFrameChannelList.DataListView.Selected :=
      DataComboListViewFrameChannelList.DataListView.Items
      [TextEPGBackDataComboListViewFrame.TopDataComboBox.ItemIndex];
  end;

end;

// ------------------------
// Reload Text EPG
// ------------------------
procedure TMainTabbedForm.TextEPGDetailSpeedButtonClick(Sender: TObject);
begin
  inherited;
  try
    TextEPGBackDataComboListViewFrame.initDataListView;
  except
    MessageDlg('Can''t find your decoder! Please check your settings!',
      System.UITypes.TMsgDlgType.mtError, [System.UITypes.TMsgDlgBtn.mbOK], 0);
  end;
end;

// ------------------------
// Schedule a recording
// ------------------------
procedure TMainTabbedForm.TextEPGInfoRecordButtonClick(Sender: TObject);
begin
  inherited;
  // start the spinner
  startSpinner;

  MainDataModule.DreamRESTRequestAddTimer.Params[0].Value :=
    MainDataModule.DreamFDMemTableTextEPG.FieldByName('sref').AsString;
  MainDataModule.DreamRESTRequestAddTimer.Params[1].Value :=
    MainDataModule.DreamFDMemTableTextEPG.FieldByName('id').AsString;
  try
    MainDataModule.DreamRESTRequestAddTimer.Execute;
  except

    // spinner off
    stopSpinner;

    MessageDlg('Can''t find your decoder! Please check your settings!',
      System.UITypes.TMsgDlgType.mtError, [System.UITypes.TMsgDlgBtn.mbOK], 0);
  end;
  if MainDataModule.DreamRESTResponseAddTimer.StatusCode = 200 then
  begin
    // spinner off
    stopSpinner;
    MessageDlg('Timer successfully scheduled!',
      System.UITypes.TMsgDlgType.mtInformation,
      [System.UITypes.TMsgDlgBtn.mbOK], 0);
    try
      initTimersListView;
    except
      MessageDlg('Can''t find your decoder! Please check your settings!',
        System.UITypes.TMsgDlgType.mtError,
        [System.UITypes.TMsgDlgBtn.mbOK], 0);
    end;
  end
  else
  begin
    // spinner off
    stopSpinner;
    MessageDlg('The following error occurred: ' +
      MainDataModule.DreamRESTResponseAddTimer.StatusText,
      System.UITypes.TMsgDlgType.mtError, [System.UITypes.TMsgDlgBtn.mbOK], 0);
  end;

end;

procedure TMainTabbedForm.MainTabControlChange(Sender: TObject);
var
  loldSettings: TSettings;
begin
  inherited;
  if Assigned(fSettings) then
  begin
    if (fSettings.BoxAddress = '') then
    begin
      // retry settings
      try
        // initialisation des settings
        initSettings;
        // initialisation de la channel list
        initChannelListView;
        // initialisation des timers
        initTimersListView;
      except
        MessageDlg('Please take a moment to fill in these settings!',
          System.UITypes.TMsgDlgType.mtInformation,
          [System.UITypes.TMsgDlgBtn.mbOK], 0);
      end;
    end
    else
    begin
      // write settings file if settings have changed
      loldSettings := TSettings.Create;
      try
        loldSettings.read;
      except

      end;

      if (loldSettings.BoxAddress <> fSettings.BoxAddress) or
        (loldSettings.Username <> fSettings.Username) or
        (loldSettings.Password <> fSettings.Password) then
      begin
        fSettings.write;

        // init Data components
        MainDataModule.DreamRESTClient.BaseURL := 'http://' +
          fSettings.BoxAddress + '/api';
        MainDataModule.DreamHTTPBasicAuthenticator.Username :=
          fSettings.Username;
        MainDataModule.DreamHTTPBasicAuthenticator.Password :=
          fSettings.Password;
      end;
      if DataComboListViewFrameChannelList.DataListView.ItemCount = 0 then
      begin
        try
          // reinitialize app completely
          if (MainTabControl.ActiveTab = TextEPGTabItem) then
          begin
            TextEPGTabControl.ActiveTab := TextEPGMasterTabItem
          end;
          // initialisation de la channel list
          MainDataModule.DreamFDMemTableServiceList.Close; // mandatory
          initChannelListView;
          // initialisation des timers
          initTimersListView;
        except
          MainTabControl.OnChange := nil;
          self.MainTabControl.ActiveTab := SettingsTabItem;
          MainTabControl.OnChange := MainTabControlChange;
          MessageDlg('Can''t find your decoder! Please check your settings!',
            System.UITypes.TMsgDlgType.mtError,
            [System.UITypes.TMsgDlgBtn.mbOK], 0);
        end;
      end;

      FreeAndNil(loldSettings);
    end;
  end;

  // reload timer list on tabchange
  // if self.MainTabControl.ActiveTab = TimersTabItem then
  // begin
  // initTimerDataListView;
  // end;

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

  try
    self.TextEPGBackDataComboListViewFrame.init
      (MainDataModule.DreamFDMemTableChannelList, 'servicename',
      MainDataModule.DreamRESTRequestChannelList,
      MainDataModule.DreamRESTResponseDataSetAdapterChannelList,
      MainDataModule.DreamFDMemTableTextEPG, 'title', lDetailStringList,
      MainDataModule.DreamRESTRequestTextEPG,
      MainDataModule.DreamRESTResponseDataSetAdapterTextEPG,
      'servicereference');
  except
    MessageDlg('Can''t find your decoder! Please check your settings!',
      System.UITypes.TMsgDlgType.mtError, [System.UITypes.TMsgDlgBtn.mbOK], 0);
  end;

  FreeAndNil(lDetailStringList);

end;

end.
