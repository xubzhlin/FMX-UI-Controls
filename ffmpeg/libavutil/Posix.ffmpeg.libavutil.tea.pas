unit Posix.ffmpeg.libavutil.tea;

(*
 * A 32-bit implementation of the TEA algorithm
 * Copyright (c) 2015 Vesselin Bontchev
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
  Taar16Byte = array[0..15] of Byte;

  av_tea_size = Integer;

  PAVTEA = ^AVTEA;
  AVTEA = record
    key: array[0..15] of Cardinal;
    rounds: Integer;
  end;


(**
  * Allocate an AVTEA context
  * To free the struct: av_free(ptr)
  *)
function av_tea_alloc: PAVTEA; cdecl; external libavutil name _PU + 'av_tea_alloc';

(**
 * Initialize an AVTEA context.
 *
 * @param ctx an AVTEA context
 * @param key a key of 16 bytes used for encryption/decryption
 * @param rounds the number of rounds in TEA (64 is the "standard")
 *)
procedure av_tea_init(ctx: PAVTEA; const key: Taar16Byte; rounds: Integer); cdecl; external libavutil name _PU + 'av_tea_init';

(**
 * Encrypt or decrypt a buffer using a previously initialized context.
 *
 * @param ctx an AVTEA context
 * @param dst destination array, can be equal to src
 * @param src source array, can be equal to dst
 * @param count number of 8 byte blocks
 * @param iv initialization vector for CBC mode, if NULL then ECB will be used
 * @param decrypt 0 for encryption, 1 for decryption
 *)
procedure av_tea_crypt(ctx: PAVTEA; dst: PByte; const src: PByte; count: Integer;
  iv: PByte; decrypt: Integer); cdecl; external libavutil name _PU + 'av_tea_crypt';

implementation

end.
