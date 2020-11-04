unit Posix.ffmpeg.libavutil.aes;

(*
 * copyright (c) 2007 Michael Niedermayer <michaelni@gmx.at>
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
  Linker.Helper, Posix.ffmpeg.consts, Posix.ffmpeg.libavutil.aes_internal;

type
(**
 * @defgroup lavu_aes AES
 * @ingroup lavu_crypto
 * @{
 *)
  av_aes_size = Integer;

(**
* Allocate an AVAES context.
*)
function av_aes_alloc: PAVAES; cdecl; external libavutil name _PU + 'av_adler32_update';

(**
 * Initialize an AVAES context.
 * @param key_bits 128, 192 or 256
 * @param decrypt 0 for encryption, 1 for decryption
 *)
function av_aes_init(var a: AVAES; key: PByte; key_bits: Integer; decrypt: Integer): PAVAES; cdecl; external libavutil name _PU + 'av_aes_init';

(**
 * Encrypt or decrypt a buffer using a previously initialized context.
 * @param count number of 16 byte blocks
 * @param dst destination array, can be equal to src
 * @param src source array, can be equal to dst
 * @param iv initialization vector for CBC mode, if NULL then ECB will be used
 * @param decrypt 0 for encryption, 1 for decryption
 *)
procedure av_aes_crypt(var a: AVAES; dst: PByte; src: PByte; count: Integer; iv: PByte; decrypt: Integer); cdecl; external libavutil name _PU + 'av_aes_crypt';



implementation

end.
