unit Posix.ffmpeg.libavutil.murmur3;

(*
 * Copyright (C) 2013 Reimar Döffinger <Reimar.Doeffinger@gmx.de>
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
  Tarr16Byte = array [0 .. 15] of Byte;

  PAVMurMur3 = ^AVMurMur3;
  AVMurMur3 = record
    h1, h2: UInt64;
    state: Tarr16Byte;
    state_pos: Integer;
    len: UInt64;
  end;
(**
 * @defgroup lavu_murmur3 Murmur3
 * @ingroup lavu_hash
 * MurmurHash3 hash function implementation.
 *
 * MurmurHash3 is a non-cryptographic hash function, of which three
 * incompatible versions were created by its inventor Austin Appleby:
 *
 * - 32-bit output
 * - 128-bit output for 32-bit platforms
 * - 128-bit output for 64-bit platforms
 *
 * FFmpeg only implements the last variant: 128-bit output designed for 64-bit
 * platforms. Even though the hash function was designed for 64-bit platforms,
 * the function in reality works on 32-bit systems too, only with reduced
 * performance.
 *
 * @anchor lavu_murmur3_seedinfo
 * By design, MurmurHash3 requires a seed to operate. In response to this,
 * libavutil provides two functions for hash initiation, one that requires a
 * seed (av_murmur3_init_seeded()) and one that uses a fixed arbitrary integer
 * as the seed, and therefore does not (av_murmur3_init()).
 *
 * To make hashes comparable, you should provide the same seed for all calls to
 * this hash function -- if you are supplying one yourself, that is.
 *
 * @{
 *)

(**
 * Allocate an AVMurMur3 hash context.
 *
 * @return Uninitialized hash context or `NULL` in case of error
 *)
function av_murmur3_alloc: PAVMurMur3; cdecl; external libavutil name _PU + 'av_murmur3_alloc';

(**
 * Initialize or reinitialize an AVMurMur3 hash context with a seed.
 *
 * @param[out] c    Hash context
 * @param[in]  seed Random seed
 *
 * @see av_murmur3_init()
 * @see @ref lavu_murmur3_seedinfo "Detailed description" on a discussion of
 * seeds for MurmurHash3.
 *)
procedure av_murmur3_init_seeded(c: PAVMurMur3; seed: UInt64); cdecl; external libavutil name _PU + 'av_murmur3_init_seeded';

(**
 * Initialize or reinitialize an AVMurMur3 hash context.
 *
 * Equivalent to av_murmur3_init_seeded() with a built-in seed.
 *
 * @param[out] c    Hash context
 *
 * @see av_murmur3_init_seeded()
 * @see @ref lavu_murmur3_seedinfo "Detailed description" on a discussion of
 * seeds for MurmurHash3.
 *)
procedure av_murmur3_init(c: PAVMurMur3); cdecl; external libavutil name _PU + 'av_murmur3_init';

(**
 * Update hash context with new data.
 *
 * @param[out] c    Hash context
 * @param[in]  src  Input data to update hash with
 * @param[in]  len  Number of bytes to read from `src`
 *)
procedure av_murmur3_update(c: PAVMurMur3; const src: PByte; len: Integer); cdecl; external libavutil name _PU + 'av_murmur3_update';

(**
 * Finish hashing and output digest value.
 *
 * @param[in,out] c    Hash context
 * @param[out]    dst  Buffer where output digest value is stored
 *)
procedure av_murmur3_final(c: PAVMurMur3; dst: Tarr16Byte); cdecl; external libavutil name _PU + 'av_murmur3_final';

implementation

end.
