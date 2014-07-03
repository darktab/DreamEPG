unit UMultiEPGFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMXTee.Chart, FMXTee.Series.Gantt, FMXTee.Procs, FMXTee.Series, FMX.Gestures,
  UMainDataModule, StrUtils, Data.DB, DateUtils;

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
  { if (fChart.BottomAxis.Minimum < fGanttSeriesGuidesMin) then
    begin
    fChart.BottomAxis.Minimum := fGanttSeriesGuidesMin;
    fChart.BottomAxis.Maximum := fChart.BottomAxis.Minimum +
    fGanttSeriesGuidesMax;
    end;
    if (fChart.BottomAxis.Maximum > 70) then
    begin
    fChart.BottomAxis.Minimum := 20;
    fChart.BottomAxis.Maximum := 70;
    end; }

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
  lShowCount: Integer;
  lDefaultServiceReference: String;
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
    fGanttSeriesChannels.AddGanttColor(now, now, lChNumber,
      AnsiLeftStr(MainDataModule.DreamFDMemTableChannelList.FieldByName
      ('servicename').AsString, 8), TAlphaColorRec.Honeydew);

    lDefaultServiceReference := MainDataModule.DreamFDMemTableChannelList.
      FieldByName('servicereference').AsString;

    if MainDataModule.DreamFDMemTableTextEPG.Active then
    begin
      MainDataModule.DreamRESTResponseDataSetAdapterTextEPG.ClearDataSet;

      MainDataModule.DreamRESTResponseDataSetAdapterTextEPG.Active := False;
      MainDataModule.DreamFDMemTableTextEPG.Close;
    end;

    MainDataModule.DreamRESTResponseDataSetAdapterTextEPG.FieldDefs.Clear;

    // sRef parameter
    MainDataModule.DreamRESTRequestTextEPG.Params[0].Value :=
      lDefaultServiceReference;

    try
      try
        MainDataModule.DreamRESTRequestTextEPG.Execute;
      except
        if MainDataModule.DreamFDMemTableTextEPG.State = dsBrowse then
        begin
          MainDataModule.DreamFDMemTableTextEPG.Close;
        end;
        MainDataModule.DreamRESTRequestTextEPG.Execute;
      end;
      lShowCount := 0;
      while not MainDataModule.DreamFDMemTableTextEPG.EOF do
      begin
        fGanttSeriesGuides.AddGanttColor
          (UnixToDateTime(MainDataModule.DreamFDMemTableTextEPG.FieldByName
          ('begin_timestamp').AsInteger),
          UnixToDateTime(MainDataModule.DreamFDMemTableTextEPG.FieldByName
          ('begin_timestamp').AsInteger + MainDataModule.DreamFDMemTableTextEPG.
          FieldByName('duration_sec').AsInteger), lChNumber,
          AnsiLeftStr(MainDataModule.DreamFDMemTableTextEPG.FieldByName('title')
          .AsString, 10), TAlphaColorRec.Honeydew);

        inc(lShowCount);
        if lShowCount = 10 then
          Break;

        MainDataModule.DreamFDMemTableTextEPG.Next;
      end;

    except

    end;

    inc(lChNumber);
    if lChNumber = 10 then
      Break;
    MainDataModule.DreamFDMemTableChannelList.Next;
  end;

  fChannelNumber := MainDataModule.DreamFDMemTableChannelList.RecordCount;

  fGanttSeriesChannelsMin := -0.5;
  fGanttSeriesChannelsMax := 5;

  fChart.LeftAxis.Automatic := False;
  fChart.LeftAxis.Minimum := fGanttSeriesChannelsMin;
  fChart.LeftAxis.Maximum := fGanttSeriesChannelsMax;

  // fGanttSeriesGuidesMin := 0;
  // fGanttSeriesGuidesMax := 50;

  // fChart.BottomAxis.Automatic := False;
  // fChart.BottomAxis.Minimum := fGanttSeriesGuidesMin;
  // fChart.BottomAxis.Maximum := fGanttSeriesGuidesMax;

  { fGanttSeriesGuides.AddGanttColor(0, 20, 0, 'test', TAlphaColorRec.Beige);
    fGanttSeriesGuides.AddGanttColor(20, 30, 0, 'blim', TAlphaColorRec.Honeydew); }

  // fLineSeriesNow.AddXY(5, fGanttSeriesChannelsMin, '',
  // TAlphaColorRec.Darksalmon);
  // fLineSeriesNow.AddXY(5, fChannelNumber + 1.5, '', TAlphaColorRec.Darksalmon);
  // fLineSeriesNow.LinePen.Width := 2;

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
