unit Posix.ffmpeg.libavutil.version;

(*
 * copyright (c) 2003 Fabrice Bellard
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

(**
 * @file
 * @ingroup lavu
 * Libavutil version macros
 *)

interface

uses
  Posix.ffmpeg.libavutil.macros,
  SysUtils;

const

(**
 * @defgroup lavu_ver Version and Build diagnostics
 *
 * Macros and function useful to check at compiletime and at runtime
 * which version of libavutil is in use.
 *
 * @{
 *)
  LIBAVUTIL_VERSION_MAJOR = 56;
  LIBAVUTIL_VERSION_MINOR = 22;
  LIBAVUTIL_VERSION_MICRO = 100;


  FF_API_VAAPI = LIBAVUTIL_VERSION_MAJOR < 57;
  FF_API_FRAME_QP = LIBAVUTIL_VERSION_MAJOR < 57;
  FF_API_PLUS1_MINUS1 = LIBAVUTIL_VERSION_MAJOR < 57;
  FF_API_ERROR_FRAME = LIBAVUTIL_VERSION_MAJOR < 57;
  FF_API_PKT_PTS = LIBAVUTIL_VERSION_MAJOR < 57;
  FF_API_CRYPTO_SIZE_T = LIBAVUTIL_VERSION_MAJOR < 57;
  FF_API_FRAME_GET_SET = LIBAVUTIL_VERSION_MAJOR < 57;
  FF_API_PSEUDOPAL = LIBAVUTIL_VERSION_MAJOR < 57;



  function LIBAVUTIL_VERSION_INT: Integer;
  function LIBAVUTIL_VERSION_STR: String;
  function LIBAVUTIL_BUILD: Integer;
  function LIBAVUTIL_IDENT: string;

(**
 * @addtogroup version_utils
 *
 * Useful to check and match library version in order to maintain
 * backward compatibility.
 *
 * The FFmpeg libraries follow a versioning sheme very similar to
 * Semantic Versioning (http://semver.org/)
 * The difference is that the component called PATCH is called MICRO in FFmpeg
 * and its value is reset to 100 instead of 0 to keep it above or equal to 100.
 * Also we do not increase MICRO for every bugfix or change in git master.
 *
 * Prior to FFmpeg 3.2 point releases did not change any lib version number to
 * avoid aliassing different git master checkouts.
 * Starting with FFmpeg 3.2, the released library versions will occupy
 * a separate MAJOR.MINOR that is not used on the master development branch.
 * That is if we branch a release of master 55.10.123 we will bump to 55.11.100
 * for the release and master will continue at 55.12.100 after it. Each new
 * point release will then bump the MICRO improving the usefulness of the lib
 * versions.
 *
 * @{
 *)

  function AV_VERSION_INT(const a, b, c: Integer): Integer;
  function AV_VERSION_DOT(const a, b, c: Integer): string;
  function AV_VERSION(const a, b, c: Integer): string;

(**
 * Extract version components from the full ::AV_VERSION_INT int as returned
 * by functions like ::avformat_version() and ::avcodec_version()
 *)
  function AV_VERSION_MAJOR(a: Integer): Integer;
  function AV_VERSION_MINOR(a: Integer): Integer;
  function AV_VERSION_MICRO(a: Integer): Integer;


implementation



function LIBAVUTIL_VERSION_INT: Integer;
begin
  Result := AV_VERSION_INT(LIBAVUTIL_VERSION_MAJOR, LIBAVUTIL_VERSION_MINOR, LIBAVUTIL_VERSION_MICRO);
end;

function LIBAVUTIL_BUILD: Integer;
begin
  Result := AV_VERSION_INT(LIBAVUTIL_VERSION_MAJOR, LIBAVUTIL_VERSION_MINOR, LIBAVUTIL_VERSION_MICRO);
end;

function LIBAVUTIL_VERSION_STR: String;
begin
  Result := AV_VERSION(LIBAVUTIL_VERSION_MAJOR, LIBAVUTIL_VERSION_MINOR, LIBAVUTIL_VERSION_MICRO);
end;

function LIBAVUTIL_IDENT: string;
begin
  Result := 'Lavu' + AV_STRINGIFY(LIBAVUTIL_VERSION_STR);
end;

function AV_VERSION_INT(const a, b, c: Integer): Integer;
begin
  Result := a shl 16 + b shl 8 + c;
end;

function AV_VERSION_DOT(const a, b, c: Integer): string;
begin
  Result := Format('%0.2d.%0.2d.%0.2d.0', [a, b, c]);
end;

function AV_VERSION(const a, b, c: Integer): string;
begin
  Result := AV_VERSION_DOT(a, b, c);
end;

function AV_VERSION_MAJOR(a: Integer): Integer;
begin
  Result := a shr 16;
end;

function AV_VERSION_MINOR(a: Integer): Integer;
begin
  Result := (a and $FF00) shr 8;
end;

function AV_VERSION_MICRO(a: Integer): Integer;
begin
  Result := a and $FF;
end;

end.
