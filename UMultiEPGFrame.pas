unit UMultiEPGFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMXTee.Chart, FMXTee.Series.Gantt, FMXTee.Procs;

type
  TMultiEPGFrame = class(TFrame)
    MultiEPGTopToolBar: TToolBar;
    MultiEPGTopLabel: TLabel;
  private
    { Private declarations }
    fChart: TChart;
    fGanttSeries1: TGanttSeries;
    fGanttSeries2: TGanttSeries;

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

procedure TMultiEPGFrame.init;
begin
  fChart := TChart.Create(self);
  fChart.Parent := self;
  fChart.Align := TAlignLayout.Client;

  fChart.View3D := false;
  fChart.BottomAxis.Visible := false;
  fChart.Frame.Visible := false;
  fChart.Width := self.Width;
  fChart.Height := self.Height;

  fGanttSeries1 := TGanttSeries.Create(self);
  fGanttSeries2 := TGanttSeries.Create(self);
  fGanttSeries1.AddGanttColor(0, 0, 0, 'TF1 HD', TAlphaColorRec.Honeydew);
  fGanttSeries1.AddGanttColor(0, 0, 1, 'RTL HD', TAlphaColorRec.Honeydew);
  fGanttSeries1.AddGanttColor(0, 0, 2, 'VOX', TAlphaColorRec.Honeydew);
  fGanttSeries1.AddGanttColor(0, 0, 3, 'M6 HD', TAlphaColorRec.Honeydew);
  fGanttSeries1.AddGanttColor(0, 0, 4, 'W9', TAlphaColorRec.Honeydew);
  fGanttSeries1.AddGanttColor(0, 0, 5, 'France 2', TAlphaColorRec.Honeydew);
  fGanttSeries1.AddGanttColor(0, 0, 6, 'Plug TV', TAlphaColorRec.Honeydew);

  fGanttSeries2.AddGanttColor(0, 20, 0, 'test', TAlphaColorRec.Beige);
  fGanttSeries2.AddGanttColor(20, 30, 0, 'blim', TAlphaColorRec.Honeydew);
  fGanttSeries2.AddGanttColor(30, 60, 0, 'blim', TAlphaColorRec.Honeydew);

  fGanttSeries2.AddGanttColor(0, 10, 1, 'blam', TAlphaColorRec.Beige);
  fGanttSeries2.AddGanttColor(10, 30, 1, 'blom', TAlphaColorRec.Honeydew);
  fGanttSeries2.AddGanttColor(30, 70, 1, 'blom', TAlphaColorRec.Honeydew);

  fGanttSeries2.AddGanttColor(0, 20, 2, 'test', TAlphaColorRec.Beige);
  fGanttSeries2.AddGanttColor(20, 30, 2, 'blim', TAlphaColorRec.Honeydew);
  fGanttSeries2.AddGanttColor(30, 60, 2, 'blim', TAlphaColorRec.Honeydew);

  fGanttSeries2.AddGanttColor(0, 20, 3, 'test', TAlphaColorRec.Beige);
  fGanttSeries2.AddGanttColor(20, 30, 3, 'blim', TAlphaColorRec.Honeydew);
  fGanttSeries2.AddGanttColor(30, 60, 3, 'blim', TAlphaColorRec.Honeydew);

  fGanttSeries2.AddGanttColor(0, 10, 4, 'blam', TAlphaColorRec.Beige);
  fGanttSeries2.AddGanttColor(10, 30, 4, 'blom', TAlphaColorRec.Honeydew);
  fGanttSeries2.AddGanttColor(30, 70, 4, 'blom', TAlphaColorRec.Honeydew);

  fGanttSeries2.AddGanttColor(0, 20, 5, 'test', TAlphaColorRec.Beige);
  fGanttSeries2.AddGanttColor(20, 30, 5, 'blim', TAlphaColorRec.Honeydew);
  fGanttSeries2.AddGanttColor(30, 60, 5, 'blim', TAlphaColorRec.Honeydew);

  fGanttSeries2.AddGanttColor(0, 20, 6, 'test', TAlphaColorRec.Beige);
  fGanttSeries2.AddGanttColor(20, 30, 6, 'blim', TAlphaColorRec.Honeydew);
  fGanttSeries2.AddGanttColor(30, 60, 6, 'blim', TAlphaColorRec.Honeydew);

  fGanttSeries1.Pointer.VertSize := 20;
  fGanttSeries2.Pointer.VertSize := 20;
  fChart.AddSeries(fGanttSeries1);
  fChart.AddSeries(fGanttSeries2);

  fChart.Legend.Visible := false;
  fChart.Border.Visible := false;

  fChart.Color := TAlphaColorRec.White;

  fChart.LeftAxis.Inverted := True;
  fChart.LeftAxis.TickOnLabelsOnly := True;

  fChart.LeftAxis.Automatic := false;
  fChart.LeftAxis.Minimum := -0.5;
  fChart.LeftAxis.Maximum := 5;

  fChart.BottomAxis.Automatic := false;
  fChart.BottomAxis.Minimum := 0;
  fChart.BottomAxis.Maximum := 50;

  fChart.AllowZoom := false;
  fChart.Panning.Active := True;
  fChart.AllowPanning := TPanningMode.pmBoth;

  // fChart.BottomAxis.Minimum := 0;
  // fChart.BottomAxis.Maximum := 10;
  // fChart.LeftAxis.Minimum := 0;
  // fChart.LeftAxis.Maximum := 2;

  // fGanttSeries1.Transparency := 50;
  // fGanttSeries2.Transparency := 50;

  // fGanttSeries1.Marks.Visible := True;
  // fGanttSeries1.Marks.Transparent := True;
  fGanttSeries2.Marks.Visible := True;
  fGanttSeries2.Marks.Transparent := True;

end;

end.
