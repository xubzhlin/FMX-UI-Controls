unit Posix.ffmpeg.libavutil.md5;

(*
 * copyright (c) 2006 Michael Niedermayer <michaelni@gmx.at>
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
  av_md5_size = Integer;

  PAVMD5 = ^AVMD5;
  AVMD5 = record
    len: UInt64;
    block: array [0 .. 7] of Byte;
    ABCD: array [0 .. 3] of Cardinal;
  end;

(**
 * Allocate an AVMD5 context.
 *)
function av_md5_alloc: PAVMD5; cdecl; external libavutil name _PU + 'av_md5_alloc';

(**
 * Initialize MD5 hashing.
 *
 * @param ctx pointer to the function context (of size av_md5_size)
 *)
procedure av_md5_init(ctx: PAVMD5); cdecl; external libavutil name _PU + 'av_md5_init';

(**
 * Update hash value.
 *
 * @param ctx hash function context
 * @param src input data to update hash with
 * @param len input data length
 *)
procedure av_md5_update(ctx: PAVMD5; const src: PByte; len: Integer); cdecl; external libavutil name _PU + 'av_md5_update';

(**
 * Finish hashing and output digest value.
 *
 * @param ctx hash function context
 * @param dst buffer where output digest value is stored
 *)
procedure av_md5_final(ctx: PAVMD5; dst: PByte); cdecl; external libavutil name _PU + 'av_md5_final';

(**
 * Hash an array of data.
 *
 * @param dst The output buffer to write the digest into
 * @param src The data to hash
 * @param len The length of the data, in bytes
 *)
procedure av_md5_sum(dst: PByte; const src: PByte; len: Integer); cdecl; external libavutil name _PU + 'av_md5_sum';

implementation

end.
