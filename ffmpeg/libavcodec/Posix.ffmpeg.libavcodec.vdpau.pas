unit Posix.ffmpeg.libavcodec.vdpau;

(*
 * The Video Decode and Presentation API for UNIX (VDPAU) is used for
 * hardware-accelerated decoding of MPEG-1/2, H.264 and VC-1.
 *
 * Copyright (C) 2008 NVIDIA
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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with FFmpeg; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 *)

interface

{$IFDEF VDPAU}

uses
  Linker.Helper, Posix.ffmpeg.consts, Posix.ffmpeg.libavutil.frame, Posix.ffmpeg.libavcodec.avcodec;

type
  PVdpPictureInfo = Pointer;
  PVdpBitstreamBuffer = Pointer;

  TAVVDPAU_Render2 = function(Context: PAVCodecContext; Frame: PAVFrame; const PictureInfo: PVdpPictureInfo; t: Cardinal; Buffer: PVdpBitstreamBuffer): Integer; cdecl;

(**
 * This structure is used to share data between the libavcodec library and
 * the client video application.
 * The user shall allocate the structure via the av_alloc_vdpau_hwaccel
 * function and make it available as
 * AVCodecContext.hwaccel_context. Members can be set by the user once
 * during initialization or through each AVCodecContext.get_buffer()
 * function call. In any case, they must be valid prior to calling
 * decoding functions.
 *
 * The size of this structure is not a part of the public ABI and must not
 * be used outside of libavcodec. Use av_vdpau_alloc_context() to allocate an
 * AVVDPAUContext.
 *)
  PAVVDPAUContext = ^AVVDPAUContext;
  AVVDPAUContext = record
    (**
     * VDPAU decoder handle
     *
     * Set by user.
     *)
    decoder: VdpDecoder;

    (**
     * VDPAU decoder render callback
     *
     * Set by the user.
     *)
    render: PVdpDecoderRender;

    render2: AVVDPAU_Render2;
  end;

(**
 * @brief allocation function for AVVDPAUContext
 *
 * Allows extending the struct without breaking API/ABI
 *)
function av_alloc_vdpaucontext: PAVVDPAUContext; cdecl; external libavcodec name _PU + 'av_alloc_vdpaucontext';
function av_vdpau_hwaccel_get_render2(const Context: PAVVDPAUContext): PAVVDPAU_Render2; cdecl; external libavcodec name _PU + 'av_vdpau_hwaccel_get_render2';
procedure av_vdpau_hwaccel_set_render2(Context: PAVVDPAUContext; Render: AVVDPAU_Render2); cdecl; external libavcodec name _PU + 'av_vdpau_hwaccel_set_render2';

(**
 * Associate a VDPAU device with a codec context for hardware acceleration.
 * This function is meant to be called from the get_format() codec callback,
 * or earlier. It can also be called after avcodec_flush_buffers() to change
 * the underlying VDPAU device mid-stream (e.g. to recover from non-transparent
 * display preemption).
 *
 * @note get_format() must return AV_PIX_FMT_VDPAU if this function completes
 * successfully.
 *
 * @param avctx decoding context whose get_format() callback is invoked
 * @param device VDPAU device handle to use for hardware acceleration
 * @param get_proc_address VDPAU device driver
 * @param flags zero of more OR'd AV_HWACCEL_FLAG_* flags
 *
 * @return 0 on success, an AVERROR code on failure.
 *)
function av_vdpau_bind_context(avctx: PAVCodecContext; device: VdpDevice; get_proc_address: PVdpGetProcAddress; flags: Cardinal): Integer; cdecl; external libavcodec name _PU + 'av_vdpau_bind_context';

(**
 * Gets the parameters to create an adequate VDPAU video surface for the codec
 * context using VDPAU hardware decoding acceleration.
 *
 * @note Behavior is undefined if the context was not successfully bound to a
 * VDPAU device using av_vdpau_bind_context().
 *
 * @param avctx the codec context being used for decoding the stream
 * @param type storage space for the VDPAU video surface chroma type
 *              (or NULL to ignore)
 * @param width storage space for the VDPAU video surface pixel width
 *              (or NULL to ignore)
 * @param height storage space for the VDPAU video surface pixel height
 *              (or NULL to ignore)
 *
 * @return 0 on success, a negative AVERROR code on failure.
 *)
function av_vdpau_get_surface_parameters(avctx: PAVCodecContext; &type: PVdpChromaType; var width: Cardinal; var height: Cardinal): Integer; cdecl; external libavcodec name _PU + 'av_vdpau_get_surface_parameters';

(**
 * Allocate an AVVDPAUContext.
 *
 * @return Newly-allocated AVVDPAUContext or NULL on failure.
 *)
function av_vdpau_alloc_context: PAVVDPAUContext; cdecl; external libavcodec name _PU + 'av_vdpau_alloc_context';

(**
 * Get a decoder profile that should be used for initializing a VDPAU decoder.
 * Should be called from the AVCodecContext.get_format() callback.
 *
 * @deprecated Use av_vdpau_bind_context() instead.
 *
 * @param avctx the codec context being used for decoding the stream
 * @param profile a pointer into which the result will be written on success.
 *                The contents of profile are undefined if this function returns
 *                an error.
 *
 * @return 0 on success (non-negative), a negative AVERROR on failure.
 *)
function av_vdpau_get_profile(avctx: PAVCodecContext; profile: PVdpDecoderProfile): Integer; cdecl; external libavcodec name _PU + 'av_vdpau_get_profile';

{$ENDIF}

implementation

end.
