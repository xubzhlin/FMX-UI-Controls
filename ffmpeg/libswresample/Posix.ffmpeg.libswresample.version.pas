unit Posix.ffmpeg.libswresample.version;

(*
 * Copyright (C) 2011-2013 Michael Niedermayer (michaelni@gmx.at)
 *
 * This file is part of libswresample
 *
 * libswresample is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * libswresample is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with libswresample; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 *)

interface

uses
  Posix.ffmpeg.libavutil.version, Posix.ffmpeg.libavutil.macros;

const
  LIBSWRESAMPLE_VERSION_MAJOR   =   3;
  LIBSWRESAMPLE_VERSION_MINOR   =   3;
  LIBSWRESAMPLE_VERSION_MICRO   = 100;

function LIBSWRESAMPLE_VERSION_INT: Integer;
function LIBSWRESAMPLE_VERSION_STR: string;
function LIBSWRESAMPLE_BUILD: Integer;
function LIBSWRESAMPLE_IDENT: string;

implementation

function LIBSWRESAMPLE_VERSION_INT: Integer;
begin
  Result := AV_VERSION_INT(LIBSWRESAMPLE_VERSION_MAJOR, LIBSWRESAMPLE_VERSION_MINOR, LIBSWRESAMPLE_VERSION_MICRO);
end;

function LIBSWRESAMPLE_VERSION_STR: string;
begin
  Result := AV_VERSION(LIBSWRESAMPLE_VERSION_MAJOR, LIBSWRESAMPLE_VERSION_MINOR, LIBSWRESAMPLE_VERSION_MICRO)
end;

function LIBSWRESAMPLE_BUILD: Integer;
begin
  Result := LIBSWRESAMPLE_VERSION_INT;
end;

function LIBSWRESAMPLE_IDENT: string;
begin
  Result := 'SwR' + AV_STRINGIFY(LIBSWRESAMPLE_VERSION_STR);
end;

end.
