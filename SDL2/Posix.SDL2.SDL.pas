unit Posix.SDL2.SDL;

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
  Linker.Helper, Posix.SDL2.consts;

const

(**
 *  \name SDL_INIT_*
 *
 *  These are the flags which may be passed to SDL_Init().  You should
 *  specify the subsystems which you will be using in your application.
 *)
  SDL_INIT_TIMER          = $00000001;
  SDL_INIT_AUDIO          = $00000010;
  SDL_INIT_VIDEO          = $00000020;  ///**< SDL_INIT_VIDEO implies SDL_INIT_EVENTS */
  SDL_INIT_JOYSTICK       = $00000200;  ///**< SDL_INIT_JOYSTICK implies SDL_INIT_EVENTS */
  SDL_INIT_HAPTIC         = $00001000;
  SDL_INIT_GAMECONTROLLER = $00002000;  ///**< SDL_INIT_GAMECONTROLLER implies SDL_INIT_JOYSTICK */
  SDL_INIT_EVENTS         = $00004000;
  SDL_INIT_SENSOR         = $00008000;
  SDL_INIT_NOPARACHUTE    = $00100000;  ///**< compatibility; this flag is ignored. */
  SDL_INIT_EVERYTHING = (
                SDL_INIT_TIMER or SDL_INIT_AUDIO or SDL_INIT_VIDEO or SDL_INIT_EVENTS or
                SDL_INIT_JOYSTICK or SDL_INIT_HAPTIC or SDL_INIT_GAMECONTROLLER or SDL_INIT_SENSOR
            );


(**
 *  This function initializes  the subsystems specified by \c flags
 *)
function SDL_Init(flags: Cardinal): Integer; cdecl; external libSDL2 name _PU + 'SDL_Init';

(**
 *  This function initializes specific SDL subsystems
 *
 *  Subsystem initialization is ref-counted, you must call
 *  SDL_QuitSubSystem() for each SDL_InitSubSystem() to correctly
 *  shutdown a subsystem manually (or call SDL_Quit() to force shutdown).
 *  If a subsystem is already loaded then this call will
 *  increase the ref-count and return.
 *)
function SDL_InitSubSystem(flags: Cardinal): Integer; cdecl; external libSDL2 name _PU + 'SDL_InitSubSystem';

(**
 *  This function cleans up specific SDL subsystems
 *)
function SDL_QuitSubSystem(flags: Cardinal): Integer; cdecl; external libSDL2 name _PU + 'SDL_QuitSubSystem';

(**
 *  This function returns a mask of the specified subsystems which have
 *  previously been initialized.
 *
 *  If \c flags is 0, it returns a mask of all initialized subsystems.
 *)
function SDL_WasInit(flags: Cardinal): Cardinal; cdecl; external libSDL2 name _PU + 'SDL_WasInit';

(**
 *  This function cleans up all initialized subsystems. You should
 *  call it upon all exit conditions.
 *)
procedure SDL_Quit; cdecl; external libSDL2 name _PU + 'SDL_Quit';


implementation

end.
