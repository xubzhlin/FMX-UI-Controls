unit Posix.lame;
(*
      author：xubzhlin
      e-mail: 371889755@qq.com
      tel: 18523843322
      date:  2008/12/31
      lame: 3.100

*)
(*
    初始化编码参数
    lame_init：初始化一个编码参数的数据结构，给使用者用来设置参数。

    设置编码参数
    lame_set_in_samplerate：设置被输入编码器的原始数据的采样率。
    lame_set_out_samplerate：设置最终mp3编码输出的声音的采样率，如果不设置则和输入采样率一样。
    lame_set_num_channels ：设置被输入编码器的原始数据的声道数。
    lame_set_mode ：设置最终mp3编码输出的声道模式，如果不设置则和输入声道数一样。参数是枚举，STEREO代表双声道，MONO代表单声道。
    lame_set_VBR：设置比特率控制模式，默认是CBR，但是通常我们都会设置VBR。参数是枚举，vbr_off代表CBR，vbr_abr代表ABR vbr_mtrh代表VBR。
    lame_set_brate：设置CBR的比特率，只有在CBR模式下才生效。
    lame_set_VBR_mean_bitrate_kbps：设置VBR的比特率，只有在VBR模式下才生效。

    初始化编码器器
    lame_init_params：根据上面设置好的参数建立编码器

    编码PCM数据
    lame_encode_buffer或lame_encode_buffer_interleaved：将PCM数据送入编码器，获取编码出的mp3数据。这些数据写入文件就是mp3文件。
    其中lame_encode_buffer输入的参数中是双声道的数据分别输入的，lame_encode_buffer_interleaved输入的参数中双声道数据是交错在一起输入的。具体使用哪个需要看采集到的数据是哪种格式的，不过现在的设备采集到的数据大部分都是双声道数据是交错在一起。
    单声道输入只能使用lame_encode_buffer，把单声道数据当成左声道数据传入，右声道传NULL即可。
    调用这两个函数时需要传入一块内存来获取编码器出的数据，这块内存的大小lame给出了一种建议的计算方式：采样率/20+7200。

    结束编码
    lame_encode_flush：刷新编码器缓冲，获取残留在编码器缓冲里的数据。这部分数据也需要写入mp3文件
*)


interface

uses
  Linker.Helper;

// 下面得定义 默认是关闭的 一般也不需要
// 我编译的libmap3lame 已经全部放开
// 这里的开关可以随意放开
// lame_init_old 无法使用 已经注释
{$DEFINE DEPRECATED_OR_OBSOLETE_CODE_REMOVED}    //移除 老的方法
{$DEFINE HAVE_MPGLIB}                            //加入 mpglib

const

{$IFDEF MSWINDOWS}
  liblame = 'mp3lame.dll';
{$ENDIF}
{$IFDEF ANDROID}
  liblame = 'libmp3lame.so';
{$ENDIF}
{$IFDEF LINUX}
  liblame = 'libmp3lame.so';
{$ENDIF LINUX}
{$IFDEF MACOS}
  {$IFDEF IOS}
    liblame = 'libmp3lame.a';
  {$ELSE}
    liblame = 'libmp3lame.dylib';
  {$ENDIF}
{$ENDIF}


(* maximum size of albumart image (128KB), which affects LAME_MAXMP3BUFFER
   as well since lame_encode_buffer() also returns ID3v2 tag data *)
  LAME_MAXALBUMART  =  128 * 1024;

(* maximum size of mp3buffer needed if you encode at most 1152 samples for
   each call to lame_encode_buffer.  see lame_encode_buffer() below
   (LAME_MAXMP3BUFFER is now obsolete)  *)
  LAME_MAXMP3BUFFER = 16384 + LAME_MAXALBUMART;

type
  lame_global_flags = Pointer;
  Tbitrate_count = array[0..13] of Byte;

type
	vbr_mode=(
	  vbr_off=0,
	  vbr_mt,                (* obsolete, same as vbr_mtrh *)
	  vbr_rh,
	  vbr_abr,
	  vbr_mtrh,
	  vbr_max_indicator,     (* Don't use this! It's used for sanity checks.       *)
	  vbr_default=vbr_mtrh     (* change this to change the default VBR mode of LAME *)
	);



	{ MPEG modes }
	MPEG_mode=(
	  STEREO = 0,
	  JOINT_STEREO,
	  DUAL_CHANNEL,    (* LAME doesn't supports this! *)
	  MONO,
	  NOT_SET,
	  MAX_INDICATOR    (* Don't use this! It's used for sanity checks. *)
	);

	{ Padding types }
	Padding_type=(
	  PAD_NO = 0,
	  PAD_ALL,
	  PAD_ADJUST,
	  PAD_MAX_INDICATOR    (* Don't use this! It's used for sanity checks. *)
	);

  preset_mode = (
     (*values from 8 to 320 should be reserved for abr bitrates*)
     (*for abr I'd suggest to directly use the targeted bitrate as a value*)
    ABR_8 = 8,
    ABR_320 = 320,
    V9 = 410,  (*Vx to match Lame and VBR_xx to match FhG*)
    VBR_10 = 410,
    V8 = 420,
    VBR_20 = 420,
    V7 = 430,
    VBR_30 = 430,
    V6 = 440,
    VBR_40 = 440,
    V5 = 450,
    VBR_50 = 450,
    V4 = 460,
    VBR_60 = 460,
    V3 = 470,
    VBR_70 = 470,
    V2 = 480,
    VBR_80 = 480,
    V1 = 490,
    VBR_90 = 490,
    V0 = 500,
    VBR_100 = 500,

     (*still there for compatibility*)
    R3MIX = 1000,
    STANDARD = 1001,
    EXTREME = 1002,
    INSANE = 1003,
    STANDARD_FAST = 1004,
    EXTREME_FAST = 1005,
    MEDIUM = 1006,
    MEDIUM_FAST = 1007
  );

  lame_errorcodes_t = (
    LAME_OKAY             =   0,
    LAME_NOERROR          =   0,
    LAME_GENERICERROR     =  -1,
    LAME_NOMEM            = -10,
    LAME_BADBITRATE       = -11,
    LAME_BADSAMPFREQ      = -12,
    LAME_INTERNALERROR    = -13,

    FRONTEND_READERROR    = -80,
    FRONTEND_WRITEERROR   = -81,
    FRONTEND_FILETOOLARGE = -82
  );

	{asm optimizations}
	asm_optimizations=(
	    MMX = 1,
	    AMD_3DNOW = 2,
	    SSE = 3
	);

	{ psychoacoustic model }
	Psy_model=(
	    PSY_GPSYCHO = 1,
	    PSY_NSPSYTUNE = 2
	);

	{ buffer considerations }
	buffer_constraint=(
	    MDB_DEFAULT=0,
	    MDB_STRICT_ISO=1,
	    MDB_MAXIMUM=2
	);

  (*
   * OPTIONAL:
   * get the version numbers in numerical form.
   *)
   Plame_version_t = ^lame_version_t;
   lame_version_t = packed record
    (* generic LAME version *)
    major: Integer;
    minor: Integer;
    alpha: Integer;               (* 0 if not an alpha version                  *)
    beta: Integer;               (* 0 if not a beta version                    *)

    (* version of the psy model *)
    psy_major: Integer;
    psy_minor: Integer;
    psy_alpha: Integer;           (* 0 if not an alpha version                  *)
    psy_beta: Integer;            (* 0 if not a beta version                    *)

    (* compile time features *)
    features: MarshaledAString;    (* Don't make assumptions about the contents! *)
   end;

  Pmp3data_struct = ^mp3data_struct;
  mp3data_struct = packed record
    header_parsed: Integer;   (* 1 if header was parsed and following data was
                                 computed                                       *)
    stereo: Integer;          (* number of channels                             *)
    samplerate: Integer;      (* sample rate                                    *)
    bitrate: Integer;         (* bitrate                                        *)
    mode: Integer;            (* mp3 frame type                                 *)
    mode_ext: Integer;        (* mp3 frame type                                 *)
    framesize: Integer;       (* number of samples per mp3 frame                *)

    (* this data is only computed if mpglib detects a Xing VBR header *)
    nsamp: LongWord;          (* number of samples in mp3 file.                 *)
    totalframes: Integer;     (* total number of frames in mp3 file             *)

    (* this data is not currently computed by the mpglib routines *)
    framenum: Integer;        (* frames decoded counter                         *)
  end;



Tlame_report_function = procedure(format: MarshaledAString; ap: array of const) of object;
//typedef void (*lame_report_function)(const char *format, va_list ap);
Thandler_function = procedure(parame1: Integer; parame2: MarshaledAString; parame3: Pointer) of object;
//void (*handler)(int, const char *, void *),

{
(***********************************************************************
 *
 *  The LAME API
 *  These functions should be called, in this order, for each
 *  MP3 file to be encoded.  See the file "API" for more documentation
 *
 ***********************************************************************)
 }

{
(*
 * REQUIRED:
 * initialize the encoder.  sets default for all encoder parameters,
 * returns NULL if some malloc()'s failed
 * otherwise returns pointer to structure needed for all future
 * API calls.
 *)
}

function lame_init: lame_global_flags; cdecl; external liblame name _PU + 'lame_init';
{$IFNDEF DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
//function lame_init_old(lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_init_old';
{$ENDIF}
{
(*
 * OPTIONAL:
 * set as needed to override defaults
 *)
}
{
(********************************************************************
 *  input stream description
 ***********************************************************************)
}

(* number of samples.  default = 2^32-1   *)
function lame_set_num_samples(lame: lame_global_flags; samples: Int64): Integer; cdecl; external liblame name _PU + 'lame_set_num_samples';
function lame_get_num_samples(const lame: lame_global_flags): Int64; cdecl; external liblame name _PU + 'lame_get_num_samples';

(* input sample rate in Hz.  default = 44100hz *)
function lame_set_in_samplerate(lame: lame_global_flags; rate: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_in_samplerate';
function lame_get_in_samplerate(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_in_samplerate';

(* number of channels in input stream. default=2  *)
function lame_set_num_channels(lame: lame_global_flags; channels: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_num_channels';
function lame_get_num_channels(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_num_channels';

{
(*
  scale the input by this amount before encoding.  default=1
  (not used by decoding routines)
*)
}
function lame_set_scale(lame: lame_global_flags; scale: Single): Integer; cdecl; external liblame name _PU + 'lame_set_scale';
function lame_get_scale(const lame: lame_global_flags): Single; cdecl; external liblame name _PU + 'lame_get_scale';

{
(*
  scale the channel 0 (left) input by this amount before encoding.  default=1
  (not used by decoding routines)
*)
}
function lame_set_scale_left(lame: lame_global_flags; scale: Single): Integer; cdecl; external liblame name _PU + 'lame_set_scale_left';
function lame_get_scale_left(const lame: lame_global_flags): Single; cdecl; external liblame name _PU + 'lame_get_scale_left';

{
(*
  scale the channel 1 (right) input by this amount before encoding.  default=1
  (not used by decoding routines)
*)
}
function lame_set_scale_right(lame: lame_global_flags; scale: Single): Integer; cdecl; external liblame name _PU + 'lame_set_scale_right';
function lame_get_scale_right(const lame: lame_global_flags): Single; cdecl; external liblame name _PU + 'lame_get_scale_right';

{
(*
  output sample rate in Hz.  default = 0, which means LAME picks best value
  based on the amount of compression.  MPEG only allows:
  MPEG1    32, 44.1,   48khz
  MPEG2    16, 22.05,  24
  MPEG2.5   8, 11.025, 12
  (not used by decoding routines)
*)
}
function lame_set_out_samplerate(lame: lame_global_flags; rate: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_out_samplerate';
function lame_get_out_samplerate(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_out_samplerate';

{
(********************************************************************
 *  general control parameters
 ***********************************************************************)
 }
(* 1=cause LAME to collect data for an MP3 frame analyzer. default=0 *)
function lame_set_analysis(lame: lame_global_flags; analyzer: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_analysis';
function lame_get_analysis(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_analysis';

{
(*
  1 = write a Xing VBR header frame.
  default = 1
  this variable must have been added by a Hungarian notation Windows programmer :-)
*)
}
function lame_set_bWriteVbrTag(lame: lame_global_flags; VbrTag: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_bWriteVbrTag';
function lame_get_bWriteVbrTag(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_bWriteVbrTag';

(* 1=decode only.  use lame/mpglib to convert mp3/ogg to wav.  default=0 *)
function lame_set_decode_only(lame: lame_global_flags; only: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_decode_only';
function lame_get_decode_only(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_decode_only';

{$IFNDEF DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
(* 1=encode a Vorbis .ogg file.  default=0 *)
function lame_set_ogg(lame: lame_global_flags; ogg: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_ogg';
function lame_get_ogg(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_ogg';
{$ENDIF}

{
(*
  internal algorithm selection.  True quality is determined by the bitrate
  but this variable will effect quality by selecting expensive or cheap algorithms.
  quality=0..9.  0=best (very slow).  9=worst.
  recommended:  2     near-best quality, not too slow
                5     good quality, fast
                7     ok quality, really fast
*)
}
function lame_set_quality(lame: lame_global_flags; quality: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_quality';
function lame_get_quality(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_quality';

{
(*
  mode = 0,1,2,3 = stereo, jstereo, dual channel (not supported), mono
  default: lame picks based on compression ration and input channels
*)
}
function lame_set_mode(lame: lame_global_flags; mode: MPEG_mode): Integer; cdecl; external liblame name _PU + 'lame_set_mode';
function lame_get_mode(const lame: lame_global_flags): MPEG_mode; cdecl; external liblame name _PU + 'lame_get_mode';

{$IFNDEF DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
{(*
  mode_automs.  Use a M/S mode with a switching threshold based on
  compression ratio
  DEPRECATED
*)}
function lame_set_mode_automs(lame: lame_global_flags; mode_automs: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_mode_automs';
function lame_get_mode_automs(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_mode_automs';
{$ENDIF}

{
(*
  force_ms.  Force M/S for all frames.  For testing only.
  default = 0 (disabled)
*)
*)}
function lame_set_force_ms(lame: lame_global_flags; force_ms: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_force_ms';
function lame_get_force_ms(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_force_ms';

(* use free_format?  default = 0 (disabled) *)
function lame_set_free_format(lame: lame_global_flags; free_format: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_free_format';
function lame_get_free_format(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_free_format';

(* perform ReplayGain analysis?  default = 0 (disabled) *)
function lame_set_findReplayGain(lame: lame_global_flags; ReplayGain: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_findReplayGain';
function lame_get_findReplayGain(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_findReplayGain';

{
(* decode on the fly. Search for the peak sample. If the ReplayGain
 * analysis is enabled then perform the analysis on the decoded data
 * stream. default = 0 (disabled)
 * NOTE: if this option is set the build-in decoder should not be used *)
}
function lame_set_decode_on_the_fly(lame: lame_global_flags; fly: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_decode_on_the_fly';
function lame_get_decode_on_the_fly(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_decode_on_the_fly';

{$IFNDEF DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
{
(* DEPRECATED: now does the same as lame_set_findReplayGain()
   default = 0 (disabled) *)
}
function lame_set_ReplayGain_input(lame: lame_global_flags; input: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_ReplayGain_input';
function lame_get_ReplayGain_input(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_ReplayGain_input';

{
(* DEPRECATED: now does the same as
   lame_set_decode_on_the_fly() && lame_set_findReplayGain()
   default = 0 (disabled) *)
}
function lame_set_ReplayGain_decode(lame: lame_global_flags; decode: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_ReplayGain_decode';
function lame_get_ReplayGain_decode(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_ReplayGain_decode';

{
(* DEPRECATED: now does the same as lame_set_decode_on_the_fly()
   default = 0 (disabled) *)
}
function lame_set_findPeakSample(lame: lame_global_flags; Sample: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_findPeakSample';
function lame_get_findPeakSample(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_findPeakSample';
{$ENDIF}

(* counters for gapless encoding *)
function lame_set_nogap_total(lame: lame_global_flags; total: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_nogap_total';
function lame_get_nogap_total(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_nogap_total';

function lame_set_nogap_currentindex(lame: lame_global_flags; currentindex: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_nogap_currentindex';
function lame_get_nogap_currentindex(const lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_nogap_currentindex';


(*
 * OPTIONAL:
 * Set printf like error/debug/message reporting functions.
 * The second argument has to be a pointer to a function which looks like
 *   void my_debugf(const char *format, va_list ap)
 *   {
 *       (void) vfprintf(stdout, format, ap);
 *   }
 * If you use NULL as the value of the pointer in the set function, the
 * lame buildin function will be used (prints to stderr).
 * To quiet any output you have to replace the body of the example function
 * with just "return;" and use it in the set function.
 *)
function lame_set_errorf(lame: lame_global_flags; report: Tlame_report_function):Integer; cdecl; external liblame name _PU + 'lame_set_errorf';
function lame_set_debugf(lame: lame_global_flags; report: Tlame_report_function):Integer; cdecl; external liblame name _PU + 'lame_set_debugf';
function lame_set_msgf(lame: lame_global_flags; report: Tlame_report_function):Integer; cdecl; external liblame name _PU + 'lame_set_msgf';

(* set one of brate compression ratio.  default is compression ratio of 11.  *)
function lame_set_brate(lame: lame_global_flags; brate: Integer):Integer; cdecl; external liblame name _PU + 'lame_set_brate';
function lame_get_brate(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_brate';
function lame_set_compression_ratio(lame: lame_global_flags; ratio: Single):Integer; cdecl; external liblame name _PU + 'lame_set_compression_ratio';
function lame_get_compression_ratio(lame: lame_global_flags):Single; cdecl; external liblame name _PU + 'lame_get_compression_ratio';

function lame_set_preset(lame: lame_global_flags; preset: Integer):Integer; cdecl; external liblame name _PU + 'lame_set_preset';
function lame_set_asm_optimizations(lame: lame_global_flags; option1, option2:Integer):Integer; cdecl; external liblame name _PU + 'lame_set_asm_optimizations';

(********************************************************************
 *  frame params
 ***********************************************************************)
(* mark as copyright.  default=0 *)
function lame_set_copyright(lame: lame_global_flags; copyright: Integer):Integer; cdecl; external liblame name _PU + 'lame_set_copyright';
function lame_get_copyright(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_copyright';

(* mark as original.  default=1 *)
function lame_set_original(lame: lame_global_flags; original: Integer):Integer; cdecl; external liblame name _PU + 'lame_set_original';
function lame_get_original(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_original';

(* error_protection.  Use 2 bytes from each frame for CRC checksum. default=0 *)
function lame_set_error_protection(lame: lame_global_flags; protection: Integer):Integer; cdecl; external liblame name _PU + 'lame_set_error_protection';
function lame_get_error_protection(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_error_protection';

{$IFNDEF DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
(* padding_type. 0=pad no frames  1=pad all frames 2=adjust padding(default) *)
function lame_set_padding_type(lame: lame_global_flags; padding: Padding_type):Integer; cdecl; external liblame name _PU + 'lame_set_padding_type';
function lame_get_padding_type(lame: lame_global_flags):Padding_type; cdecl; external liblame name _PU + 'lame_get_padding_type';
{$ENDIF}

(* MP3 'private extension' bit  Meaningless.  default=0 *)
function lame_set_extension(lame: lame_global_flags; extension: Integer):Integer; cdecl; external liblame name _PU + 'lame_set_extension';
function lame_get_extension(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_extension';

(* enforce strict ISO compliance.  default=0 *)
function lame_set_strict_ISO(lame: lame_global_flags; ISO: Integer):Integer; cdecl; external liblame name _PU + 'lame_set_strict_ISO';
function lame_get_strict_ISO(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_strict_ISO';

(********************************************************************
 * quantization/noise shaping
 ***********************************************************************)

(* disable the bit reservoir. For testing only. default=0 *)
function lame_set_disable_reservoir(lame: lame_global_flags; reservoir: Integer):Integer; cdecl; external liblame name _PU + 'lame_set_disable_reservoir';
function lame_get_disable_reservoir(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_disable_reservoir';

(* select a different "best quantization" function. default=0  *)
function lame_set_quant_comp(lame: lame_global_flags; comp: Integer):Integer; cdecl; external liblame name _PU + 'lame_set_quant_comp';
function lame_get_quant_comp(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_quant_comp';
function lame_set_quant_comp_short(lame: lame_global_flags; comp: Integer):Integer; cdecl; external liblame name _PU + 'lame_set_quant_comp_short';
function lame_get_quant_comp_short(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_quant_comp_short';

function lame_set_experimentalX(lame: lame_global_flags; experimentalX: Integer):Integer; cdecl; external liblame name _PU + 'lame_set_experimentalX';
function lame_get_experimentalX(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_experimentalX';

(* another experimental option.  for testing only *)
function lame_set_experimentalY(lame: lame_global_flags; experimentalY: Integer):Integer; cdecl; external liblame name _PU + 'lame_set_experimentalY';
function lame_get_experimentalY(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_experimentalY';

(* another experimental option.  for testing only *)
function lame_set_experimentalZ(lame: lame_global_flags; experimentalZ: Integer):Integer; cdecl; external liblame name _PU + 'lame_set_experimentalZ';
function lame_sgt_experimentalZ(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_experimentalZ';

(* Naoki's psycho acoustic model.  default=0 *)
function lame_set_exp_nspsytune(lame: lame_global_flags; exp: Integer):Integer; cdecl; external liblame name _PU + 'lame_set_exp_nspsytune';
function lame_get_exp_nspsytune(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_exp_nspsytune';

procedure lame_set_msfix(lame: lame_global_flags; msfix: Double); cdecl; external liblame name _PU + 'lame_set_msfix';
function lame_get_msfix(lame: lame_global_flags):Single; cdecl; external liblame name _PU + 'lame_get_msfix';

(********************************************************************
 * VBR control
 **********************************************************************)
(* Types of VBR.  default = vbr_off = CBR *)
function lame_set_VBR(lame: lame_global_flags; VBR: vbr_mode): Integer; cdecl; external liblame name _PU + 'lame_set_VBR';
function lame_get_VBR(lame: lame_global_flags):vbr_mode; cdecl; external liblame name _PU + 'lame_get_VBR';

(* VBR quality level.  0=highest  9=lowest  *)
function lame_set_VBR_q(lame: lame_global_flags; quality: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_VBR_q';
function lame_get_VBR_q(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_VBR_q';

(* VBR quality level.  0=highest  9=lowest, Range [0,...,10[  *)
function lame_set_VBR_quality(lame: lame_global_flags; quality: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_VBR_quality';
function lame_get_VBR_quality(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_VBR_quality';

(* Ignored except for VBR=vbr_abr (ABR mode) *)
function lame_set_VBR_mean_bitrate_kbps(lame: lame_global_flags; kbps: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_VBR_mean_bitrate_kbps';
function lame_get_VBR_mean_bitrate_kbps(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_VBR_mean_bitrate_kbps';

function lame_set_VBR_min_bitrate_kbps(lame: lame_global_flags; kbps: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_VBR_min_bitrate_kbps';
function lame_get_VBR_min_bitrate_kbps(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_VBR_min_bitrate_kbps';

function lame_set_VBR_max_bitrate_kbps(lame: lame_global_flags; kbps: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_VBR_max_bitrate_kbps';
function lame_get_VBR_max_bitrate_kbps(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_VBR_max_bitrate_kbps';

(*
  1=strictly enforce VBR_min_bitrate.  Normally it will be violated for
  analog silence
*)
function lame_set_VBR_hard_min(lame: lame_global_flags; kbps: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_VBR_hard_min';
function lame_get_VBR_hard_min(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_VBR_hard_min';

{$IFNDEF DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
(* for preset *)
function lame_set_preset_expopts(lame: lame_global_flags; preset: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_preset_expopts';
{$ENDIF}

(********************************************************************
 * Filtering control
 ***********************************************************************)
(* freq in Hz to apply lowpass. Default = 0 = lame chooses.  -1 = disabled *)
function lame_set_lowpassfreq(lame: lame_global_flags; freq: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_lowpassfreq';
function lame_get_lowpassfreq(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_lowpassfreq';

(* width of transition band, in Hz.  Default = one polyphase filter band *)
function lame_set_lowpasswidth(lame: lame_global_flags; width: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_lowpasswidth';
function lame_get_lowpasswidth(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_lowpasswidth';

(* freq in Hz to apply highpass. Default = 0 = lame chooses.  -1 = disabled *)
function lame_set_highpassfreq(lame: lame_global_flags; freq: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_highpassfreq';
function lame_get_highpassfreq(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_highpassfreq';

(* width of transition band, in Hz.  Default = one polyphase filter band *)
function lame_set_highpasswidth(lame: lame_global_flags; width: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_highpasswidth';
function lame_get_highpasswidth(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_highpasswidth';

(********************************************************************
 * psycho acoustics and other arguments which you should not change
 * unless you know what you are doing
 ***********************************************************************)

(* only use ATH for masking *)
function lame_set_ATHonly(lame: lame_global_flags; ATHonly: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_ATHonly';
function lame_get_ATHonly(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_ATHonly';

(* only use ATH for short blocks *)
function lame_set_ATHshort(lame: lame_global_flags; ATHshort: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_ATHshort';
function lame_get_ATHshort(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_ATHshort';

(* disable ATH *)
function lame_set_noATH(lame: lame_global_flags; noATH: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_noATH';
function lame_get_noATH(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_noATH';

(* select ATH formula *)
function lame_set_ATHtype(lame: lame_global_flags; ATHtype: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_ATHtype';
function lame_get_ATHtype(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_ATHtype';

(* lower ATH by this many db *)
function lame_set_ATHlower(lame: lame_global_flags; ATHlower: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_ATHlower';
function lame_get_ATHlower(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_ATHlower';

(* select ATH adaptive adjustment type *)
function lame_set_athaa_type(lame: lame_global_flags; athaa_type: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_athaa_type';
function lame_get_athaa_type(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_athaa_type';

{$IFNDEF DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
(* select the loudness approximation used by the ATH adaptive auto-leveling  *)
function lame_set_athaa_loudapprox(lame: lame_global_flags; loudapprox: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_athaa_loudapprox';
function lame_get_athaa_loudapprox(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_athaa_loudapprox';
{$ENDIF}

(* adjust (in dB) the point below which adaptive ATH level adjustment occurs *)
function lame_set_athaa_sensitivity(lame: lame_global_flags; sensitivity: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_athaa_sensitivity';
function lame_get_athaa_sensitivity(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_athaa_sensitivity';

{$IFNDEF DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
(* OBSOLETE: predictability limit (ISO tonality formula) *)
function lame_set_cwlimit(lame: lame_global_flags; cwlimit: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_cwlimit';
function lame_get_cwlimit(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_cwlimit';
{$ENDIF}

(*
  allow blocktypes to differ between channels?
  default: 0 for jstereo, 1 for stereo
*)
function lame_set_allow_diff_short(lame: lame_global_flags; diff: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_allow_diff_short';
function lame_get_allow_diff_short(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_allow_diff_short';

(* use temporal masking effect (default = 1) *)
function lame_set_useTemporal(lame: lame_global_flags; useTemporal: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_useTemporal';
function lame_get_useTemporal(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_useTemporal';

(* use temporal masking effect (default = 1) *)
function lame_set_interChRatio(lame: lame_global_flags; Ratio: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_interChRatio';
function lame_get_interChRatio(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_interChRatio';

(* disable short blocks *)
function lame_set_no_short_blocks(lame: lame_global_flags; blocks: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_no_short_blocks';
function lame_get_no_short_blocks(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_no_short_blocks';

(* force short blocks *)
function lame_set_force_short_blocks(lame: lame_global_flags; blocks: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_force_short_blocks';
function lame_get_force_short_blocks(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_force_short_blocks';

(* Input PCM is emphased PCM (for instance from one of the rarely
   emphased CDs), it is STRONGLY not recommended to use this, because
   psycho does not take it into account, and last but not least many decoders
   ignore these bits *)
function lame_set_emphasis(lame: lame_global_flags; emphasis: Integer): Integer; cdecl; external liblame name _PU + 'lame_set_emphasis';
function lame_get_emphasis(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_emphasis';


(************************************************************************)
(* internal variables, cannot be set...                                 *)
(* provided because they may be of use to calling application           *)
(************************************************************************)
(* version  0=MPEG-2  1=MPEG-1  (2=MPEG-2.5)     *)
function lame_get_version(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_version';

(* encoder delay   *)
function lame_get_encoder_delay(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_encoder_delay';

(*
  padding appended to the input to make sure decoder can fully decode
  all input.  Note that this value can only be calculated during the
  call to lame_encoder_flush().  Before lame_encoder_flush() has
  been called, the value of encoder_padding = 0.
*)
function lame_get_encoder_padding(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_encoder_padding';

(* size of MPEG frame *)
function lame_get_framesize(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_framesize';

(* number of PCM samples buffered, but not yet encoded to mp3 data. *)
function lame_get_mf_samples_to_encode(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_mf_samples_to_encode';

(*
  size (bytes) of mp3 data buffered, but not yet encoded.
  this is the number of bytes which would be output by a call to
  lame_encode_flush_nogap.  NOTE: lame_encode_flush() will return
  more bytes than this because it will encode the reamining buffered
  PCM samples before flushing the mp3 buffers.
*)
function lame_get_size_mp3buffer(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_size_mp3buffer';


(* number of frames encoded so far *)
function lame_get_frameNum(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_frameNum';

(*
  lame's estimate of the total number of frames to be encoded
   only valid if calling program set num_samples
*)
function lame_get_totalframes(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_totalframes';

(* RadioGain value. Multiplied by 10 and rounded to the nearest. *)
function lame_get_RadioGain(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_RadioGain';

(* AudiophileGain value. Multipled by 10 and rounded to the nearest. *)
function lame_get_AudiophileGain(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_AudiophileGain';

(* the peak sample *)
function lame_get_PeakSample(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_PeakSample';

(* Gain change required for preventing clipping. The value is correct only if
   peak sample searching was enabled. If negative then the waveform
   already does not clip. The value is multiplied by 10 and rounded up. *)
function lame_get_noclipGainChange(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_noclipGainChange';

(* user-specified scale factor required for preventing clipping. Value is
   correct only if peak sample searching was enabled and no user-specified
   scaling was performed. If negative then either the waveform already does
   not clip or the value cannot be determined *)
function lame_get_noclipScale(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_get_noclipScale';

(* returns the limit of PCM samples, which one can pass in an encode call
   under the constrain of a provided buffer of size buffer_size *)
function lame_get_maximum_number_of_samples(lame: lame_global_flags; buffer_size: NativeInt):Integer; cdecl; external liblame name _PU + 'lame_get_maximum_number_of_samples';

(*
 * REQUIRED:
 * sets more internal configuration based on data provided above.
 * returns -1 if something failed.
 *)
 function lame_init_params(lame: lame_global_flags):Integer; cdecl; external liblame name _PU + 'lame_init_params';

(*
 * OPTIONAL:
 * get the version number, in a string. of the form:
 * "3.63 (beta)" or just "3.63".
 *)
function get_lame_version: MarshaledAString; cdecl; external liblame name _PU + 'get_lame_version';
function get_lame_short_version: MarshaledAString; cdecl; external liblame name _PU + 'get_lame_version';
function get_lame_very_short_version: MarshaledAString; cdecl; external liblame name _PU + 'get_lame_version';
function get_psy_version: MarshaledAString; cdecl; external liblame name _PU + 'get_lame_version';
function get_lame_url: MarshaledAString; cdecl; external liblame name _PU + 'get_lame_version';
function get_lame_os_bitness: MarshaledAString; cdecl; external liblame name _PU + 'get_lame_version';

procedure get_lame_version_numerical(version: Plame_version_t); cdecl; external liblame name _PU + 'get_lame_version_numerical';

(*
 * OPTIONAL:
 * print internal lame configuration to message handler
*)
procedure lame_print_config(lame: lame_global_flags); cdecl; external liblame name _PU + 'lame_print_config';
procedure lame_print_internals(lame: lame_global_flags); cdecl; external liblame name _PU + 'lame_print_internals';

(*
 * input pcm data, output (maybe) mp3 frames.
 * This routine handles all buffering, resampling and filtering for you.
 *
 * return code     number of bytes output in mp3buf. Can be 0
 *                 -1:  mp3buf was too small
 *                 -2:  malloc() problem
 *                 -3:  lame_init_params() not called
 *                 -4:  psycho acoustic problems
 *
 * The required mp3buf_size can be computed from num_samples,
 * samplerate and encoding rate, but here is a worst case estimate:
 *
 * mp3buf_size in bytes = 1.25*num_samples + 7200
 *
 * I think a tighter bound could be:  (mt, March 2000)
 * MPEG1:
 *    num_samples*(bitrate/8)/samplerate + 4*1152*(bitrate/8)/samplerate + 512
 * MPEG2:
 *    num_samples*(bitrate/8)/samplerate + 4*576*(bitrate/8)/samplerate + 256
 *
 * but test first if you use that!
 *
 * set mp3buf_size = 0 and LAME will not check if mp3buf_size is
 * large enough.
 *
 * NOTE:
 * if gfp->num_channels=2, but gfp->mode = 3 (mono), the L & R channels
 * will be averaged into the L channel before encoding only the L channel
 * This will overwrite the data in buffer_l[] and buffer_r[].
 *
*)
function lame_encode_buffer(
        lame: lame_global_flags;             (* global context handle         *)
        const buffer_l: PSmallint;   (* PCM data for left channel     *)
        const buffer_r: PSmallint;   (* PCM data for right channel    *)
        const nsamples: Integer;             (* number of samples per channel *)
        mp3buf: PByte;                       (* pointer to encoded MP3 stream *)
        const mp3buf_size: Integer)          (* number of valid octets in this stream*)
        : Integer;cdecl; external liblame name _PU + 'lame_print_internals';
(*
int CDECL lame_encode_buffer (
        lame_global_flags*  gfp,           /* global context handle         */
        const short int     buffer_l [],   /* PCM data for left channel     */
        const short int     buffer_r [],   /* PCM data for right channel    */
        const int           nsamples,      /* number of samples per channel */
        unsigned char*      mp3buf,        /* pointer to encoded MP3 stream */
        const int           mp3buf_size ); /* number of valid octets in this
                                              stream                        */
*)

(*
 * as above, but input has L & R channel data interleaved.
 * NOTE:
 * num_samples = number of samples in the L (or R)
 * channel, not the total number of samples in pcm[]
 *)
function lame_encode_buffer_interleaved(
      lame: lame_global_flags;
      pcm: PSmallint;
      nsamples: Integer;
      mp3buf: PByte;
      const mp3buf_size: Integer)
      : Integer;cdecl; external liblame name _PU + 'lame_encode_buffer_interleaved';
(*
int CDECL lame_encode_buffer_interleaved(
        lame_global_flags*  gfp,           /* global context handlei        */
        short int           pcm[],         /* PCM data for left and right
                                              channel, interleaved          */
        int                 num_samples,   /* number of samples per channel,
                                              _not_ number of samples in
                                              pcm[]                         */
        unsigned char*      mp3buf,        /* pointer to encoded MP3 stream */
        int                 mp3buf_size ); /* number of valid octets in this
                                              stream                        */

*)
(* as lame_encode_buffer, but for 'float's.
 * !! NOTE: !! data must still be scaled to be in the same range as
 * short int, +/- 32768
 *)
function lame_encode_buffer_float(
      lame: lame_global_flags;
      const pcm_l: PSingle;
      const pcm_r: PSingle;
      const nsamples: Integer;
      mp3buf: PByte;
      const mp3buf_size: Integer)
      : Integer;cdecl; external liblame name _PU + 'lame_encode_buffer_float';
(*
int CDECL lame_encode_buffer_float(
        lame_global_flags*  gfp,           /* global context handle         */
        const float         pcm_l [],      /* PCM data for left channel     */
        const float         pcm_r [],      /* PCM data for right channel    */
        const int           nsamples,      /* number of samples per channel */
        unsigned char*      mp3buf,        /* pointer to encoded MP3 stream */
        const int           mp3buf_size ); /* number of valid octets in this
                                              stream                        */
*)
(* as lame_encode_buffer, but for 'float's.
 * !! NOTE: !! data must be scaled to +/- 1 full scale
 *)
function lame_encode_buffer_ieee_float(
    lame: lame_global_flags;
    const pcm_l: PSingle;
    const pcm_r: PSingle;
    const nsamples: Integer;
    mp3buf: PByte;
    const mp3buf_size: Integer)
    : Integer;cdecl; external liblame name _PU + 'lame_encode_buffer_ieee_float';
(*
int CDECL lame_encode_buffer_ieee_float(
        lame_t          gfp,
        const float     pcm_l [],          /* PCM data for left channel     */
        const float     pcm_r [],          /* PCM data for right channel    */
        const int       nsamples,
        unsigned char * mp3buf,
        const int       mp3buf_size);
*)
function lame_encode_buffer_interleaved_ieee_float(
    lame: lame_global_flags;
    const pcm: PSingle;
    const nsamples: Integer;
    mp3buf: PByte;
    const mp3buf_size: Integer)
    : Integer;cdecl; external liblame name _PU + 'lame_encode_buffer_interleaved_ieee_float';
(*
int CDECL lame_encode_buffer_interleaved_ieee_float(
        lame_t          gfp,
        const float     pcm[],             /* PCM data for left and right
                                              channel, interleaved          */
        const int       nsamples,
        unsigned char * mp3buf,
        const int       mp3buf_size);
*)
(* as lame_encode_buffer, but for 'double's.
 * !! NOTE: !! data must be scaled to +/- 1 full scale
 *)
function lame_encode_buffer_ieee_double(
    lame: lame_global_flags;
    const pcm_l: PDouble;
    const pcm_r: PDouble;
    const nsamples: Integer;
    mp3buf: PByte;
    const mp3buf_size: Integer)
    : Integer;cdecl; external liblame name _PU + 'lame_encode_buffer_ieee_double';
(*
int CDECL lame_encode_buffer_ieee_double(
        lame_t          gfp,
        const double    pcm_l [],          /* PCM data for left channel     */
        const double    pcm_r [],          /* PCM data for right channel    */
        const int       nsamples,
        unsigned char * mp3buf,
        const int       mp3buf_size);
*)
function lame_encode_buffer_interleaved_ieee_double(
    lame: lame_global_flags;
    const pcm: PDouble;
    const nsamples: Integer;
    mp3buf: PByte;
    const mp3buf_size: Integer)
    : Integer;cdecl; external liblame name _PU + 'lame_encode_buffer_interleaved_ieee_double';
(*
int CDECL lame_encode_buffer_interleaved_ieee_double(
        lame_t          gfp,
        const double    pcm[],             /* PCM data for left and right
                                              channel, interleaved          */
        const int       nsamples,
        unsigned char * mp3buf,
        const int       mp3buf_size);
*)
(* as lame_encode_buffer, but for long's
 * !! NOTE: !! data must still be scaled to be in the same range as
 * short int, +/- 32768
 *
 * This scaling was a mistake (doesn't allow one to exploit full
 * precision of type 'long'.  Use lame_encode_buffer_long2() instead.
 *
 *)
function lame_encode_buffer_long(
    lame: lame_global_flags;
    const pcm_l: PLongInt;
    const pcm_r: PLongInt;
    const nsamples: Integer;
    mp3buf: PByte;
    const mp3buf_size: Integer)
    : Integer;cdecl; external liblame name _PU + 'lame_encode_buffer_long';
(*
int CDECL lame_encode_buffer_long(
        lame_global_flags*  gfp,           /* global context handle         */
        const long     buffer_l [],       /* PCM data for left channel     */
        const long     buffer_r [],       /* PCM data for right channel    */
        const int           nsamples,      /* number of samples per channel */
        unsigned char*      mp3buf,        /* pointer to encoded MP3 stream */
        const int           mp3buf_size ); /* number of valid octets in this
                                              stream                        */
*)
(* Same as lame_encode_buffer_long(), but with correct scaling.
 * !! NOTE: !! data must still be scaled to be in the same range as
 * type 'long'.   Data should be in the range:  +/- 2^(8*size(long)-1)
 *
 *)
function lame_encode_buffer_long2(
    lame: lame_global_flags;
    const pcm_l: PLongInt;
    const pcm_r: PLongInt;
    const nsamples: Integer;
    mp3buf: PByte;
    const mp3buf_size: Integer)
    : Integer;cdecl; external liblame name _PU + 'lame_encode_buffer_long2';
(*
int CDECL lame_encode_buffer_long2(
        lame_global_flags*  gfp,           /* global context handle         */
        const long     buffer_l [],       /* PCM data for left channel     */
        const long     buffer_r [],       /* PCM data for right channel    */
        const int           nsamples,      /* number of samples per channel */
        unsigned char*      mp3buf,        /* pointer to encoded MP3 stream */
        const int           mp3buf_size ); /* number of valid octets in this
                                              stream                        */
*)

(* as lame_encode_buffer, but for int's
 * !! NOTE: !! input should be scaled to the maximum range of 'int'
 * If int is 4 bytes, then the values should range from
 * +/- 2147483648.
 *
 * This routine does not (and cannot, without loosing precision) use
 * the same scaling as the rest of the lame_encode_buffer() routines.
 *
 *)
function lame_encode_buffer_int(
    lame: lame_global_flags;
    const pcm_l: PInteger;
    const pcm_r: PInteger;
    const nsamples: Integer;
    mp3buf: PByte;
    const mp3buf_size: Integer)
    : Integer;cdecl; external liblame name _PU + 'lame_encode_buffer_int';
(*
int CDECL lame_encode_buffer_int(
        lame_global_flags*  gfp,           /* global context handle         */
        const int      buffer_l [],       /* PCM data for left channel     */
        const int      buffer_r [],       /* PCM data for right channel    */
        const int           nsamples,      /* number of samples per channel */
        unsigned char*      mp3buf,        /* pointer to encoded MP3 stream */
        const int           mp3buf_size ); /* number of valid octets in this
                                              stream                        */
*)
(*
 * as above, but for interleaved data.
 * !! NOTE: !! data must still be scaled to be in the same range as
 * type 'int32_t'.   Data should be in the range:  +/- 2^(8*size(int32_t)-1)
 * NOTE:
 * num_samples = number of samples in the L (or R)
 * channel, not the total number of samples in pcm[]
 *)
function lame_encode_buffer_interleaved_int(
    lame: lame_global_flags;
    const pcm: PInteger;
    const nsamples: Integer;
    mp3buf: PByte;
    const mp3buf_size: Integer)
    : Integer;cdecl; external liblame name _PU + 'lame_encode_buffer_interleaved_int';
(*
int
lame_encode_buffer_interleaved_int(
        lame_t          gfp,
        const int       pcm [],            /* PCM data for left and right
                                              channel, interleaved          */
        const int       nsamples,          /* number of samples per channel,
                                              _not_ number of samples in
                                              pcm[]                         */
        unsigned char*  mp3buf,            /* pointer to encoded MP3 stream */
        const int       mp3buf_size );     /* number of valid octets in this
                                              stream                        */
*)


(*
 * REQUIRED:
 * lame_encode_flush will flush the intenal PCM buffers, padding with
 * 0's to make sure the final frame is complete, and then flush
 * the internal MP3 buffers, and thus may return a
 * final few mp3 frames.  'mp3buf' should be at least 7200 bytes long
 * to hold all possible emitted data.
 *
 * will also write id3v1 tags (if any) into the bitstream
 *
 * return code = number of bytes output to mp3buf. Can be 0
 *)
function lame_encode_flush(
    lame: lame_global_flags;
    mp3buf: PByte;
    size: Integer)
    : Integer;cdecl; external liblame name _PU + 'lame_encode_flush';
(*
int CDECL lame_encode_flush(
        lame_global_flags *  gfp,    /* global context handle                 */
        unsigned char*       mp3buf, /* pointer to encoded MP3 stream         */
        int                  size);  /* number of valid octets in this stream */
*)

(*
 * OPTIONAL:
 * lame_encode_flush_nogap will flush the internal mp3 buffers and pad
 * the last frame with ancillary data so it is a complete mp3 frame.
 *
 * 'mp3buf' should be at least 7200 bytes long
 * to hold all possible emitted data.
 *
 * After a call to this routine, the outputed mp3 data is complete, but
 * you may continue to encode new PCM samples and write future mp3 data
 * to a different file.  The two mp3 files will play back with no gaps
 * if they are concatenated together.
 *
 * This routine will NOT write id3v1 tags into the bitstream.
 *
 * return code = number of bytes output to mp3buf. Can be 0
 *)
function lame_encode_flush_nogap(
    lame: lame_global_flags;
    mp3buf: PByte;
    size: Integer)
    : Integer;cdecl; external liblame name _PU + 'lame_encode_flush_nogap';
(*
int CDECL lame_encode_flush_nogap(
        lame_global_flags *  gfp,    /* global context handle                 */
        unsigned char*       mp3buf, /* pointer to encoded MP3 stream         */
        int                  size);  /* number of valid octets in this stream */
*)
(*
 * OPTIONAL:
 * Normally, this is called by lame_init_params().  It writes id3v2 and
 * Xing headers into the front of the bitstream, and sets frame counters
 * and bitrate histogram data to 0.  You can also call this after
 * lame_encode_flush_nogap().
 *)
(* global context handle *)
function lame_init_bitstream(lame: lame_global_flags): Integer;cdecl; external liblame name _PU + 'lame_init_bitstream';

(*
 * OPTIONAL:    some simple statistics
 * a bitrate histogram to visualize the distribution of used frame sizes
 * a stereo mode histogram to visualize the distribution of used stereo
 *   modes, useful in joint-stereo mode only
 *   0: LR    left-right encoded
 *   1: LR-I  left-right and intensity encoded (currently not supported)
 *   2: MS    mid-side encoded
 *   3: MS-I  mid-side and intensity encoded (currently not supported)
 *
 * attention: don't call them after lame_encode_finish
 * suggested: lame_encode_flush -> lame_*_hist -> lame_close
 *)

procedure lame_bitrate_hist(lame: lame_global_flags; bitrate_count: Tbitrate_count);cdecl; external liblame name _PU + 'lame_bitrate_hist';
procedure lame_bitrate_kbps(lame: lame_global_flags; bitrate_count: Tbitrate_count);cdecl; external liblame name _PU + 'lame_bitrate_kbps';
procedure lame_stereo_mode_hist(lame: lame_global_flags; bitrate_count: Tbitrate_count);cdecl; external liblame name _PU + 'lame_stereo_mode_hist';
procedure lame_bitrate_stereo_mode_hist(lame: lame_global_flags; bitrate_count: Tbitrate_count);cdecl; external liblame name _PU + 'lame_bitrate_stereo_mode_hist';
procedure lame_block_type_hist(lame: lame_global_flags; bitrate_count: Tbitrate_count);cdecl; external liblame name _PU + 'lame_block_type_hist';
procedure lame_bitrate_block_type_hist(lame: lame_global_flags; bitrate_count: Tbitrate_count);cdecl; external liblame name _PU + 'lame_bitrate_block_type_hist';


{$IFNDEF DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
(*
 * OPTIONAL:
 * lame_mp3_tags_fid will rewrite a Xing VBR tag to the mp3 file with file
 * pointer fid.  These calls perform forward and backwards seeks, so make
 * sure fid is a real file.  Make sure lame_encode_flush has been called,
 * and all mp3 data has been written to the file before calling this
 * function.
 * NOTE:
 * if VBR  tags are turned off by the user, or turned off by LAME because
 * the output is not a regular file, this call does nothing
 * NOTE:
 * LAME wants to read from the file to skip an optional ID3v2 tag, so
 * make sure you opened the file for writing and reading.
 * NOTE:
 * You can call lame_get_lametag_frame instead, if you want to insert
 * the lametag yourself.
*)
//void CDECL lame_mp3_tags_fid(lame_global_flags *, FILE* fid);
procedure lame_mp3_tags_fid(lame: lame_global_flags; fid: Nativeint); cdecl; external liblame name _PU + 'lame_mp3_tags_fid';
{$ENDIF}

(*
 * OPTIONAL:
 * lame_get_lametag_frame copies the final LAME-tag into 'buffer'.
 * The function returns the number of bytes copied into buffer, or
 * the required buffer size, if the provided buffer is too small.
 * Function failed, if the return value is larger than 'size'!
 * Make sure lame_encode flush has been called before calling this function.
 * NOTE:
 * if VBR  tags are turned off by the user, or turned off by LAME,
 * this call does nothing and returns 0.
 * NOTE:
 * LAME inserted an empty frame in the beginning of mp3 audio data,
 * which you have to replace by the final LAME-tag frame after encoding.
 * In case there is no ID3v2 tag, usually this frame will be the very first
 * data in your mp3 file. If you put some other leading data into your
 * file, you'll have to do some bookkeeping about where to write this buffer.
 *)
function lame_get_lametag_frame(const lame: lame_global_flags; buffer: Pointer; fid: Pointer; size: NativeInt): NativeInt; cdecl; external liblame name _PU + 'lame_get_lametag_frame';


(*
 * REQUIRED:
 * final call to free all remaining buffers
 *)
function lame_close(lame: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_close';

{$IFNDEF DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
(*
 * OBSOLETE:
 * lame_encode_finish combines lame_encode_flush() and lame_close() in
 * one call.  However, once this call is made, the statistics routines
 * will no longer work because the data will have been cleared, and
 * lame_mp3_tags_fid() cannot be called to add data to the VBR header
 *)
function lame_encode_finish(lame: lame_global_flags; mp3buf: PByte; size: Integer): Integer; cdecl; external liblame name _PU + 'lame_close';
{$ENDIF}



(*********************************************************************
 *
 * decoding
 *
 * a simple interface to mpglib, part of mpg123, is also included if
 * libmp3lame is compiled with HAVE_MPGLIB
 *
 *********************************************************************)
{$IFNDEF HAVE_MPGLIB}
(* required call to initialize decoder *)
function hip_decode_init: hip_t; cdecl; external liblame name _PU + 'hip_decode_init';

(* cleanup call to exit decoder  *)
function hip_decode_exit(gfp: hip_t): Pointer; cdecl; external liblame name _PU + 'hip_decode_exit';

(* HIP reporting functions *)
procedure hip_set_errorf(gfp: hip_t; report: lame_report_function); cdecl; external liblame name _PU + 'hip_set_errorf';
procedure hip_set_debugf(gfp: hip_t; report: lame_report_function); cdecl; external liblame name _PU + 'hip_set_debugf';
procedure hip_set_msgf(gfp: hip_t; report: lame_report_function); cdecl; external liblame name _PU + 'hip_set_msgf';

(*********************************************************************
 * input 1 mp3 frame, output (maybe) pcm data.
 *
 *  nout = hip_decode(hip, mp3buf,len,pcm_l,pcm_r);
 *
 * input:
 *    len          :  number of bytes of mp3 data in mp3buf
 *    mp3buf[len]  :  mp3 data to be decoded
 *
 * output:
 *    nout:  -1    : decoding error
 *            0    : need more data before we can complete the decode
 *           >0    : returned 'nout' samples worth of data in pcm_l,pcm_r
 *    pcm_l[nout]  : left channel data
 *    pcm_r[nout]  : right channel data
 *
 *********************************************************************)
function hip_decode(gfp: hip_t; mp3buf: PByte; len: NativeInt; pcm_l: array of SmallInt;
  pcm_r: array of SmallInt): Integer; cdecl; external liblame name _PU + 'hip_decode';

(* same as hip_decode, and also returns mp3 header data *)
function hip_decode_headers(gfp: hip_t; mp3buf: PByte; len: NativeInt; pcm_l: array of SmallInt;
  pcm_r: array of SmallInt; mp3data: Pmp3data_struct): Integer; cdecl; external liblame name _PU + 'hip_decode_headers';

(* same as hip_decode, but returns at most one frame *)
function hip_decode1(gfp: hip_t; mp3buf: PByte; len: NativeInt; pcm_l: array of SmallInt;
  pcm_r: array of SmallInt): Integer; cdecl; external liblame name _PU + 'hip_decode';


(* same as hip_decode1, but returns at most one frame and mp3 header data *)
function hip_decode1_headers(gfp: hip_t; mp3buf: PByte; len: NativeInt; pcm_l: array of SmallInt;
  pcm_r: array of SmallInt; mp3data: Pmp3data_struct): Integer; cdecl; external liblame name _PU + 'hip_decode1_headers';

(* same as hip_decode1_headers, but also returns enc_delay and enc_padding
   from VBR Info tag, (-1 if no info tag was found) *)
function hip_decode1_headersB(gfp: hip_t; mp3buf: PByte; len: NativeInt; pcm_l: array of SmallInt;
  pcm_r: array of SmallInt; mp3data: Pmp3data_struct; var enc_delay: Integer; var enc_padding: Integer)
  : Integer; cdecl; external liblame name _PU + 'hip_decode1_headersB';
{$ENDIF}
(* OBSOLETE:
 * lame_decode... functions are there to keep old code working
 * but it is strongly recommended to replace calls by hip_decode...
 * function calls, see above.
 *)
{$IFNDEF DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
function lame_decode_init: Integer; cdecl; external liblame name _PU + 'lame_decode_init';
function lame_decode(mp3buf: PByte; len: Integer; pcm_l: array of SmallInt;
  pcm_r: array of SmallInt): Integer; cdecl; external liblame name _PU + 'lame_decode';
function lame_decode_headers(mp3buf: PByte; len: Integer; pcm_l: array of SmallInt;
  pcm_r: array of SmallInt; mp3data: Pmp3data_struct): Integer; cdecl; external liblame name _PU + 'lame_decode_headers';
function lame_decode1(mp3buf: PByte; len: Integer; pcm_l: array of SmallInt;
  pcm_r: array of SmallInt): Integer; cdecl; external liblame name _PU + 'lame_decode1';
function lame_decode1_headers(mp3buf: PByte; len: Integer; pcm_l: array of SmallInt;
  pcm_r: array of SmallInt; mp3data: Pmp3data_struct): Integer; cdecl; external liblame name _PU + 'lame_decode1_headers';
function lame_decode1_headersB(mp3buf: PByte; len: Integer; pcm_l: array of SmallInt;
  pcm_r: array of SmallInt; mp3data: Pmp3data_struct): Integer; cdecl; external liblame name _PU + 'lame_decode1_headersB';
function lame_decode_exit: Integer; cdecl; external liblame name _PU + 'lame_decode_exit';
{$ENDIF}
(* obsolete lame_decode API calls *)


(*********************************************************************
 *
 * id3tag stuff
 *
 *********************************************************************)

(*
 * id3tag.h -- Interface to write ID3 version 1 and 2 tags.
 *
 * Copyright (C) 2000 Don Melton.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
 *)

(* utility to obtain alphabetically sorted list of genre names with numbers *)
procedure id3tag_genre_list(handler: Thandler_function; cookie: Pointer); cdecl; external liblame name _PU + 'id3tag_genre_list';
//void CDECL id3tag_genre_list(
//        void (*handler)(int, const char *, void *),
//        void*  cookie);
procedure id3tag_init(gfp: lame_global_flags); cdecl; external liblame name _PU + 'id3tag_init';

(* force addition of version 2 tag *)
procedure id3tag_add_v2(gfp: lame_global_flags); cdecl; external liblame name _PU + 'id3tag_add_v2';

(* add only a version 1 tag *)
procedure id3tag_v1_only(gfp: lame_global_flags); cdecl; external liblame name _PU + 'id3tag_v1_only';

(* add only a version 2 tag *)
procedure id3tag_v2_only(gfp: lame_global_flags); cdecl; external liblame name _PU + 'id3tag_v2_only';

(* pad version 1 tag with spaces instead of nulls *)
procedure id3tag_space_v1(gfp: lame_global_flags); cdecl; external liblame name _PU + 'id3tag_space_v1';

(* pad version 2 tag with extra 128 bytes *)
procedure id3tag_pad_v2(gfp: lame_global_flags); cdecl; external liblame name _PU + 'id3tag_pad_v2';

(* pad version 2 tag with extra n bytes *)
procedure id3tag_set_pad(gfp: lame_global_flags; n: NativeInt); cdecl; external liblame name _PU + 'id3tag_set_pad';
procedure id3tag_set_title(gfp: lame_global_flags; title: MarshaledAString); cdecl; external liblame name _PU + 'id3tag_set_title';
procedure id3tag_set_artist(gfp: lame_global_flags; artist: MarshaledAString); cdecl; external liblame name _PU + 'id3tag_set_artist';
procedure id3tag_set_album(gfp: lame_global_flags; album: MarshaledAString); cdecl; external liblame name _PU + 'id3tag_set_album';
procedure id3tag_set_year(gfp: lame_global_flags; year: MarshaledAString); cdecl; external liblame name _PU + 'id3tag_set_year';
procedure id3tag_set_comment(gfp: lame_global_flags; comment: MarshaledAString); cdecl; external liblame name _PU + 'id3tag_set_comment';

(* return -1 result if track number is out of ID3v1 range
                    and ignored for ID3v1 *)
function id3tag_set_track(gfp: lame_global_flags; track: MarshaledAString): Integer; cdecl; external liblame name _PU + 'id3tag_set_track';

(* return non-zero result if genre name or number is invalid
  result 0: OK
  result -1: genre number out of range
  result -2: no valid ID3v1 genre name, mapped to ID3v1 'Other'
             but taken as-is for ID3v2 genre tag *)
function id3tag_set_genre(gfp: lame_global_flags; genre: MarshaledAString): Integer; cdecl; external liblame name _PU + 'id3tag_set_genre';

(* return non-zero result if field name is invalid *)
function id3tag_set_fieldvalue(gfp: lame_global_flags; fieldvalue: MarshaledAString): Integer; cdecl; external liblame name _PU + 'id3tag_set_fieldvalue';

(* return non-zero result if image type is invalid *)
function id3tag_set_albumart(gfp: lame_global_flags; image: MarshaledAString; size: NativeInt): Integer; cdecl; external liblame name _PU + 'id3tag_set_albumart';

(* lame_get_id3v1_tag copies ID3v1 tag into buffer.
 * Function returns number of bytes copied into buffer, or number
 * of bytes rquired if buffer 'size' is too small.
 * Function fails, if returned value is larger than 'size'.
 * NOTE:
 * This functions does nothing, if user/LAME disabled ID3v1 tag.
 *)
function lame_get_id3v1_tag(gfp: lame_global_flags; buffer: PByte; size: NativeInt): NativeInt; cdecl; external liblame name _PU + 'lame_get_id3v1_tag';

(* lame_get_id3v2_tag copies ID3v2 tag into buffer.
 * Function returns number of bytes copied into buffer, or number
 * of bytes rquired if buffer 'size' is too small.
 * Function fails, if returned value is larger than 'size'.
 * NOTE:
 * This functions does nothing, if user/LAME disabled ID3v2 tag.
 *)
function lame_get_id3v2_tag(gfp: lame_global_flags; buffer: PByte; size: NativeInt): NativeInt; cdecl; external liblame name _PU + 'lame_get_id3v2_tag';

(* normaly lame_init_param writes ID3v2 tags into the audio stream
 * Call lame_set_write_id3tag_automatic(gfp, 0) before lame_init_param
 * to turn off this behaviour and get ID3v2 tag with above function
 * write it yourself into your file.
 *)
procedure lame_set_write_id3tag_automatic(gfp: lame_global_flags; automatic: Integer); cdecl; external liblame name _PU + 'lame_set_write_id3tag_automatic';
function lame_get_write_id3tag_automatic(gfp: lame_global_flags): Integer; cdecl; external liblame name _PU + 'lame_get_write_id3tag_automatic';

(* experimental *)
function id3tag_set_textinfo_latin1(gfp: lame_global_flags; id: MarshaledAString; text: MarshaledAString): Integer; cdecl; external liblame name _PU + 'id3tag_set_textinfo_latin1';

(* experimental *)
function id3tag_set_comment_latin1(gfp: lame_global_flags; lang: MarshaledAString; desc: MarshaledAString; text: MarshaledAString): Integer; cdecl; external liblame name _PU + 'id3tag_set_comment_latin1';

{$IFNDEF DEPRECATED_OR_OBSOLETE_CODE_REMOVED}
(* experimental *)
function id3tag_set_textinfo_ucs2(gfp: lame_global_flags; const id: MarshaledAString; const text: PByte): Integer; cdecl; external liblame name _PU + 'id3tag_set_textinfo_ucs2';
(* experimental *)
function id3tag_set_comment_ucs2(gfp: lame_global_flags; const lang: MarshaledAString; const desc: PByte; const text: PByte): Integer; cdecl; external liblame name _PU + 'id3tag_set_comment_ucs2';
(* experimental *)
function id3tag_set_fieldvalue_ucs2(gfp: lame_global_flags; const fieldvalue: PByte): Integer; cdecl; external liblame name _PU + 'id3tag_set_fieldvalue_ucs2';
{$ENDIF}
(* experimental *)
function id3tag_set_fieldvalue_utf16(gfp: lame_global_flags; const fieldvalue: PByte): Integer; cdecl; external liblame name _PU + 'id3tag_set_fieldvalue_utf16';
(* experimental *)
function id3tag_set_textinfo_utf16(gfp: lame_global_flags; const id: MarshaledAString; const text: PByte): Integer; cdecl; external liblame name _PU + 'id3tag_set_fieldvalue_utf16';
(* experimental *)
function id3tag_set_comment_utf16(gfp: lame_global_flags; const lang: MarshaledAString; const desc: PByte; const text: PByte): Integer; cdecl; external liblame name _PU + 'id3tag_set_comment_utf16';



(***********************************************************************
*
*  list of valid bitrates [kbps] & sample frequencies [Hz].
*  first index: 0: MPEG-2   values  (sample frequencies 16...24 kHz)
*               1: MPEG-1   values  (sample frequencies 32...48 kHz)
*               2: MPEG-2.5 values  (sample frequencies  8...12 kHz)
***********************************************************************)
//
//extern const int     bitrate_table    [3][16];
//extern const int     samplerate_table [3][ 4];
//
//(* access functions for use in DLL, global vars are not exported *)
function lame_get_bitrate(mpeg_version: Integer; table_index: Integer): Integer; cdecl; external liblame name _PU + 'lame_get_bitrate';
function lame_get_samplerate(mpeg_version: Integer; table_index: Integer): Integer; cdecl; external liblame name _PU + 'lame_get_samplerate';

implementation


end.
