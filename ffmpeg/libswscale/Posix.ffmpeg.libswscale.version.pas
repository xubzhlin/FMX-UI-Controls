unit Posix.ffmpeg.libswscale.version;

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
  Posix.ffmpeg.libavutil.version, Posix.ffmpeg.libavutil.macros;

const
  LIBSWSCALE_VERSION_MAJOR  =   5;
  LIBSWSCALE_VERSION_MINOR  =   3;
  LIBSWSCALE_VERSION_MICRO  = 100;
  FF_API_SWS_VECTOR         = (LIBSWSCALE_VERSION_MAJOR < 6);

function LIBSWSCALE_VERSION_INT: Integer;
function LIBSWSCALE_VERSION_STR: string;
function LIBSWSCALE_BUILD: Integer;
function LIBSWSCALE_IDENT: string;

implementation

function LIBSWSCALE_VERSION_INT: Integer;
begin
  Result := AV_VERSION_INT(LIBSWSCALE_VERSION_MAJOR, LIBSWSCALE_VERSION_MINOR, LIBSWSCALE_VERSION_MICRO);
end;

function LIBSWSCALE_VERSION_STR: String;
begin
  Result := AV_VERSION(LIBSWSCALE_VERSION_MAJOR, LIBSWSCALE_VERSION_MINOR, LIBSWSCALE_VERSION_MICRO);
end;

function LIBSWSCALE_BUILD: Integer;
begin
  Result := LIBSWSCALE_VERSION_INT;
end;

function LIBSWSCALE_IDENT: string;
begin
  Result := 'SwS' + AV_STRINGIFY(LIBSWSCALE_VERSION_STR);
end;

end.
