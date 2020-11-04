unit Posix.ffmpeg.libavcodec.adts_parser;

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

(**
 * Extract the number of samples and frames from AAC data.
 * @param[in]  buf     pointer to AAC data buffer
 * @param[out] samples Pointer to where number of samples is written
 * @param[out] frames  Pointer to where number of frames is written
 * @return Returns 0 on success, error code on failure.
 *)
function av_adts_header_parse(const buf: PByte; samples: PCardinal; frame_size: PByte): Integer; cdecl; external libavcodec name _PU + 'av_adts_header_parse';


implementation

end.

