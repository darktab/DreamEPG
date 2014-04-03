program DreamEPG;

uses
  System.StartUpCopy,
  FMX.MobilePreview,
  FMX.Forms,
  UMainForm in 'UMainForm.pas' {MainForm},
  UMainTabbedForm in 'UMainTabbedForm.pas' {MainTabbedForm},
  UMainDataModule in 'UMainDataModule.pas' {MainDataModule: TDataModule},
  UDataComboListViewFrame in 'UDataComboListViewFrame.pas' {DataComboListViewFrame: TFrame},
  UBackDataComboListViewFrame in 'UBackDataComboListViewFrame.pas' {BackDataComboListViewFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainDataModule, MainDataModule);
  Application.CreateForm(TMainTabbedForm, MainTabbedForm);
  Application.Run;
end.
