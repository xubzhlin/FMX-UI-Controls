unit Posix.SDL2.SDL_render;

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
  Linker.Helper, Posix.SDL2.consts, Posix.SDL2.SDL_video, Posix.SDL2.SDL_surface,
  Posix.SDL2.SDL_rect, Posix.SDL2.SDL_stdinc, Posix.SDL2.SDL_blendmode;

type
(**
 *  \brief Flags used when creating a rendering context
 *)
  SDL_RendererFlags = (
    SDL_RENDERER_SOFTWARE = $00000001,         (**< The renderer is a software fallback *)
    SDL_RENDERER_ACCELERATED = $00000002,      (**< The renderer uses hardware
                                                     acceleration *)
    SDL_RENDERER_PRESENTVSYNC = $00000004,     (**< Present is synchronized
                                                     with the refresh rate *)
    SDL_RENDERER_TARGETTEXTURE = $00000008     (**< The renderer supports
                                                     rendering to texture *)
  );

  PSDL_RendererInfo = ^SDL_RendererInfo;
  SDL_RendererInfo = record
    name: MarshaledAString;           ///**< The name of the renderer */
    flags: Cardinal;                  ///**< Supported ::SDL_RendererFlags */
    num_texture_formats: Cardinal;    ///**< The number of available texture formats */
    texture_formats: array[0..15] of Cardinal; ///**< The available texture formats */
    max_texture_width: Integer ;      ///**< The maximum texture width */
    max_texture_height: Integer;      ///**< The maximum texture height */
  end;

(**
 *  \brief The access pattern allowed for a texture.
 *)
  SDL_TextureAccess = (
    SDL_TEXTUREACCESS_STATIC,    ///**< Changes rarely, not lockable */
    SDL_TEXTUREACCESS_STREAMING, ///**< Changes frequently, lockable */
    SDL_TEXTUREACCESS_TARGET     ///**< Texture can be used as a render target */
  );

(**
 *  \brief The texture channel modulation used in SDL_RenderCopy().
 *)
  SDL_TextureModulate = (
    SDL_TEXTUREMODULATE_NONE  = $00000000,    ///**< No modulation */
    SDL_TEXTUREMODULATE_COLOR = $00000001,    ///**< srcC = srcC * color */
    SDL_TEXTUREMODULATE_ALPHA = $00000002     ///**< srcA = srcA * alpha */
  );

(**
 *  \brief Flip constants for SDL_RenderCopyEx
 *)
  SDL_RendererFlip = (
    SDL_FLIP_NONE = $00000000,        ///**< Do not flip */
    SDL_FLIP_HORIZONTAL = $00000001,  ///**< flip horizontally */
    SDL_FLIP_VERTICAL = $00000002     ///**< flip vertically */
  );

  PSDL_Renderer = Pointer;
  PSDL_Texture = Pointer;

(**
 *  \brief Get the number of 2D rendering drivers available for the current
 *         display.
 *
 *  A render driver is a set of code that handles rendering and texture
 *  management on a particular display.  Normally there is only one, but
 *  some drivers may have several available with different capabilities.
 *
 *  \sa SDL_GetRenderDriverInfo()
 *  \sa SDL_CreateRenderer()
 *)
function SDL_GetNumRenderDrivers: Integer; cdecl; external libSDL2 name _PU + 'SDL_GetNumRenderDrivers';

(**
 *  \brief Get information about a specific 2D rendering driver for the current
 *         display.
 *
 *  \param index The index of the driver to query information about.
 *  \param info  A pointer to an SDL_RendererInfo struct to be filled with
 *               information on the rendering driver.
 *
 *  \return 0 on success, -1 if the index was out of range.
 *
 *  \sa SDL_CreateRenderer()
 *)
function SDL_GetRenderDriverInfo(index: Integer; info: PSDL_RendererInfo): Integer; cdecl; external libSDL2 name _PU + 'SDL_GetRenderDriverInfo';

(**
 *  \brief Create a window and default renderer
 *
 *  \param width    The width of the window
 *  \param height   The height of the window
 *  \param window_flags The flags used to create the window
 *  \param window   A pointer filled with the window, or NULL on error
 *  \param renderer A pointer filled with the renderer, or NULL on error
 *
 *  \return 0 on success, or -1 on error
 *)
function SDL_CreateWindowAndRenderer(width: Integer; height: Integer; window_flags: Cardinal;
  var window: PSDL_Window; var renderer: PSDL_Renderer): Integer; cdecl; external libSDL2 name _PU + 'SDL_CreateWindowAndRenderer';

(**
 *  \brief Create a 2D rendering context for a window.
 *
 *  \param window The window where rendering is displayed.
 *  \param index    The index of the rendering driver to initialize, or -1 to
 *                  initialize the first one supporting the requested flags.
 *  \param flags    ::SDL_RendererFlags.
 *
 *  \return A valid rendering context or NULL if there was an error.
 *
 *  \sa SDL_CreateSoftwareRenderer()
 *  \sa SDL_GetRendererInfo()
 *  \sa SDL_DestroyRenderer()
 *)
function SDL_CreateRenderer(window: PSDL_Window; index: Integer; flags: Cardinal): PSDL_Renderer; cdecl; external libSDL2 name _PU + 'SDL_CreateRenderer';

(**
 *  \brief Create a 2D software rendering context for a surface.
 *
 *  \param surface The surface where rendering is done.
 *
 *  \return A valid rendering context or NULL if there was an error.
 *
 *  \sa SDL_CreateRenderer()
 *  \sa SDL_DestroyRenderer()
 *)
function SDL_CreateSoftwareRenderer(surface: PSDL_Surface): PSDL_Renderer; cdecl; external libSDL2 name _PU + 'SDL_CreateSoftwareRenderer';

(**
 *  \brief Get the renderer associated with a window.
 *)
function SDL_GetRenderer(window: PSDL_Window): PSDL_Renderer; cdecl; external libSDL2 name _PU + 'SDL_GetRenderer';

(**
 *  \brief Get information about a rendering context.
 *)
function SDL_GetRendererInfo(renderer: PSDL_Renderer; info: PSDL_RendererInfo): Integer; cdecl; external libSDL2 name _PU + 'SDL_GetRendererInfo';

(**
 *  \brief Get the output size in pixels of a rendering context.
 *)
function SDL_GetRendererOutputSize(renderer: PSDL_Renderer; var w: Integer; var h: Integer): Integer; cdecl; external libSDL2 name _PU + 'SDL_GetRendererOutputSize';

(**
 *  \brief Create a texture for a rendering context.
 *
 *  \param renderer The renderer.
 *  \param format The format of the texture.
 *  \param access One of the enumerated values in ::SDL_TextureAccess.
 *  \param w      The width of the texture in pixels.
 *  \param h      The height of the texture in pixels.
 *
 *  \return The created texture is returned, or NULL if no rendering context was
 *          active,  the format was unsupported, or the width or height were out
 *          of range.
 *
 *  \note The contents of the texture are not defined at creation.
 *
 *  \sa SDL_QueryTexture()
 *  \sa SDL_UpdateTexture()
 *  \sa SDL_DestroyTexture()
 *)
function SDL_CreateTexture(renderer: PSDL_Renderer; format: Cardinal; access: Integer;
  w: Integer; h: Integer): PSDL_Texture; cdecl; external libSDL2 name _PU + 'SDL_CreateTexture';

(**
 *  \brief Create a texture from an existing surface.
 *
 *  \param renderer The renderer.
 *  \param surface The surface containing pixel data used to fill the texture.
 *
 *  \return The created texture is returned, or NULL on error.
 *
 *  \note The surface is not modified or freed by this function.
 *
 *  \sa SDL_QueryTexture()
 *  \sa SDL_DestroyTexture()
 *)
function SDL_CreateTextureFromSurface(renderer: PSDL_Renderer; surface: PSDL_Surface): PSDL_Texture; cdecl; external libSDL2 name _PU + 'SDL_CreateTextureFromSurface';

(**
 *  \brief Query the attributes of a texture
 *
 *  \param texture A texture to be queried.
 *  \param format  A pointer filled in with the raw format of the texture.  The
 *                 actual format may differ, but pixel transfers will use this
 *                 format.
 *  \param access  A pointer filled in with the actual access to the texture.
 *  \param w       A pointer filled in with the width of the texture in pixels.
 *  \param h       A pointer filled in with the height of the texture in pixels.
 *
 *  \return 0 on success, or -1 if the texture is not valid.
 *)
function SDL_QueryTexture(texture: PSDL_Texture; var format: Cardinal; access: Integer;
  w: Integer; h: Integer): Integer; cdecl; external libSDL2 name _PU + 'SDL_QueryTexture';

(**
 *  \brief Set an additional color value used in render copy operations.
 *
 *  \param texture The texture to update.
 *  \param r       The red color value multiplied into copy operations.
 *  \param g       The green color value multiplied into copy operations.
 *  \param b       The blue color value multiplied into copy operations.
 *
 *  \return 0 on success, or -1 if the texture is not valid or color modulation
 *          is not supported.
 *
 *  \sa SDL_GetTextureColorMod()
 *)
function SDL_SetTextureColorMod(texture: PSDL_Texture; r: Byte; g: Byte; b: Byte): Integer; cdecl; external libSDL2 name _PU + 'SDL_SetTextureColorMod';

(**
 *  \brief Get the additional color value used in render copy operations.
 *
 *  \param texture The texture to query.
 *  \param r         A pointer filled in with the current red color value.
 *  \param g         A pointer filled in with the current green color value.
 *  \param b         A pointer filled in with the current blue color value.
 *
 *  \return 0 on success, or -1 if the texture is not valid.
 *
 *  \sa SDL_SetTextu)eColorMod()
 *)
function SDL_GetTextureColorMod(texture: PSDL_Texture; var r: Byte; var g: Byte; var b: Byte): Integer; cdecl; external libSDL2 name _PU + 'SDL_GetTextureColorMod';

(**
 *  \brief Set an additional alpha value used in render copy operations.
 *
 *  \param texture The texture to update.
 *  \param alpha     The alpha value multiplied into copy operations.
 *
 *  \return 0 on success, or -1 if the texture is not valid or alpha modulation
 *          is not supported.
 *
 *  \sa SDL_GetTextureAlphaMod()
 *)
function SDL_SetTextureAlphaMod(texture: PSDL_Texture; alpha: Byte): Integer; cdecl; external libSDL2 name _PU + 'SDL_SetTextureAlphaMod';

(**
 *  \brief Get the additional alpha value used in render copy operations.
 *
 *  \param texture The texture to query.
 *  \param alpha     A pointer filled in with the current alpha value.
 *
 *  \return 0 on success, or -1 if the texture is not valid.
 *
 *  \sa SDL_SetTextureAlphaMod()
 *)
function SDL_GetTextureAlphaMod(texture: PSDL_Texture; var alpha: Byte): Integer; cdecl; external libSDL2 name _PU + 'SDL_GetTextureAlphaMod';

(**
 *  \brief Set the blend mode used for texture copy operations.
 *
 *  \param texture The texture to update.
 *  \param blendMode ::SDL_BlendMode to use for texture blending.
 *
 *  \return 0 on success, or -1 if the texture is not valid or the blend mode is
 *          not supported.
 *
 *  \note If the blend mode is not supported, the closest supported mode is
 *        chosen.
 *
 *  \sa SDL_GetTextureBlendMode()
 *)
function SDL_SetTextureBlendMode(texture: PSDL_Texture; blendMode: SDL_BlendMode): Integer; cdecl; external libSDL2 name _PU + 'SDL_SetTextureBlendMode';

(**
 *  \brief Get the blend mode used for texture copy operations.
 *
 *  \param texture   The texture to query.
 *  \param blendMode A pointer filled in with the current blend mode.
 *
 *  \return 0 on success, or -1 if the texture is not valid.
 *
 *  \sa SDL_SetTextureBlendMode()
 */
 *)
function SDL_GetTextureBlendMode(texture: PSDL_Texture; var blendMode: SDL_BlendMode): Integer; cdecl; external libSDL2 name _PU + 'SDL_GetTextureBlendMode';

(**
 *  \brief Update the given texture rectangle with new pixel data.
 *
 *  \param texture   The texture to update
 *  \param rect      A pointer to the rectangle of pixels to update, or NULL to
 *                   update the entire texture.
 *  \param pixels    The raw pixel data in the format of the texture.
 *  \param pitch     The number of bytes in a row of pixel data, including padding between lines.
 *
 *  The pixel data must be in the format of the texture. The pixel format can be
 *  queried with SDL_QueryTexture.
 *
 *  \return 0 on success, or -1 if the texture is not valid.
 *
 *  \note This is a fairly slow function.
 *)
function SDL_UpdateTexture(texture: PSDL_Texture; const rect: PSDL_Rect; const pixels: Pointer; pitch: Integer): Integer; cdecl; external libSDL2 name _PU + 'SDL_UpdateTexture';

(**
 *  \brief Update a rectangle within a planar YV12 or IYUV texture with new pixel data.
 *
 *  \param texture   The texture to update
 *  \param rect      A pointer to the rectangle of pixels to update, or NULL to
 *                   update the entire texture.
 *  \param Yplane    The raw pixel data for the Y plane.
 *  \param Ypitch    The number of bytes between rows of pixel data for the Y plane.
 *  \param Uplane    The raw pixel data for the U plane.
 *  \param Upitch    The number of bytes between rows of pixel data for the U plane.
 *  \param Vplane    The raw pixel data for the V plane.
 *  \param Vpitch    The number of bytes between rows of pixel data for the V plane.
 *
 *  \return 0 on success, or -1 if the texture is not valid.
 *
 *  \note You can use SDL_UpdateTexture() as long as your pixel data is
 *        a contiguous block of Y and U/V planes in the proper order, but
 *        this function is available if your pixel data is not contiguous.
 *)
function SDL_UpdateYUVTexture(texture: PSDL_Texture; const rect: PSDL_Rect; const Yplane: Pbyte; Ypitch: Integer;
  Uplane: PByte; Upitch: Integer; Vplane: Pbyte; Vpitch: Integer): Integer; cdecl; external libSDL2 name _PU + 'SDL_UpdateYUVTexture';

(**
 *  \brief Lock a portion of the texture for write-only pixel access.
 *
 *  \param texture   The texture to lock for access, which was created with
 *                   ::SDL_TEXTUREACCESS_STREAMING.
 *  \param rect      A pointer to the rectangle to lock for access. If the rect
 *                   is NULL, the entire texture will be locked.
 *  \param pixels    This is filled in with a pointer to the locked pixels,
 *                   appropriately offset by the locked area.
 *  \param pitch     This is filled in with the pitch of the locked pixels.
 *
 *  \return 0 on success, or -1 if the texture is not valid or was not created with ::SDL_TEXTUREACCESS_STREAMING.
 *
 *  \sa SDL_UnlockTexture()
 *)
function SDL_LockTexture(texture: PSDL_Texture; const rect: PSDL_Rect; var pixels: Pointer; var pitch: Integer): Integer; cdecl; external libSDL2 name _PU + 'SDL_LockTexture';

(**
 *  \brief Unlock a texture, uploading the changes to video memory, if needed.
 *
 *  \sa SDL_LockTexture()
 *)
procedure SDL_UnlockTexture(texture: PSDL_Texture); cdecl; external libSDL2 name _PU + 'SDL_UnlockTexture';

(**
 * \brief Determines whether a window supports the use of render targets
 *
 * \param renderer The renderer that will be checked
 *
 * \return SDL_TRUE if supported, SDL_FALSE if not.
 *)
function SDL_RenderTargetSupported(renderer: PSDL_Renderer): SDL_bool; cdecl; external libSDL2 name _PU + 'SDL_RenderTargetSupported';

(**
 * \brief Set a texture as the current rendering target.
 *
 * \param renderer The renderer.
 * \param texture The targeted texture, which must be created with the SDL_TEXTUREACCESS_TARGET flag, or NULL for the default render target
 *
 * \return 0 on success, or -1 on error
 *
 *  \sa SDL_GetRenderTarget()
 *)
function SDL_SetRenderTarget(renderer: PSDL_Renderer; texture: PSDL_Texture): Integer; cdecl; external libSDL2 name _PU + 'SDL_SetRenderTarget';

(**
 * \brief Get the current render target or NULL for the default render target.
 *
 * \return The current render target
 *
 *  \sa SDL_SetRenderTarget()
 *)
function SDL_GetRenderTarget(renderer: PSDL_Renderer): PSDL_Texture; cdecl; external libSDL2 name _PU + 'SDL_GetRenderTarget';

(**
 *  \brief Set device independent resolution for rendering
 *
 *  \param renderer The renderer for which resolution should be set.
 *  \param w      The width of the logical resolution
 *  \param h      The height of the logical resolution
 *
 *  This function uses the viewport and scaling functionality to allow a fixed logical
 *  resolution for rendering, regardless of the actual output resolution.  If the actual
 *  output resolution doesn't have the same aspect ratio the output rendering will be
 *  centered within the output display.
 *
 *  If the output display is a window, mouse events in the window will be filtered
 *  and scaled so they seem to arrive within the logical resolution.
 *
 *  \note If this function results in scaling or subpixel drawing by the
 *        rendering backend, it will be handled using the appropriate
 *        quality hints.
 *
 *  \sa SDL_RenderGetLogicalSize()
 *  \sa SDL_RenderSetScale()
 *  \sa SDL_RenderSetViewport()
 *)
function SDL_RenderSetLogicalSize(renderer: PSDL_Renderer; w: Integer; h: Integer): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderSetLogicalSize';

(**
 *  \brief Get device independent resolution for rendering
 *
 *  \param renderer The renderer from which resolution should be queried.
 *  \param w      A pointer filled with the width of the logical resolution
 *  \param h      A pointer filled with the height of the logical resolution
 *
 *  \sa SDL_RenderSetLogicalSize()
 *)
procedure SDL_RenderGetLogicalSize(renderer: PSDL_Renderer; var w: Integer; var h: Integer); cdecl; external libSDL2 name _PU + 'SDL_RenderGetLogicalSize';

(**
 *  \brief Set whether to force integer scales for resolution-independent rendering
 *
 *  \param renderer The renderer for which integer scaling should be set.
 *  \param enable   Enable or disable integer scaling
 *
 *  This function restricts the logical viewport to integer values - that is, when
 *  a resolution is between two multiples of a logical size, the viewport size is
 *  rounded down to the lower multiple.
 *
 *  \sa SDL_RenderSetLogicalSize()
 *)
function SDL_RenderSetIntegerScale(renderer: PSDL_Renderer; enable: SDL_bool): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderSetIntegerScale';

(**
 *  \brief Get whether integer scales are forced for resolution-independent rendering
 *
 *  \param renderer The renderer from which integer scaling should be queried.
 *
 *  \sa SDL_RenderSetIntegerScale()
 *)
function SDL_RenderGetIntegerScale(renderer: PSDL_Renderer): SDL_bool; cdecl; external libSDL2 name _PU + 'SDL_RenderGetIntegerScale';

(**
 *  \brief Set the drawing area for rendering on the current target.
 *
 *  \param renderer The renderer for which the drawing area should be set.
 *  \param rect The rectangle representing the drawing area, or NULL to set the viewport to the entire target.
 *
 *  The x,y of the viewport rect represents the origin for rendering.
 *
 *  \return 0 on success, or -1 on error
 *
 *  \note If the window associated with the renderer is resized, the viewport is automatically reset.
 *
 *  \sa SDL_RenderGetViewport()
 *  \sa SDL_RenderSetLogicalSize()
 *)
function SDL_RenderSetViewport(renderer: PSDL_Renderer; const rect: PSDL_Rect): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderSetViewport';

(**
 *  \brief Get the drawing area for the current target.
 *
 *  \sa SDL_RenderSetViewport()
 *)
function SDL_RenderGetViewport(renderer: PSDL_Renderer; rect: PSDL_Rect): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderGetViewport';

(**
 *  \brief Set the clip rectangle for the current target.
 *
 *  \param renderer The renderer for which clip rectangle should be set.
 *  \param rect   A pointer to the rectangle to set as the clip rectangle, or
 *                NULL to disable clipping.
 *
 *  \return 0 on success, or -1 on error
 *
 *  \sa SDL_RenderGetClipRect()
 *)
function SDL_RenderSetClipRect(renderer: PSDL_Renderer; const rect: PSDL_Rect): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderSetClipRect';

(**
 *  \brief Get the clip rectangle for the current target.
 *
 *  \param renderer The renderer from which clip rectangle should be queried.
 *  \param rect   A pointer filled in with the current clip rectangle, or
 *                an empty rectangle if clipping is disabled.
 *
 *  \sa SDL_RenderSetClipRect()
 *)
procedure SDL_RenderGetClipRect(renderer: PSDL_Renderer; rect: PSDL_Rect); cdecl; external libSDL2 name _PU + 'SDL_RenderGetClipRect';

(**
 *  \brief Get whether clipping is enabled on the given renderer.
 *
 *  \param renderer The renderer from which clip state should be queried.
 *
 *  \sa SDL_RenderGetClipRect()
 *)
function SDL_RenderIsClipEnabled(renderer: PSDL_Renderer): SDL_bool; cdecl; external libSDL2 name _PU + 'SDL_RenderIsClipEnabled';

(**
 *  \brief Set the drawing scale for rendering on the current target.
 *
 *  \param renderer The renderer for which the drawing scale should be set.
 *  \param scaleX The horizontal scaling factor
 *  \param scaleY The vertical scaling factor
 *
 *  The drawing coordinates are scaled by the x/y scaling factors
 *  before they are used by the renderer.  This allows resolution
 *  independent drawing with a single coordinate system.
 *
 *  \note If this results in scaling or subpixel drawing by the
 *        rendering backend, it will be handled using the appropriate
 *        quality hints.  For best results use integer scaling factors.
 *
 *  \sa SDL_RenderGetScale()
 *  \sa SDL_RenderSetLogicalSize()
 *)
function SDL_RenderSetScale(renderer: PSDL_Renderer; scaleX: Single; scaleY: Single): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderSetScale';

(**
 *  \brief Get the drawing scale for the current target.
 *
 *  \param renderer The renderer from which drawing scale should be queried.
 *  \param scaleX A pointer filled in with the horizontal scaling factor
 *  \param scaleY A pointer filled in with the vertical scaling factor
 *
 *  \sa SDL_RenderSetScale()
 *)
procedure SDL_RenderGetScale(renderer: PSDL_Renderer; var scaleX: Single; var scaleY: Single); cdecl; external libSDL2 name _PU + 'SDL_RenderGetScale';

(**
 *  \brief Set the color used for drawing operations (Rect, Line and Clear).
 *
 *  \param renderer The renderer for which drawing color should be set.
 *  \param r The red value used to draw on the rendering target.
 *  \param g The green value used to draw on the rendering target.
 *  \param b The blue value used to draw on the rendering target.
 *  \param a The alpha value used to draw on the rendering target, usually
 *           ::SDL_ALPHA_OPAQUE (255).
 *
 *  \return 0 on success, or -1 on error
 *)
function SDL_SetRenderDrawColor(renderer: PSDL_Renderer; r: Byte; g: Byte; b: Byte; a: Byte): Integer; cdecl; external libSDL2 name _PU + 'SDL_SetRenderDrawColor';

(**
 *  \brief Get the color used for drawing operations (Rect, Line and Clear).
 *
 *  \param renderer The renderer from which drawing color should be queried.
 *  \param r A pointer to the red value used to draw on the rendering target.
 *  \param g A pointer to the green value used to draw on the rendering target.
 *  \param b A pointer to the blue value used to draw on the rendering target.
 *  \param a A pointer to the alpha value used to draw on the rendering target,
 *           usually ::SDL_ALPHA_OPAQUE (255).
 *
 *  \return 0 on success, or -1 on error
 *)
function SDL_GetRenderDrawColor(renderer: PSDL_Renderer; var r: Byte; var g: Byte; var b: Byte; var a: Byte): Integer; cdecl; external libSDL2 name _PU + 'SDL_GetRenderDrawColor';

(**
 *  \brief Set the blend mode used for drawing operations (Fill and Line).
 *
 *  \param renderer The renderer for which blend mode should be set.
 *  \param blendMode ::SDL_BlendMode to use for blending.
 *
 *  \return 0 on success, or -1 on error
 *
 *  \note If the blend mode is not supported, the closest supported mode is
 *        chosen.
 *
 *  \sa SDL_GetRenderDrawBlendMode()
 *)
function SDL_SetRenderDrawBlendMode(renderer: PSDL_Renderer; blendMode: SDL_BlendMode): Integer; cdecl; external libSDL2 name _PU + 'SDL_SetRenderDrawBlendMode';

(**
 *  \brief Get the blend mode used for drawing operations.
 *
 *  \param renderer The renderer from which blend mode should be queried.
 *  \param blendMode A pointer filled in with the current blend mode.
 *
 *  \return 0 on success, or -1 on error
 *
 *  \sa SDL_SetRenderDrawBlendMode()
 *)
function SDL_GetRenderDrawBlendMode(renderer: PSDL_Renderer; var blendMode: SDL_BlendMode): Integer; cdecl; external libSDL2 name _PU + 'SDL_GetRenderDrawBlendMode';

(**
 *  \brief Clear the current rendering target with the drawing color
 *
 *  This function clears the entire rendering target, ignoring the viewport and
 *  the clip rectangle.
 *
 *  \return 0 on success, or -1 on error
 *)
function SDL_RenderClear(renderer: PSDL_Renderer): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderClear';

(**
 *  \brief Draw a point on the current rendering target.
 *
 *  \param renderer The renderer which should draw a point.
 *  \param x The x coordinate of the point.
 *  \param y The y coordinate of the point.
 *
 *  \return 0 on success, or -1 on error
 *)
function SDL_RenderDrawPoint(renderer: PSDL_Renderer; x: Integer; y: Integer): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderDrawPoint';

(**
 *  \brief Draw multiple points on the current rendering target.
 *
 *  \param renderer The renderer which should draw multiple points.
 *  \param points The points to draw
 *  \param count The number of points to draw
 *
 *  \return 0 on success, or -1 on error
 *)
function SDL_RenderDrawPoints(renderer: PSDL_Renderer; const points: PSDL_Point; count: Integer): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderDrawPoints';

(**
 *  \brief Draw a line on the current rendering target.
 *
 *  \param renderer The renderer which should draw a line.
 *  \param x1 The x coordinate of the start point.
 *  \param y1 The y coordinate of the start point.
 *  \param x2 The x coordinate of the end point.
 *  \param y2 The y coordinate of the end point.
 *
 *  \return 0 on success, or -1 on error
 *)
function SDL_RenderDrawLine(renderer: PSDL_Renderer; x1: Integer; y1:
  Integer; x2: Integer; y2: Integer): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderDrawLine';

(**
 *  \brief Draw a series of connected lines on the current rendering target.
 *
 *  \param renderer The renderer which should draw multiple lines.
 *  \param points The points along the lines
 *  \param count The number of points, drawing count-1 lines
 *
 *  \return 0 on success, or -1 on error
 *)
function SDL_RenderDrawLines(renderer: PSDL_Renderer; const points: PSDL_Point; count: Integer): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderDrawLines';

(**
 *  \brief Draw a rectangle on the current rendering target.
 *
 *  \param renderer The renderer which should draw a rectangle.
 *  \param rect A pointer to the destination rectangle, or NULL to outline the entire rendering target.
 *
 *  \return 0 on success, or -1 on error
 *)
function SDL_RenderDrawRect(renderer: PSDL_Renderer; const rect: PSDL_Rect): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderDrawRect';

(**
 *  \brief Draw some number of rectangles on the current rendering target.
 *
 *  \param renderer The renderer which should draw multiple rectangles.
 *  \param rects A pointer to an array of destination rectangles.
 *  \param count The number of rectangles.
 *
 *  \return 0 on success, or -1 on error
 *)
function SDL_RenderDrawRects(renderer: PSDL_Renderer; const rect: PSDL_Rect; count: Integer): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderDrawRects';

(**
 *  \brief Fill a rectangle on the current rendering target with the drawing color.
 *
 *  \param renderer The renderer which should fill a rectangle.
 *  \param rect A pointer to the destination rectangle, or NULL for the entire
 *              rendering target.
 *
 *  \return 0 on success, or -1 on error
 *)
function SDL_RenderFillRect(renderer: PSDL_Renderer; const rect: PSDL_Rect): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderFillRect';

(**
 *  \brief Fill some number of rectangles on the current rendering target with the drawing color.
 *
 *  \param renderer The renderer which should fill multiple rectangles.
 *  \param rects A pointer to an array of destination rectangles.
 *  \param count The number of rectangles.
 *
 *  \return 0 on success, or -1 on error
 *)
function SDL_RenderFillRects(renderer: PSDL_Renderer; const rect: PSDL_Rect; count: Integer): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderFillRects';

(**
 *  \brief Copy a portion of the texture to the current rendering target.
 *
 *  \param renderer The renderer which should copy parts of a texture.
 *  \param texture The source texture.
 *  \param srcrect   A pointer to the source rectangle, or NULL for the entire
 *                   texture.
 *  \param dstrect   A pointer to the destination rectangle, or NULL for the
 *                   entire rendering target.
 *
 *  \return 0 on success, or -1 on error
 *)
function SDL_RenderCopy(renderer: PSDL_Renderer; texture: PSDL_Texture; const srcrect: PSDL_Rect;
  const dstrect: PSDL_Rect): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderCopy';

(**
 *  \brief Copy a portion of the source texture to the current rendering target, rotating it by angle around the given center
 *
 *  \param renderer The renderer which should copy parts of a texture.
 *  \param texture The source texture.
 *  \param srcrect   A pointer to the source rectangle, or NULL for the entire
 *                   texture.
 *  \param dstrect   A pointer to the destination rectangle, or NULL for the
 *                   entire rendering target.
 *  \param angle    An angle in degrees that indicates the rotation that will be applied to dstrect, rotating it in a clockwise direction
 *  \param center   A pointer to a point indicating the point around which dstrect will be rotated (if NULL, rotation will be done around dstrect.w/2, dstrect.h/2).
 *  \param flip     An SDL_RendererFlip value stating which flipping actions should be performed on the texture
 *
 *  \return 0 on success, or -1 on error
 *)
function SDL_RenderCopyEx(renderer: PSDL_Renderer; texture: PSDL_Texture; const srcrect: PSDL_Rect;
  const dstrect: SDL_Rect; angle: Double; const center: PSDL_Point;
  const flip: SDL_RendererFlip): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderCopyEx';

(**
 *  \brief Read pixels from the current rendering target.
 *
 *  \param renderer The renderer from which pixels should be read.
 *  \param rect   A pointer to the rectangle to read, or NULL for the entire
 *                render target.
 *  \param format The desired format of the pixel data, or 0 to use the format
 *                of the rendering target
 *  \param pixels A pointer to be filled in with the pixel data
 *  \param pitch  The pitch of the pixels parameter.
 *
 *  \return 0 on success, or -1 if pixel reading is not supported.
 *
 *  \warning This is a very slow operation, and should not be used frequently.
 *)
function SDL_RenderReadPixels(renderer: PSDL_Renderer; const rect: PSDL_Rect; format: Cardinal;
  pixels: Pointer; pitch: Integer): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderReadPixels';

(**
 *  \brief Update the screen with rendering performed.
 *)
function SDL_RenderPresent(renderer: PSDL_Renderer): Integer; cdecl; external libSDL2 name _PU + 'SDL_RenderPresent';

(**
 *  \brief Destroy the specified texture.
 *
 *  \sa SDL_CreateTexture()
 *  \sa SDL_CreateTextureFromSurface()
 *)
procedure SDL_DestroyTexture(texture: PSDL_Texture); cdecl; external libSDL2 name _PU + 'SDL_DestroyTexture';


(**
 *  \brief Destroy the rendering context for a window and free associated
 *         textures.
 *
 *  \sa SDL_CreateRenderer()
 *)
procedure SDL_DestroyRenderer(renderer: PSDL_Renderer); cdecl; external libSDL2 name _PU + 'SDL_DestroyRenderer';

(**
 *  \brief Bind the texture to the current OpenGL/ES/ES2 context for use with
 *         OpenGL instructions.
 *
 *  \param texture  The SDL texture to bind
 *  \param texw     A pointer to a float that will be filled with the texture width
 *  \param texh     A pointer to a float that will be filled with the texture height
 *
 *  \return 0 on success, or -1 if the operation is not supported
 *)
function SDL_GL_BindTexture(renderer: PSDL_Renderer; var texw: Single; var texh: Single): Integer; cdecl; external libSDL2 name _PU + 'SDL_GL_BindTexture';

(**
 *  \brief Unbind a texture from the current OpenGL/ES/ES2 context.
 *
 *  \param texture  The SDL texture to unbind
 *
 *  \return 0 on success, or -1 if the operation is not supported
 *)
function SDL_GL_UnbindTexture(texture: PSDL_Texture): Integer; cdecl; external libSDL2 name _PU + 'SDL_GL_UnbindTexture';

(**
 *  \brief Get the CAMetalLayer associated with the given Metal renderer
 *
 *  \param renderer The renderer to query
 *
 *  \return CAMetalLayer* on success, or NULL if the renderer isn't a Metal renderer
 *
 *  \sa SDL_RenderGetMetalCommandEncoder()
 *)
function SDL_RenderGetMetalLayer(renderer: PSDL_Renderer): Pointer; cdecl; external libSDL2 name _PU + 'SDL_RenderGetMetalLayer';

(**
 *  \brief Get the Metal command encoder for the current frame
 *
 *  \param renderer The renderer to query
 *
 *  \return id<MTLRenderCommandEncoder> on success, or NULL if the renderer isn't a Metal renderer
 *
 *  \sa SDL_RenderGetMetalLayer()
 *)
function SDL_RenderGetMetalCommandEncoder(renderer: PSDL_Renderer): Pointer; cdecl; external libSDL2 name _PU + 'SDL_RenderGetMetalCommandEncoder';

implementation

end.
