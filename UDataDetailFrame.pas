unit UDataDetailFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Memo, FMX.Objects, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter,
  REST.Client;

type
  TDataDetailFrame = class(TFrame)
    TextEPGDateTimeLabel: TLabel;
    TextEPGInfoBottomRectangle: TRectangle;
    TextEPGInfoLabel: TLabel;
    TextEPGInfoMemo: TMemo;
    TextEPGInfoRecordButton: TButton;
    TextEPGInfoToolBar: TToolBar;
    TextEPGTitleLabel: TLabel;
    TextEPGBackButton: TButton;
    DataAniIndicator: TAniIndicator;
    procedure TextEPGInfoRecordButtonClick(Sender: TObject);
  private
    { Private declarations }
    fDataSet: TDataSet;
    fRESTRequestAddTimer: TRESTRequest;
    fRESTResponseAddTimer: TRESTResponse;

    procedure startSpinner;
    procedure stopSpinner;
  public
    { Public declarations }
    procedure init(lDetailDataSet: TDataSet;
      lDetailRESTRequestAddTimer: TRESTRequest;
      lDetailRESTResponseAddTimer: TRESTResponse);
  end;

implementation

{$R *.fmx}

procedure TDataDetailFrame.init(lDetailDataSet: TDataSet;
  lDetailRESTRequestAddTimer: TRESTRequest;
  lDetailRESTResponseAddTimer: TRESTResponse);
begin
  fDataSet := lDetailDataSet;
  fRESTRequestAddTimer := lDetailRESTRequestAddTimer;
  fRESTResponseAddTimer := lDetailRESTResponseAddTimer;

  TextEPGTitleLabel.Text := fDataSet.FieldByName('sname').AsString;
  TextEPGInfoLabel.Text := fDataSet.FieldByName('title').AsString;
  TextEPGDateTimeLabel.Text := fDataSet.FieldByName('date').AsString + ': ' +
    fDataSet.FieldByName('begin').AsString + ' - ' + fDataSet.FieldByName('end')
    .AsString;;
  TextEPGInfoMemo.Text := fDataSet.FieldByName('longdesc').AsString;
end;

procedure TDataDetailFrame.startSpinner;
begin
  // spinner on
  DataAniIndicator.Visible := True;
  DataAniIndicator.Enabled := True;
  Application.ProcessMessages;
end;

procedure TDataDetailFrame.stopSpinner;
begin
  // spinner on
  DataAniIndicator.Visible := False;
  DataAniIndicator.Enabled := False;
end;

procedure TDataDetailFrame.TextEPGInfoRecordButtonClick(Sender: TObject);
begin
  // start the spinner
  startSpinner;

  fRESTRequestAddTimer.Params[0].Value := fDataSet.FieldByName('sref').AsString;
  fRESTRequestAddTimer.Params[1].Value := fDataSet.FieldByName('id').AsString;
  try
    fRESTRequestAddTimer.Execute;
  except

    // spinner off
    stopSpinner;

    MessageDlg('Can''t find your decoder! Please check your settings!',
      System.UITypes.TMsgDlgType.mtError, [System.UITypes.TMsgDlgBtn.mbOK], 0);
  end;
  if fRESTResponseAddTimer.StatusCode = 200 then
  begin
    // spinner off
    stopSpinner;
    MessageDlg('Timer successfully scheduled!',
      System.UITypes.TMsgDlgType.mtInformation,
      [System.UITypes.TMsgDlgBtn.mbOK], 0);
  end
  else
  begin
    // spinner off
    stopSpinner;
    MessageDlg('The following error occurred: ' +
      fRESTResponseAddTimer.StatusText, System.UITypes.TMsgDlgType.mtError,
      [System.UITypes.TMsgDlgBtn.mbOK], 0);
  end;
end;

end.
