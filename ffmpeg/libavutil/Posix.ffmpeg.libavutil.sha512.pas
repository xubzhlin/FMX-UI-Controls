unit Posix.ffmpeg.libavutil.sha512;

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
(**
 * @defgroup lavu_sha512 SHA-512
 * @ingroup lavu_hash
 * SHA-512 (Secure Hash Algorithm) hash function implementations.
 *
 * This module supports the following SHA-2 hash functions:
 *
 * - SHA-512/224: 224 bits
 * - SHA-512/256: 256 bits
 * - SHA-384: 384 bits
 * - SHA-512: 512 bits
 *
 * @see For SHA-1, SHA-256, and variants thereof, see @ref lavu_sha.
 *
 * @{
 *)
  av_sha512_size = Integer;

  PAVSHA512 = ^AVSHA512;
  AVSHA512 = record
    digest_len: Byte;
    count: UInt64;
    buffer: array [0 .. 127] of Byte;
    state: array [0 .. 7] of UInt64;
  end;

(**
 * Allocate an AVSHA512 context.
 *)
function av_sha512_alloc: PAVSHA512; cdecl; external libavutil name _PU + 'av_sha512_alloc';

(**
 * Initialize SHA-2 512 hashing.
 *
 * @param context pointer to the function context (of size av_sha512_size)
 * @param bits    number of bits in digest (224, 256, 384 or 512 bits)
 * @return        zero if initialization succeeded, -1 otherwise
 *)
function av_sha512_init(context: PAVSHA512; bits: Integer): Integer; cdecl; external libavutil name _PU + 'av_sha512_init';

(**
 * Update hash value.
 *
 * @param context hash function context
 * @param data    input data to update hash with
 * @param len     input data length
 *)
procedure av_sha512_update(context: PAVSHA512; const data: PByte; len: Cardinal); cdecl; external libavutil name _PU + 'av_sha512_update';

(**
 * Finish hashing and output digest value.
 *
 * @param context hash function context
 * @param digest  buffer where output digest value is stored
 *)
procedure av_sha512_final(context: PAVSHA512; digest: PByte); cdecl; external libavutil name _PU + 'av_sha512_final';

implementation

end.
