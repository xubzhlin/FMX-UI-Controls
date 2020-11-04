unit Posix.ffmpeg.libavutil.bswap;

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

function AV_BSWAP16C(x: Integer): Integer;
function AV_BSWAP32C(x: Integer): Integer;
function AV_BSWAP64C(x: Integer): Integer;

implementation

function AV_BSWAP16C(x: Integer): Integer;
begin
  Result := (x shl 8 and $FF00) or (x shr 8 and $0FF);
end;

function AV_BSWAP32C(x: Integer): Integer;
begin
  Result := (AV_BSWAP16C(x) shl 16) or (AV_BSWAP16C(x) shr 16);
end;

function AV_BSWAP64C(x: Integer): Integer;
begin
  Result := (AV_BSWAP32C(x) shl 32) or (AV_BSWAP32C(x) shr 32);
end;

end.
