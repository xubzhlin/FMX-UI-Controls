unit Posix.ffmpeg.libavutil.twofish;

(*
 * An implementation of the TwoFish algorithm
 * Copyright (c) 2015 Supraja Meedinti
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
  PAVTWOFISH = ^AVTWOFISH;
  AVTWOFISH = record
    K: array[0..39] of Cardinal;
    S: array[0..3] of Cardinal;
    ksize: Integer;
    MDS1: array[0..255] of Cardinal;
    MDS2: array[0..255] of Cardinal;
    MDS3: array[0..255] of Cardinal;
    MDS4: array[0..255] of Cardinal;
  end;

(**
  * Allocate an AVTWOFISH context
  * To free the struct: av_free(ptr)
  *)
function av_twofish_alloc: PAVTWOFISH; cdecl; external libavutil name _PU + 'av_twofish_alloc';

(**
  * Initialize an AVTWOFISH context.
  *
  * @param ctx an AVTWOFISH context
  * @param key a key of size ranging from 1 to 32 bytes used for encryption/decryption
  * @param key_bits number of keybits: 128, 192, 256 If less than the required, padded with zeroes to nearest valid value; return value is 0 if key_bits is 128/192/256, -1 if less than 0, 1 otherwise
 *)
function av_twofish_init(ctx: PAVTWOFISH; const key: PByte; key_bits: Integer): Integer; cdecl; external libavutil name _PU + 'av_twofish_init';

(**
  * Encrypt or decrypt a buffer using a previously initialized context
  *
  * @param ctx an AVTWOFISH context
  * @param dst destination array, can be equal to src
  * @param src source array, can be equal to dst
  * @param count number of 16 byte blocks
  * @paran iv initialization vector for CBC mode, NULL for ECB mode
  * @param decrypt 0 for encryption, 1 for decryption
 *)
function av_twofish_crypt(ctx: PAVTWOFISH; dst: PByte; const src: PByte; count: Integer;
  iv: PByte; decrypt: Integer): Integer; cdecl; external libavutil name _PU + 'av_twofish_crypt';

implementation

end.
