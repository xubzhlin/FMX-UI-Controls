unit Posix.ffmpeg.libavfilter.version;

(*
 * Version macros.
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
  Posix.ffmpeg.libavutil.version, Posix.ffmpeg.libavutil.macros;

const
  LIBAVFILTER_VERSION_MAJOR  =   7;
  LIBAVFILTER_VERSION_MINOR  =  40;
  LIBAVFILTER_VERSION_MICRO  = 101;

(**
 * FF_API_* defines may be placed below to indicate public API that will be
 * dropped at a future version bump. The defines themselves are not part of
 * the public API and may change, break or disappear at any time.
 *)

  FF_API_OLD_FILTER_OPTS_ERROR       = (LIBAVFILTER_VERSION_MAJOR < 8);
  FF_API_LAVR_OPTS                   = (LIBAVFILTER_VERSION_MAJOR < 8);
  FF_API_FILTER_GET_SET              = (LIBAVFILTER_VERSION_MAJOR < 8);
  FF_API_NEXT                        = (LIBAVFILTER_VERSION_MAJOR < 8);

function LIBAVFILTER_VERSION_INT: Integer;
function LIBAVFILTER_VERSION_STR: string;
function LIBAVFILTER_BUILD: Integer;
function LIBAVFILTER_IDENT: string;

implementation

function LIBAVFILTER_VERSION_INT: Integer;
begin
  Result := AV_VERSION_INT(LIBAVFILTER_VERSION_MAJOR, LIBAVFILTER_VERSION_MINOR, LIBAVFILTER_VERSION_MICRO);
end;

function LIBAVFILTER_VERSION_STR: string;
begin
  Result := AV_VERSION(LIBAVFILTER_VERSION_MAJOR, LIBAVFILTER_VERSION_MINOR, LIBAVFILTER_VERSION_MICRO);
end;

function LIBAVFILTER_BUILD: Integer;
begin
  Result := LIBAVFILTER_VERSION_INT;
end;

function LIBAVFILTER_IDENT: string;
begin
  Result := 'Lavfi' + AV_STRINGIFY(LIBAVFILTER_VERSION_STR);
end;

end.
