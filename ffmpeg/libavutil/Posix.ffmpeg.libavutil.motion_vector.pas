unit Posix.ffmpeg.libavutil.motion_vector;

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
  PAVMotionVector = ^AVMotionVector;
  AVMotionVector = record
    (**
     * Where the current macroblock comes from; negative value when it comes
     * from the past, positive value when it comes from the future.
     * XXX: set exact relative ref frame reference instead of a +/- 1 "direction".
     *)
    source: Integer;
    (**
     * Width and height of the block.
     *)
    w, h: Byte;
    (**
     * Absolute source position. Can be outside the frame area.
     *)
    src_x, src_y: WORD;
    (**
     * Absolute destination position. Can be outside the frame area.
     *)
    dst_x, dst_y: WORD;
    (**
     * Extra flag information.
     * Currently unused.
     *)
    flags: UInt64;
    (**
     * Motion vector
     * src_x = dst_x + motion_x / motion_scale
     * src_y = dst_y + motion_y / motion_scale
     *)
    motion_x, motion_y: Integer;
    motion_scale: WORD;
  end;

implementation

end.
