unit Posix.ffmpeg.libavutil.channel_layout;

(*
 * Copyright (c) 2006 Michael Niedermayer <michaelni@gmx.at>
 * Copyright (c) 2008 Peter Ross
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

uses
    Linker.Helper, Posix.ffmpeg.consts, Posix.ffmpeg.libavutil.bprint;

const
(**
 * @file
 * audio channel layout utility functions
 *)

(**
 * @addtogroup lavu_audio
 * @{
 *)

(**
 * @defgroup channel_masks Audio channel masks
 *
 * A channel layout is a 64-bits integer with a bit set for every channel.
 * The number of bits set must be equal to the number of channels.
 * The value 0 means that the channel layout is not known.
 * @note this data structure is not powerful enough to handle channels
 * combinations that have the same channel multiple times, such as
 * dual-mono.
 *
 * @{
 *)
  AV_CH_FRONT_LEFT              = $00000001;
  AV_CH_FRONT_RIGHT             = $00000002;
  AV_CH_FRONT_CENTER            = $00000004;
  AV_CH_LOW_FREQUENCY           = $00000008;
  AV_CH_BACK_LEFT               = $00000010;
  AV_CH_BACK_RIGHT              = $00000020;
  AV_CH_FRONT_LEFT_OF_CENTER    = $00000040;
  AV_CH_FRONT_RIGHT_OF_CENTER   = $00000080;
  AV_CH_BACK_CENTER             = $00000100;
  AV_CH_SIDE_LEFT               = $00000200;
  AV_CH_SIDE_RIGHT              = $00000400;
  AV_CH_TOP_CENTER              = $00000800;
  AV_CH_TOP_FRONT_LEFT          = $00001000;
  AV_CH_TOP_FRONT_CENTER        = $00002000;
  AV_CH_TOP_FRONT_RIGHT         = $00004000;
  AV_CH_TOP_BACK_LEFT           = $00008000;
  AV_CH_TOP_BACK_CENTER         = $00010000;
  AV_CH_TOP_BACK_RIGHT          = $00020000;
  AV_CH_STEREO_LEFT             = $20000000;  ///< Stereo downmix.
  AV_CH_STEREO_RIGHT            = $40000000;  ///< See AV_CH_STEREO_LEFT.
  AV_CH_WIDE_LEFT               = $0000000080000000;
  AV_CH_WIDE_RIGHT              = $0000000100000000;
  AV_CH_SURROUND_DIRECT_LEFT    = $0000000200000000;
  AV_CH_SURROUND_DIRECT_RIGHT   = $0000000400000000;
  AV_CH_LOW_FREQUENCY_2         = $0000000800000000;

  (** Channel mask value used for AVCodecContext.request_channel_layout
      to indicate that the user requests the channel order of the decoder output
      to be the native codec channel order. *)
  AV_CH_LAYOUT_NATIVE           = $8000000000000000;

 (**
 * @}
 * @defgroup channel_mask_c Audio channel layouts
 * @{
 * *)
  AV_CH_LAYOUT_MONO               = AV_CH_FRONT_CENTER;
  AV_CH_LAYOUT_STEREO             = AV_CH_FRONT_LEFT or AV_CH_FRONT_RIGHT;
  AV_CH_LAYOUT_2POINT1            = AV_CH_LAYOUT_STEREO or AV_CH_LOW_FREQUENCY;
  AV_CH_LAYOUT_2_1                = AV_CH_LAYOUT_STEREO or AV_CH_BACK_CENTER;
  AV_CH_LAYOUT_SURROUND           = AV_CH_LAYOUT_STEREO or AV_CH_FRONT_CENTER;
  AV_CH_LAYOUT_3POINT1            = AV_CH_LAYOUT_SURROUND or AV_CH_LOW_FREQUENCY;
  AV_CH_LAYOUT_4POINT0            = AV_CH_LAYOUT_SURROUND or AV_CH_BACK_CENTER;
  AV_CH_LAYOUT_4POINT1            = AV_CH_LAYOUT_4POINT0 or AV_CH_LOW_FREQUENCY;
  AV_CH_LAYOUT_2_2                = AV_CH_LAYOUT_STEREO or AV_CH_SIDE_LEFT or AV_CH_SIDE_RIGHT;
  AV_CH_LAYOUT_QUAD               = AV_CH_LAYOUT_STEREO or AV_CH_BACK_LEFT or AV_CH_BACK_RIGHT;
  AV_CH_LAYOUT_5POINT0            = AV_CH_LAYOUT_SURROUND or AV_CH_SIDE_LEFT or AV_CH_SIDE_RIGHT;
  AV_CH_LAYOUT_5POINT1            = AV_CH_LAYOUT_5POINT0 or AV_CH_LOW_FREQUENCY;
  AV_CH_LAYOUT_5POINT0_BACK       = AV_CH_LAYOUT_SURROUND or AV_CH_BACK_LEFT or AV_CH_BACK_RIGHT;
  AV_CH_LAYOUT_5POINT1_BACK       = AV_CH_LAYOUT_5POINT0_BACK or AV_CH_LOW_FREQUENCY;
  AV_CH_LAYOUT_6POINT0            = AV_CH_LAYOUT_5POINT0 or AV_CH_BACK_CENTER;
  AV_CH_LAYOUT_6POINT0_FRONT      = AV_CH_LAYOUT_2_2 or AV_CH_FRONT_LEFT_OF_CENTER or AV_CH_FRONT_RIGHT_OF_CENTER;
  AV_CH_LAYOUT_HEXAGONAL          = AV_CH_LAYOUT_5POINT0_BACK or AV_CH_BACK_CENTER;
  AV_CH_LAYOUT_6POINT1            = AV_CH_LAYOUT_5POINT1 or AV_CH_BACK_CENTER;
  AV_CH_LAYOUT_6POINT1_BACK       = AV_CH_LAYOUT_5POINT1_BACK or AV_CH_BACK_CENTER;
  AV_CH_LAYOUT_6POINT1_FRONT      = AV_CH_LAYOUT_6POINT0_FRONT or AV_CH_LOW_FREQUENCY;
  AV_CH_LAYOUT_7POINT0            = AV_CH_LAYOUT_5POINT0 or AV_CH_BACK_LEFT or AV_CH_BACK_RIGHT;
  AV_CH_LAYOUT_7POINT0_FRONT      = AV_CH_LAYOUT_5POINT0 or AV_CH_FRONT_LEFT_OF_CENTER or AV_CH_FRONT_RIGHT_OF_CENTER;
  AV_CH_LAYOUT_7POINT1            = AV_CH_LAYOUT_5POINT1 or AV_CH_BACK_LEFT or AV_CH_BACK_RIGHT;
  AV_CH_LAYOUT_7POINT1_WIDE       = AV_CH_LAYOUT_5POINT1 or AV_CH_FRONT_LEFT_OF_CENTER or AV_CH_FRONT_RIGHT_OF_CENTER;
  AV_CH_LAYOUT_7POINT1_WIDE_BACK  = AV_CH_LAYOUT_5POINT1_BACK or AV_CH_FRONT_LEFT_OF_CENTER or AV_CH_FRONT_RIGHT_OF_CENTER;
  AV_CH_LAYOUT_OCTAGONAL          = AV_CH_LAYOUT_5POINT0 or AV_CH_BACK_LEFT or AV_CH_BACK_CENTER or AV_CH_BACK_RIGHT;
  AV_CH_LAYOUT_HEXADECAGONAL      = AV_CH_LAYOUT_OCTAGONAL or AV_CH_WIDE_LEFT or AV_CH_WIDE_RIGHT
    or AV_CH_TOP_BACK_LEFT or AV_CH_TOP_BACK_RIGHT or AV_CH_TOP_BACK_CENTER or AV_CH_TOP_FRONT_CENTER
    or AV_CH_TOP_FRONT_LEFT or AV_CH_TOP_FRONT_RIGHT;
  AV_CH_LAYOUT_STEREO_DOWNMIX     = AV_CH_STEREO_LEFT or AV_CH_STEREO_RIGHT;

type
 AVMatrixEncoding = (
    AV_MATRIX_ENCODING_NONE,
    AV_MATRIX_ENCODING_DOLBY,
    AV_MATRIX_ENCODING_DPLII,
    AV_MATRIX_ENCODING_DPLIIX,
    AV_MATRIX_ENCODING_DPLIIZ,
    AV_MATRIX_ENCODING_DOLBYEX,
    AV_MATRIX_ENCODING_DOLBYHEADPHONE,
    AV_MATRIX_ENCODING_NB
  );

(**
 * Return a channel layout id that matches name, or 0 if no match is found.
 *
 * name can be one or several of the following notations,
 * separated by '+' or '|':
 * - the name of an usual channel layout (mono, stereo, 4.0, quad, 5.0,
 *   5.0(side), 5.1, 5.1(side), 7.1, 7.1(wide), downmix);
 * - the name of a single channel (FL, FR, FC, LFE, BL, BR, FLC, FRC, BC,
 *   SL, SR, TC, TFL, TFC, TFR, TBL, TBC, TBR, DL, DR);
 * - a number of channels, in decimal, followed by 'c', yielding
 *   the default channel layout for that number of channels (@see
 *   av_get_default_channel_layout);
 * - a channel layout mask, in hexadecimal starting with "0x" (see the
 *   AV_CH_* macros).
 *
 * Example: "stereo+FC" = "2c+FC" = "2c+1c" = "0x7"
 *)
function av_get_channel_layout(const name: MarshaledAString): UInt64; cdecl; external libavutil name _PU + 'av_get_channel_layout';

(**
 * Return a channel layout and the number of channels based on the specified name.
 *
 * This function is similar to (@see av_get_channel_layout), but can also parse
 * unknown channel layout specifications.
 *
 * @param[in]  name             channel layout specification string
 * @param[out] channel_layout   parsed channel layout (0 if unknown)
 * @param[out] nb_channels      number of channels
 *
 * @return 0 on success, AVERROR(EINVAL) if the parsing fails.
 *)
function av_get_extended_channel_layout(const name: MarshaledAString; var channel_layout: Int64; var nb_channels: Integer): Integer; cdecl; external libavutil name _PU + 'av_get_extended_channel_layout';

(**
 * Return a description of a channel layout.
 * If nb_channels is <= 0, it is guessed from the channel_layout.
 *
 * @param buf put here the string containing the channel layout
 * @param buf_size size in bytes of the buffer
 *)
procedure av_get_channel_layout_string(cbuf: MarshaledAString; buf_size: Integer; nb_channels: Integer; channel_layout: Int64); cdecl; external libavutil name _PU + 'av_get_channel_layout_string';

(**
 * Append a description of a channel layout to a bprint buffer.
 *)
procedure av_bprint_channel_layout(var bp: AVBPrint; nb_channels: Integer; channel_layout: Int64); cdecl; external libavutil name _PU + 'av_bprint_channel_layout';

(**
 * Return the number of channels in the channel layout.
 *)
function av_get_channel_layout_nb_channels(channel_layout: Int64): Integer; cdecl; external libavutil name _PU + 'av_get_channel_layout_nb_channels';

(**
 * Return default channel layout for a given number of channels.
 *)
function av_get_default_channel_layout(channel_layout: Int64): Int64; cdecl; external libavutil name _PU + 'av_get_default_channel_layout';

(**
 * Get the index of a channel in channel_layout.
 *
 * @param channel a channel layout describing exactly one channel which must be
 *                present in channel_layout.
 *
 * @return index of channel in channel_layout on success, a negative AVERROR
 *         on error.
 *)
function av_get_channel_layout_channel_index(channel_layout: Int64; channel: Int64): Integer; cdecl; external libavutil name _PU + 'av_get_channel_layout_channel_index';

(**
 * Get the channel with the given index in channel_layout.
 *)
function av_channel_layout_extract_channel(channel_layout: Int64; index: Integer): Int64; cdecl; external libavutil name _PU + 'av_channel_layout_extract_channel';

(**
 * Get the name of a given channel.
 *
 * @return channel name on success, NULL on error.
 *)
function av_get_channel_name(channel: Int64): MarshaledAString; cdecl; external libavutil name _PU + 'av_get_channel_name';

(**
 * Get the description of a given channel.
 *
 * @param channel  a channel layout with a single channel
 * @return  channel description on success, NULL on error
 *)
function av_get_channel_description(channel: Int64): MarshaledAString; cdecl; external libavutil name _PU + 'av_get_channel_description';

(**
 * Get the value and name of a standard channel layout.
 *
 * @param[in]  index   index in an internal list, starting at 0
 * @param[out] layout  channel layout mask
 * @param[out] name    name of the layout
 * @return  0  if the layout exists,
 *          <0 if index is beyond the limits
 *)
function av_get_standard_channel_layout(index: Cardinal; var layout: Int64; const name: PMarshaledAString): Integer; cdecl; external libavutil name _PU + 'av_get_standard_channel_layout';


implementation

end.
