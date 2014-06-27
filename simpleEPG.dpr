program simpleEPG;

uses
  System.StartUpCopy,
  FMX.MobilePreview,
  FMX.Forms,
  UMainForm in 'UMainForm.pas' {MainForm} ,
  UMainTabbedForm in 'UMainTabbedForm.pas' {MainTabbedForm} ,
  UMainDataModule in 'UMainDataModule.pas' {MainDataModule: TDataModule} ,
  UDataComboListViewFrame
    in 'UDataComboListViewFrame.pas' {DataComboListViewFrame: TFrame} ,
  UBackDataComboListViewFrame
    in 'UBackDataComboListViewFrame.pas' {BackDataComboListViewFrame: TFrame} ,
  UDetailInitThread in 'UDetailInitThread.pas',
  USettings in 'USettings.pas',
  UDataListViewFrame in 'UDataListViewFrame.pas' {DataListViewFrame: TFrame} ,
  UDataDetailFrame in 'UDataDetailFrame.pas' {DataDetailFrame: TFrame} ,
  UMultiEPGFrame in 'UMultiEPGFrame.pas' {MultiEPGFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.soPortrait];
  Application.CreateForm(TMainDataModule, MainDataModule);
  Application.CreateForm(TMainTabbedForm, MainTabbedForm);
  Application.Run;

end.
