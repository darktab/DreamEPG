unit UMainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  UMainDataModule;

type
  TMainForm = class(TForm)
  private
    { Private declarations }
    fmainDataModule: TMainDataModule;
  public
    { Public declarations }
    Constructor Create(AOwner: TComponent); override;

  published
    { Publihed declarations }
    Property MainDataModule: TMainDataModule read fmainDataModule
      write fmainDataModule;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

// Create a Main Form
constructor TMainForm.Create(AOwner: TComponent);
begin
  // Execute the parent (TObject) constructor first
  inherited; // Call the parent Create method
  fmainDataModule := TMainDataModule.Create(AOwner);

end;

end.
