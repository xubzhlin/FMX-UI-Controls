unit Posix.ffmpeg.libavutil.aes_internal;

(*
 * copyright (c) 2015 Rodger Combs <rodger.combs@gmail.com>
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

type
  av_aes_block = record
    U64: array [0 .. 1] of UInt64;
    U32: array [0 .. 3] of Cardinal;
    U8x4: array [0 .. 3, 0 .. 3] of Byte;
    U8: array [0 .. 15] of Byte;
  end;

  PAVAES = ^AVAES;
  Tcrypt = function(a: PAVAES; var dst: Byte; var src: Byte; count: Integer; iv: Byte; rounds: Integer):Pointer; cdecl;
  AVAES = record
    round_key: array [0 .. 14] of av_aes_block;
    state: array [0 .. 1] of av_aes_block;
    round: Integer;
    crypt: Tcrypt;
  end;

implementation

end.
