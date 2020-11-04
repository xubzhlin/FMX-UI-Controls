unit Posix.SDL2.SDL_blendmode;

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

type
(**
 *  \brief The blend mode used in SDL_RenderCopy() and drawing operations.
 *)
  SDL_BlendMode = (
    SDL_BLENDMODE_NONE = $00000000,     (**< no blending
                                              dstRGBA = srcRGBA *)
    SDL_BLENDMODE_BLEND = $00000001,    (**< alpha blending
                                              dstRGB = (srcRGB * srcA) + (dstRGB * (1-srcA))
                                              dstA = srcA + (dstA * (1-srcA)) *)
    SDL_BLENDMODE_ADD = $00000002,      (**< additive blending
                                              dstRGB = (srcRGB * srcA) + dstRGB
                                              dstA = dstA *)
    SDL_BLENDMODE_MOD = $00000004,      (**< color modulate
                                              dstRGB = srcRGB * dstRGB
                                              dstA = dstA *)
    SDL_BLENDMODE_INVALID = $7FFFFFFF

    (* Additional custom blend modes can be returned by SDL_ComposeCustomBlendMode() *)
  );

(**
 *  \brief The blend operation used when combining source and destination pixel components
 *)
  SDL_BlendOperation = (
    SDL_BLENDOPERATION_ADD              = $1,  ///**< dst + src: supported by all renderers */
    SDL_BLENDOPERATION_SUBTRACT         = $2,  ///**< dst - src : supported by D3D9, D3D11, OpenGL, OpenGLES */
    SDL_BLENDOPERATION_REV_SUBTRACT     = $3,  ///**< src - dst : supported by D3D9, D3D11, OpenGL, OpenGLES */
    SDL_BLENDOPERATION_MINIMUM          = $4,  ///**< min(dst, src) : supported by D3D11 */
    SDL_BLENDOPERATION_MAXIMUM          = $5   ///**< max(dst, src) : supported by D3D11 */
  );

(**
 *  \brief The normalized factor used to multiply pixel components
 *)
  SDL_BlendFactor = (
    SDL_BLENDFACTOR_ZERO                = $1,  ///**< 0, 0, 0, 0 */
    SDL_BLENDFACTOR_ONE                 = $2,  ///**< 1, 1, 1, 1 */
    SDL_BLENDFACTOR_SRC_COLOR           = $3,  ///**< srcR, srcG, srcB, srcA */
    SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR = $4,  ///**< 1-srcR, 1-srcG, 1-srcB, 1-srcA */
    SDL_BLENDFACTOR_SRC_ALPHA           = $5,  ///**< srcA, srcA, srcA, srcA */
    SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA = $6,  ///**< 1-srcA, 1-srcA, 1-srcA, 1-srcA */
    SDL_BLENDFACTOR_DST_COLOR           = $7,  ///**< dstR, dstG, dstB, dstA */
    SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR = $8,  ///**< 1-dstR, 1-dstG, 1-dstB, 1-dstA */
    SDL_BLENDFACTOR_DST_ALPHA           = $9,  ///**< dstA, dstA, dstA, dstA */
    SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA = $A   ///**< 1-dstA, 1-dstA, 1-dstA, 1-dstA */
  );

(**
 *  \brief Create a custom blend mode, which may or may not be supported by a given renderer
 *
 *  \param srcColorFactor
 *  \param dstColorFactor
 *  \param colorOperation
 *  \param srcAlphaFactor
 *  \param dstAlphaFactor
 *  \param alphaOperation
 *
 *  The result of the blend mode operation will be:
 *      dstRGB = dstRGB * dstColorFactor colorOperation srcRGB * srcColorFactor
 *  and
 *      dstA = dstA * dstAlphaFactor alphaOperation srcA * srcAlphaFactor
 *)
function SDL_ComposeCustomBlendMode(srcColorFactor: SDL_BlendFactor; dstColorFactor: SDL_BlendFactor;
  colorOperation: SDL_BlendOperation; srcAlphaFactor: SDL_BlendFactor; dstAlphaFactor: SDL_BlendFactor;
  alphaOperation: SDL_BlendOperation): Integer; cdecl; external libSDL2 name _PU + 'SDL_ComposeCustomBlendMode';



implementation

end.
