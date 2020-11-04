unit Posix.SDL2.SDL_keyboard;

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
  Linker.Helper, Posix.SDL2.consts, Posix.SDL2.SDL_scancode;

type
  SDL_Keycode = Integer;

(**
 *  \brief The SDL keysym structure, used in key events.
 *
 *  \note  If you are looking for translated character input, see the ::SDL_TEXTINPUT event.
 *)
  SDL_Keysym = record
    scancode: SDL_Scancode;      ///**< SDL physical key code - see ::SDL_Scancode for details */
    sym: SDL_Keycode;            ///**< SDL virtual key code - see ::SDL_Keycode for details */
    &mod: WORD;                  ///**< current key modifiers */
    unused: Cardinal;
  end;

implementation

end.
