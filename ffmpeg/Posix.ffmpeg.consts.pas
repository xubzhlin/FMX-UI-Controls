unit Posix.ffmpeg.consts;

interface

{$IFDEF ANDROID}
{$DEFINE HAVE_FFMPEG_MERGE}  //ffmpeg 是否合并成一个库
{$ENDIF}
{$DEFINE HAVE_INLINE}        //是否合使用inline


const
{$IFDEF HAVE_FFMPEG_MERGE}
  {$IFDEF MSWINDOWS}
    libffmpeg = 'ffmpeg.dll';
  {$ENDIF}
  {$IFDEF ANDROID}
    libffmpeg = 'libffmpeg.so';
  {$ENDIF}
  {$IFDEF LINUX}
    libffmpeg = 'libffmpeg.so';
  {$ENDIF LINUX}
  {$IFDEF MACOS}
    {$IFDEF IOS}
      libffmpeg = 'libffmpeg.a';
    {$ELSE}
      libffmpeg = 'libffmpeg.dylib';
    {$ENDIF}
  {$ENDIF}
  libavcodec = libffmpeg;
  libavdevice = libffmpeg;
  libavfilter = libffmpeg;
  libavformat = libffmpeg;
  libavutil = libffmpeg;
  libpostproc = libffmpeg;
  libswresample = libffmpeg;
  libswscale = libffmpeg;
{$ELSE}
  {$IFDEF MSWINDOWS}
    libavutil = 'avutil-56.dll';
    libavcodec = 'avcodec-58.dll';
    libavdevice = 'avdevice-58.dll';
    libavfilter = 'avfilter.dll-7';
    libavformat = 'avformat-58.dll';
    libpostproc = 'postproc.dll';
    libswresample = 'swresample-3.dll';
    libswscale = 'swscale-5';
  {$ENDIF}
  {$IFDEF ANDROID}
    libavutil = 'libavutil.so';
    libavcodec = 'libavcodec .so';
    libavdevice = 'libavdevice.so';
    libavfilter = 'libavfilter.so';
    libavformat = 'libavformat.so';
    libpostproc = 'libpostproc.so';
    libswresample = 'libswresample.so';
    libswscale = 'libswscale.so';
  {$ENDIF}
  {$IFDEF LINUX}
    libavutil = 'libavutil.so';
    libavcodec = 'libavcodec .so';
    libavdevice = 'libavdevice.so';
    libavfilter = 'libavfilter.so';
    libavformat = 'libavformat.so';
    libpostproc = 'libpostproc.so';
    libswresample = 'libswresample.so';
    libswscale = 'libswscale.so';
  {$ENDIF LINUX}
  {$IFDEF MACOS}
    {$IFDEF IOS}
      libavutil = 'libavutil.a';
      libavcodec = 'libavcodec .a';
      libavdevice = 'libavdevice.a';
      libavfilter = 'libavfilter.a';
      libavformat = 'libavformat.a';
      libpostproc = 'libpostproc.a';
      libswresample = 'libswresample.a';
      libswscale = 'libswscale.a';
    {$ELSE}
      libavutil = 'libavutil.dylib';
      libavcodec = 'libavcodec .dylib';
      libavdevice = 'libavdevice.dylib';
      libavfilter = 'libavfilter.dylib';
      libavformat = 'libavformat.dylib';
      libpostproc = 'libpostproc.dylib';
      libswresample = 'libswresample.dylib';
      libswscale = 'libswscale.dylib';
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

type
  Ptm = ^tm;
  tm = record
    tm_sec: Integer;            // Seconds. [0-60] (1 leap second)
    tm_min: Integer;            // Minutes. [0-59]
    tm_hour: Integer;           // Hours.[0-23]
    tm_mday: Integer;           // Day.[1-31]
    tm_mon: Integer;            // Month.[0-11]
    tm_year: Integer;           // Year since 1900
    tm_wday: Integer;           // Day of week [0-6] (Sunday = 0)
    tm_yday: Integer;           // Days of year [0-365]
    tm_isdst: Integer;          // Daylight Savings flag [-1/0/1]
    tm_gmtoff: LongInt;         // Seconds east of UTC
    tm_zone: MarshaledAString;         // Timezone abbreviation
  end;

  PPByte = PByte;


//function av_version_info: MarshaledAString; cdecl; external libffmpeg name _PU + 'av_version_info';
//function avformat_version: MarshaledAString; cdecl; external libffmpeg name _PU + 'avformat_version';
//function swresample_version: MarshaledAString; cdecl; external libffmpeg name _PU + 'swresample_version';
//function avdevice_version: MarshaledAString; cdecl; external libffmpeg name _PU + 'avdevice_version';
//function postproc_version: MarshaledAString; cdecl; external libffmpeg name _PU + 'postproc_version';
//function swscale_version: MarshaledAString; cdecl; external libffmpeg name _PU + 'swscale_version';


implementation

end.
