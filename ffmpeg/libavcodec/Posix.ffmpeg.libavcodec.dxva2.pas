unit Posix.ffmpeg.libavcodec.dxva2;

(*
 * DXVA2 HW acceleration
 *
 * copyright (c) 2009 Laurent Aimar
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


interface

{$IFDEF MSWINDOWS}

uses
  Winapi.Direct3D9;

const
  FF_DXVA2_WORKAROUND_SCALING_LIST_ZIGZAG = 1; ///< Work around for DXVA2 and old UVD/UVD+ ATI video cards
  FF_DXVA2_WORKAROUND_INTEL_CLEARVIDEO    = 2; ///< Work around for DXVA2 and old Intel GPUs with ClearVideo interface

type
  GUID   = TGUID;
  UINT   = ShortInt;
  USHORT = ShortInt;

  PLPDIRECT3DSURFACE9 = ^LPDIRECT3DSURFACE9;
  LPDIRECT3DSURFACE9  = ^IDirect3DSurface9;

  PIDirectXVideoDecoder = ^IDirectXVideoDecoder;

  IDirectXVideoDecoder = interface(IUnknown)
  end;

  PDXVA2_ConfigPictureDecode = ^DXVA2_ConfigPictureDecode;

  DXVA2_ConfigPictureDecode = record
    guidConfigBitstreamEncryption: GUID;
    guidConfigMBcontrolEncryption: GUID;
    guidConfigResidDiffEncryption: GUID;
    ConfigBitstreamRaw: UINT;
    ConfigMBcontrolRasterOrder: UINT;
    ConfigResidDiffHost: UINT;
    ConfigSpatialResid8: UINT;
    ConfigResid8Subtraction: UINT;
    ConfigSpatialHost8or9Clipping: UINT;
    ConfigSpatialResidInterleaved: UINT;
    ConfigIntraResidUnsigned: UINT;
    ConfigResidDiffAccelerator: UINT;
    ConfigHostInverseScan: UINT;
    ConfigSpecificIDCT: UINT;
    Config4GroupedCoefs: UINT;
    ConfigMinRenderTargetBuffCount: UINT;
    ConfigDecoderSpecific: USHORT;
  end;

(**
 * This structure is used to provides the necessary configurations and data
 * to the DXVA2 FFmpeg HWAccel implementation.
 *
 * The application must make it available as AVCodecContext.hwaccel_context.
 *)
  dxva_context = record
	(**
	 * DXVA2 decoder object
     *)
	  decoder: PIDirectXVideoDecoder;

	(**
     * DXVA2 configuration used to create the decoder
	 *)
    cfg: PDXVA2_ConfigPictureDecode;

    (**
     * The number of surface in the surface array
     *)
    surface_count: Cardinal;

    (**
     * The array of Direct3D surfaces used to create the decoder
     *)
    surface: PLPDIRECT3DSURFACE9;

    (**
     * A bit field configuring the workarounds needed for using the decoder
	 *)
    workaround: UInt64;

    (**
     * Private to the FFmpeg AVHWAccel implementation
     *)
    report_id: Cardinal;
  end;
{$ENDIF}

implementation

end.
