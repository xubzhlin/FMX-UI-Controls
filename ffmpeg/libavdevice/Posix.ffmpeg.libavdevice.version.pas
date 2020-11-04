unit Posix.ffmpeg.libavdevice.version;

interface

uses
  Posix.ffmpeg.libavutil.version, Posix.ffmpeg.libavutil.macros;

const
  LIBAVDEVICE_VERSION_MAJOR  =   58;
  LIBAVDEVICE_VERSION_MINOR  =    5;
  LIBAVDEVICE_VERSION_MICRO  =  100;


(**
 * FF_API_* defines may be placed below to indicate public API that will be
 * dropped at a future version bump. The defines themselves are not part of
 * the public API and may change, break or disappear at any time.
 *)

function LIBAVDEVICE_VERSION_INT: Integer;
function LIBAVDEVICE_VERSION_STR: string;
function LIBAVDEVICE_BUILD: Integer;
function LIBAVDEVICE_IDENT: string;

implementation

function LIBAVDEVICE_VERSION_INT: Integer;
begin
  Result := AV_VERSION_INT(LIBAVDEVICE_VERSION_MAJOR, LIBAVDEVICE_VERSION_MINOR, LIBAVDEVICE_VERSION_MICRO);
end;

function LIBAVDEVICE_VERSION_STR: string;
begin
  Result := AV_VERSION(LIBAVDEVICE_VERSION_MAJOR, LIBAVDEVICE_VERSION_MINOR, LIBAVDEVICE_VERSION_MICRO);
end;

function LIBAVDEVICE_BUILD: Integer;
begin
  Result := LIBAVDEVICE_VERSION_INT;
end;

function LIBAVDEVICE_IDENT: string;
begin
  Result := 'Lavd' + AV_STRINGIFY(LIBAVDEVICE_VERSION_STR);
end;

end.
