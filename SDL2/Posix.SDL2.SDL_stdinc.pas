unit Posix.SDL2.SDL_stdinc;

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
 * \brief A signed 8-bit integer type.
 *)
  SDL_MAX_SINT8   =  127;        //* 127 */
  SDL_MIN_SINT8   = -128;        //* -128 */

  SDL_MAX_SINT16 =  32767;
  SDL_MIN_SINT16 = -32768;

  SDL_MAX_UINT16 = 65535;
  SDL_MIN_UINT16 = 0;

  SDL_MAX_SINT32 =  2147483647;
  SDL_MIN_SINT32 = -2147483648;

  SDL_MAX_UINT32 = 4294967295;
  SDL_MIN_UINT32 = 0;

  SDL_MAX_SINT64 =  9223372036854775807;
  SDL_MIN_SINT64 = -9223372036854775808;

  SDL_MAX_UINT64 = 18446744073709551615;
  SDL_MIN_UINT64 = 0;

type
  SDL_bool = (
    SDL_FALSE = 0,
    SDL_TRUE = 1
  );

  SDL_DUMMY_ENUM = (
    DUMMY_ENUM_VALUE
  );

implementation

end.
