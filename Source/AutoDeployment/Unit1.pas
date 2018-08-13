unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Layouts,
  FMX.ScrollBox, FMX.Memo, System.Masks, System.Generics.Collections,
  FMX.ComboEdit, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc;

const
  cDeployHeader = '<DeployFile LocalName="%s" Configuration="%s" Class="File">';
  cDeployFooter = '</DeployFile>';
  cPlatform = #9'<Platform Name="%s">'
              +#13#10#9#9'<RemoteDir>%s</RemoteDir>'
              +#13#10#9#9'<RemoteName>%s</RemoteName>'
              +#13#10#9#9'<Overwrite>true</Overwrite>'
              +#13#10#9'</Platform>';

type
  TLocalFileRec = record
    LocalPath:String;
    RemotePath:String;
    LocalName:String;
  end;

  TForm15 = class(TForm)
    layoutFolderPath: TLayout;
    layoutSDKTransPath2: TLayout;
    FolderPath: TEdit;
    btnSDKTransPathRef: TButton;
    Label1: TLabel;
    Layout1: TLayout;
    Text1: TText;
    Text2: TText;
    Layout2: TLayout;
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    Deploy: TButton;
    Release: TCheckBox;
    Debug: TCheckBox;
    Android: TCheckBox;
    iOS32: TCheckBox;
    iOS64: TCheckBox;
    iOSSimulator: TCheckBox;
    OSX: TCheckBox;
    Text3: TText;
    Text4: TText;
    ComboEdit1: TComboEdit;
    ComboEdit2: TComboEdit;
    ComboEdit3: TComboEdit;
    CheckBox2: TCheckBox;
    procedure btnSDKTransPathRefClick(Sender: TObject);
    procedure DeployClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FRootPath:string;
    FlieList:TList<TLocalFileRec>;
    Platforms:TStringList;
    Configurations:TStringList;

    procedure GetFileListEx(FilePath, ExtMask: string; FileList: TList<TLocalFileRec>; SubDirectory: Boolean = True); overload;
    procedure GetFileListEx(RemotePath, FilePath, ExtMask: string; RemotePathLen:Integer; FileList: TList<TLocalFileRec>; SubDirectory: Boolean = True); overload;
    function GetRelativePath(FilePath:string):string;
  public
    { Public declarations }
  end;

var
  Form15: TForm15;

implementation

{$R *.fmx}

procedure TForm15.btnSDKTransPathRefClick(Sender: TObject);
var
  Dir:string;
begin
  if (SelectDirectory('选择需要部署的文件夹', '', Dir)) then
    FolderPath.Text := Dir;
  Dir:=GetRelativePath(Dir);
end;

procedure TForm15.DeployClick(Sender: TObject);
var
  i,j,k:integer;
  APlatform:String;
  AConfiguration:String;
  AFlieName:String;
  ALocalPath:String;
  ARemotePath:String;
begin

  try
   //开始生产部署
    if FlieList = nil then
      FlieList:=TList<TLocalFileRec>.Create;
    if Configurations = nil then
      Configurations:=TStringList.Create;
    if Platforms = nil then
      Platforms:=TStringList.Create;
    if Release.IsChecked then
      Configurations.Add('Release');
    if Debug.IsChecked then
    Configurations.Add('Debug');

    if Configurations.Count=0 then
      raise Exception.Create('请选择需要部署的 Configuration ');

    if Android.IsChecked then
      Platforms.Add('Android');
    if iOS32.IsChecked then
      Platforms.Add('iOSDevice32');
    if iOS64.IsChecked then
      Platforms.Add('iOSDevice64');
    if OSX.IsChecked then
      Platforms.Add('OSX32');
    if Platforms.Count = 0 then
      raise Exception.Create('请选择需要部署的 Platform ');

    Memo1.Lines.Clear;
    GetFileListEx(FolderPath.Text, '',FlieList, not CheckBox1.IsChecked);
    for i := 0 to FlieList.Count - 1 do
    begin
      AFlieName:=FlieList[i].LocalName;
      ALocalPath:=FlieList[i].LocalPath + FlieList[i].LocalName;
      for j := 0 to Configurations.Count - 1 do
      begin
        AConfiguration:=Configurations[j];
        Memo1.Lines.Add(Format(cDeployHeader, [ALocalPath, AConfiguration]));
        for k := 0 to Platforms.Count - 1 do
        begin
          APlatform:=Platforms[k];
          if APlatform = 'Android' then
          begin
            if (ComboEdit1.Text = '') and (not CheckBox2.IsChecked) then
              ARemotePath:='.\'
            else
              ARemotePath:=ComboEdit1.Text + FlieList[i].RemotePath;
          end
          else
          if APlatform = 'OSX' then
          begin
            if (ComboEdit2.Text = '') and (not CheckBox2.IsChecked) then
              ARemotePath:='.\'
            else
              ARemotePath:=ComboEdit2.Text + FlieList[i].RemotePath;
          end
          else
          if (APlatform = 'iOSDevice64') or (APlatform = 'iOSDevice32') or (APlatform = 'iOSSimulator') then
          begin
            if (ComboEdit3.Text = '') and (not CheckBox2.IsChecked) then
              ARemotePath:='.\'
            else
              ARemotePath:=ComboEdit3.Text + FlieList[i].RemotePath;
          end;

          Memo1.Lines.Add(Format(cPlatform, [APlatform, ARemotePath,  AFlieName]));
        end;
        Memo1.Lines.Add(cDeployFooter);
      end;
    end;

  finally
    Platforms.Clear;
    Configurations.Clear;
    FlieList.Clear;
  end;

end;

procedure TForm15.FormCreate(Sender: TObject);
begin
  //获取本地路径
  FRootPath:=ExtractFilePath(ParamStr(0));
end;

procedure TForm15.GetFileListEx(RemotePath, FilePath, ExtMask: string; RemotePathLen:Integer;
  FileList: TList<TLocalFileRec>; SubDirectory: Boolean);
  function Match(FileName: string; MaskList: TStrings): Boolean;
  var
    i: integer;
  begin
    if MaskList.Count = 0 then
      Result:=True
    else
      Result := False;
    for i := 0 to MaskList.Count - 1 do
    begin
      if MatchesMask(FileName, MaskList[i]) then
      begin
        Result := True;
        break;
      end;
    end;
  end;

var
  i:integer;
  FileRec: TSearchRec;
  MaskList: TStringList;
  LocalRec:TLocalFileRec;
begin
  if DirectoryExists(FilePath) then
  begin
    if FilePath[Length(FilePath)] <> '\' then
      FilePath := FilePath + '\';
    if FindFirst(FilePath + '*.*', faAnyFile, FileRec) = 0 then
    begin
      MaskList := TStringList.Create;
      try
        ExtractStrings([';'], [], PWideChar(ExtMask), MaskList);

        repeat
          if ((FileRec.Attr and faDirectory) <> 0) and SubDirectory then
          begin
            if (FileRec.Name <> '.') and (FileRec.Name <> '..') then
              GetFileListEx(RemotePath, FilePath + FileRec.Name + '\', ExtMask, RemotePathLen, FileList, SubDirectory);
          end
          else
          begin
            if Match(FilePath + FileRec.Name, MaskList) then
            begin
              LocalRec.LocalPath:=GetRelativePath(FilePath);
              LocalRec.RemotePath:=Copy(FilePath, RemotePathLen+1, Length(FilePath) - RemotePathLen);
              LocalRec.LocalName:=FileRec.Name;
              FileList.Add(LocalRec);
            end;
          end;
        until FindNext(FileRec) <> 0;

      finally
        MaskList.Free;
      end;
    end;
    FindClose(FileRec);
  end;

end;

function TForm15.GetRelativePath(FilePath: string): string;
begin
  Result:=FilePath;
  if Pos(FRootPath, FilePath, 1) = 1 then
    Result:=FilePath.Replace(FRootPath, '');
end;

procedure TForm15.GetFileListEx(FilePath, ExtMask: string;
  FileList: TList<TLocalFileRec>; SubDirectory: Boolean);
var
  AIndex:Integer;
  RemotePath:String;
begin
  //确保  不是 '/' 结束的
  AIndex := Length(FilePath) - 1;
  repeat
    if FilePath[AIndex] = '\' then
    begin
      RemotePath := Copy(FilePath, 1, AIndex - 1);
      Break;
    end;
    Dec(AIndex);
  until AIndex<0;
  if FilePath[Length(RemotePath)] <> '\' then
    RemotePath := RemotePath + '\';
  GetFileListEx(RemotePath, FilePath, ExtMask,  Length(RemotePath), FileList, SubDirectory);
end;

end.
