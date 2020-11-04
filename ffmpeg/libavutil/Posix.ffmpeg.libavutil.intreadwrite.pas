unit Posix.ffmpeg.libavutil.intreadwrite;

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

type
  av_alias64 = record
  case Integer of
      0:
        (u64: Uint64);
      1:
        (u32: array[0..1] of Cardinal);
      2:
        (u16: array[0..3] of WORD);
      3:
        (u8: array[0..7] of Byte);
      4:
        (f64: Double);
      5:
        (f32: array[0..1] of Single);
  end;

  av_alias32 = record
  case Integer of
      0:
        (u32: Cardinal);
      1:
        (u16: array[0..1] of WORD);
      2:
        (u8: array[0..3] of Byte);
      3:
        (f32: Single);
  end;

  av_alias16 = record
  case Integer of
      0:
        (u16: WORD);
      1:
        (u8: array[0..1] of Byte);
  end;


implementation

end.
