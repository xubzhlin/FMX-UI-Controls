unit Posix.ffmpeg.libpostproc.version;

(*
 * Copyright (C) 2001-2003 Michael Niedermayer (michaelni@gmx.at)
 *
 * This file is part of FFmpeg.
 *
 * FFmpeg is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * FFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with FFmpeg; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 *)

interface

uses
  Posix.ffmpeg.libavutil.version, Posix.ffmpeg.libavutil.macros;

const
  LIBPOSTPROC_VERSION_MAJOR  =  55;
  LIBPOSTPROC_VERSION_MINOR  =   3;
  LIBPOSTPROC_VERSION_MICRO  = 100;

function LIBPOSTPROC_VERSION_INT: Integer;
function LIBPOSTPROC_VERSION_STR: string;
function LIBPOSTPROC_BUILD: Integer;
function LIBPOSTPROC_IDENT: string;

implementation

function LIBPOSTPROC_VERSION_INT: Integer;
begin
  Result := AV_VERSION_INT(LIBPOSTPROC_VERSION_MAJOR, LIBPOSTPROC_VERSION_MINOR, LIBPOSTPROC_VERSION_MICRO);
end;

function LIBPOSTPROC_VERSION_STR: string;
begin
  Result := AV_VERSION(LIBPOSTPROC_VERSION_MAJOR, LIBPOSTPROC_VERSION_MINOR, LIBPOSTPROC_VERSION_MICRO);
end;

function LIBPOSTPROC_BUILD: Integer;
begin
  Result := LIBPOSTPROC_VERSION_INT;
end;

function LIBPOSTPROC_IDENT: string;
begin
  Result := 'postproc' + AV_STRINGIFY(LIBPOSTPROC_VERSION_STR);
end;

end.
