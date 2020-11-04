unit Posix.ffmpeg.libavcodec.dv_profile;

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
  Linker.Helper, Posix.ffmpeg.consts, Posix.ffmpeg.libavutil.rational, Posix.ffmpeg.libavutil.pixfmt;

const
  (* minimum number of bytes to read from a DV stream in order to
 * determine the profile *)
  DV_PROFILE_BYTES = (6 * 80); //* 6 DIF blocks */

type
(*
 * AVDVProfile is used to express the differences between various
 * DV flavors. For now it's primarily used for differentiating
 * 525/60 and 625/50, but the plans are to use it for various
 * DV specs as well (e.g. SMPTE314M vs. IEC 61834).
 *)
  PAVDVProfile = ^AVDVProfile;
  AVDVProfile = record
    dsf: Integer;                   (* value of the dsf in the DV header *)
    video_stype: Integer;           (* stype for VAUX source pack *)
    frame_size: Integer;            (* total size of one frame in bytes *)
    difseg_size: Integer;           (* number of DIF segments per DIF channel *)
    n_difchan: Integer;             (* number of DIF channels per frame *)
    time_base: AVRational;          (* 1/framerate *)
    ltc_divisor: Integer;           (* FPS from the LTS standpoint *)
    height: Integer;                (* picture height in pixels *)
    width: Integer;                 (* picture width in pixels *)
    sar: array[0..1] of AVRational; (* sample aspect ratios for 4:3 and 16:9 *)
    pix_fmt: AVPixelFormat;          (* picture pixel format *)
    bpm: Integer;                   (* blocks per macroblock *)
    block_sizes: Pbyte;             (* AC block sizes, in bits *)
    audio_stride: Integer;          (* size of audio_shuffle table *)
    audio_min_samples: array[0..2] of Integer;  (* min amount of audio samples *)
                                            (* for 48kHz, 44.1kHz and 32kHz *)
    audio_samples_dist: array[0..4] of Integer; (* how many samples are supposed to be *)

                                            (* in each frame in a 5 frames window *)
    audio_shuffle: array[0..8] of PByte;    (* PCM shuffling table *)
  end;

(**
 * Get a DV profile for the provided compressed frame.
 *
 * @param sys the profile used for the previous frame, may be NULL
 * @param frame the compressed data buffer
 * @param buf_size size of the buffer in bytes
 * @return the DV profile for the supplied data or NULL on failure
 *)
function av_dv_frame_profile(const sys: PAVDVProfile; const frame: PByte; buf_size: Cardinal): PAVDVProfile; cdecl; external libavcodec name _PU + 'av_dv_frame_profile';

(**
 * Get a DV profile for the provided stream parameters.
 *)
function av_dv_codec_profile(width: Integer; height: Integer; pix_fmt: AVPixelFormat): PAVDVProfile; cdecl; external libavcodec name _PU + 'av_dv_codec_profile';

(**
 * Get a DV profile for the provided stream parameters.
 * The frame rate is used as a best-effort parameter.
 *)
function av_dv_codec_profile2(width: Integer; height: Integer; pix_fmt: AVPixelFormat; frame_rate: AVRational): PAVDVProfile; cdecl; external libavcodec name _PU + 'av_dv_codec_profile2';

implementation

end.
