unit UBackDataComboListViewFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UDataComboListViewFrame, FMX.ListView.Types, FMX.ListView, UDataListView,
  FMX.ListBox, UDataComboBox, FMX.Objects;

type
  TBackDataComboListViewFrame = class(TDataComboListViewFrame)
    TopBackButton: TButton;
    TopReloadSpeedButton: TSpeedButton;
    procedure TopReloadSpeedButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure initDataListView; override;
  end;

var
  BackDataComboListViewFrame: TBackDataComboListViewFrame;

implementation

{$R *.fmx}

procedure TBackDataComboListViewFrame.initDataListView;
begin
  TopReloadSpeedButton.Visible := false;
  inherited;
  TopReloadSpeedButton.Visible := true;
end;

procedure TBackDataComboListViewFrame.TopReloadSpeedButtonClick
  (Sender: TObject);
begin
  inherited;
  initDataListView;
end;

end.
