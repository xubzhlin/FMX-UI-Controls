unit Posix.x264;

interface

uses
  Linker.Helper;

const
  APIVersion = '_157';
{$IFDEF MSWINDOWS}
  libx264 = 'libx264' + APIVersion + '.dll';
{$ENDIF}
{$IFDEF ANDROID}
  libx264 = 'libx264' + APIVersion + '.so';
{$ENDIF}
{$IFDEF LINUX}
  libx264 = 'libx264' + APIVersion + '.so';
{$ENDIF LINUX}
{$IFDEF MACOS}
  {$IFDEF IOS}
    libx264 = 'libx264' + APIVersion + '.a';
  {$ELSE}
    libx264 = 'libx264' + APIVersion + '.dylib';
  {$ENDIF}
{$ENDIF}



  //* Colorspace type */
  X264_CSP_MASK = $00ff;  //* */
  X264_CSP_NONE  = $0000; //Invalid mode     */
  X264_CSP_I400  = $0001; //monochrome 4:0:0 */
  X264_CSP_I420  = $0002; //yuv 4:2:0 planar */
  X264_CSP_YV12  = $0003; //yvu 4:2:0 planar */
  X264_CSP_NV12  = $0004; //yuv 4:2:0, with one y plane and one packed u+v */
  X264_CSP_NV21  = $0005; //yuv 4:2:0, with one y plane and one packed v+u */
  X264_CSP_I422  = $0006; //yuv 4:2:2 planar */
  X264_CSP_YV16  = $0007; //yvu 4:2:2 planar */
  X264_CSP_NV16  = $0008; //yuv 4:2:2, with one y plane and one packed u+v */
  X264_CSP_YUYV  = $0009; //yuyv 4:2:2 packed */
  X264_CSP_UYVY  = $000a; //uyvy 4:2:2 packed */
  X264_CSP_V210  = $000b; //10-bit yuv 4:2:2 packed in 32 */
  X264_CSP_I444  = $000c; //yuv 4:4:4 planar */
  X264_CSP_YV24  = $000d; //yvu 4:4:4 planar */
  X264_CSP_BGR   = $000e; //packed bgr 24bits */
  X264_CSP_BGRA  = $000f; //packed bgr 32bits */
  X264_CSP_RGB   = $0010; //packed rgb 24bits */
  X264_CSP_MAX   = $0011; //end of list */
  X264_CSP_VFLIP = $1000; //the csp is vertically flipped */
  X264_CSP_HIGH_DEPTH = $2000; //the csp has a depth of 16 bits per pixel component */

  //* Slice type */
  X264_TYPE_AUTO = $0000; //Let x264 choose the right type */
  X264_TYPE_IDR  = $0001;
  X264_TYPE_I    = $0002;
  X264_TYPE_P    = $0003;
  X264_TYPE_BREF = $0004; //Non-disposable B-frame */
  X264_TYPE_B    = $0005;
  X264_TYPE_KEYFRAME  = $0006; //IDR or I depending on b_open_gop option */
//  IS_X264_TYPE_I(x) ((x)==X264_TYPE_I || (x)==X264_TYPE_IDR || (x)==X264_TYPE_KEYFRAME)
//  IS_X264_TYPE_B(x) ((x)==X264_TYPE_B || (x)==X264_TYPE_BREF)

  //* Log level */
  X264_LOG_NONE   = -1;
  X264_LOG_ERROR  =  0;
  X264_LOG_WARNING=  1;
  X264_LOG_INFO   =  2;
  X264_LOG_DEBUG  =  3;

  //* Threading */
  X264_THREADS_AUTO        =   0 ; //* Automatically select optimal number of threads */
  X264_SYNC_LOOKAHEAD_AUTO =  -1 ; //* Automatically select optimal lookahead thread buffer size */

  //* HRD */
  X264_NAL_HRD_NONE = 0;
  X264_NAL_HRD_VBR  = 1;
  X264_NAL_HRD_CBR  = 2;

  X264_PARAM_BAD_NAME  = -1;
  X264_PARAM_BAD_VALUE = -2;


type
  Px264_t = Pointer;
  Pva_list = Pointer;

type
  Px264_param_t = ^x264_param_t;

  nal_unit_type_e = (
    NAL_UNKNOWN     = 0,
    NAL_SLICE       = 1,
    NAL_SLICE_DPA   = 2,
    NAL_SLICE_DPB   = 3,
    NAL_SLICE_DPC   = 4,
    NAL_SLICE_IDR   = 5,    //* ref_idc != 0 */
    NAL_SEI         = 6,    //* ref_idc == 0 */
    NAL_SPS         = 7,
    NAL_PPS         = 8,
    NAL_AUD         = 9,
    NAL_FILLER      = 12
    //* ref_idc == 0 for 6,9,10,11,12 */
  );

  nal_priority_e = (
    NAL_PRIORITY_DISPOSABLE = 0,
    NAL_PRIORITY_LOW        = 1,
    NAL_PRIORITY_HIGH       = 2,
    NAL_PRIORITY_HIGHEST    = 3
  );

  pic_struct_e = (
    PIC_STRUCT_AUTO              = 0, // automatically decide (default)
    PIC_STRUCT_PROGRESSIVE       = 1, // progressive frame
    // "TOP" and "BOTTOM" are not supported in x264 (PAFF only)
    PIC_STRUCT_TOP_BOTTOM        = 4, // top field followed by bottom
    PIC_STRUCT_BOTTOM_TOP        = 5, // bottom field followed by top
    PIC_STRUCT_TOP_BOTTOM_TOP    = 6, // top field, bottom field, top field repeated
    PIC_STRUCT_BOTTOM_TOP_BOTTOM = 7, // bottom field, top field, bottom field repeated
    PIC_STRUCT_DOUBLE            = 8, // double frame
    PIC_STRUCT_TRIPLE            = 9 // triple frame
  );

  x264_hrd_t = packed record
    cpb_initial_arrival_time: Double;
    cpb_final_arrival_time: Double;
    cpb_removal_time: Double;
    dpb_output_time: Double;
  end;

(* Arbitrary user SEI:
 * Payload size is in bytes and the payload pointer must be valid.
 * Payload types and syntax can be found in Annex D of the H.264 Specification.
 * SEI payload alignment bits as described in Annex D must be included at the
 * end of the payload if needed.
 * The payload should not be NAL-encapsulated.
 * Payloads are written first in order of input, apart from in the case when HRD
 * is enabled where payloads are written after the Buffering Period SEI. *)
  Px264_sei_payload_t = ^x264_sei_payload_t;
  x264_sei_payload_t = packed record
    payload_size: Integer;
    payload_type: Integer;
    payload: PByte;
  end;

  Tsei_free = procedure(P: Pointer) of object;
  //void (*sei_free)( void* );
  x264_sei_t = packed record
    num_payloads: Integer;
    payloads: Px264_sei_payload_t;
    //* In: optional callback to free each payload AND x264_sei_payload_t when used. */
    sei_free: Tsei_free;
  end;

  x264_image_t = packed record
    i_csp: Integer;       //* Colorspace */
    i_plane: Integer;      //* Number of image planes */
    i_stride: array[0..3] of Integer; //* Strides for each plane */
    plane:array[0..3] of Byte;   //* Pointers to each plane */
  end;

  Tquant_offsets_free = procedure(P: Pointer) of object;
  //void (*quant_offsets_free)( void* );
  Tmb_info_free = procedure(P: Pointer) of object;
  //void (*mb_info_free)( void* );

  x264_image_properties_t = packed record
    (* All arrays of data here are ordered as follows:
     * each array contains one offset per macroblock, in raster scan order.  In interlaced
     * mode, top-field MBs and bottom-field MBs are interleaved at the row level.
     * Macroblocks are 16x16 blocks of pixels (with respect to the luma plane).  For the
     * purposes of calculating the number of macroblocks, width and height are rounded up to
     * the nearest 16.  If in interlaced mode, height is rounded up to the nearest 32 instead. *)

    (* In: an array of quantizer offsets to be applied to this image during encoding.
     *     These are added on top of the decisions made by x264.
     *     Offsets can be fractional; they are added before QPs are rounded to integer.
     *     Adaptive quantization must be enabled to use this feature.  Behavior if quant
     *     offsets differ between encoding passes is undefined. *)
    quant_offsets: Single;
    (* In: optional callback to free quant_offsets when used.
     *     Useful if one wants to use a different quant_offset array for each frame. *)
    quant_offsets_free: Tquant_offsets_free;

    (* In: optional array of flags for each macroblock.
     *     Allows specifying additional information for the encoder such as which macroblocks
     *     remain unchanged.  Usable flags are listed below.
     *     x264_param_t.analyse.b_mb_info must be set to use this, since x264 needs to track
     *     extra data internally to make full use of this information.
     *
     * Out: if b_mb_info_update is set, x264 will update this array as a result of encoding.
     *
     *      For "MBINFO_CONSTANT", it will remove this flag on any macroblock whose decoded
     *      pixels have changed.  This can be useful for e.g. noting which areas of the
     *      frame need to actually be blitted. Note: this intentionally ignores the effects
     *      of deblocking for the current frame, which should be fine unless one needs exact
     *      pixel-perfect accuracy.
     *
     *      Results for MBINFO_CONSTANT are currently only set for P-frames, and are not
     *      guaranteed to enumerate all blocks which haven't changed.  (There may be false
     *      negatives, but no false positives.)
     *)
    mb_info : PByte;
    //* In: optional callback to free mb_info when used. */
    mb_info_free: Tmb_info_free;

    (* The macroblock is constant and remains unchanged from the previous frame. */
    #define X264_MBINFO_CONSTANT   (1<<0)
    /* More flags may be added in the future. *)

    //* Out: SSIM of the the frame luma (if x264_param_t.b_ssim is set) */
    f_ssim: Double;
    //* Out: Average PSNR of the frame (if x264_param_t.b_psnr is set) */
    f_psnr_avg: Double;
    //* Out: PSNR of Y, U, and V (if x264_param_t.b_psnr is set) */
    f_psnr: array[0..2] of double;

    //* Out: Average effective CRF of the encoded frame */
    f_crf_avg: Double;
  end;


  x264_picture_t = packed record
    (* In: force picture type (if not auto)
     *     If x264 encoding parameters are violated in the forcing of picture types,
     *     x264 will correct the input picture type and log a warning.
     * Out: type of the picture encoded *)
    i_type: Integer;
    //* In: force quantizer for != X264_QP_AUTO */
    i_qpplus1: Integer;
    (* In: pic_struct, for pulldown/doubling/etc...used only if b_pic_struct=1.
     *     use pic_struct_e for pic_struct inputs
     * Out: pic_struct element associated with frame *)
    i_pic_struct: Integer;
    (* Out: whether this frame is a keyframe.  Important when using modes that result in
     * SEI recovery points being used instead of IDR frames. *)
    b_keyframe: Integer;
    //* In: user pts, Out: pts of encoded picture (user)*/
    i_pts: Int64;
    (* Out: frame dts. When the pts of the first frame is close to zero,
     *      initial frames may have a negative dts which must be dealt with by any muxer *)
    i_dts: Int64;
    (* In: custom encoding parameters to be set from this frame forwards
           (in coded order, not display order). If NULL, continue using
           parameters from the previous frame.  Some parameters, such as
           aspect ratio, can only be changed per-GOP due to the limitations
           of H.264 itself; in this case, the caller must force an IDR frame
           if it needs the changed parameter to apply immediately. *)
    param: Px264_param_t;
    //* In: raw image data */
    (* Out: reconstructed image data.  x264 may skip part of the reconstruction process,
            e.g. deblocking, in frames where it isn't necessary.  To force complete
            reconstruction, at a small speed cost, set b_full_recon. *)
    img: x264_image_t;
    (* In: optional information to modify encoder decisions for this frame
     * Out: information about the encoded frame *)
    prop: x264_image_properties_t;
    //* Out: HRD timing information. Output only when i_nal_hrd is set. */
    hrd_timing: x264_hrd_t;
    //* In: arbitrary user SEI (e.g subtitles, AFDs) */
    extra_sei: x264_sei_t;
    //* private user data. copied from input to output frames. */
    opaque: Pointer;
  end;


(* The data within the payload is already NAL-encapsulated; the ref_idc and type
 * are merely in the struct for easy access by the calling application.
 * All data returned in an x264_nal_t, including the data in p_payload, is no longer
 * valid after the next call to x264_encoder_encode.  Thus it must be used or copied
 * before calling x264_encoder_encode or x264_encoder_headers again. *)
  Px264_nal_t = ^x264_nal_t;
  x264_nal_t = packed record
    i_ref_idc: Integer;  //* nal_priority_e */
    i_type: Integer;      //* nal_unit_type_e */
    b_long_startcode: Integer;
    i_first_mb: Integer;  //* If this NAL is a slice, the index of the first MB in the slice. */
    i_last_mb: Integer;   //* If this NAL is a slice, the index of the last MB in the slice. */

    //* Size of payload (including any padding) in bytes. */
    i_payload: Integer;
    (* If param->b_annexb is set, Annex-B bytestream with startcode.
     * Otherwise, startcode is replaced with a 4-byte size.
     * This size is the size used in mp4/similar muxing; it is equal to i_payload-4 *)
    p_payload: PByte;

    //* Size of padding in bytes. */
    i_padding: Integer;
  end;

  //(*pf_log)( void *, int i_level, const char *psz, va_list );
  Tpf_log = procedure(P: Pointer; i_level: Integer; const psz: MarshaledAString; ap: Px264_t) of object;
  //void (*param_free)( void* );
  Tparam_free = procedure(P: Pointer) of object;
  //void (*nalu_process)( x264_t *h, x264_nal_t *nal, void *opaque );
  Tnalu_process = procedure(h: Px264_t; nal: Px264_nal_t; opaque: Pointer);


  (* Zones: override ratecontrol or other options for specific sections of the video.
   * See x264_encoder_reconfig() for which options can be changed.
   * If zones overlap, whichever comes later in the list takes precedence. *)
  x264_zone_t = packed record
    i_start, i_end: Integer;  //* range of frame numbers */
    b_force_qp: Integer; //* whether to use qp vs bitrate factor */
    i_qp: Integer;
    f_bitrate_factor: Single;
    param: Px264_param_t;
  end;

  Tvui = packed record
    //* they will be reduced to be 0 < x <= 65535 and prime */
    i_sar_height: Integer;
    i_sar_width: Integer;

    i_overscan: Integer;    //* 0=undef, 1=no overscan, 2=overscan */

    //* see h264 annex E for the values of the following */
    i_vidformat: Integer;
    b_fullrange: Integer;
    i_colorprim: Integer;
    i_transfer: Integer;
    i_colmatrix: Integer;
    i_chroma_loc: Integer;    //* both top & bottom */
  end;

  //* Encoder analyser parameters */
  Tanalyse = packed record
    intra: Smallint;     //* intra partitions */
    inter: Smallint;     //* inter partitions */

    b_transform_8x8: Integer;
    i_weighted_pred: Integer; //* weighting for P-frames */
    b_weighted_bipred: Integer; //* implicit weighting for B-frames */
    i_direct_mv_pred: Integer; //* spatial vs temporal mv prediction */
    i_chroma_qp_offset: Integer;

    i_me_method: Integer; //* motion estimation algorithm to use (X264_ME_*) */
    i_me_range: Integer; //* integer pixel motion estimation search range (from predicted mv) */
    i_mv_range: Integer; //* maximum length of a mv (in pixels). -1 = auto, based on level */
    i_mv_range_thread: Integer; //* minimum space between threads. -1 = auto, based on number of threads. */
    i_subpel_refine: Integer; //* subpixel motion estimation quality */
    b_chroma_me: Integer; //* chroma ME for subpel and mode decision in P-frames */
    b_mixed_references: Integer; //* allow each mb partition to have its own reference number */
    i_trellis: Integer;  //* trellis RD quantization */
    b_fast_pskip: Integer; //* early SKIP detection on P-frames */
    b_dct_decimate: Integer; //* transform coefficient thresholding on P-frames */
    i_noise_reduction: Integer; //* adaptive pseudo-deadzone */
    f_psy_rd: Single; //* Psy RD strength */
    f_psy_trellis: Single; //* Psy trellis strength */
    b_psy: Integer; //* Toggle all psy optimizations */

    b_mb_info: Integer;            //* Use input mb_info data in x264_picture_t */
    b_mb_info_update: Integer; //* Update the values in mb_info according to the results of encoding. */

    //* the deadzone size that will be used in luma quantization */
    i_luma_deadzone: array[0..1] of Integer; //* {inter, intra} */

    b_psnr: Integer;    //* compute and print PSNR stats */
    b_ssim: Integer;    //* compute and print SSIM stats */

  end;

  //* Rate control parameters */
  Trc = packed record
    i_rc_method: Integer;    //* X264_RC_* */

    i_qp_constant: Integer;  //* 0=lossless */
    i_qp_min: Integer;       //* min allowed QP value */
    i_qp_max: Integer;       //* max allowed QP value */
    i_qp_step: Integer;      //* max QP step between frames */

    i_bitrate: Integer;
    f_rf_constant: Single;  //* 1pass VBR, nominal QP */
    f_rf_constant_max: Single;  //* In CRF mode, maximum CRF as caused by VBV */
    f_rate_tolerance: Single;
    i_vbv_max_bitrate: Integer;
    i_vbv_buffer_size: Integer;
    f_vbv_buffer_init: Single; //* <=1: fraction of buffer_size. >1: kbit */
    f_ip_factor: Single;
    f_pb_factor: Single;

    (* VBV filler: force CBR VBV and use filler bytes to ensure hard-CBR.
     * Implied by NAL-HRD CBR. *)
    b_filler: Integer;

    i_aq_mode: Integer;      //* psy adaptive QP. (X264_AQ_*) */
    f_aq_strength: Single;
    b_mb_tree: Integer;      //* Macroblock-tree ratecontrol. */
    i_lookahead: Integer;

    //* 2pass */
    b_stat_write: Integer;   //* Enable stat writing in psz_stat_out */
    psz_stat_out:MarshaledAString;  //* output filename (in UTF-8) of the 2pass stats file */
    b_stat_read: Integer;    //* Read stat from psz_stat_in and use it */
    psz_stat_in: MarshaledAString;   //* input filename (in UTF-8) of the 2pass stats file */

    //* 2pass params (same as ffmpeg ones) */
    f_qcompress: Single;    //* 0.0 => cbr, 1.0 => constant qp */
    f_qblur: Single;        //* temporally blur quants */
    _complexity_blur: Single; //* temporally blur complexity */
    fzones: x264_zone_t;         //* ratecontrol overrides */
    i_zones: Integer;        //* number of zone_t's */
    psz_zones: MarshaledAString;     //* alternate method of specifying zones */
  end;

  (* Cropping Rectangle parameters: added to those implicitly defined by
     non-mod16 video resolutions. *)
  Tcrop_rect = packed record
    i_left: Smallint;
    i_top: Smallint;
    i_right: Smallint;
    i_bottom: Smallint;
  end;

  x264_param_t = packed record
    //* CPU flags */
    cpu: Smallint;
    i_threads: Integer;           //* encode multiple frames in parallel */
    i_lookahead_threads: Integer; //* multiple threads for lookahead analysis */
    b_sliced_threads: Integer;  //* Whether to use slice-based threading. */
    b_deterministic: Integer; //* whether to allow non-deterministic optimizations when threaded */
    b_cpu_independent: Integer; //* force canonical behavior rather than cpu-dependent optimal algorithms */
    i_sync_lookahead: Integer; //* threaded lookahead buffer */

    //* Video Properties */
    i_width: Integer;
    i_height: Integer;
    i_csp: Integer;         //* CSP of encoded bitstream */
    i_bitdepth: Integer;
    i_level_idc: Integer;
    i_frame_total: Integer; //* number of frames to encode if known, else 0 */

    (* NAL HRD
     * Uses Buffering and Picture Timing SEIs to signal HRD
     * The HRD in H.264 was not designed with VFR in mind.
     * It is therefore not recommendeded to use NAL HRD with VFR.
     * Furthermore, reconfiguring the VBV (via x264_encoder_reconfig)
     * will currently generate invalid HRD. *)
    i_nal_hrd: Integer;

    vui: Tvui;

    //* Bitstream parameters */
    i_frame_reference: Integer;  //* Maximum number of reference frames */
    i_dpb_size: Integer;         //* Force a DPB size larger than that implied by B-frames and reference frames.
                                     //* Useful in combination with interactive error resilience. */
    i_keyint_max: Integer;       //* Force an IDR keyframe at this interval */
    i_keyint_min: Integer;       //* Scenecuts closer together than this are coded as I, not IDR. */
    i_scenecut_threshold: Integer; //* how aggressively to insert extra I frames */
    b_intra_refresh: Integer;    //* Whether or not to use periodic intra refresh instead of IDR frames. */

    i_bframe: Integer;   //* how many b-frame between 2 references pictures */
    i_bframe_adaptive: Integer;
    i_bframe_bias: Integer;
    i_bframe_pyramid: Integer;   //* Keep some B-frames as references: 0=off, 1=strict hierarchical, 2=normal */
    b_open_gop: Integer;
    b_bluray_compat: Integer;
    i_avcintra_class: Integer;
    i_avcintra_flavor: Integer;

    b_deblocking_filter: Integer;
    i_deblocking_filter_alphac0: Integer;    //* [-6, 6] -6 light filter, 6 strong */
    i_deblocking_filter_beta: Integer;       //* [-6, 6]  idem */

    b_cabac: Integer;
    i_cabac_init_idc: Integer;

    b_interlaced: Integer;
    b_constrained_intra: Integer;

    i_cqm_preset: Integer;
    psz_cqm_file: MarshaledAString;      //* filename (in UTF-8) of CQM file, JM format */
    cqm_4iy: array[0..15] of Byte;        //* used only if i_cqm_preset == X264_CQM_CUSTOM */
    cqm_4py: array[0..15] of Byte;
    cqm_4ic: array[0..15] of Byte;
    cqm_4pc: array[0..15] of Byte;
    cqm_8iy: array[0..15] of Byte;
    cqm_8py: array[0..15] of Byte;
    cqm_8ic: array[0..15] of Byte;
    cqm_8pc: array[0..15] of Byte;

    //* Log */
    pf_log: Tpf_log;
    p_log_private: Pointer;
    i_log_level: Integer;
    b_full_recon: Integer;   //* fully reconstruct frames, even when not necessary for encoding.  Implied by psz_dump_yuv */
    psz_dump_yuv: MarshaledAString;  //* filename (in UTF-8) for reconstructed frames */

    //* Encoder analyser parameters */
    analyse: Tanalyse;
    //* Rate control parameters */
    rc: Trc;
    (* Cropping Rectangle parameters: added to those implicitly defined by
       non-mod16 video resolutions. *)
    crop_rect: Tcrop_rect;

    //* frame packing arrangement flag */
    i_frame_packing: Integer;

    //* alternative transfer SEI */
    i_alternative_transfer: Integer;

    //* Muxing parameters */
    b_aud: Integer;                  //* generate access unit delimiters */
    b_repeat_headers: Integer;      //* put SPS/PPS before each keyframe */
    b_annexb: Integer;               //* if set, place start codes (4 bytes) before NAL units,
                                // * otherwise place size (4 bytes) before NAL units. */
    i_sps_id: Integer;               //* SPS and PPS id number */
    b_vfr_input: Integer;            //* VFR input.  If 1, use timebase and timestamps for ratecontrol purposes.
                                // * If 0, use fps only. */
    b_pulldown: Integer;            //* use explicity set timebase for CFR */
    i_fps_num: Cardinal;
    i_fps_den: Cardinal;
    i_timebase_num: Cardinal;   //* Timebase numerator */
    i_timebase_den: Cardinal;   //* Timebase denominator */

    b_tff: Integer;

    (* Pulldown:
     * The correct pic_struct must be passed with each input frame.
     * The input timebase should be the timebase corresponding to the output framerate. This should be constant.
     * e.g. for 3:2 pulldown timebase should be 1001/30000
     * The PTS passed with each frame must be the PTS of the frame after pulldown is applied.
     * Frame doubling and tripling require b_vfr_input set to zero (see H.264 Table D-1)
     *
     * Pulldown changes are not clearly defined in H.264. Therefore, it is the calling app's responsibility to manage this.
     *)

    b_pic_struct: Integer;

    (* Fake Interlaced.
     *
     * Used only when b_interlaced=0. Setting this flag makes it possible to flag the stream as PAFF interlaced yet
     * encode all frames progessively. It is useful for encoding 25p and 30p Blu-Ray streams.
     *)

    b_fake_interlaced: Integer;

    (* Don't optimize header parameters based on video content, e.g. ensure that splitting an input video, compressing
     * each part, and stitching them back together will result in identical SPS/PPS. This is necessary for stitching
     * with container formats that don't allow multiple SPS/PPS. *)
    b_stitchable: Integer;

    b_opencl: Integer;            //* use OpenCL when available */
    i_opencl_device: Integer;     //* specify count of GPU devices to skip, for CLI users */
    opencl_device_id: Pointer;  //* pass explicit cl_device_id as void*, for API users */
    psz_clbin_file: MarshaledAString;    //* filename (in UTF-8) of the compiled OpenCL kernel cache file */

    //* Slicing parameters */
    i_slice_max_size: Integer;    //* Max size per slice in bytes; includes estimated NAL overhead. */
    i_slice_max_mbs: Integer;     //* Max number of MBs per slice; overrides i_slice_count. */
    i_slice_min_mbs: Integer;     //* Min number of MBs per slice */
    i_slice_count: Integer;       //* Number of slices per frame: forces rectangular slices. */
    i_slice_count_max: Integer;   //* Absolute cap on slices per frame; stops applying slice-max-size
                             // * and slice-max-mbs if this is reached. */

    (* Optional callback for freeing this x264_param_t when it is done being used.
     * Only used when the x264_param_t sits in memory for an indefinite period of time,
     * i.e. when an x264_param_t is passed to x264_t in an x264_picture_t or in zones.
     * Not used when x264_encoder_reconfig is called directly. *)
    param_free: Tparam_free;


    (* Optional low-level callback for low-latency encoding.  Called for each output NAL unit
     * immediately after the NAL unit is finished encoding.  This allows the calling application
     * to begin processing video data (e.g. by sending packets over a network) before the frame
     * is done encoding.
     *
     * This callback MUST do the following in order to work correctly:
     * 1) Have available an output buffer of at least size nal->i_payload*3/2 + 5 + 64.
     * 2) Call x264_nal_encode( h, dst, nal ), where dst is the output buffer.
     * After these steps, the content of nal is valid and can be used in the same way as if
     * the NAL unit were output by x264_encoder_encode.
     *
     * This does not need to be synchronous with the encoding process: the data pointed to
     * by nal (both before and after x264_nal_encode) will remain valid until the next
     * x264_encoder_encode call.  The callback must be re-entrant.
     *
     * This callback does not work with frame-based threads; threads must be disabled
     * or sliced-threads enabled.  This callback also does not work as one would expect
     * with HRD -- since the buffering period SEI cannot be calculated until the frame
     * is finished encoding, it will not be sent via this callback.
     *
     * Note also that the NALs are not necessarily returned in order when sliced threads is
     * enabled.  Accordingly, the variable i_first_mb and i_last_mb are available in
     * x264_nal_t to help the calling application reorder the slices if necessary.
     *
     * When this callback is enabled, x264_encoder_encode does not return valid NALs;
     * the calling application is expected to acquire all output NALs through the callback.
     *
     * It is generally sensible to combine this callback with a use of slice-max-mbs or
     * slice-max-size.
     *
     * The opaque pointer is the opaque pointer from the input frame associated with this
     * NAL unit. This helps distinguish between nalu_process calls from different sources,
     * e.g. if doing multiple encodes in one process.
     *)
    nalu_process: Tnalu_process;
  end;

  Tx264_nal_encode = procedure(h: Px264_t; dst: PByte; nal: Px264_nal_t) of object;
  //void x264_nal_encode( x264_t *h, uint8_t *dst, x264_nal_t *nal );

(****************************************************************************
 * H.264 level restriction information
 ****************************************************************************)
 x264_level_t = packed record
    level_idc: Byte;
    mbps: Cardinal;        //* max macroblock processing rate (macroblocks/sec) */
    frame_size: Cardinal;  //* max frame size (macroblocks) */
    dpb: Cardinal;         //* max decoded picture buffer (mbs) */
    bitrate: Cardinal;     //* max bitrate (kbit/sec) */
    cpb: Cardinal;         //* max vbv buffer (kbit) */
    mv_range: Word;    //* max vertical mv component range (pixels) */
    mvs_per_2mb: Byte; //* max mvs per 2 consecutive mbs. */
    slice_rate: Byte;  //* ?? */
    mincr: Byte;       //* min compression ratio */
    bipred8x8: Byte;   //* limit bipred to >=8x8 */
    direct8x8: Byte;   //* limit b_direct to >=8x8 */
    frame_only: Byte;  //* forbid interlacing */
 end;

{$IFDEF Android}
(* all of the levels defined in the standard, terminated by .level_idc=0 *)
//X264_API extern const x264_level_t x264_levels[];

(****************************************************************************
 * Basic parameter handling functions
 ****************************************************************************)

(* x264_param_default:
 *      fill x264_param_t with default values and do CPU detection *)
procedure x264_param_default(var param: x264_param_t); cdecl; external libx264 name _PU + 'x264_param_default';

(* x264_param_parse:
 *  set one parameter by name.
 *  returns 0 on success, or returns one of the following errors.
 *  note: BAD_VALUE occurs only if it can't even parse the value,
 *  numerical range is not checked until x264_encoder_open() or
 *  x264_encoder_reconfig().
 *  value=NULL means "true" for boolean options, but is a BAD_VALUE for non-booleans. *)
function x264_param_parse(var param: x264_param_t; name: MarshaledAString; value: MarshaledAString): Integer; cdecl; external libx264 name _PU + 'x264_param_parse';

(****************************************************************************
 * Advanced parameter handling functions
 ****************************************************************************)

(* These functions expose the full power of x264's preset-tune-profile system for
 * easy adjustment of large numbers of internal parameters.
 *
 * In order to replicate x264CLI's option handling, these functions MUST be called
 * in the following order:
 * 1) x264_param_default_preset
 * 2) Custom user options (via param_parse or directly assigned variables)
 * 3) x264_param_apply_fastfirstpass
 * 4) x264_param_apply_profile
 *
 * Additionally, x264CLI does not apply step 3 if the preset chosen is "placebo"
 * or --slow-firstpass is set. *)

(* x264_param_default_preset:
 *      The same as x264_param_default, but also use the passed preset and tune
 *      to modify the default settings.
 *      (either can be NULL, which implies no preset or no tune, respectively)
 *
 *      Currently available presets are, ordered from fastest to slowest: *)
//static const char * const x264_preset_names[] = { "ultrafast", "superfast", "veryfast", "faster", "fast", "medium", "slow", "slower", "veryslow", "placebo", 0 };

(*      Multiple tunings can be used if separated by a delimiter in ",./-+",
 *      however multiple psy tunings cannot be used.
 *      film, animation, grain, stillimage, psnr, and ssim are psy tunings.
 *
 *      returns 0 on success, negative on failure (e.g. invalid preset/tune name). *)
function x264_param_default_preset(var param: x264_param_t; preset: MarshaledAString; tune: MarshaledAString): Integer; cdecl; external libx264 name _PU + 'x264_param_default_preset';

(* x264_param_apply_fastfirstpass:
 *      If first-pass mode is set (rc.b_stat_read == 0, rc.b_stat_write == 1),
 *      modify the encoder settings to disable options generally not useful on
 *      the first pass. *)
procedure x264_param_apply_fastfirstpass(var param: x264_param_t); cdecl; external libx264 name _PU + 'x264_param_apply_fastfirstpass';


(* x264_param_apply_profile:
 *      Applies the restrictions of the given profile.
 *      Currently available profiles are, from most to least restrictive: *)
//static const char * const x264_profile_names[] = { "baseline", "main", "high", "high10", "high422", "high444", 0 };


(*      (can be NULL, in which case the function will do nothing)
 *
 *      Does NOT guarantee that the given profile will be used: if the restrictions
 *      of "High" are applied to settings that are already Baseline-compatible, the
 *      stream will remain baseline.  In short, it does not increase settings, only
 *      decrease them.
 *
 *      returns 0 on success, negative on failure (e.g. invalid profile name). *)
function x264_param_apply_profile(var param: x264_param_t; profile: MarshaledAString): Integer; cdecl; external libx264 name _PU + 'x264_param_apply_profile';

(* x264_chroma_format:
 *      Specifies the chroma formats that x264 supports encoding. When this
 *      value is non-zero, then it represents a X264_CSP_* that is the only
 *      chroma format that x264 supports encoding. If the value is 0 then
 *      there are no restrictions. *)
//X264_API extern const int x264_chroma_format;

(* x264_picture_init:
 *  initialize an x264_picture_t.  Needs to be done if the calling application
 *  allocates its own x264_picture_t as opposed to using x264_picture_alloc. *)
procedure x264_picture_init(var pic: x264_picture_t); cdecl; external libx264 name _PU + 'x264_picture_init';

(* x264_picture_alloc:
 *  alloc data for a picture. You must call x264_picture_clean on it.
 *  returns 0 on success, or -1 on malloc failure or invalid colorspace. *)
function x264_picture_alloc(var pic: x264_picture_t; i_csp: Integer; i_width: Integer; i_height: Integer): Integer; cdecl; external libx264 name _PU + 'x264_picture_alloc';

(* x264_picture_clean:
 *  free associated resource for a x264_picture_t allocated with
 *  x264_picture_alloc ONLY *)
procedure x264_picture_clean(var pic: x264_picture_t); cdecl; external libx264 name _PU + 'x264_picture_clean';


(****************************************************************************
 * Encoder functions
 ****************************************************************************)

(* Force a link error in the case of linking against an incompatible API version.
 * Glue #defines exist to force correct macro expansion; the final output of the macro
 * is x264_encoder_open_##X264_BUILD (for purposes of dlopen). *)

(* x264_encoder_open:
 *      create a new encoder handler, all parameters from x264_param_t are copied *)
function x264_encoder_open(var param: x264_param_t): Px264_t; cdecl; external libx264 name _PU + 'x264_encoder_open' + APIVersion;

(* x264_encoder_reconfig:
 *      various parameters from x264_param_t are copied.
 *      this takes effect immediately, on whichever frame is encoded next;
 *      due to delay, this may not be the next frame passed to encoder_encode.
 *      if the change should apply to some particular frame, use x264_picture_t->param instead.
 *      returns 0 on success, negative on parameter validation error.
 *      not all parameters can be changed; see the actual function for a detailed breakdown.
 *
 *      since not all parameters can be changed, moving from preset to preset may not always
 *      fully copy all relevant parameters, but should still work usably in practice. however,
 *      more so than for other presets, many of the speed shortcuts used in ultrafast cannot be
 *      switched out of; using reconfig to switch between ultrafast and other presets is not
 *      recommended without a more fine-grained breakdown of parameters to take this into account. *)
function x264_encoder_reconfig(x264_t: Px264_t; var param: x264_param_t): Integer; cdecl; external libx264 name _PU + 'x264_encoder_reconfig';

(* x264_encoder_parameters:
 *      copies the current internal set of parameters to the pointer provided
 *      by the caller.  useful when the calling application needs to know
 *      how x264_encoder_open has changed the parameters, or the current state
 *      of the encoder after multiple x264_encoder_reconfig calls.
 *      note that the data accessible through pointers in the returned param struct
 *      (e.g. filenames) should not be modified by the calling application. *)
procedure x264_encoder_parameters(x264_t: Px264_t; var param: x264_param_t); cdecl; external libx264 name _PU + 'x264_encoder_parameters';

(* x264_encoder_headers:
 *      return the SPS and PPS that will be used for the whole stream.
 *      *pi_nal is the number of NAL units outputted in pp_nal.
 *      returns the number of bytes in the returned NALs.
 *      returns negative on error.
 *      the payloads of all output NALs are guaranteed to be sequential in memory. *)
function x264_encoder_headers(x264_t: Px264_t; var pp_nal: Px264_nal_t; var pi_nal: Integer): Integer; cdecl; external libx264 name _PU + 'x264_encoder_headers';

(* x264_encoder_encode:
 *      encode one picture.
 *      *pi_nal is the number of NAL units outputted in pp_nal.
 *      returns the number of bytes in the returned NALs.
 *      returns negative on error and zero if no NAL units returned.
 *      the payloads of all output NALs are guaranteed to be sequential in memory. *)
function x264_encoder_encode(x264_t: Px264_t; var pp_nal: Px264_nal_t; pi_nal: Integer; var pic_in: x264_picture_t; var pic_out: x264_picture_t): Integer; cdecl; external libx264 name _PU + 'x264_encoder_encode';

(* x264_encoder_close:
 *      close an encoder handler *)
procedure x264_encoder_close(x264_t: Px264_t); cdecl; external libx264 name _PU + 'x264_encoder_close';

(* x264_encoder_delayed_frames:
 *      return the number of currently delayed (buffered) frames
 *      this should be used at the end of the stream, to know when you have all the encoded frames. *)
function x264_encoder_delayed_frames(x264_t: Px264_t): Integer; cdecl; external libx264 name _PU + 'x264_encoder_delayed_frames';

(* x264_encoder_maximum_delayed_frames( x264_t * ):
 *      return the maximum number of delayed (buffered) frames that can occur with the current
 *      parameters. *)
function x264_encoder_maximum_delayed_frames(x264_t: Px264_t): Integer; cdecl; external libx264 name _PU + 'x264_encoder_maximum_delayed_frames';

(* x264_encoder_intra_refresh:
 *      If an intra refresh is not in progress, begin one with the next P-frame.
 *      If an intra refresh is in progress, begin one as soon as the current one finishes.
 *      Requires that b_intra_refresh be set.
 *
 *      Useful for interactive streaming where the client can tell the server that packet loss has
 *      occurred.  In this case, keyint can be set to an extremely high value so that intra refreshes
 *      only occur when calling x264_encoder_intra_refresh.
 *
 *      In multi-pass encoding, if x264_encoder_intra_refresh is called differently in each pass,
 *      behavior is undefined.
 *
 *      Should not be called during an x264_encoder_encode. *)
procedure x264_encoder_intra_refresh(x264_t: Px264_t); cdecl; external libx264 name _PU + 'x264_encoder_intra_refresh';

(* x264_encoder_invalidate_reference:
 *      An interactive error resilience tool, designed for use in a low-latency one-encoder-few-clients
 *      system.  When the client has packet loss or otherwise incorrectly decodes a frame, the encoder
 *      can be told with this command to "forget" the frame and all frames that depend on it, referencing
 *      only frames that occurred before the loss.  This will force a keyframe if no frames are left to
 *      reference after the aforementioned "forgetting".
 *
 *      It is strongly recommended to use a large i_dpb_size in this case, which allows the encoder to
 *      keep around extra, older frames to fall back on in case more recent frames are all invalidated.
 *      Unlike increasing i_frame_reference, this does not increase the number of frames used for motion
 *      estimation and thus has no speed impact.  It is also recommended to set a very large keyframe
 *      interval, so that keyframes are not used except as necessary for error recovery.
 *
 *      x264_encoder_invalidate_reference is not currently compatible with the use of B-frames or intra
 *      refresh.
 *
 *      In multi-pass encoding, if x264_encoder_invalidate_reference is called differently in each pass,
 *      behavior is undefined.
 *
 *      Should not be called during an x264_encoder_encode, but multiple calls can be made simultaneously.
 *
 *      Returns 0 on success, negative on failure. *)
function x264_encoder_invalidate_reference(x264_t: Px264_t; pts: UInt64): Integer; cdecl; external libx264 name _PU + 'x264_encoder_invalidate_reference';

{$ENDIF}

implementation


end.
