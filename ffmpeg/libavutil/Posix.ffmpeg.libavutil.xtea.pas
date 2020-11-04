unit Posix.ffmpeg.libavutil.xtea;

(*
 * A 32-bit implementation of the XTEA algorithm
 * Copyright (c) 2012 Samuel Pitoiset
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
(**
 * @file
 * @brief Public header for libavutil XTEA algorithm
 * @defgroup lavu_xtea XTEA
 * @ingroup lavu_crypto
 * @{
 *)
  PAVXTEA = ^AVXTEA;
  AVXTEA = record
    key: array[0..15] of Cardinal;
  end;

(**
 * Allocate an AVXTEA context.
 *)
function av_xtea_alloc: PAVXTEA; cdecl; external libavutil name _PU + 'av_xtea_alloc';

(**
 * Initialize an AVXTEA context.
 *
 * @param ctx an AVXTEA context
 * @param key a key of 16 bytes used for encryption/decryption,
 *            interpreted as big endian 32 bit numbers
 *)
procedure av_xtea_init(ctx: PAVXTEA; const key: Taar16Byte); cdecl; external libavutil name _PU + 'av_xtea_init';

(**
 * Initialize an AVXTEA context.
 *
 * @param ctx an AVXTEA context
 * @param key a key of 16 bytes used for encryption/decryption,
 *            interpreted as little endian 32 bit numbers
 *)
procedure av_xtea_le_init(ctx: PAVXTEA; const key: Taar16Byte); cdecl; external libavutil name _PU + 'av_xtea_le_init';

(**
 * Encrypt or decrypt a buffer using a previously initialized context,
 * in big endian format.
 *
 * @param ctx an AVXTEA context
 * @param dst destination array, can be equal to src
 * @param src source array, can be equal to dst
 * @param count number of 8 byte blocks
 * @param iv initialization vector for CBC mode, if NULL then ECB will be used
 * @param decrypt 0 for encryption, 1 for decryption
 *)
procedure av_xtea_crypt(ctx: PAVXTEA; dst: PByte; const src: PByte; count: Integer;
  iv: PByte; decrypt: Integer); cdecl; external libavutil name _PU + 'av_xtea_crypt';

(**
 * Encrypt or decrypt a buffer using a previously initialized context,
 * in little endian format.
 *
 * @param ctx an AVXTEA context
 * @param dst destination array, can be equal to src
 * @param src source array, can be equal to dst
 * @param count number of 8 byte blocks
 * @param iv initialization vector for CBC mode, if NULL then ECB will be used
 * @param decrypt 0 for encryption, 1 for decryption
 *)
procedure av_xtea_le_crypt(ctx: PAVXTEA; dst: PByte; const src: PByte; count: Integer;
  iv: PByte; decrypt: Integer); cdecl; external libavutil name _PU + 'av_xtea_le_crypt';


implementation

end.
