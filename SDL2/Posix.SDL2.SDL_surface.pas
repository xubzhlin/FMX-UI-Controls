unit Posix.SDL2.SDL_surface;

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
  Linker.Helper, Posix.SDL2.consts, Posix.SDL2.SDL_rect;

const
(**
 *  \name Surface flags
 *
 *  These are the currently supported flags for the ::SDL_Surface.
 *
 *  \internal
 *  Used internally (read-only).
 *)
  SDL_SWSURFACE      = 0;          ///**< Just here for compatibility */
  SDL_PREALLOC       = $00000001;  ///**< Surface uses preallocated memory */
  SDL_RLEACCEL       = $00000002;  ///**< Surface is RLE encoded */
  SDL_DONTFREE       = $00000004;  ///**< Surface is referenced internally */

type
  PSDL_BlitMap = Pointer;
  PSDL_PixelFormat = Pointer;
 (**
 * \brief A collection of pixels used in software blitting.
 *
 * \note  This structure should be treated as read-only, except for \c pixels,
 *        which, if not NULL, contains the raw pixel data for the surface.
 *)
  PSDL_Surface = ^SDL_Surface;
  SDL_Surface = record
    flags: Cardinal;               ///**< Read-only */
    format: PSDL_PixelFormat;      ///**< Read-only */
    w, h: Integer;                 ///**< Read-only */
    pitch: Integer;                ///**< Read-only */
    pixels: Pointer;               ///**< Read-write */

    ///** Application data associated with the surface */
    userdata: Pointer;             ///**< Read-write */

    ///** information needed for surfaces requiring locks */
    locked: Integer;               ///**< Read-only */
    lock_data: Pointer;            ///**< Read-only */

    ///** clipping information */
    clip_rect: SDL_Rect;         ///**< Read-only */

    ///** info for fast blit mapping to other surfaces */
    map: PSDL_BlitMap;    ///**< Private */

    ///** Reference count -- used when freeing surface */
    refcount: Integer;               ///**< Read-mostly */
  end;


implementation

end.
