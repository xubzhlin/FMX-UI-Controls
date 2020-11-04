unit Posix.ffmpeg.libpostproc.postprocess;

(*
 * Copyright (C) 2001-2003 Michael Niedermayer (michaelni@gmx.at)
 *
 * This file is part of FFmpeg.
 *
 * FFmpeg is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * FFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with FFmpeg; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 *)

interface

uses
  Linker.Helper, Posix.ffmpeg.consts;

const
  PP_CPU_CAPS_MMX   = $80000000;
  PP_CPU_CAPS_MMX2  = $20000000;
  PP_CPU_CAPS_3DNOW = $40000000;
  PP_CPU_CAPS_ALTIVEC = $10000000;
  PP_CPU_CAPS_AUTO  = $00080000;

  PP_FORMAT         = $00000008;
  PP_FORMAT_420     = ($00000011 or PP_FORMAT);
  PP_FORMAT_422     = ($00000001 or PP_FORMAT);
  PP_FORMAT_411     = ($00000002 or PP_FORMAT);
  PP_FORMAT_444     = ($00000000 or PP_FORMAT);
  PP_FORMAT_440     = ($00000010 or PP_FORMAT);

  PP_PICT_TYPE_QP2  = $00000010; ///< MPEG2 style QScale

  PP_QUALITY_MAX = 6;

type
  Ppp_context  = Pointer;
  Ppp_mode = Pointer;

  Paar3Byte = ^Taar3Byte;
  Taar3Byte = array[0..2] of Byte;

  Paar3Int = ^Taar3Int;
  Taar3Int = array[0..2] of Integer;

(**
 * Return the LIBPOSTPROC_VERSION_INT constant.
 *)
function postproc_version: Cardinal; cdecl; external libpostproc name _PU + 'postproc_version';

(**
 * Return the libpostproc build-time configuration.
 *)
function postproc_configuration: MarshaledAString; cdecl; external libpostproc name _PU + 'postproc_configuration';

(**
 * Return the libpostproc license.
 *)
function postproc_license: MarshaledAString; cdecl; external libpostproc name _PU + 'postproc_license';

function pp_help: MarshaledAString; cdecl; external libpostproc name _PU + 'pp_help';

procedure pp_postprocess(const src: Paar3Byte; const srcStride: Taar3Int; dst: Paar3Byte; dstStride: Taar3Int;
  horizontalSize: Integer; verticalSize: Integer; const QP_store: PByte; QP_stride: Integer;
  mode: Ppp_mode; ppContext: Ppp_context; pict_type: Integer); cdecl; external libpostproc name _PU + 'pp_postprocess';

(**
 * Return a pp_mode or NULL if an error occurred.
 *
 * @param name    the string after "-pp" on the command line
 * @param quality a number from 0 to PP_QUALITY_MAX
 *)
function pp_get_mode_by_name_and_quality(const name: MarshaledAString; quality: Integer): Ppp_mode; cdecl; external libpostproc name _PU + 'pp_get_mode_by_name_and_quality';
procedure pp_free_mode(mode: Ppp_mode); cdecl; external libpostproc name _PU + 'pp_free_mode';

function pp_get_context(width: Integer; height: Integer; flags: Integer): Ppp_context; cdecl; external libpostproc name _PU + 'pp_get_context';
procedure pp_free_context(ppContext: Ppp_context); cdecl; external libpostproc name _PU + 'pp_free_context';

implementation

end.
