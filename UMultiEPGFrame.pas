unit UMultiEPGFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMXTee.Chart, FMXTee.Series.Gantt;

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
    Constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

constructor TMultiEPGFrame.Create(AOwner: TComponent);
begin
  // Execute the parent (TObject) constructor first
  inherited; // Call the parent Create method

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
  fGanttSeries1.AddGanttColor(0, 20, 0, 'test', TAlphaColorRec.Honeydew);
  fGanttSeries1.AddGanttColor(20, 30, 0, 'blim', TAlphaColorRec.Honeydew);
  fGanttSeries2.AddGanttColor(0, 10, 1, 'blam', TAlphaColorRec.Salmon);
  fGanttSeries2.AddGanttColor(10, 30, 1, 'blom', TAlphaColorRec.Darksalmon);
  fGanttSeries1.Pointer.VertSize := 20;
  fGanttSeries2.Pointer.VertSize := 20;
  fChart.AddSeries(fGanttSeries1);
  fChart.AddSeries(fGanttSeries2);

  fChart.Legend.Visible := false;
  fChart.Border.Visible := false;

  fChart.Color := TAlphaColorRec.White;

  // fGanttSeries1.Transparency := 50;
  // fGanttSeries2.Transparency := 50;

  fGanttSeries1.Marks.Visible := true;
  fGanttSeries1.Marks.Transparent := true;
  fGanttSeries2.Marks.Visible := true;
  fGanttSeries2.Marks.Transparent := true;

  fGanttSeries1.XLabel[0] := 'TF1 HD';
  fGanttSeries2.XLabel[0] := 'RTL HD';
end;

end.
