unit Posix.ffmpeg.libavcodec.ac3_parser;

(*
 * AC-3 parser prototypes
 * Copyright (c) 2003 Fabrice Bellard
 * Copyright (c) 2003 Michael Niedermayer
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
  Linker.Helper, Posix.ffmpeg.consts;

(**
 * Extract the bitstream ID and the frame size from AC-3 data.
 *)
function av_ac3_parse_header(const buf: PByte; size: NativeInt; bitstream_id: PByte; frame_size: PWORD): Integer; cdecl; external libavcodec name _PU + 'av_ac3_parse_header';


implementation

end.
