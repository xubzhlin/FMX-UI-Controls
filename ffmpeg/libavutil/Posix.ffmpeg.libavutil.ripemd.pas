unit Posix.ffmpeg.libavutil.ripemd;

(*
 * Copyright (C) 2007 Michael Niedermayer <michaelni@gmx.at>
 * Copyright (C) 2013 James Almer <jamrial@gmail.com>
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

type
  av_ripemd_size = Integer;

  PAVRIPEMD = ^AVRIPEMD;
  AVRIPEMD = record
    digest_len: Byte;
    count: UInt64;
    buffer: array [0 .. 63] of Byte;
    state: array [0 .. 9] of Cardinal;
    ext: Byte;
  end;

(**
 * Allocate an AVRIPEMD context.
 *)
function av_ripemd_alloc: PAVRIPEMD; cdecl; external libavutil name _PU + 'av_ripemd_alloc';

(**
 * Initialize RIPEMD hashing.
 *
 * @param context pointer to the function context (of size av_ripemd_size)
 * @param bits    number of bits in digest (128, 160, 256 or 320 bits)
 * @return        zero if initialization succeeded, -1 otherwise
 *)
function av_ripemd_init(context: PAVRIPEMD; bits: Integer): Integer; cdecl; external libavutil name _PU + 'av_ripemd_init';

(**
 * Update hash value.
 *
 * @param context hash function context
 * @param data    input data to update hash with
 * @param len     input data length
 *)
function av_ripemd_update(context: PAVRIPEMD; const data: PByte; len: Cardinal): Integer; cdecl; external libavutil name _PU + 'av_ripemd_update';

(**
 * Finish hashing and output digest value.
 *
 * @param context hash function context
 * @param digest  buffer where output digest value is stored
 *)
procedure av_ripemd_final(context: PAVRIPEMD; digest: PByte); cdecl; external libavutil name _PU + 'av_ripemd_final';


implementation

end.
