unit Posix.ffmpeg.libavutil.infloat;

(*
 * Copyright (c) 2011 Mans Rullgard
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

type
  av_intfloat32 = record
  case Integer of
      0:
        (i: Cardinal);
      1:
        (f: Double);
  end;

  av_intfloat64 = record
  case Integer of
      0:
        (i: UInt64);
      1:
        (f: Double);
  end;

function av_int2float(i: Cardinal): Double;
function av_float2int(f: Double): Cardinal;
function av_int2double(i: Cardinal): Double;
function av_double2int(f: Double): UInt64;

implementation

function av_int2float(i: Cardinal): Double;
var
  v: av_intfloat32;
begin
  v.i    := i;
  Result := v.f;
end;

function av_float2int(f: Double): Cardinal;
var
  v: av_intfloat32;
begin
  v.f    := f;
  Result := v.i;
end;

function av_int2double(i: Cardinal): Double;
var
  v: av_intfloat64;
begin
  v.i    := i;
  Result := v.f;
end;

function av_double2int(f: Double): UInt64;
var
  v: av_intfloat64;
begin
  v.f    := f;
  Result := v.i;
end;

end.
