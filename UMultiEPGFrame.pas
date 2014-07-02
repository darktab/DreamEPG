unit UMultiEPGFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMXTee.Chart, FMXTee.Series.Gantt, FMXTee.Procs, FMXTee.Series, FMX.Gestures,
  UMainDataModule, StrUtils;

type
  TMultiEPGFrame = class(TFrame)
    MultiEPGTopToolBar: TToolBar;
    MultiEPGTopLabel: TLabel;

    procedure ChartScroll(Sender: TObject);

  private
    { Private declarations }
    fChart: TChart;
    fGanttSeriesChannels: TGanttSeries;
    fGanttSeriesGuides: TGanttSeries;
    fLineSeriesNow: TLineSeries;
    fLastPosition: TPointF;

    fGanttSeriesChannelsMax: Double;
    fGanttSeriesChannelsMin: Double;
    fChannelNumber: Integer;

    fGanttSeriesGuidesMax: TDateTime;
    fGanttSeriesGuidesMin: TDateTime;

  public
    { Public declarations }
    procedure init;
    Constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

constructor TMultiEPGFrame.Create(AOwner: TComponent);
begin
  // Execute the parent (TObject) constructor first
  inherited; // Call the parent Create method

end;

procedure TMultiEPGFrame.ChartScroll(Sender: TObject);
begin
  if (fChart.BottomAxis.Minimum < fGanttSeriesGuidesMin) then
  begin
    fChart.BottomAxis.Minimum := fGanttSeriesGuidesMin;
    fChart.BottomAxis.Maximum := fChart.BottomAxis.Minimum +
      fGanttSeriesGuidesMax;
  end;
  if (fChart.BottomAxis.Maximum > 70) then
  begin
    fChart.BottomAxis.Minimum := 20;
    fChart.BottomAxis.Maximum := 70;
  end;

  if (fChart.LeftAxis.Minimum < fGanttSeriesChannelsMin) then
  begin
    fChart.LeftAxis.Minimum := fGanttSeriesChannelsMin;
    fChart.LeftAxis.Maximum := fGanttSeriesChannelsMax;
  end;

  if (fChart.LeftAxis.Maximum > fChannelNumber - 0.5) then
  begin
    fChart.LeftAxis.Maximum := fChannelNumber - 0.5;
    fChart.LeftAxis.Minimum := fChart.LeftAxis.Maximum - 6.5;
  end;

end;

procedure TMultiEPGFrame.init;
var
  lChNumber: Integer;
begin
  fChart := TChart.Create(self);
  fChart.Parent := self;
  fChart.Align := TAlignLayout.Client;

  fChart.View3D := False;
  fChart.BottomAxis.Visible := True;
  fChart.BottomAxis.OtherSide := True;

  fChart.Frame.Visible := False;
  fChart.Width := self.Width;
  fChart.Height := self.Height;
  fChart.MarginRight := 0;
  fChart.MarginBottom := 0;

  fChart.Legend.Visible := False;
  fChart.Border.Visible := False;

  fChart.Color := TAlphaColorRec.White;

  fChart.LeftAxis.Inverted := True;
  fChart.LeftAxis.TickOnLabelsOnly := True;

  fChart.LeftAxis.MinorTicks.Visible := False;
  fChart.BottomAxis.MinorTicks.Visible := False;

  fChart.AllowZoom := False;
  fChart.AllowPanning := TPanningMode.pmBoth;
  fChart.ScrollMouseButton := TMouseButton.mbLeft;
  fChart.OnScroll := self.ChartScroll;

  fGanttSeriesChannels := TGanttSeries.Create(self);
  fGanttSeriesGuides := TGanttSeries.Create(self);
  fLineSeriesNow := TLineSeries.Create(self);

  if not MainDataModule.DreamFDMemTableChannelList.Active then
  begin
    MainDataModule.DreamFDMemTableChannelList.Open;
    MainDataModule.DreamFDMemTableChannelList.First;
  end;

  lChNumber := 0;
  while not MainDataModule.DreamFDMemTableChannelList.EOF do
  begin
    fGanttSeriesChannels.AddGanttColor(0, 0, lChNumber,
      AnsiLeftStr(MainDataModule.DreamFDMemTableChannelList.FieldByName
      ('servicename').AsString, 8), TAlphaColorRec.Honeydew);

    inc(lChNumber);
    MainDataModule.DreamFDMemTableChannelList.Next;
  end;
  fChannelNumber := MainDataModule.DreamFDMemTableChannelList.RecordCount;

  fGanttSeriesChannelsMin := -0.5;
  fGanttSeriesChannelsMax := 5;

  fChart.LeftAxis.Automatic := False;
  fChart.LeftAxis.Minimum := fGanttSeriesChannelsMin;
  fChart.LeftAxis.Maximum := fGanttSeriesChannelsMax;

  fGanttSeriesGuidesMin := 0;
  fGanttSeriesGuidesMax := 50;

  fChart.BottomAxis.Automatic := False;
  fChart.BottomAxis.Minimum := fGanttSeriesGuidesMin;
  fChart.BottomAxis.Maximum := fGanttSeriesGuidesMax;

  fGanttSeriesGuides.AddGanttColor(0, 20, 0, 'test', TAlphaColorRec.Beige);
  fGanttSeriesGuides.AddGanttColor(20, 30, 0, 'blim', TAlphaColorRec.Honeydew);
  fGanttSeriesGuides.AddGanttColor(30, 60, 0, 'blim', TAlphaColorRec.Honeydew);

  fGanttSeriesGuides.AddGanttColor(0, 10, 1, 'blam', TAlphaColorRec.Beige);
  fGanttSeriesGuides.AddGanttColor(10, 30, 1, 'blom', TAlphaColorRec.Honeydew);
  fGanttSeriesGuides.AddGanttColor(30, 70, 1, 'blom', TAlphaColorRec.Honeydew);

  fGanttSeriesGuides.AddGanttColor(0, 20, 2, 'test', TAlphaColorRec.Beige);
  fGanttSeriesGuides.AddGanttColor(20, 30, 2, 'blim', TAlphaColorRec.Honeydew);
  fGanttSeriesGuides.AddGanttColor(30, 60, 2, 'blim', TAlphaColorRec.Honeydew);

  fGanttSeriesGuides.AddGanttColor(0, 20, 3, 'test', TAlphaColorRec.Beige);
  fGanttSeriesGuides.AddGanttColor(20, 30, 3, 'blim', TAlphaColorRec.Honeydew);
  fGanttSeriesGuides.AddGanttColor(30, 60, 3, 'blim', TAlphaColorRec.Honeydew);

  fGanttSeriesGuides.AddGanttColor(0, 10, 4, 'blam', TAlphaColorRec.Beige);
  fGanttSeriesGuides.AddGanttColor(10, 30, 4, 'blom', TAlphaColorRec.Honeydew);
  fGanttSeriesGuides.AddGanttColor(30, 70, 4, 'blom', TAlphaColorRec.Honeydew);

  fGanttSeriesGuides.AddGanttColor(0, 20, 5, 'test', TAlphaColorRec.Beige);
  fGanttSeriesGuides.AddGanttColor(20, 30, 5, 'blim', TAlphaColorRec.Honeydew);
  fGanttSeriesGuides.AddGanttColor(30, 60, 5, 'blim', TAlphaColorRec.Honeydew);

  fGanttSeriesGuides.AddGanttColor(0, 20, 6, 'test', TAlphaColorRec.Beige);
  fGanttSeriesGuides.AddGanttColor(20, 30, 6, 'blim', TAlphaColorRec.Honeydew);
  fGanttSeriesGuides.AddGanttColor(30, 60, 6, 'blim', TAlphaColorRec.Honeydew);

  fLineSeriesNow.AddXY(5, fGanttSeriesChannelsMin, '',
    TAlphaColorRec.Darksalmon);
  fLineSeriesNow.AddXY(5, fChannelNumber + 1.5, '',
    TAlphaColorRec.Darksalmon);
  fLineSeriesNow.LinePen.Width := 2;

  fGanttSeriesChannels.Pointer.VertSize := 20;
  fGanttSeriesGuides.Pointer.VertSize := 20;
  fChart.AddSeries(fGanttSeriesChannels);
  fChart.AddSeries(fGanttSeriesGuides);
  fChart.AddSeries(fLineSeriesNow);

  fGanttSeriesGuides.Marks.Visible := True;
  fGanttSeriesGuides.Marks.Transparent := True;
  fGanttSeriesGuides.Marks.Clip := True;

end;

end.
