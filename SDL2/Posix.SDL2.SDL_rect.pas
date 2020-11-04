unit Posix.SDL2.SDL_rect;

(*
  Simple DirectMedia Layer
  Copyright (C) 1997-2018 Sam Lantinga <slouken@libsdl.org>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*)

interface

uses
  Linker.Helper, Posix.SDL2.consts, Posix.SDL2.SDL_stdinc;

type
(**
 *  \brief  The structure that defines a point
 *
 *  \sa SDL_EnclosePoints
 *  \sa SDL_PointInRect
 *)
  PSDL_Point = ^SDL_Point;
  SDL_Point = record
    x: Integer;
    y: Integer;
  end;

(**
 *  \brief A rectangle, with the origin at the upper left.
 *
 *  \sa SDL_RectEmpty
 *  \sa SDL_RectEquals
 *  \sa SDL_HasIntersection
 *  \sa SDL_IntersectRect
 *  \sa SDL_UnionRect
 *  \sa SDL_EnclosePoints
 *)
  PSDL_Rect = ^SDL_Rect;
  SDL_Rect = record
    x, y: Integer;
    w, h: Integer;
  end;

 (**
 *  \brief Determine whether two rectangles intersect.
 *
 *  \return SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
 *)
function SDL_HasIntersection(const A: PSDL_Rect; const B: PSDL_Rect): SDL_bool; cdecl; external libSDL2 name _PU + 'SDL_HasIntersection';

(**
 *  \brief Calculate the intersection of two rectangles.
 *
 *  \return SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
 *)
function SDL_IntersectRect(const A: PSDL_Rect; const B: PSDL_Rect; rect: PSDL_Rect): SDL_bool; cdecl; external libSDL2 name _PU + 'SDL_IntersectRect';

(**
 *  \brief Calculate the union of two rectangles.
 *)
procedure SDL_UnionRect(const A: PSDL_Rect; const B: PSDL_Rect; rect: PSDL_Rect); cdecl; external libSDL2 name _PU + 'SDL_UnionRect';

(**
 *  \brief Calculate a minimal rectangle enclosing a set of points
 *
 *  \return SDL_TRUE if any points were within the clipping rect
 *)
function SDL_EnclosePoints(const points: PSDL_Point; count: Integer; const clip: PSDL_Rect; rect: PSDL_Rect): SDL_bool; cdecl; external libSDL2 name _PU + 'SDL_EnclosePoints';

(**
 *  \brief Calculate the intersection of a rectangle and line segment.
 *
 *  \return SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
 *)
function SDL_IntersectRectAndLine(const rect: PSDL_Rect; var X1: Integer; var Y1: Integer; var X2: Integer; var Y2: Integer): SDL_bool; cdecl; external libSDL2 name _PU + 'SDL_IntersectRectAndLine';

implementation


(**
 *  \brief Returns true if point resides inside a rectangle.
 *)
function SDL_PointInRect(const p: PSDL_Point; const r: PSDL_Rect): SDL_bool;
var
  ret: Boolean;
begin
  ret := (p^.x = r^.x) and (p^.x < (r^.x + r^.w)) and
    (p^.y = r^.y) and (p^.y < (r^.y + r^.h));
  if ret then
    Result := SDL_TRUE
  else
    Result := SDL_False;
end;

(**
 *  \brief Returns true if the rectangle has no area.
 *)
function SDL_RectEmpty(const r: PSDL_Rect): SDL_bool;
var
  ret: Boolean;
begin
  ret := (r = nil) or (r^.w <= 0) or (r^.h <= 0);
  if ret then
    Result := SDL_TRUE
  else
    Result := SDL_False;
end;

(**
 *  \brief Returns true if the two rectangles are equal.
 *)
function SDL_RectEquals(const a: PSDL_Rect; const b: PSDL_Rect): SDL_bool;
var
  ret: Boolean;
begin
  ret := (a <> nil) and (b <> nil) and (a^.x = b^.x) and (a^.y = b^.y) and
    (a^.w = b^.w) and (a^.h = b^.h);
  if ret then
    Result := SDL_TRUE
  else
    Result := SDL_False;
end;


end.
