unit Posix.SDL2.consts;

interface

uses
  Linker.Helper;

const
  {$IFDEF MSWINDOWS}
    libSDL2 = 'SDL2.dll';
  {$ENDIF}
  {$IFDEF ANDROID}
    libSDL2 = 'libSDL2.so';
  {$ENDIF}
  {$IFDEF LINUX}
    libSDL2 = 'libSDL2.so';
  {$ENDIF LINUX}
  {$IFDEF MACOS}
    {$IFDEF IOS}
      libSDL2 = 'libSDL2.a';
    {$ELSE}
      libSDL2 = 'libSDL2.dylib';
    {$ENDIF}
  {$ENDIF}

procedure SDL_Delay(ms: Cardinal); cdecl; external libSDL2 name _PU + 'SDL_Delay';

implementation




end.
