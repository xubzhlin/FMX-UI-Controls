unit Posix.ffmpeg.libavutil.macros;

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

(**
 * @file
 * @ingroup lavu
 * Utility Preprocessor macros
 *)

interface


(**
 * @addtogroup preproc_misc Preprocessor String Macros
 *
 * String manipulation macros
 *
 * @{
 *)
function AV_STRINGIFY(const strTemp: string): string;
function AV_TOSTRING(const strTemp: string): String;
function AV_GLUE(a, b: string): string;
function AV_JOIN(a, b: string): string;

function AV_PRAGMA(strTemp: string): string;
function FFALIGN(x, a: Integer): Integer;



implementation

function AV_TOSTRING(const strTemp: string): String;
begin
  Result := '#' + strTemp;
end;

function AV_STRINGIFY(const strTemp: string): string;
begin
  Result := AV_TOSTRING(strTemp);
end;

function AV_GLUE(a, b: string): string;
begin
  Result := a + '##' + b;
end;

function AV_JOIN(a, b: string): string;
begin
  Result := AV_GLUE(a, b);
end;

function AV_PRAGMA(strTemp: string): string;
begin
  Result := '#' + strTemp;
end;

function FFALIGN(x, a: Integer): Integer;
begin
  Result := (x + a -1) and (not (a - 1));
end;

end.
