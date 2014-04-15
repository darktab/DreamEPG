unit USettings;

interface

uses
  System.Classes, System.SysUtils, Data.DBXJSONReflect, FMX.Dialogs;

type
  TSettings = class(TObject)
  private
    { Private declarations }

    // to be marshalled to JSON
    fFilename: String;
    fBoxAddress: String;
    fUsername: String;
    fPassword: String;

  protected
    { Protected declarations }

  public
    { Public declarations }
    constructor Create;
    destructor Destroy;
    procedure write;
    procedure read;
  published
    { Published declarations }
    Property BoxAddress: String read fBoxAddress write fBoxAddress;
    Property Username: String read fUsername write fUsername;
    Property Password: String read fPassword write fPassword;
  end;

implementation

constructor TSettings.Create;
begin
  fBoxAddress := '';
  fUsername := '';
  fPassword := '';
end;

destructor TSettings.Destroy;
begin
  { if (Assigned(fJSONMarshaller)) then
    begin
    FreeAndNil(fJSONMarshaller);
    end;
    if (Assigned(fJSONUnMarshaller)) then
    begin
    FreeAndNil(fJSONUnMarshaller);
    end; }
end;

procedure TSettings.read;
begin

end;

procedure TSettings.write;
var
  lJSONMarshaller: TJSONMarshal;
  lJSONUnMarshaller: TJSONUnMarshal;
  lJSONString: String;
begin
  lJSONMarshaller := TJSONMarshal.Create(TJSONConverter.Create);
  lJSONUnMarshaller := TJSONUnMarshal.Create;

  lJSONString := lJSONMarshaller.Marshal(self).ToString;
  ShowMessage(lJSONString);

end;

end.
