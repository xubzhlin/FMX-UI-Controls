unit Posix.ffmpeg.libavdevice.avdevice;

interface

uses
  Posix.ffmpeg.libavutil.samplefmt, Posix.ffmpeg.libavutil.rational, Posix.ffmpeg.libavutil.pixfmt,
  Posix.ffmpeg.libavformat.avformat, Posix.ffmpeg.libavcodec.avcodec;


type
  PAVDeviceInfo = ^AVDeviceInfo;
  AVDeviceInfo = record
    device_name: MarshaledAString;
    device_description: MarshaledAString;
  end;

  PAVDeviceInfoList = ^AVDeviceInfoList;
  AVDeviceInfoList = record
    devices: PAVDeviceInfo;
    nb_devices: Integer;
    default_device: Integer;
  end;


  PAVDeviceCapabilitiesQuery = ^AVDeviceCapabilitiesQuery;
  AVDeviceCapabilitiesQuery = record
    av_class: Pointer;
    device_context: PAVFormatContext;
    codec: AVCodecID ;
    sample_format: AVSampleFormat;
    pixel_format: AVPixelFormat;
    sample_rate: Integer;
    channels: Integer;
    channel_layout: Int64;
    window_width: Integer;
    window_height: Integer;
    frame_width: Integer;
    frame_height: Integer;
    fps: AVRational;
  end;

implementation

end.
