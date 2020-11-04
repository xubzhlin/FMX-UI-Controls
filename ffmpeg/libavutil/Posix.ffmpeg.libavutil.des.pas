unit Posix.ffmpeg.libavutil.des;

(*
 * DES encryption/decryption
 * Copyright (c) 2007 Reimar Doeffinger
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
 * @defgroup lavu_des DES
 * @ingroup lavu_crypto
 * @{
 *)
  Tround_key = array[0..15] of UInt64;

  PAVDES = ^AVDES;
  AVDES = record
    round_keys: array[0..2] of Tround_key;
    triple_des: Integer;
  end;

(**
 * Allocate an AVDES context.
 *)
function av_des_alloc: PAVDES; cdecl; external libavutil name _PU + 'av_des_alloc';

(**
 * @brief Initializes an AVDES context.
 *
 * @param key_bits must be 64 or 192
 * @param decrypt 0 for encryption/CBC-MAC, 1 for decryption
 * @return zero on success, negative value otherwise
 *)
function av_des_init(var d: AVDES; key: PByte; key_bits: Integer; decrypt: Integer): Integer; cdecl; external libavutil name _PU + 'av_des_init';

(**
 * @brief Encrypts / decrypts using the DES algorithm.
 *
 * @param count number of 8 byte blocks
 * @param dst destination array, can be equal to src, must be 8-byte aligned
 * @param src source array, can be equal to dst, must be 8-byte aligned, may be NULL
 * @param iv initialization vector for CBC mode, if NULL then ECB will be used,
 *           must be 8-byte aligned
 * @param decrypt 0 for encryption, 1 for decryption
 *)
procedure av_des_crypt(var d: AVDES; dst: PByte; const src: PByte; count: Integer; iv: PByte ;decrypt: Integer); cdecl; external libavutil name _PU + 'av_des_crypt';

(**
 * @brief Calculates CBC-MAC using the DES algorithm.
 *
 * @param count number of 8 byte blocks
 * @param dst destination array, can be equal to src, must be 8-byte aligned
 * @param src source array, can be equal to dst, must be 8-byte aligned, may be NULL
 *)
procedure av_des_mac(var d: AVDES; dst: PByte; const src: PByte; count: Integer); cdecl; external libavutil name _PU + 'av_des_mac';

implementation

end.
