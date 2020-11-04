unit Posix.ffmpeg.libavfilter.buffersink;

(*
 * This file is part of FFmpeg.
 *
 * FFmpeg is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * FFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with FFmpeg; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 *)

interface

uses
  Linker.Helper, Posix.ffmpeg.consts, Posix.ffmpeg.libavutil.pixfmt, Posix.ffmpeg.libavutil.frame,
  Posix.ffmpeg.libavutil.samplefmt, Posix.ffmpeg.libavutil.rational, Posix.ffmpeg.libavutil.avutil,
  Posix.ffmpeg.libavutil.buffer, Posix.ffmpeg.libavfilter.avfilter;

const
(**
 * Tell av_buffersink_get_buffer_ref() to read video/samples buffer
 * reference, but not remove it from the buffer. This is useful if you
 * need only to read a video/samples buffer, without to fetch it.
 *)
  AV_BUFFERSINK_FLAG_PEEK = 1;

(**
 * Tell av_buffersink_get_buffer_ref() not to request a frame from its input.
 * If a frame is already buffered, it is read (and removed from the buffer),
 * but if no frame is present, return AVERROR(EAGAIN).
 *)
  AV_BUFFERSINK_FLAG_NO_REQUEST = 2;


type
(**
 * Struct to use for initializing a buffersink context.
 *)
  PAVBufferSinkParams = ^AVBufferSinkParams;
  AVBufferSinkParams = record
    pixel_fmts: PAVPixelFormat; ///< list of allowed pixel formats, terminated by AV_PIX_FMT_NONE
  end;

(**
 * Struct to use for initializing an abuffersink context.
 *)
  PAVABufferSinkParams = ^AVABufferSinkParams;
  AVABufferSinkParams = record
    sample_fmts: PAVSampleFormat; ///< list of allowed sample formats, terminated by AV_SAMPLE_FMT_NONE
    channel_layouts: PInt64;         ///< list of allowed channel layouts, terminated by -1
    channel_counts: PInteger;              ///< list of allowed channel counts, terminated by -1
    all_channel_counts: Integer;                 ///< if not 0, accept any channel count or layout
    sample_rates: PInteger;                      ///< list of allowed sample rates, terminated by -1
  end;

(**
 * Get a frame with filtered data from sink and put it in frame.
 *
 * @param ctx    pointer to a buffersink or abuffersink filter context.
 * @param frame  pointer to an allocated frame that will be filled with data.
 *               The data must be freed using av_frame_unref() / av_frame_free()
 * @param flags  a combination of AV_BUFFERSINK_FLAG_* flags
 *
 * @return  >= 0 in for success, a negative AVERROR code for failure.
 *)
function av_buffersink_get_frame_flags(ctx: PAVFilterContext; frame: PAVFrame; flags: Integer): Integer; cdecl; external libavfilter name _PU + 'av_buffersink_get_frame_flags';

(**
 * Create an AVBufferSinkParams structure.
 *
 * Must be freed with av_free().
 *)
function av_buffersink_params_alloc: PAVBufferSinkParams; cdecl; external libavfilter name _PU + 'av_buffersink_params_alloc';

(**
 * Create an AVABufferSinkParams structure.
 *
 * Must be freed with av_free().
 *)
function av_abuffersink_params_alloc: PAVABufferSinkParams; cdecl; external libavfilter name _PU + 'av_abuffersink_params_alloc';

(**
 * Set the frame size for an audio buffer sink.
 *
 * All calls to av_buffersink_get_buffer_ref will return a buffer with
 * exactly the specified number of samples, or AVERROR(EAGAIN) if there is
 * not enough. The last buffer at EOF will be padded with 0.
 *)
procedure av_buffersink_set_frame_size(ctx: PAVFilterContext; frame_size: Cardinal); cdecl; external libavfilter name _PU + 'av_buffersink_set_frame_size';

(**
 * @defgroup lavfi_buffersink_accessors Buffer sink accessors
 * Get the properties of the stream
 * @{
 *)
function av_buffersink_get_type(const ctx: PAVFilterContext): AVMediaType; cdecl; external libavfilter name _PU + 'av_buffersink_get_type';
function av_buffersink_get_time_base(const ctx: PAVFilterContext): AVRational; cdecl; external libavfilter name _PU + 'av_buffersink_get_time_base';
function av_buffersink_get_format(const ctx: PAVFilterContext): Integer; cdecl; external libavfilter name _PU + 'av_buffersink_get_format';

function av_buffersink_get_frame_rate(const ctx: PAVFilterContext): AVRational; cdecl; external libavfilter name _PU + 'av_buffersink_get_frame_rate';
function av_buffersink_get_w(const ctx: PAVFilterContext): Integer; cdecl; external libavfilter name _PU + 'av_buffersink_get_w';
function av_buffersink_get_h(const ctx: PAVFilterContext): Integer; cdecl; external libavfilter name _PU + 'av_buffersink_get_h';
function av_buffersink_get_sample_aspect_ratio(const ctx: PAVFilterContext): AVRational; cdecl; external libavfilter name _PU + 'av_buffersink_get_sample_aspect_ratio';

function av_buffersink_get_channels(const ctx: PAVFilterContext): Integer; cdecl; external libavfilter name _PU + 'av_buffersink_get_channels';
function av_buffersink_get_channel_layout(const ctx: PAVFilterContext): UInt64; cdecl; external libavfilter name _PU + 'av_buffersink_get_channel_layout';
function av_buffersink_get_sample_rate(const ctx: PAVFilterContext): Integer; cdecl; external libavfilter name _PU + 'av_buffersink_get_sample_rate';

function av_buffersink_get_hw_frames_ctx(const ctx: PAVFilterContext): PAVBufferRef; cdecl; external libavfilter name _PU + 'av_buffersink_get_hw_frames_ctx';

(**
 * Get a frame with filtered data from sink and put it in frame.
 *
 * @param ctx pointer to a context of a buffersink or abuffersink AVFilter.
 * @param frame pointer to an allocated frame that will be filled with data.
 *              The data must be freed using av_frame_unref() / av_frame_free()
 *
 * @return
 *         - >= 0 if a frame was successfully returned.
 *         - AVERROR(EAGAIN) if no frames are available at this point; more
 *           input frames must be added to the filtergraph to get more output.
 *         - AVERROR_EOF if there will be no more output frames on this sink.
 *         - A different negative AVERROR code in other failure cases.
 *)
function av_buffersink_get_frame(ctx: PAVFilterContext; frame: PAVFrame): Integer; cdecl; external libavfilter name _PU + 'av_buffersink_get_frame';

(**
 * Same as av_buffersink_get_frame(), but with the ability to specify the number
 * of samples read. This function is less efficient than
 * av_buffersink_get_frame(), because it copies the data around.
 *
 * @param ctx pointer to a context of the abuffersink AVFilter.
 * @param frame pointer to an allocated frame that will be filled with data.
 *              The data must be freed using av_frame_unref() / av_frame_free()
 *              frame will contain exactly nb_samples audio samples, except at
 *              the end of stream, when it can contain less than nb_samples.
 *
 * @return The return codes have the same meaning as for
 *         av_buffersink_get_frame().
 *
 * @warning do not mix this function with av_buffersink_get_frame(). Use only one or
 * the other with a single sink, not both.
 *)
function av_buffersink_get_samples(ctx: PAVFilterContext; frame: PAVFrame; nb_samples: Integer): Integer; cdecl; external libavfilter name _PU + 'av_buffersink_get_samples';


implementation

end.
