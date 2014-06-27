unit UMultiEPGFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMXTee.Chart, FMXTee.Series.Gantt;

type
  TMultiEPGFrame = class(TFrame)
  private
    { Private declarations }
    fChart: TChart;
    fGanttSeries: TGanttSeries;
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

  fGanttSeries := TGanttSeries.Create(self);
  fChart.AddSeries(fGanttSeries);
end;

end.
