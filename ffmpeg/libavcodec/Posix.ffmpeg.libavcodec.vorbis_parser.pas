unit Posix.ffmpeg.libavcodec.vorbis_parser;

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

const

  VORBIS_FLAG_HEADER  = $00000001;
  VORBIS_FLAG_COMMENT = $00000002;
  VORBIS_FLAG_SETUP   = $00000004;

type
  PAVVorbisParseContext = Pointer;

(**
 * Allocate and initialize the Vorbis parser using headers in the extradata.
 *)
function av_vorbis_parse_init(const extradata: PByte; extradata_size: Integer): PAVVorbisParseContext; cdecl; external libavcodec name _PU + 'av_vorbis_parse_init';

(**
 * Free the parser and everything associated with it.
 *)
procedure av_vorbis_parse_free(var s: PAVVorbisParseContext); cdecl; external libavcodec name _PU + 'av_vorbis_parse_free';

(**
 * Get the duration for a Vorbis packet.
 *
 * If @p flags is @c NULL,
 * special frames are considered invalid.
 *
 * @param s        Vorbis parser context
 * @param buf      buffer containing a Vorbis frame
 * @param buf_size size of the buffer
 * @param flags    flags for special frames
 *)
function av_vorbis_parse_frame_flags(s: PAVVorbisParseContext; const buf: PByte; buf_size: Integer; var flags: Integer): Integer; cdecl; external libavcodec name _PU + 'av_vorbis_parse_frame_flags';

(**
 * Get the duration for a Vorbis packet.
 *
 * @param s        Vorbis parser context
 * @param buf      buffer containing a Vorbis frame
 * @param buf_size size of the buffer
 *)
function av_vorbis_parse_frame(s: PAVVorbisParseContext; const buf: PByte; buf_size: Integer): Integer; cdecl; external libavcodec name _PU + 'av_vorbis_parse_frame';

procedure av_vorbis_parse_reset(var s: PAVVorbisParseContext); cdecl; external libavcodec name _PU + 'av_vorbis_parse_reset';


implementation

end.
