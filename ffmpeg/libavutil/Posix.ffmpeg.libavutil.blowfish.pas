unit Posix.ffmpeg.libavutil.blowfish;

(*
 * Blowfish algorithm
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

const
(**
 * @defgroup lavu_blowfish Blowfish
 * @ingroup lavu_crypto
 * @{
 *)
  AV_BF_ROUNDS = 16;

type
  T256Cardinal = array[0..255] of Cardinal;

  PAVBlowfish = ^AVBlowfish;
  AVBlowfish = record
    p:array[0..AV_BF_ROUNDS+1] of Cardinal;
    s:array[0..3] of T256Cardinal;
  end;

(**
 * Allocate an AVBlowfish context.
 *)
function av_blowfish_alloc: PAVBlowfish; cdecl; external libavutil name _PU + 'av_blowfish_alloc';

(**
 * Initialize an AVBlowfish context.
 *
 * @param ctx an AVBlowfish context
 * @param key a key
 * @param key_len length of the key
 *)
procedure av_blowfish_init(var ctx: AVBlowfish; const key: PByte; key_len: Integer); cdecl; external libavutil name _PU + 'av_blowfish_init';

(**
 * Encrypt or decrypt a buffer using a previously initialized context.
 *
 * @param ctx an AVBlowfish context
 * @param xl left four bytes halves of input to be encrypted
 * @param xr right four bytes halves of input to be encrypted
 * @param decrypt 0 for encryption, 1 for decryption
 *)
procedure av_blowfish_crypt_ecb(var ctx: AVBlowfish; var xl: Cardinal; var xr: Cardinal; decrypt: Integer); cdecl; external libavutil name _PU + 'av_blowfish_crypt_ecb';

(**
 * Encrypt or decrypt a buffer using a previously initialized context.
 *
 * @param ctx an AVBlowfish context
 * @param dst destination array, can be equal to src
 * @param src source array, can be equal to dst
 * @param count number of 8 byte blocks
 * @param iv initialization vector for CBC mode, if NULL ECB will be used
 * @param decrypt 0 for encryption, 1 for decryption
 *)
procedure av_blowfish_crypt(var ctx: AVBlowfish; dst: PByte; const src: PByte; count: Integer;
  iv: PByte; decrypt: Integer); cdecl; external libavutil name _PU + 'av_blowfish_crypt';

implementation

end.
