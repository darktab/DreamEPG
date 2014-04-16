unit USettings;

interface

uses
  System.Classes, System.SysUtils, Data.DBXJSONReflect, FMX.Dialogs,
  System.IOUtils, Data.DBXJSON;

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
  fFilename := 'Settings.json';
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
var
  lJSONUnMarshaller: TJSONUnMarshal;
  lTextFile: TextFile;
  ltext: String;
  lJSONObject: TJSONValue;
  lJSONString: String;
  lSettings: TSettings;
begin
  // Création du unmarshaller
  lJSONUnMarshaller := TJSONUnMarshal.Create;
  // change to Document directoy
  ChDir(TPath.GetDocumentsPath);
  // assignation du fichier text de settings
  AssignFile(lTextFile, fFilename);
  // open file for reading
  Reset(lTextFile);
  // Display the file contents
  while not Eof(lTextFile) do
  begin
    ReadLn(lTextFile, ltext);
    lJSONString := lJSONString + ltext;
  end;
  // Close the file for the last time
  CloseFile(lTextFile);
  // unmarshall to local instance
  lJSONObject := TJSONObject.ParseJSONValue(lJSONString) as TJSONObject;
  lSettings := TSettings(lJSONUnMarshaller.Unmarshal(lJSONObject));
  // copying values to this instance
  fBoxAddress := lSettings.BoxAddress;
  fUsername := lSettings.Username;
  fPassword := lSettings.Password;
  if Assigned(lSettings) then
  begin
    FreeAndNil(lSettings);
  end;
  if (Assigned(lJSONUnMarshaller)) then
  begin
    FreeAndNil(lJSONUnMarshaller);
  end;
end;

procedure TSettings.write;
var
  lJSONMarshaller: TJSONMarshal;
  lTextFile: TextFile;

  lJSONString: String;
begin
  // Création du marshaller
  lJSONMarshaller := TJSONMarshal.Create(TJSONConverter.Create);
  // marchalling en string
  lJSONString := lJSONMarshaller.Marshal(self).ToString;
  // change to Document directoy
  ChDir(TPath.GetDocumentsPath);
  // assignation du fichier text de settings
  AssignFile(lTextFile, fFilename);
  ReWrite(lTextFile);
  // Ecriture du fichier
  WriteLn(lTextFile, lJSONString);
  // Fermeture du fichier
  CloseFile(lTextFile);
  // destruction du marshaller
  if (Assigned(lJSONMarshaller)) then
  begin
    FreeAndNil(lJSONMarshaller);
  end;
end;

end.
