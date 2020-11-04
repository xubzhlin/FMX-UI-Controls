unit Posix.ffmpeg.libavutil.sha;

(*
 * Copyright (C) 2007 Michael Niedermayer <michaelni@gmx.at>
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
  Taar64Byte = array[0..63] of Byte;
  av_sha_size = Integer;

  PAVSHA = ^AVSHA;
  AVSHA = record
    digest_len: Byte;
    count: Cardinal;
    buffer: array [0 .. 63] of Byte;
    state: array [0 .. 7] of Cardinal;
    transform: procedure(state: PCardinal; const buffer: Taar64Byte);
  end;

(**
 * Allocate an AVSHA context.
 *)
function av_sha_alloc: PAVSHA; cdecl; external libavutil name _PU + 'av_sha_alloc';

(**
 * Initialize SHA-1 or SHA-2 hashing.
 *
 * @param context pointer to the function context (of size av_sha_size)
 * @param bits    number of bits in digest (SHA-1 - 160 bits, SHA-2 224 or 256 bits)
 * @return        zero if initialization succeeded, -1 otherwise
 *)
function av_sha_init(context: PAVSHA; bits: Integer): Integer; cdecl; external libavutil name _PU + 'av_sha_init';

(**
 * Update hash value.
 *
 * @param ctx     hash function context
 * @param data    input data to update hash with
 * @param len     input data length
 *)
procedure av_sha_update(ctx: PAVSHA; const data: PByte; len: Cardinal); cdecl; external libavutil name _PU + 'av_sha_update';

(**
 * Finish hashing and output digest value.
 *
 * @param context hash function context
 * @param digest  buffer where output digest value is stored
 *)
procedure av_sha_final(context: PAVSHA; digest: PByte); cdecl; external libavutil name _PU + 'av_sha_final';

implementation

end.
