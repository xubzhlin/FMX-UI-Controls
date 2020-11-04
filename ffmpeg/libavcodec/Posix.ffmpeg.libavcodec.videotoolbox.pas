unit Posix.ffmpeg.libavcodec.videotoolbox;

(*
 * Videotoolbox hardware acceleration
 *
 * copyright (c) 2012 Sebastien Zwickert
 *
 * This file is part of FFmpeg.
 *
 * FFmpeg is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * FFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with FFmpeg; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 *)

interface

{$IFDEF VIDEOTOOLBOX}

uses
  Linker.Helper, Posix.ffmpeg.consts, Posix.ffmpeg.libavcodec.avcodec;

type
(**
 * This struct holds all the information that needs to be passed
 * between the caller and libavcodec for initializing Videotoolbox decoding.
 * Its size is not a part of the public ABI, it must be allocated with
 * av_videotoolbox_alloc_context() and freed with av_free().
 *)
  PAVVideotoolboxContext = ^AVVideotoolboxContext;
  AVVideotoolboxContext = record
    (**
     * Videotoolbox decompression session object.
     * Created and freed the caller.
     *)
    session: VTDecompressionSessionRef;

    (**
     * The output callback that must be passed to the session.
     * Set by av_videottoolbox_default_init()
     *)
    output_callback: VTDecompressionOutputCallback;

    (**
     * CVPixelBuffer Format Type that Videotoolbox will use for decoded frames.
     * set by the caller. If this is set to 0, then no specific format is
     * requested from the decoder, and its native format is output.
     *)
    cv_pix_fmt_type: OSType;

    (**
     * CoreMedia Format Description that Videotoolbox will use to create the decompression session.
     * Set by the caller.
     *)
    cm_fmt_desc: CMVideoFormatDescriptionRef;

    (**
     * CoreMedia codec type that Videotoolbox will use to create the decompression session.
     * Set by the caller.
     *)
    cm_codec_type: Integer;
  end;

(**
 * Allocate and initialize a Videotoolbox context.
 *
 * This function should be called from the get_format() callback when the caller
 * selects the AV_PIX_FMT_VIDETOOLBOX format. The caller must then create
 * the decoder object (using the output callback provided by libavcodec) that
 * will be used for Videotoolbox-accelerated decoding.
 *
 * When decoding with Videotoolbox is finished, the caller must destroy the decoder
 * object and free the Videotoolbox context using av_free().
 *
 * @return the newly allocated context or NULL on failure
 *)
function av_videotoolbox_alloc_context: PAVVideotoolboxContext; cdecl; external libavcodec name _PU + 'av_videotoolbox_alloc_context';

(**
 * This is a convenience function that creates and sets up the Videotoolbox context using
 * an internal implementation.
 *
 * @param avctx the corresponding codec context
 *
 * @return >= 0 on success, a negative AVERROR code on failure
 *)
function av_videotoolbox_default_init(avctx: PAVCodecContext): Integer; cdecl; external libavcodec name _PU + 'av_videotoolbox_default_init';

(**
 * This is a convenience function that creates and sets up the Videotoolbox context using
 * an internal implementation.
 *
 * @param avctx the corresponding codec context
 * @param vtctx the Videotoolbox context to use
 *
 * @return >= 0 on success, a negative AVERROR code on failure
 *)
function av_videotoolbox_default_init2(avctx: PAVCodecContext; vtctx: PAVVideotoolboxContext): Integer; cdecl; external libavcodec name _PU + 'av_videotoolbox_default_init2';

(**
 * This function must be called to free the Videotoolbox context initialized with
 * av_videotoolbox_default_init().
 *
 * @param avctx the corresponding codec context
 *)
procedure av_videotoolbox_default_free(avctx: PAVCodecContext); cdecl; external libavcodec name _PU + 'av_videotoolbox_default_free';

{$ENDIF}

implementation

end.
