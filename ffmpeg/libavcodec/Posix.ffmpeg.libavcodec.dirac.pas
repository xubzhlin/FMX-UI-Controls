unit Posix.ffmpeg.libavcodec.dirac;

(*
 * Copyright (C) 2007 Marco Gerards <marco@gnu.org>
 * Copyright (C) 2009 David Conrad
 * Copyright (C) 2011 Jordi Ortiz
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
  Linker.Helper, Posix.ffmpeg.consts, Posix.ffmpeg.libavutil.rational, Posix.ffmpeg.libavutil.pixfmt;

const
(**
 * The spec limits the number of wavelet decompositions to 4 for both
 * level 1 (VC-2) and 128 (long-gop default).
 * 5 decompositions is the maximum before >16-bit buffers are needed.
 * Schroedinger allows this for DD 9,7 and 13,7 wavelets only, limiting
 * the others to 4 decompositions (or 3 for the fidelity filter).
 *
 * We use this instead of MAX_DECOMPOSITIONS to save some memory.
 *)
  MAX_DWT_LEVELS = 5;

type
(**
 * Parse code values:
 *
 * Dirac Specification ->
 * 9.6.1  Table 9.1
 *
 * VC-2 Specification  ->
 * 10.4.1 Table 10.1
 *)
  DiracParseCodes = (
    DIRAC_PCODE_SEQ_HEADER      = $00,
    DIRAC_PCODE_END_SEQ         = $10,
    DIRAC_PCODE_AUX             = $20,
    DIRAC_PCODE_PAD             = $30,
    DIRAC_PCODE_PICTURE_CODED   = $08,
    DIRAC_PCODE_PICTURE_RAW     = $48,
    DIRAC_PCODE_PICTURE_LOW_DEL = $C8,
    DIRAC_PCODE_PICTURE_HQ      = $E8,
    DIRAC_PCODE_INTER_NOREF_CO1 = $0A,
    DIRAC_PCODE_INTER_NOREF_CO2 = $09,
    DIRAC_PCODE_INTER_REF_CO1   = $0D,
    DIRAC_PCODE_INTER_REF_CO2   = $0E,
    DIRAC_PCODE_INTRA_REF_CO    = $0C,
    DIRAC_PCODE_INTRA_REF_RAW   = $4C,
    DIRAC_PCODE_INTRA_REF_PICT  = $CC,
    DIRAC_PCODE_MAGIC           = $42424344
  );

  PDiracVersionInfo = ^DiracVersionInfo;
  DiracVersionInfo = record
    major: Integer;
    minor: Integer;
  end;

  PAVDiracSeqHeader = ^AVDiracSeqHeader;
  AVDiracSeqHeader = record
    width: Cardinal;
    height: Cardinal;
    chroma_format: Byte;          ///< 0: 444  1: 422  2: 420

    interlaced: Byte;
    top_field_first: Byte;

    frame_rate_index: Byte;       ///< index into dirac_frame_rate[]
    aspect_ratio_index: Byte;     ///< index into dirac_aspect_ratio[]

    clean_width: WORD;
    clean_height: WORD;
    clean_left_offset: WORD;
    clean_right_offset: WORD;

    pixel_range_index: Byte;      ///< index into dirac_pixel_range_presets[]
    color_spec_index: Byte;       ///< index into dirac_color_spec_presets[]

    profile: Integer;
    level: Integer;

    framerate: AVRational;
    sample_aspect_ratio: AVRational;

    pix_fmt: AVPixelFormat;
    color_range: AVColorRange;
    color_primaries: AVColorPrimaries;
    color_trc: AVColorTransferCharacteristic;
    colorspace: AVColorSpace;

    version: DiracVersionInfo;
    bit_depth: Integer;
  end;

(**
 * Parse a Dirac sequence header.
 *
 * @param dsh this function will allocate and fill an AVDiracSeqHeader struct
 *            and write it into this pointer. The caller must free it with
 *            av_free().
 * @param buf the data buffer
 * @param buf_size the size of the data buffer in bytes
 * @param log_ctx if non-NULL, this function will log errors here
 * @return 0 on success, a negative AVERROR code on failure
 *)
function av_dirac_parse_sequence_header(var dsh: PAVDiracSeqHeader; const buf: PByte; buf_size: NativeInt; log_ctx: Pointer): Integer; cdecl; external libavcodec name _PU + 'av_dirac_parse_sequence_header';


implementation

end.
