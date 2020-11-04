unit Posix.ffmpeg.libavutil.hmac;

(*
 * Copyright (C) 2012 Martin Storsjo
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
  MAX_HASHLEN   =  64;
  MAX_BLOCKLEN  = 128;

type

(**
 * @defgroup lavu_hmac HMAC
 * @ingroup lavu_crypto
 * @{
 *)
  AVHMACType = (
    AV_HMAC_MD5,
    AV_HMAC_SHA1,
    AV_HMAC_SHA224,
    AV_HMAC_SHA256,
    AV_HMAC_SHA384,
    AV_HMAC_SHA512
  );

  Thmac_final = procedure(ctx: Pointer; dst: PByte); cdecl;
  Thmac_update = procedure(ctx: Pointer; const src: PByte; len: Integer); cdecl;
  Thmac_init = procedure(ctx: Pointer); cdecl;

  PAVHMAC = ^AVHMAC;
  AVHMAC = record
    hash: Pointer;
    blocklen, hashlen: Integer;
    hmac_final: Thmac_final;
    update: Thmac_update;
    init: Thmac_init;
    key: array[0..MAX_BLOCKLEN-1] of Byte;
    keylen: Integer;
  end;

(**
 * Allocate an AVHMAC context.
 * @param type The hash function used for the HMAC.
 *)
function av_hmac_alloc(&type: AVHMACType): PAVHMAC; cdecl; external libavutil name _PU + 'av_hmac_alloc';

(**
 * Free an AVHMAC context.
 * @param ctx The context to free, may be NULL
 *)
procedure av_hmac_free(var ctx: AVHMAC); cdecl; external libavutil name _PU + 'av_hmac_free';

(**
 * Initialize an AVHMAC context with an authentication key.
 * @param ctx    The HMAC context
 * @param key    The authentication key
 * @param keylen The length of the key, in bytes
 *)
procedure av_hmac_init(var ctx: AVHMAC; const key: PByte; keylen: Cardinal); cdecl; external libavutil name _PU + 'av_hmac_init';

(**
 * Hash data with the HMAC.
 * @param ctx  The HMAC context
 * @param data The data to hash
 * @param len  The length of the data, in bytes
 *)
procedure av_hmac_update(var ctx: AVHMAC; const data: PByte; len: Cardinal); cdecl; external libavutil name _PU + 'av_hmac_update';

(**
 * Finish hashing and output the HMAC digest.
 * @param ctx    The HMAC context
 * @param out    The output buffer to write the digest into
 * @param outlen The length of the out buffer, in bytes
 * @return       The number of bytes written to out, or a negative error code.
 *)
function av_hmac_final(var ctx: AVHMAC; &out: PByte; outlen: Cardinal): Integer; cdecl; external libavutil name _PU + 'av_hmac_final';

(**
 * Hash an array of data with a key.
 * @param ctx    The HMAC context
 * @param data   The data to hash
 * @param len    The length of the data, in bytes
 * @param key    The authentication key
 * @param keylen The length of the key, in bytes
 * @param out    The output buffer to write the digest into
 * @param outlen The length of the out buffer, in bytes
 * @return       The number of bytes written to out, or a negative error code.
 *)
function av_hmac_calc(var ctx: AVHMAC; const data: PByte; len: Cardinal; const key: PByte;
  keylen: Cardinal; &out: PByte; outlen: Cardinal): Integer; cdecl; external libavutil name _PU + 'av_hmac_calc';


implementation

end.
