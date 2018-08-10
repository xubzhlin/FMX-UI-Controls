unit uOpenFileServiceUnit;
//调用系统应用打开文件

interface

uses
{$IFDEF Android}
  Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Net, Androidapi.JNI.JavaTypes,
  Androidapi.Helpers,
{$ENDIF}
{$IFDEF iOS}
  iOSapi.UIKit, iOSapi.Foundation, FMX.Platform.iOS, FMX.Forms, Macapi.Helpers, iOSapi.CoreGraphics,
  FMX.Helpers.iOS,
{$ENDIF}
  System.SysUtils, System.IOUtils, FMX.Dialogs;


procedure OpenFile(FullPath:string);

implementation

uses
  FMX.Types, uLogsUnit {$IFDEF iOS}, Macapi.ObjectiveC {$ENDIF};


type
  TFileType = (ftnone, ft3gp, ftapk, ftasf, ftavi, ftbin, ftbmp, ftc, ftclass, ftconf, ctcpp, ftdoc,
    ftdocx, ftxls ,ftxlsx, ftexe, ftgif, ftgtar, ftgz, fth, fthtm, fthtml, ftjar, ftjava, ftjpeg, ftjpg,
    ftjs, ftlog, ftm3u, ftm4a, ftm4b, ftm4p, ftm4u, ftm4v, ftmov, ftmp2, ftmp3, ftmp4, ftmpc,
    ftmpe, ftmpeg, ftmpg, ftmpg4, ftmpga, ftmsg, ftogg, ftpdf, ftpng, ftpps, ftppt, ftpptx,
    ftprop, ftrmvb, ftsh,fttgz, ftwav, ftwmv, ftwps, ftz, ftzip, ftrc, ftrtf, fttar, fttxt, ftwma, ftxml);

const
  TFileTypeExt:array[TFileType] of string = ('', '.3gp', '.apk', '.asf', '.avi', '.bin', '.bmp', '.c', '.class', '.conf', '.cpp', '.doc',
    '.docx', '.xls ','.xlsx', '.exe', '.gif', '.gtar', '.gz', '.h', 'htm', '.html', '.jar', '.java', '.jpeg', '.jpg',
    '.js', '.log', '.m3u', '.m4a', '.m4b', '.m4p', '.m4u', '.m4v', '.mov', '.mp2', '.mp3', '.mp4', '.mpc',
    '.mpe', '.mpeg', '.mpg', '.mpg4', '.mpga', '.msg', '.ogg', '.pdf', '.png', '.pps', '.ppt', '.pptx',
    '.prop', '.rmvb', '.sh','.tgz', '.wav', '.wmv', '.wps', '.z', '.zip', '.rc', '.rtf', '.tar', '.txt', '.wma', '.xml');

  TFileTypeMIME:array[TFileType] of string = ('*/*', 'video/3gpp', 'application/vnd.android.package-archive', 'video/x-ms-asf',
    'video/x-msvideo', 'application/octet-stream', 'image/bmp', 'text/plain', 'application/octet-stream', 'text/plain',
    'text/plain', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-excel ', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/octet-stream',
    'image/gif', 'application/x-gtar', 'application/x-gzip', 'text/plain', 'text/html', 'text/html', 'application/java-archive',
    'text/plain', 'image/jpeg', 'image/jpeg', 'application/x-javascript', 'text/plain', 'audio/x-mpegurl', 'audio/mp4a-latm',
    'audio/mp4a-latm', 'audio/mp4a-latm', 'video/vnd.mpegurl', 'video/x-m4v', 'video/quicktime', 'audio/x-mpeg', 'audio/x-mpeg',
    'video/mp4', 'application/vnd.mpohun.certificate', 'video/mpeg', 'video/mpeg', 'video/mpeg', 'video/mp4', 'audio/mpeg',
    'application/vnd.ms-outlook', 'audio/ogg', 'application/pdf', 'image/png', 'application/vnd.ms-powerpoint',
    'application/vnd.ms-powerpoint', 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'text/plain', 'audio/x-pn-realaudio', 'text/plain','application/x-compressed', 'audio/x-wav"', 'audio/x-ms-wmv',
    'application/vnd.ms-works', 'application/x-compress', 'application/x-zip-compressed', 'text/plain', 'application/rtf',
    'application/x-tar', 'text/plain', 'audio/x-ms-wma', 'text/plain');


{$IFDEF Android}
procedure OpenFile(FullPath:string);
var
  Ext:string;
  MIME:string;
  FileType:TFileType;
  JavaFile:JFile;
  Intent:JIntent;
  Uri:Jnet_Uri;
begin
  Ext:=ExtractFileExt(FullPath);
  for FileType:=Low(TFileType) to High(TFileType) do
  begin
    if TFileTypeExt[FileType] = Ext then
    begin
      MIME := TFileTypeMIME[FileType];
      JavaFile := TJFile.JavaClass.init(StringToJString(FullPath));
      Uri := TJnet_Uri.JavaClass.fromFile(JavaFile);
      Intent := TJIntent.JavaClass.init;
      Intent.setDataAndType(Uri, StringToJString(MIME));
      try
        SharedActivityContext.startActivity(Intent);
      except
        Showmessage('找不到打开此文件的应用！');
      end;
    end;
  end;
  
end;
{$ENDIF}

{$IFDEF iOS}
procedure OpenFile(FullPath:string);
var
  URL:NSURL;
  View:UIView;
  Rect:CGRect;
  Controller:UIDocumentInteractionController;
begin
  URL := TNSURL.Wrap(TNSURL.OCClass.fileURLWithPath(StrToNSStr(FullPath)));
  Controller := TUIDocumentInteractionController.Wrap(TUIDocumentInteractionController.OCClass.interactionControllerWithURL(URL));
  View := WindowHandleToPlatform(Application.MainForm.Handle).View;

  if IsPad then
    Rect :=  CGRectMake((View.bounds.size.width - 300) / 2, (View.bounds.size.height - 300) / 2, 300, 300)
  else
    Rect := View.bounds;
  Controller.presentOptionsMenuFromRect(Rect, View, True);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
procedure OpenFile(FullPath:string);
begin

end;
{$ENDIF}


end.
