unit UMainTabbedForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UMainForm, FMX.TabControl;

type
  TMainTabbedForm = class(TMainForm)
    MainTabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
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
begin
  inherited;
  //self.MainDataModule.DreamRESTRequestChannelList.Resource := 'about';
  self.MainDataModule.DreamRESTRequestChannelList.Execute;
  //ShowMessage(self.MainDataModule.DreamRESTResponseChannelList.JSONValue.Value);
end;

end.
