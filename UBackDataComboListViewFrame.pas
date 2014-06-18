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
    TVShowProgressBar: TProgressBar;
    procedure TopReloadSpeedButtonClick(Sender: TObject);
  private
    { Private declarations }
    fTVShowProgress: TProgressBar;
  public
    { Public declarations }
    procedure initDataListView; override;
  end;

var
  BackDataComboListViewFrame: TBackDataComboListViewFrame;

implementation

{$R *.fmx}

procedure TBackDataComboListViewFrame.initDataListView;
var
  tmpPos: integer;
begin
  TopReloadSpeedButton.Visible := false;
  inherited;
  TopReloadSpeedButton.Visible := true;

  // if not Assigned(fTVShowProgress) then
  // begin
  // fTVShowProgress := TProgressBar.Create(self);
  // end;
  // fTVShowProgress.Align := TAlignLayout.alTop;
  // self.DataListView.AddObject(fTVShowProgress);
  // self.DataListView.Items[0]. := fTVShowProgress;
  tmpPos := self.DataListView.DataSet.RecNo;
  TVShowProgressBar.Min := self.DataListView.DataSet.FieldByName
    ('begin_timestamp').AsLargeInt;
  TVShowProgressBar.Max := TVShowProgressBar.Min +
    self.DataListView.DataSet.FieldByName('duration_sec').AsLargeInt;
  TVShowProgressBar.Value := self.DataListView.DataSet.FieldByName
    ('now_timestamp').AsLargeInt;

  self.DataListView.DataSet.RecNo := tmpPos;

end;

procedure TBackDataComboListViewFrame.TopReloadSpeedButtonClick
  (Sender: TObject);
begin
  inherited;
  initDataListView;
end;

end.
