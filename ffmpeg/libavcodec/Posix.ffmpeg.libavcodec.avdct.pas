unit Posix.ffmpeg.libavcodec.avdct;

(*
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
 * AVDCT context.
 * @note function pointers can be NULL if the specific features have been
 *       disabled at build time.
 *)
  PAVDCT = ^AVDCT;
  AVDCT = record
    av_class: Pointer;
    idct: procedure(block: PWORD); cdecl; //* align 16 */
    (**
     * IDCT input permutation.
     * Several optimized IDCTs need a permutated input (relative to the
     * normal order of the reference IDCT).
     * This permutation must be performed before the idct_put/add.
     * Note, normally this can be merged with the zigzag/alternate scan<br>
     * An example to avoid confusion:
     * - (->decode coeffs -> zigzag reorder -> dequant -> reference IDCT -> ...)
     * - (x -> reference DCT -> reference IDCT -> x)
     * - (x -> reference DCT -> simple_mmx_perm = idct_permutation
     *    -> simple_idct_mmx -> x)
     * - (-> decode coeffs -> zigzag reorder -> simple_mmx_perm -> dequant
     *    -> simple_idct_mmx -> ...)
     *)
    idct_permutation: array[0..63] of Byte;
    fdct: procedure(block: PWORD); cdecl; //* align 16 */
    (*
     * DCT algorithm.
     * must use AVOptions to set this field.
     *)
    dct_algo: Integer;

    (*
     * IDCT algorithm.
     * must use AVOptions to set this field.
     *)
    idct_algo: Integer;
    get_pixels: procedure(block: PWORD; pixels: PByte; line_size: NativeInt); cdecl;

    bits_per_sample: Integer;
  end;

(**
 * Allocates a AVDCT context.
 * This needs to be initialized with avcodec_dct_init() after optionally
 * configuring it with AVOptions.
 *
 * To free it use av_free()
 *)
function avcodec_dct_alloc: PAVDCT; cdecl; external libavcodec name _PU + 'avcodec_dct_alloc';

function avcodec_dct_init(dct: PAVDCT): Integer; cdecl; external libavcodec name _PU + 'avcodec_dct_init';

function avcodec_dct_get_class: Pointer; cdecl; external libavcodec name _PU + 'avcodec_dct_get_class';


implementation

end.

