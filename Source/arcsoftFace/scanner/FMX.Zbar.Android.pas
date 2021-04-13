unit FMX.Zbar.Android;

(*
  author by xubzhlin
  mail: 371889755@qq.com
*)

interface

(*------------------------------------------------------------------------
 *  Copyright 2007-2010 (c) Jeff Brown <spadix@users.sourceforge.net>
 *
 *  This file is part of the ZBar Bar Code Reader.
 *
 *  The ZBar Bar Code Reader is free software; you can redistribute it
 *  and/or modify it under the terms of the GNU Lesser Public License as
 *  published by the Free Software Foundation; either version 2.1 of
 *  the License, or (at your option) any later version.
 *
 *  The ZBar Bar Code Reader is distributed in the hope that it will be
 *  useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 *  of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser Public License
 *  along with the ZBar Bar Code Reader; if not, write to the Free
 *  Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 *  Boston, MA  02110-1301  USA
 *
 *  http://sourceforge.net/projects/zbar
 *------------------------------------------------------------------------*)

const
  _PU = '';
  libzbar = 'libzbar.so';

//#ifndef _ZBAR_H_
//#define _ZBAR_H_

(** @file
 * ZBar Barcode Reader C API definition
 *)

(** @mainpage
 *
 * interface to the barcode reader is available at several levels.
 * most applications will want to use the high-level interfaces:
 *
 * @section high-level High-Level Interfaces
 *
 * these interfaces wrap all library functionality into an easy-to-use
 * package for a specific toolkit:
 * - the "GTK+ 2.x widget" may be used with GTK GUI applications.  a
 *   Python wrapper is included for PyGtk
 * - the @ref zbar::QZBar "Qt4 widget" may be used with Qt GUI
 *   applications
 * - the Processor interface (in @ref c-processor "C" or @ref
 *   zbar::Processor "C++") adds a scanning window to an application
 *   with no GUI.
 *
 * @section mid-level Intermediate Interfaces
 *
 * building blocks used to construct high-level interfaces:
 * - the ImageScanner (in @ref c-imagescanner "C" or @ref
 *   zbar::ImageScanner "C++") looks for barcodes in a library defined
 *   image object
 * - the Window abstraction (in @ref c-window "C" or @ref
 *   zbar::Window "C++") sinks library images, displaying them on the
 *   platform display
 * - the Video abstraction (in @ref c-video "C" or @ref zbar::Video
 *   "C++") sources library images from a video device
 *
 * @section low-level Low-Level Interfaces
 *
 * direct interaction with barcode scanning and decoding:
 * - the Scanner (in @ref c-scanner "C" or @ref zbar::Scanner "C++")
 *   looks for barcodes in a linear intensity sample stream
 * - the Decoder (in @ref c-decoder "C" or @ref zbar::Decoder "C++")
 *   extracts barcodes from a stream of bar and space widths
 *)

//#ifdef __cplusplus

(** C++ namespace for library interfaces *)
//namespace zbar {
//    extern "C" {
//#endif


(** @name Global library interfaces *)
(*@{*)

type
(** "color" of element: bar or space. *)
  Pzbar_color_t = ^zbar_color_t;
  zbar_color_t = (
    ZBAR_SPACE = 0,    (**< light area or space between bars *)
    ZBAR_BAR   = 1       (**< dark area or colored bar segment *)
  );

(** decoded symbol type. *)
  Pzbar_symbol_type_t = ^zbar_symbol_type_t;
  zbar_symbol_type_t = (
    ZBAR_NONE        =      0,  (**< no symbol decoded *)
    ZBAR_PARTIAL     =      1,  (**< intermediate status *)
    ZBAR_EAN2        =      2,  (**< GS1 2-digit add-on *)
    ZBAR_EAN5        =      5,  (**< GS1 5-digit add-on *)
    ZBAR_EAN8        =      8,  (**< EAN-8 *)
    ZBAR_UPCE        =      9,  (**< UPC-E *)
    ZBAR_ISBN10      =     10,  (**< ISBN-10 (from EAN-13). @since 0.4 *)
    ZBAR_UPCA        =     12,  (**< UPC-A *)
    ZBAR_EAN13       =     13,  (**< EAN-13 *)
    ZBAR_ISBN13      =     14,  (**< ISBN-13 (from EAN-13). @since 0.4 *)
    ZBAR_COMPOSITE   =     15,  (**< EAN/UPC composite *)
    ZBAR_I25         =     25,  (**< Interleaved 2 of 5. @since 0.4 *)
    ZBAR_DATABAR     =     34,  (**< GS1 DataBar (RSS). @since 0.11 *)
    ZBAR_DATABAR_EXP =     35,  (**< GS1 DataBar Expanded. @since 0.11 *)
    ZBAR_CODABAR     =     38,  (**< Codabar. @since 0.11 *)
    ZBAR_CODE39      =     39,  (**< Code 39. @since 0.4 *)
    ZBAR_PDF417      =     57,  (**< PDF417. @since 0.6 *)
    ZBAR_QRCODE      =     64,  (**< QR Code. @since 0.10 *)
    ZBAR_CODE93      =     93,  (**< Code 93. @since 0.11 *)
    ZBAR_CODE128     =    128,  (**< Code 128 *)

    (** mask for base symbol type.
     * @deprecated in 0.11, remove this from existing code
     *)
    ZBAR_SYMBOL      = $00ff,
    (** 2-digit add-on flag.
     * @deprecated in 0.11, a ::ZBAR_EAN2 component is used for
     * 2-digit GS1 add-ons
     *)
    ZBAR_ADDON2      = $0200,
    (** 5-digit add-on flag.
     * @deprecated in 0.11, a ::ZBAR_EAN5 component is used for
     * 5-digit GS1 add-ons
     *)
    ZBAR_ADDON5      = $0500,
    (** add-on flag mask.
     * @deprecated in 0.11, GS1 add-ons are represented using composite
     * symbols of type ::ZBAR_COMPOSITE; add-on components use ::ZBAR_EAN2
     * or ::ZBAR_EAN5
     *)
    ZBAR_ADDON       = $0700
  );

(** decoded symbol coarse orientation.
 * @since 0.11
 *)
  Pzbar_orientation_t = ^zbar_orientation_t;
  zbar_orientation_t = (
    ZBAR_ORIENT_UNKNOWN = -1,   (**< unable to determine orientation *)
    ZBAR_ORIENT_UP,             (**< upright, read left to right *)
    ZBAR_ORIENT_RIGHT,          (**< sideways, read top to bottom *)
    ZBAR_ORIENT_DOWN,           (**< upside-down, read right to left *)
    ZBAR_ORIENT_LEFT            (**< sideways, read bottom to top *)
  );

(** error codes. *)
  Pzbar_error_t = ^zbar_error_t;
  zbar_error_t = (
    ZBAR_OK = 0,                (**< no error *)
    ZBAR_ERR_NOMEM,             (**< out of memory *)
    ZBAR_ERR_INTERNAL,          (**< internal library error *)
    ZBAR_ERR_UNSUPPORTED,       (**< unsupported request *)
    ZBAR_ERR_INVALID,           (**< invalid request *)
    ZBAR_ERR_SYSTEM,            (**< system error *)
    ZBAR_ERR_LOCKING,           (**< locking error *)
    ZBAR_ERR_BUSY,              (**< all resources busy *)
    ZBAR_ERR_XDISPLAY,          (**< X11 display error *)
    ZBAR_ERR_XPROTO,            (**< X11 protocol error *)
    ZBAR_ERR_CLOSED,            (**< output window is closed *)
    ZBAR_ERR_WINAPI,            (**< windows system error *)
    ZBAR_ERR_NUM                (**< number of error codes *)
  );

(** decoder configuration options.
 * @since 0.4
 *)
  Pzbar_config_t = ^zbar_config_t;
  zbar_config_t = (
    ZBAR_CFG_ENABLE = 0,        (**< enable symbology/feature *)
    ZBAR_CFG_ADD_CHECK,         (**< enable check digit when optional *)
    ZBAR_CFG_EMIT_CHECK,        (**< return check digit when present *)
    ZBAR_CFG_ASCII,             (**< enable full ASCII character set *)
    ZBAR_CFG_NUM,               (**< number of boolean decoder configs *)

    ZBAR_CFG_MIN_LEN = $20,    (**< minimum data length for valid decode *)
    ZBAR_CFG_MAX_LEN,           (**< maximum data length for valid decode *)

    ZBAR_CFG_UNCERTAINTY = $40,(**< required video consistency frames *)

    ZBAR_CFG_POSITION = $80,   (**< enable scanner to collect position data *)

    ZBAR_CFG_X_DENSITY = $100, (**< image scanner vertical scan density *)
    ZBAR_CFG_Y_DENSITY          (**< image scanner horizontal scan density *)
  );

(** decoder symbology modifier flags.
 * @since 0.11
 *)
  Pzbar_modifier_t = ^zbar_modifier_t;
  zbar_modifier_t = (
    (** barcode tagged as GS1 (EAN.UCC) reserved
     * (eg, FNC1 before first data character).
     * data may be parsed as a sequence of GS1 AIs
     *)
    ZBAR_MOD_GS1 = 0,

    (** barcode tagged as AIM reserved
     * (eg, FNC1 after first character or digit pair)
     *)
    ZBAR_MOD_AIM,

    (** number of modifiers *)
    ZBAR_MOD_NUM
  );

(** retrieve runtime library version information.
 * @param major set to the running major version (unless NULL)
 * @param minor set to the running minor version (unless NULL)
 * @returns 0
 *)
function zbar_version(major: PByte; minor: PByte): Integer;
  cdecl; external libzbar name _PU + 'zbar_version';

(** set global library debug level.
 * @param verbosity desired debug level.  higher values create more spew
 *)
procedure zbar_set_verbosity(verbosity: Integer);
  cdecl; external libzbar name _PU + 'zbar_set_verbosity';

(** increase global library debug level.
 * eg, for -vvvv
 *)
procedure zbar_increase_verbosity();
  cdecl; external libzbar name _PU + 'zbar_increase_verbosity';

(** retrieve string name for symbol encoding.
 * @param sym symbol type encoding
 * @returns the static string name for the specified symbol type,
 * or "UNKNOWN" if the encoding is not recognized
 *)
function zbar_get_symbol_name(sym: zbar_symbol_type_t): MarshaledAString;
  cdecl; external libzbar name _PU + 'zbar_get_symbol_name';

(** retrieve string name for addon encoding.
 * @param sym symbol type encoding
 * @returns static string name for any addon, or the empty string
 * if no addons were decoded
 * @deprecated in 0.11
 *)
function zbar_get_addon_name(sym: zbar_symbol_type_t): MarshaledAString;
  cdecl; external libzbar name _PU + 'zbar_get_addon_name';

(** retrieve string name for configuration setting.
 * @param config setting to name
 * @returns static string name for config,
 * or the empty string if value is not a known config
 *)
function zbar_get_config_name(config: zbar_config_t): MarshaledAString;
  cdecl; external libzbar name _PU + 'zbar_get_config_name';

(** retrieve string name for modifier.
 * @param modifier flag to name
 * @returns static string name for modifier,
 * or the empty string if the value is not a known flag
 *)
function zbar_get_modifier_name(modifier: zbar_modifier_t): MarshaledAString;
  cdecl; external libzbar name _PU + 'zbar_get_modifier_name';

(** retrieve string name for orientation.
 * @param orientation orientation encoding
 * @returns the static string name for the specified orientation,
 * or "UNKNOWN" if the orientation is not recognized
 * @since 0.11
 *)
function zbar_get_orientation_name(orientation: zbar_orientation_t): MarshaledAString;
  cdecl; external libzbar name _PU + 'zbar_get_orientation_name';


(** parse a configuration string of the form "[symbology.]config[=value]".
 * the config must match one of the recognized names.
 * the symbology, if present, must match one of the recognized names.
 * if symbology is unspecified, it will be set to 0.
 * if value is unspecified it will be set to 1.
 * @returns 0 if the config is parsed successfully, 1 otherwise
 * @since 0.4
 *)
function zbar_parse_config(const config_string: MarshaledAString;
                             symbology: Pzbar_symbol_type_t;
                             config: Pzbar_config_t;
                             value: PInteger): Integer;
  cdecl; external libzbar name _PU + 'zbar_parse_config';

(** consistently compute fourcc values across architectures
 * (adapted from v4l2 specification)
 * @since 0.11
 *)
 (*
#define zbar_fourcc(a, b, c, d)                 \
        ((unsigned long)(a) |                   \
         ((unsigned long)(b) << 8) |            \
         ((unsigned long)(c) << 16) |           \
         ((unsigned long)(d) << 24))
  *)

(** parse a fourcc string into its encoded integer value.
 * @since 0.11
 *)
(*
static inline unsigned long zbar_fourcc_parse (const char *format)
{
    unsigned long fourcc = 0;
    if(format) {
        int i;
        for(i = 0; i < 4 && format[i]; i++)
            fourcc |= ((unsigned long)format[i]) << (i * 8);
    }
    return(fourcc);
}
*)
(** @internal type unsafe error API (don't use) *)
(*
extern int _zbar_error_spew(const void *object,
                            int verbosity);
extern const char *_zbar_error_string(const void *object,
                                      int verbosity);
extern zbar_error_t _zbar_get_error_code(const void *object);
*)

(*@}*)
type
  Pzbar_symbol_s = ^zbar_symbol_s;
  zbar_symbol_s = packed record
  end;

  Pzbar_symbol_t = ^zbar_symbol_t;
  zbar_symbol_t = packed record
  end;

  Pzbar_symbol_set_s = ^zbar_symbol_set_s;
  zbar_symbol_set_s = packed record
  end;

  Pzbar_symbol_set_t = ^zbar_symbol_set_t;
  zbar_symbol_set_t = packed record
  end;


(*------------------------------------------------------------*)
(** @name Symbol interface
 * decoded barcode symbol result object.  stores type, data, and image
 * location of decoded symbol.  all memory is owned by the library
 *)
(*@{*)

(** @typedef zbar_symbol_t
 * opaque decoded symbol object.
 *)

(** symbol reference count manipulation.
 * increment the reference count when you store a new reference to the
 * symbol.  decrement when the reference is no longer used.  do not
 * refer to the symbol once the count is decremented and the
 * containing image has been recycled or destroyed.
 * @note the containing image holds a reference to the symbol, so you
 * only need to use this if you keep a symbol after the image has been
 * destroyed or reused.
 * @since 0.9
 *)
procedure zbar_symbol_ref(const symbol: pzbar_symbol_t;
                            refs: Integer);
  cdecl; external libzbar name _PU + 'zbar_symbol_ref';
(** retrieve type of decoded symbol.
 * @returns the symbol type
 *)
function zbar_symbol_get_type(const symbol: Pzbar_symbol_t): zbar_symbol_type_t;
  cdecl; external libzbar name _PU + 'zbar_symbol_get_type';

(** retrieve symbology boolean config settings.
 * @returns a bitmask indicating which configs were set for the detected
 * symbology during decoding.
 * @since 0.11
 *)
function zbar_symbol_get_configs(const symbol: Pzbar_symbol_t): Cardinal;
  cdecl; external libzbar name _PU + 'zbar_symbol_get_configs';

(** retrieve symbology modifier flag settings.
 * @returns a bitmask indicating which characteristics were detected
 * during decoding.
 * @since 0.11
 *)
function zbar_symbol_get_modifiers(const symbol: Pzbar_symbol_t): Cardinal;
  cdecl; external libzbar name _PU + 'zbar_symbol_get_modifiers';

(** retrieve data decoded from symbol.
 * @returns the data string
 *)
function zbar_symbol_get_data(const symbol: Pzbar_symbol_t): MarshaledAString;
  cdecl; external libzbar name _PU + 'zbar_symbol_get_data';

(** retrieve length of binary data.
 * @returns the length of the decoded data
 *)
function zbar_symbol_get_data_length(const symbol: Pzbar_symbol_t): Cardinal;
  cdecl; external libzbar name _PU + 'zbar_symbol_get_data_length';

(** retrieve a symbol confidence metric.
 * @returns an unscaled, relative quantity: larger values are better
 * than smaller values, where "large" and "small" are application
 * dependent.
 * @note expect the exact definition of this quantity to change as the
 * metric is refined.  currently, only the ordered relationship
 * between two values is defined and will remain stable in the future
 * @since 0.9
 *)
function zbar_symbol_get_quality(const symbol: Pzbar_symbol_t): Integer;
  cdecl; external libzbar name _PU + 'zbar_symbol_get_quality';

(** retrieve current cache count.  when the cache is enabled for the
 * image_scanner this provides inter-frame reliability and redundancy
 * information for video streams.
 * @returns < 0 if symbol is still uncertain.
 * @returns 0 if symbol is newly verified.
 * @returns > 0 for duplicate symbols
 *)
function zbar_symbol_get_count(const symbol: Pzbar_symbol_t): Integer;
  cdecl; external libzbar name _PU + 'zbar_symbol_get_count';

(** retrieve the number of points in the location polygon.  the
 * location polygon defines the image area that the symbol was
 * extracted from.
 * @returns the number of points in the location polygon
 * @note this is currently not a polygon, but the scan locations
 * where the symbol was decoded
 *)
function zbar_symbol_get_loc_size(const symbol: Pzbar_symbol_t): Word;
  cdecl; external libzbar name _PU + 'zbar_symbol_get_loc_size';

(** retrieve location polygon x-coordinates.
 * points are specified by 0-based index.
 * @returns the x-coordinate for a point in the location polygon.
 * @returns -1 if index is out of range
 *)
function zbar_symbol_get_loc_x(const symbol: Pzbar_symbol_t;
                                 index: Word): Integer;
  cdecl; external libzbar name _PU + 'zbar_symbol_get_loc_x';

(** retrieve location polygon y-coordinates.
 * points are specified by 0-based index.
 * @returns the y-coordinate for a point in the location polygon.
 * @returns -1 if index is out of range
 *)
function zbar_symbol_get_loc_y(const symbol: Pzbar_symbol_t;
                                 index: Word): Integer;
  cdecl; external libzbar name _PU + 'zbar_symbol_get_loc_y';

(** retrieve general orientation of decoded symbol.
 * @returns a coarse, axis-aligned indication of symbol orientation or
 * ::ZBAR_ORIENT_UNKNOWN if unknown
 * @since 0.11
 *)
function zbar_symbol_get_orientation(const symbol: Pzbar_symbol_t): zbar_orientation_t;
  cdecl; external libzbar name _PU + 'zbar_symbol_get_orientation';


(** iterate the set to which this symbol belongs (there can be only one).
 * @returns the next symbol in the set, or
 * @returns NULL when no more results are available
 *)
function zbar_symbol_next(const symbol: Pzbar_symbol_t): Pzbar_symbol_t;
  cdecl; external libzbar name _PU + 'zbar_symbol_next';

(** retrieve components of a composite result.
 * @returns the symbol set containing the components
 * @returns NULL if the symbol is already a physical symbol
 * @since 0.10
 *)
function zbar_symbol_get_components(const symbol: Pzbar_symbol_t): Pzbar_symbol_set_t;
  cdecl; external libzbar name _PU + 'zbar_symbol_get_components';

(** iterate components of a composite result.
 * @returns the first physical component symbol of a composite result
 * @returns NULL if the symbol is already a physical symbol
 * @since 0.10
 *)
function zbar_symbol_first_component(const symbol: Pzbar_symbol_t): zbar_symbol_t;
  cdecl; external libzbar name _PU + 'zbar_symbol_first_component';

(** print XML symbol element representation to user result buffer.
 * @see http://zbar.sourceforge.net/2008/barcode.xsd for the schema.
 * @param symbol is the symbol to print
 * @param buffer is the inout result pointer, it will be reallocated
 * with a larger size if necessary.
 * @param buflen is inout length of the result buffer.
 * @returns the buffer pointer
 * @since 0.6
 *)
function zbar_symbol_xml(const symbol: zbar_symbol_t;
                             var buffer: MarshaledAString;
                             var buflen: Cardinal): MarshaledAString;
  cdecl; external libzbar name _PU + 'zbar_symbol_xml';

(*@}*)

(*------------------------------------------------------------*)
(** @name Symbol Set interface
 * container for decoded result symbols associated with an image
 * or a composite symbol.
 * @since 0.10
 *)
(*@{*)

(** @typedef zbar_symbol_set_t
 * opaque symbol iterator object.
 * @since 0.10
 *)

(** reference count manipulation.
 * increment the reference count when you store a new reference.
 * decrement when the reference is no longer used.  do not refer to
 * the object any longer once references have been released.
 * @since 0.10
 *)
procedure zbar_symbol_set_ref(const symbols: Pzbar_symbol_set_t;
                                refs: Integer);
  cdecl; external libzbar name _PU + 'zbar_symbol_set_ref';

(** retrieve set size.
 * @returns the number of symbols in the set.
 * @since 0.10
 *)
function zbar_symbol_set_get_size(const symbols: Pzbar_symbol_set_t): Integer;
  cdecl; external libzbar name _PU + 'zbar_symbol_set_get_size';

(** set iterator.
 * @returns the first decoded symbol result in a set
 * @returns NULL if the set is empty
 * @since 0.10
 *)
function zbar_symbol_set_first_symbol(const symbols: Pzbar_symbol_set_t): Pzbar_symbol_t;
  cdecl; external libzbar name _PU + 'zbar_symbol_set_first_symbol';

(** raw result iterator.
 * @returns the first decoded symbol result in a set, *before* filtering
 * @returns NULL if the set is empty
 * @since 0.11
 *)
function zbar_symbol_set_first_unfiltered(const symbols: Pzbar_symbol_set_t): Pzbar_symbol_t;
  cdecl; external libzbar name _PU + 'zbar_symbol_set_first_unfiltered';

(*@}*)

(*------------------------------------------------------------*)
(** @name Image interface
 * stores image data samples along with associated format and size
 * metadata
 *)
(*@{*)

type
  Pzbar_image_s = ^zbar_image_s;
  zbar_image_s = packed record
  end;
(** opaque image object. *)
  Pzbar_image_t = ^zbar_image_t;
  zbar_image_t = packed record
  end;

(** cleanup handler callback function.
 * called to free sample data when an image is destroyed.
 *)
 zbar_image_cleanup_handler_t = procedure(image: Pzbar_image_t) of object;


(** data handler callback function.
 * called when decoded symbol results are available for an image
 *)
  zbar_image_data_handler_t = procedure(image: Pzbar_image_t; const userdata: Pointer) of object;


(** new image constructor.
 * @returns a new image object with uninitialized data and format.
 * this image should be destroyed (using zbar_image_destroy()) as
 * soon as the application is finished with it
 *)
function zbar_image_create: Pzbar_image_t;
  cdecl; external libzbar name _PU + 'zbar_image_create';

(** image destructor.  all images created by or returned to the
 * application should be destroyed using this function.  when an image
 * is destroyed, the associated data cleanup handler will be invoked
 * if available
 * @note make no assumptions about the image or the data buffer.
 * they may not be destroyed/cleaned immediately if the library
 * is still using them.  if necessary, use the cleanup handler hook
 * to keep track of image data buffers
 *)
procedure zbar_image_destroy(image: Pzbar_image_t);
  cdecl; external libzbar name _PU + 'zbar_image_destroy';

(** image reference count manipulation.
 * increment the reference count when you store a new reference to the
 * image.  decrement when the reference is no longer used.  do not
 * refer to the image any longer once the count is decremented.
 * zbar_image_ref(image, -1) is the same as zbar_image_destroy(image)
 * @since 0.5
 *)
procedure zbar_image_ref(image: Pzbar_image_t; refs: Integer);
  cdecl; external libzbar name _PU + 'zbar_image_ref';

(** image format conversion.  refer to the documentation for supported
 * image formats
 * @returns a @em new image with the sample data from the original image
 * converted to the requested format.  the original image is
 * unaffected.
 * @note the converted image size may be rounded (up) due to format
 * constraints
 *)
function zbar_image_convert(const image: Pzbar_image_t;
                                        format: LongInt): Pzbar_image_t;
  cdecl; external libzbar name _PU + 'zbar_image_convert';

(** image format conversion with crop/pad.
 * if the requested size is larger than the image, the last row/column
 * are duplicated to cover the difference.  if the requested size is
 * smaller than the image, the extra rows/columns are dropped from the
 * right/bottom.
 * @returns a @em new image with the sample data from the original
 * image converted to the requested format and size.
 * @note the image is @em not scaled
 * @see zbar_image_convert()
 * @since 0.4
 *)
function zbar_image_convert_resize(const image: zbar_image_t;
                                               format: Cardinal;
                                               width: Word;
                                               height: Word): Pzbar_image_t;
  cdecl; external libzbar name _PU + 'zbar_image_convert_resize';

(** retrieve the image format.
 * @returns the fourcc describing the format of the image sample data
 *)
function zbar_image_get_format(const image: Pzbar_image_t): Cardinal;
  cdecl; external libzbar name _PU + 'zbar_image_get_format';

(** retrieve a "sequence" (page/frame) number associated with this image.
 * @since 0.6
 *)
function zbar_image_get_sequence(const image: zbar_image_t): Word;
  cdecl; external libzbar name _PU + 'zbar_image_get_sequence';

(** retrieve the width of the image.
 * @returns the width in sample columns
 *)
function zbar_image_get_width(const image: zbar_image_t): Word;
  cdecl; external libzbar name _PU + 'zbar_image_get_width';

(** retrieve the height of the image.
 * @returns the height in sample rows
 *)
function zbar_image_get_height(const image: zbar_image_t): Word;
   cdecl; external libzbar name _PU + 'zbar_image_get_height';

(** retrieve both dimensions of the image.
 * fills in the width and height in samples
 *)
procedure zbar_image_get_size(const image: Pzbar_image_t;
                                width: PWord;
                                height: PWord);
   cdecl; external libzbar name _PU + 'zbar_image_get_size';

(** retrieve the crop rectangle.
 * fills in the image coordinates of the upper left corner and size
 * of an axis-aligned rectangular area of the image that will be scanned.
 * defaults to the full image
 * @since 0.11
 *)
procedure zbar_image_get_crop(const image: zbar_image_t;
                                x: PWord;
                                y: PWord;
                                width: PWord;
                                height: PWord);
   cdecl; external libzbar name _PU + 'zbar_image_get_crop';

(** return the image sample data.  the returned data buffer is only
 * valid until zbar_image_destroy() is called
 *)
function zbar_image_get_data(const image: zbar_image_t): Pointer;
   cdecl; external libzbar name _PU + 'zbar_image_get_data';

(** return the size of image data.
 * @since 0.6
 *)
function zbar_image_get_data_length(const img: zbar_image_t): Cardinal;
   cdecl; external libzbar name _PU + 'zbar_image_get_data_length';

(** retrieve the decoded results.
 * @returns the (possibly empty) set of decoded symbols
 * @returns NULL if the image has not been scanned
 * @since 0.10
 *)
function zbar_image_get_symbols(const image: zbar_image_t): Pzbar_symbol_set_t;
   cdecl; external libzbar name _PU + 'zbar_image_get_symbols';

(** associate the specified symbol set with the image, replacing any
 * existing results.  use NULL to release the current results from the
 * image.
 * @see zbar_image_scanner_recycle_image()
 * @since 0.10
 *)
procedure zbar_image_set_symbols(image: Pzbar_image_t;
                                   const symbols: Pzbar_symbol_set_t);
   cdecl; external libzbar name _PU + 'zbar_image_set_symbols';

(** image_scanner decode result iterator.
 * @returns the first decoded symbol result for an image
 * or NULL if no results are available
 *)
function zbar_image_first_symbol(const image: Pzbar_image_t): Pzbar_symbol_t;
   cdecl; external libzbar name _PU + 'zbar_image_first_symbol';

(** specify the fourcc image format code for image sample data.
 * refer to the documentation for supported formats.
 * @note this does not convert the data!
 * (see zbar_image_convert() for that)
 *)
procedure zbar_image_set_format(image: Pzbar_image_t;
                                  format: Cardinal);
   cdecl; external libzbar name _PU + 'zbar_image_set_format';

(** associate a "sequence" (page/frame) number with this image.
 * @since 0.6
 *)
procedure zbar_image_set_sequence(image: Pzbar_image_t;
                                    sequence_num: Word);
   cdecl; external libzbar name _PU + 'zbar_image_set_sequence';

(** specify the pixel size of the image.
 * @note this also resets the crop rectangle to the full image
 * (0, 0, width, height)
 * @note this does not affect the data!
 *)
procedure zbar_image_set_size(image: Pzbar_image_t;
                                width: Word;
                                height: Word);
   cdecl; external libzbar name _PU + 'zbar_image_set_size';

(** specify a rectangular region of the image to scan.
 * the rectangle will be clipped to the image boundaries.
 * defaults to the full image specified by zbar_image_set_size()
 *)
procedure zbar_image_set_crop(image: Pzbar_image_t;
                                x: Word;
                                y: Word;
                                width: Word;
                                height: Word);
   cdecl; external libzbar name _PU + 'zbar_image_set_crop';

(** specify image sample data.  when image data is no longer needed by
 * the library the specific data cleanup handler will be called
 * (unless NULL)
 * @note application image data will not be modified by the library
 *)
procedure zbar_image_set_data(image: Pzbar_image_t;
                                const data: Pointer;
                                data_byte_length: Cardinal;
                                cleanup_hndlr: zbar_image_cleanup_handler_t);
   cdecl; external libzbar name _PU + 'zbar_image_set_data';

(** built-in cleanup handler.
 * passes the image data buffer to free()
 *)
procedure zbar_image_free_data(image: Pzbar_image_t);
   cdecl; external libzbar name _PU + 'zbar_image_free_data';

(** associate user specified data value with an image.
 * @since 0.5
 *)
procedure zbar_image_set_userdata(image: Pzbar_image_t;
                                    userdata: Pointer);
   cdecl; external libzbar name _PU + 'zbar_image_set_userdata';

(** return user specified data value associated with the image.
 * @since 0.5
 *)
function zbar_image_get_userdata(const image: Pzbar_image_t): Pointer;
   cdecl; external libzbar name _PU + 'zbar_image_get_userdata';

(** dump raw image data to a file for debug.
 * the data will be prefixed with a 16 byte header consisting of:
 *   - 4 bytes uint = $676d697a ("zimg")
 *   - 4 bytes format fourcc
 *   - 2 bytes width
 *   - 2 bytes height
 *   - 4 bytes size of following image data in bytes
 * this header can be dumped w/eg:
 * @verbatim
       od -Ax -tx1z -N16 -w4 [file]
@endverbatim
 * for some formats the image can be displayed/converted using
 * ImageMagick, eg:
 * @verbatim
       display -size 640x480+16 [-depth ?] [-sampling-factor ?x?] \
           {GRAY,RGB,UYVY,YUV}:[file]
@endverbatim
 *
 * @param image the image object to dump
 * @param filebase base filename, appended with ".XXXX.zimg" where
 * XXXX is the format fourcc
 * @returns 0 on success or a system error code on failure
 *)
function zbar_image_write(const image: Pzbar_image_t;
                            const filebase: MarshaledAString): Integer;
   cdecl; external libzbar name _PU + 'zbar_image_write';

(** read back an image in the format written by zbar_image_write()
 * @note TBD
 *)
function zbar_image_read(filename: MarshaledAString): Pzbar_image_t;
   cdecl; external libzbar name _PU + 'zbar_image_read';

(*@}*)

(*------------------------------------------------------------*)
(** @name Processor interface
 * @anchor c-processor
 * high-level self-contained image processor.
 * processes video and images for barcodes, optionally displaying
 * images to a library owned output window
 *)
(*@{*)

type
  Pzbar_processor_s = ^zbar_processor_s;
  zbar_processor_s = packed record
  end;
(** opaque standalone processor object. *)
  Pzbar_processor_t = ^zbar_processor_t;
  zbar_processor_t = packed record
  end;

(** constructor.
 * if threaded is set and threading is available the processor
 * will spawn threads where appropriate to avoid blocking and
 * improve responsiveness
 *)
function zbar_processor_create(threaded: Integer): zbar_processor_t;
   cdecl; external libzbar name _PU + 'zbar_processor_create';

(** destructor.  cleans up all resources associated with the processor
 *)
procedure zbar_processor_destroy(processor: Pzbar_processor_t);
   cdecl; external libzbar name _PU + 'zbar_processor_destroy';

(** (re)initialization.
 * opens a video input device and/or prepares to display output
 *)
function zbar_processor_init(processor: Pzbar_processor_t;
                               const video_device: MarshaledAString;
                               enable_display: Integer): Integer;
   cdecl; external libzbar name _PU + 'zbar_processor_init';

(** request a preferred size for the video image from the device.
 * the request may be adjusted or completely ignored by the driver.
 * @note must be called before zbar_processor_init()
 * @since 0.6
 *)
function zbar_processor_request_size(processor: Pzbar_processor_t;
                                       width: Word;
                                       height: Word): Integer;
  cdecl; external libzbar name _PU + 'zbar_processor_request_size';

(** request a preferred video driver interface version for
 * debug/testing.
 * @note must be called before zbar_processor_init()
 * @since 0.6
 *)
function zbar_processor_request_interface(processor: Pzbar_processor_t;
                                            version: Integer): Integer;
  cdecl; external libzbar name _PU + 'zbar_processor_request_interface';

(** request a preferred video I/O mode for debug/testing.  You will
 * get errors if the driver does not support the specified mode.
 * @verbatim
    0 = auto-detect
    1 = force I/O using read()
    2 = force memory mapped I/O using mmap()
    3 = force USERPTR I/O (v4l2 only)
@endverbatim
 * @note must be called before zbar_processor_init()
 * @since 0.7
 *)
function zbar_processor_request_iomode(video: Pzbar_processor_t;
                                         iomode: Integer): Integer;
  cdecl; external libzbar name _PU + 'zbar_processor_request_iomode';

(** force specific input and output formats for debug/testing.
 * @note must be called before zbar_processor_init()
 *)
function zbar_processor_force_format(processor: Pzbar_processor_t;
                                       input_format: Cardinal;
                                       output_format: Cardinal): Integer;
  cdecl; external libzbar name _PU + 'zbar_processor_force_format';

(** setup result handler callback.
 * the specified function will be called by the processor whenever
 * new results are available from the video stream or a static image.
 * pass a NULL value to disable callbacks.
 * @param processor the object on which to set the handler.
 * @param handler the function to call when new results are available.
 * @param userdata is set as with zbar_processor_set_userdata().
 * @returns the previously registered handler
 *)
function zbar_processor_set_data_handler(processor: Pzbar_processor_t;
                                handler: zbar_image_data_handler_t;
                                const userdata: Pointer): zbar_image_data_handler_t;
  cdecl; external libzbar name _PU + 'zbar_processor_set_data_handler';

(** associate user specified data value with the processor.
 * @since 0.6
 *)
procedure zbar_processor_set_userdata(processor: Pzbar_processor_t;
                                        userdata: Pointer);
  cdecl; external libzbar name _PU + 'zbar_processor_set_userdata';

(** return user specified data value associated with the processor.
 * @since 0.6
 *)
function zbar_processor_get_userdata(const processor: Pzbar_processor_t): Pointer;
  cdecl; external libzbar name _PU + 'zbar_processor_get_userdata';

(** set config for indicated symbology (0 for all) to specified value.
 * @returns 0 for success, non-0 for failure (config does not apply to
 * specified symbology, or value out of range)
 * @see zbar_decoder_set_config()
 * @since 0.4
 *)
function zbar_processor_set_config(processor: Pzbar_processor_t;
                                     symbology: zbar_symbol_type_t;
                                     config: zbar_config_t;
                                     value: Integer): Integer;
  cdecl; external libzbar name _PU + 'zbar_processor_set_config';

(** parse configuration string using zbar_parse_config()
 * and apply to processor using zbar_processor_set_config().
 * @returns 0 for success, non-0 for failure
 * @see zbar_parse_config()
 * @see zbar_processor_set_config()
 * @since 0.4
 *)
//function zbar_processor_parse_config(processor: Pzbar_processor_t;
//                                               const config_string: MarshaledAString): Integer;
//  cdecl; external libzbar name _PU + 'zbar_processor_parse_config';
//
//{
//    zbar_symbol_type_t sym;
//    zbar_config_t cfg;
//    int val;
//    return(zbar_parse_config(config_string, &sym, &cfg, &val) ||
//           zbar_processor_set_config(processor, sym, cfg, val));
//}

(** retrieve the current state of the ouput window.
 * @returns 1 if the output window is currently displayed, 0 if not.
 * @returns -1 if an error occurs
 *)
function zbar_processor_is_visible(processor: Pzbar_processor_t): Integer;
  cdecl; external libzbar name _PU + 'zbar_processor_parse_config';

(** show or hide the display window owned by the library.
 * the size will be adjusted to the input size
 *)
function zbar_processor_set_visible(processor: Pzbar_processor_t;
                                      visible: Integer): Integer;
  cdecl; external libzbar name _PU + 'zbar_processor_set_visible';

(** control the processor in free running video mode.
 * only works if video input is initialized. if threading is in use,
 * scanning will occur in the background, otherwise this is only
 * useful wrapping calls to zbar_processor_user_wait(). if the
 * library output window is visible, video display will be enabled.
 *)
function zbar_processor_set_active(processor: Pzbar_processor_t;
                                     active: Integer): Integer;
  cdecl; external libzbar name _PU + 'zbar_processor_set_active';

(** retrieve decode results for last scanned image/frame.
 * @returns the symbol set result container or NULL if no results are
 * available
 * @note the returned symbol set has its reference count incremented;
 * ensure that the count is decremented after use
 * @since 0.10
 *)
function zbar_processor_get_results(const processor: Pzbar_processor_t): Pzbar_symbol_set_t;
  cdecl; external libzbar name _PU + 'zbar_processor_get_results';

(** wait for input to the display window from the user
 * (via mouse or keyboard).
 * @returns >0 when input is received, 0 if timeout ms expired
 * with no input or -1 in case of an error
 *)
function zbar_processor_user_wait(processor: Pzbar_processor_t;
                                    timeout: Integer): Integer;
  cdecl; external libzbar name _PU + 'zbar_processor_user_wait';

(** process from the video stream until a result is available,
 * or the timeout (in milliseconds) expires.
 * specify a timeout of -1 to scan indefinitely
 * (zbar_processor_set_active() may still be used to abort the scan
 * from another thread).
 * if the library window is visible, video display will be enabled.
 * @note that multiple results may still be returned (despite the
 * name).
 * @returns >0 if symbols were successfully decoded,
 * 0 if no symbols were found (ie, the timeout expired)
 * or -1 if an error occurs
 *)
function zbar_process_one(processor: Pzbar_processor_t;
                            timeout: Integer): Integer;
  cdecl; external libzbar name _PU + 'zbar_process_one';

(** process the provided image for barcodes.
 * if the library window is visible, the image will be displayed.
 * @returns >0 if symbols were successfully decoded,
 * 0 if no symbols were found or -1 if an error occurs
 *)
function zbar_process_image(processor: Pzbar_processor_t;
                              image: Pzbar_image_t): Integer;
  cdecl; external libzbar name _PU + 'zbar_process_image';

(** display detail for last processor error to stderr.
 * @returns a non-zero value suitable for passing to exit()
 *)
//function zbar_processor_error_spew(const processor: Pzbar_processor_t,
//                           verbosity: Integer): Integer;
//  cdecl; external libzbar name _PU + 'zbar_processor_error_spew';
//{
//    return(_zbar_error_spew(processor, verbosity));
//}

(** retrieve the detail string for the last processor error. *)
//static inline const char*
//zbar_processor_error_string (const zbar_processor_t *processor,
//                             int verbosity)
//{
//    return(_zbar_error_string(processor, verbosity));
//}

(** retrieve the type code for the last processor error. *)
//static inline zbar_error_t
//zbar_processor_get_error_code (const zbar_processor_t *processor)
//{
//    return(_zbar_get_error_code(processor));
//}

(*@}*)

(*------------------------------------------------------------*)
 (** @name Video interface
 * @anchor c-video
 * mid-level video source abstraction.
 * captures images from a video device
 *)
(*@{*)

type
  Pzbar_video_s = ^zbar_video_s;
  zbar_video_s = packed record
  end;
(** opaque video object. *)
  Pzbar_video_t = ^zbar_video_t;
  zbar_video_t = packed record
  end;

(** constructor. *)
function zbar_video_create: Pzbar_video_t;
  cdecl; external libzbar name _PU + 'zbar_video_create';

(** destructor. *)
procedure zbar_video_destroy(video: Pzbar_video_t);
  cdecl; external libzbar name _PU + 'zbar_video_create';

(** open and probe a video device.
 * the device specified by platform specific unique name
 * (v4l device node path in *nix eg "/dev/video",
 *  DirectShow DevicePath property in windows).
 * @returns 0 if successful or -1 if an error occurs
 *)
function zbar_video_open(video: Pzbar_video_t;
                           const device: MarshaledAString): Integer;
  cdecl; external libzbar name _PU + 'zbar_video_open';

(** retrieve file descriptor associated with open *nix video device
 * useful for using select()/poll() to tell when new images are
 * available (NB v4l2 only!!).
 * @returns the file descriptor or -1 if the video device is not open
 * or the driver only supports v4l1
 *)
function zbar_video_get_fd(const video: Pzbar_video_t): Integer;
  cdecl; external libzbar name _PU + 'zbar_video_get_fd';

(** request a preferred size for the video image from the device.
 * the request may be adjusted or completely ignored by the driver.
 * @returns 0 if successful or -1 if the video device is already
 * initialized
 * @since 0.6
 *)
function zbar_video_request_size(video: zbar_video_t;
                                   width: Word;
                                   height: Word): Integer;
  cdecl; external libzbar name _PU + 'zbar_video_request_size';

(** request a preferred driver interface version for debug/testing.
 * @note must be called before zbar_video_open()
 * @since 0.6
 *)
function zbar_video_request_interface(video: zbar_video_t;
                                        version: Integer): Integer;
  cdecl; external libzbar name _PU + 'zbar_video_request_interface';

(** request a preferred I/O mode for debug/testing.  You will get
 * errors if the driver does not support the specified mode.
 * @verbatim
    0 = auto-detect
    1 = force I/O using read()
    2 = force memory mapped I/O using mmap()
    3 = force USERPTR I/O (v4l2 only)
@endverbatim
 * @note must be called before zbar_video_open()
 * @since 0.7
 *)
function zbar_video_request_iomode(video: Pzbar_video_t;
                                     iomode: Integer): Integer;
  cdecl; external libzbar name _PU + 'zbar_video_request_iomode';

(** retrieve current output image width.
 * @returns the width or 0 if the video device is not open
 *)
function zbar_video_get_width(const video: Pzbar_video_t): Integer;
  cdecl; external libzbar name _PU + 'zbar_video_get_width';

(** retrieve current output image height.
 * @returns the height or 0 if the video device is not open
 *)
function zbar_video_get_height(const video: zbar_video_t): Integer;
  cdecl; external libzbar name _PU + 'zbar_video_get_height';

(** initialize video using a specific format for debug.
 * use zbar_negotiate_format() to automatically select and initialize
 * the best available format
 *)
function zbar_video_init(video: zbar_video_t;
                           format: Cardinal): Integer;
  cdecl; external libzbar name _PU + 'zbar_video_init';

(** start/stop video capture.
 * all buffered images are retired when capture is disabled.
 * @returns 0 if successful or -1 if an error occurs
 *)
function zbar_video_enable(video: Pzbar_video_t;
                             enable: Integer): Integer;
  cdecl; external libzbar name _PU + 'zbar_video_enable';

(** retrieve next captured image.  blocks until an image is available.
 * @returns NULL if video is not enabled or an error occurs
 *)
function zbar_video_next_image(video: Pzbar_video_t): pzbar_image_t;
  cdecl; external libzbar name _PU + 'zbar_video_next_image';

(** display detail for last video error to stderr.
 * @returns a non-zero value suitable for passing to exit()
 *)
//static inline int zbar_video_error_spew (const zbar_video_t *video,
//                                         int verbosity)
//{
//    return(_zbar_error_spew(video, verbosity));
//}

(** retrieve the detail string for the last video error. *)
//static inline const char *zbar_video_error_string (const zbar_video_t *video,
//                                                   int verbosity)
//{
//    return(_zbar_error_string(video, verbosity));
//}

(** retrieve the type code for the last video error. *)
//static inline zbar_error_t
//zbar_video_get_error_code (const zbar_video_t *video)
//{
//    return(_zbar_get_error_code(video));
//}

(*@}*)

(*------------------------------------------------------------*)
(** @name Window interface
 * @anchor c-window
 * mid-level output window abstraction.
 * displays images to user-specified platform specific output window
 *)
(*@{*)

type
  Pzbar_window_s = ^zbar_window_s;
  zbar_window_s = packed record
  end;
(** opaque window object. *)
  Pzbar_window_t = ^zbar_window_t;
  zbar_window_t = packed record
  end;

(** constructor. *)
function zbar_window_create: Pzbar_window_t;
  cdecl; external libzbar name _PU + 'zbar_window_create';

(** destructor. *)
procedure zbar_window_destroy(window: Pzbar_window_t);
  cdecl; external libzbar name _PU + 'zbar_window_destroy';

(** associate reader with an existing platform window.
 * This can be any "Drawable" for X Windows or a "HWND" for windows.
 * input images will be scaled into the output window.
 * pass NULL to detach from the resource, further input will be
 * ignored
 *)
function zbar_window_attach(window: Pzbar_window_t;
                              x11_display_w32_hwnd: Pointer;
                              x11_drawable: Cardinal): Integer;
  cdecl; external libzbar name _PU + 'zbar_window_attach';

(** control content level of the reader overlay.
 * the overlay displays graphical data for informational or debug
 * purposes.  higher values increase the level of annotation (possibly
 * decreasing performance). @verbatim
    0 = disable overlay
    1 = outline decoded symbols (default)
    2 = also track and display input frame rate
@endverbatim
 *)
procedure zbar_window_set_overlay(window: Pzbar_window_t;
                                    level: Integer);
  cdecl; external libzbar name _PU + 'zbar_window_set_overlay';

(** retrieve current content level of reader overlay.
 * @see zbar_window_set_overlay()
 * @since 0.10
 *)
function zbar_window_get_overlay(const window: Pzbar_window_t): Integer;
  cdecl; external libzbar name _PU + 'zbar_window_get_overlay';

(** draw a new image into the output window. *)
function zbar_window_draw(window: Pzbar_window_t;
                            image: Pzbar_image_t): Integer;
  cdecl; external libzbar name _PU + 'zbar_window_draw';

(** redraw the last image (exposure handler). *)
function zbar_window_redraw(window: Pzbar_window_t): Integer;
  cdecl; external libzbar name _PU + 'zbar_window_redraw';

(** resize the image window (reconfigure handler).
 * this does @em not update the contents of the window
 * @since 0.3, changed in 0.4 to not redraw window
 *)
function zbar_window_resize(window: Pzbar_window_t;
                              width: Word;
                              height: Word): Integer;
  cdecl; external libzbar name _PU + 'zbar_window_resize';

(** display detail for last window error to stderr.
 * @returns a non-zero value suitable for passing to exit()
 *)
//static inline int zbar_window_error_spew (const zbar_window_t *window,
//                                          int verbosity)
//{
//    return(_zbar_error_spew(window, verbosity));
//}

(** retrieve the detail string for the last window error. *)
//static inline const char*
//zbar_window_error_string (const zbar_window_t *window,
//                          int verbosity)
//{
//    return(_zbar_error_string(window, verbosity));
//}

(** retrieve the type code for the last window error. *)
//static inline zbar_error_t
//zbar_window_get_error_code (const zbar_window_t *window)
//{
//    return(_zbar_get_error_code(window));
//}


(** select a compatible format between video input and output window.
 * the selection algorithm attempts to use a format shared by
 * video input and window output which is also most useful for
 * barcode scanning.  if a format conversion is necessary, it will
 * heuristically attempt to minimize the cost of the conversion
 *)
function zbar_negotiate_format(video: Pzbar_video_t;
                                 window: Pzbar_window_t): Integer;
  cdecl; external libzbar name _PU + 'zbar_negotiate_format';
(*@}*)

(*------------------------------------------------------------*)
(** @name Image Scanner interface
 * @anchor c-imagescanner
 * mid-level image scanner interface.
 * reads barcodes from 2-D images
 *)
(*@{*)

type
  Pzbar_image_scanner_s = ^zbar_image_scanner_s;
  zbar_image_scanner_s = packed record

  end;
(** opaque image scanner object. *)
  Pzbar_image_scanner_t = ^zbar_image_scanner_t;
  zbar_image_scanner_t = packed record

  end;

(** constructor. *)
function zbar_image_scanner_create: Pzbar_image_scanner_t;
  cdecl; external libzbar name _PU + 'zbar_image_scanner_create';

(** destructor. *)
procedure zbar_image_scanner_destroy(scanner: Pzbar_image_scanner_t);
  cdecl; external libzbar name _PU + 'zbar_image_scanner_destroy';

(** setup result handler callback.
 * the specified function will be called by the scanner whenever
 * new results are available from a decoded image.
 * pass a NULL value to disable callbacks.
 * @returns the previously registered handler
 *)
function zbar_image_scanner_set_data_handler(scanner: Pzbar_image_scanner_t;
                                    handler: zbar_image_data_handler_t;
                                    const userdata: Pointer): zbar_image_data_handler_t;
  cdecl; external libzbar name _PU + 'zbar_image_scanner_set_data_handler';

(** set config for indicated symbology (0 for all) to specified value.
 * @returns 0 for success, non-0 for failure (config does not apply to
 * specified symbology, or value out of range)
 * @see zbar_decoder_set_config()
 * @since 0.4
 *)
function zbar_image_scanner_set_config(scanner: Pzbar_image_scanner_t;
                                         symbology: zbar_symbol_type_t;
                                         config: zbar_config_t;
                                         value: Integer): Integer;
  cdecl; external libzbar name _PU + 'zbar_image_scanner_set_config';

(** parse configuration string using zbar_parse_config()
 * and apply to image scanner using zbar_image_scanner_set_config().
 * @returns 0 for success, non-0 for failure
 * @see zbar_parse_config()
 * @see zbar_image_scanner_set_config()
 * @since 0.4
 *)
//static inline int
//zbar_image_scanner_parse_config (zbar_image_scanner_t *scanner,
//                                 const char *config_string)
//{
//    zbar_symbol_type_t sym;
//    zbar_config_t cfg;
//    int val;
//    return(zbar_parse_config(config_string, &sym, &cfg, &val) ||
//           zbar_image_scanner_set_config(scanner, sym, cfg, val));
//}

(** enable or disable the inter-image result cache (default disabled).
 * mostly useful for scanning video frames, the cache filters
 * duplicate results from consecutive images, while adding some
 * consistency checking and hysteresis to the results.
 * this interface also clears the cache
 *)
procedure zbar_image_scanner_enable_cache(scanner: Pzbar_image_scanner_t;
                                            enable: Integer);
  cdecl; external libzbar name _PU + 'zbar_image_scanner_enable_cache';

(** remove any previously decoded results from the image scanner and the
 * specified image.  somewhat more efficient version of
 * zbar_image_set_symbols(image, NULL) which may retain memory for
 * subsequent decodes
 * @since 0.10
 *)
procedure zbar_image_scanner_recycle_image(scanner: Pzbar_image_scanner_t;
                                             image: Pzbar_image_t);
  cdecl; external libzbar name _PU + 'zbar_image_scanner_recycle_image';

(** retrieve decode results for last scanned image.
 * @returns the symbol set result container or NULL if no results are
 * available
 * @note the symbol set does not have its reference count adjusted;
 * ensure that the count is incremented if the results may be kept
 * after the next image is scanned
 * @since 0.10
 *)
function zbar_image_scanner_get_results(const scanner: Pzbar_image_scanner_t): Pzbar_symbol_set_t;
  cdecl; external libzbar name _PU + 'zbar_image_scanner_get_results';

(** scan for symbols in provided image.  The image format must be
 * "Y800" or "GRAY".
 * @returns >0 if symbols were successfully decoded from the image,
 * 0 if no symbols were found or -1 if an error occurs
 * @see zbar_image_convert()
 * @since 0.9 - changed to only accept grayscale images
 *)
function zbar_scan_image(scanner: Pzbar_image_scanner_t;
                           image: Pzbar_image_t): Integer;
  cdecl; external libzbar name _PU + 'zbar_scan_image';

(*@}*)

(*------------------------------------------------------------*)
(** @name Decoder interface
 * @anchor c-decoder
 * low-level bar width stream decoder interface.
 * identifies symbols and extracts encoded data
 *)
(*@{*)

type
  Pzbar_decoder_s = ^zbar_decoder_s;
  zbar_decoder_s = packed record

  end;
(** opaque decoder object. *)
  Pzbar_decoder_t = ^zbar_decoder_t;
  zbar_decoder_t = packed record

  end;

(** decoder data handler callback function.
 * called by decoder when new data has just been decoded
 *)
  zbar_decoder_handler_t = procedure(decoder: Pzbar_decoder_t) of object;

(** constructor. *)
function zbar_decoder_create: Pzbar_decoder_t;
  cdecl; external libzbar name _PU + 'zbar_decoder_create';

(** destructor. *)
procedure zbar_decoder_destroy(decoder: Pzbar_decoder_t);
  cdecl; external libzbar name _PU + 'zbar_decoder_destroy';

(** set config for indicated symbology (0 for all) to specified value.
 * @returns 0 for success, non-0 for failure (config does not apply to
 * specified symbology, or value out of range)
 * @since 0.4
 *)
function zbar_decoder_set_config(decoder: Pzbar_decoder_t;
                                   symbology: zbar_symbol_type_t;
                                   config: zbar_config_t;
                                   value: Integer): Integer;
  cdecl; external libzbar name _PU + 'zbar_decoder_set_config';

(** parse configuration string using zbar_parse_config()
 * and apply to decoder using zbar_decoder_set_config().
 * @returns 0 for success, non-0 for failure
 * @see zbar_parse_config()
 * @see zbar_decoder_set_config()
 * @since 0.4
 *)
//static inline int zbar_decoder_parse_config (zbar_decoder_t *decoder,
//                                             const char *config_string)
//{
//    zbar_symbol_type_t sym;
//    zbar_config_t cfg;
//    int val;
//    return(zbar_parse_config(config_string, &sym, &cfg, &val) ||
//           zbar_decoder_set_config(decoder, sym, cfg, val));
//}

(** retrieve symbology boolean config settings.
 * @returns a bitmask indicating which configs are currently set for the
 * specified symbology.
 * @since 0.11
 *)
function zbar_decoder_get_configs(const decoder: Pzbar_decoder_t;
                                             symbology: zbar_symbol_type_t): Word;
  cdecl; external libzbar name _PU + 'zbar_decoder_get_configs';

(** clear all decoder state.
 * any partial symbols are flushed
 *)
procedure zbar_decoder_reset(decoder: Pzbar_decoder_t);
  cdecl; external libzbar name _PU + 'zbar_decoder_reset';

(** mark start of a new scan pass.
 * clears any intra-symbol state and resets color to ::ZBAR_SPACE.
 * any partially decoded symbol state is retained
 *)
procedure zbar_decoder_new_scan(decoder: Pzbar_decoder_t);
  cdecl; external libzbar name _PU + 'zbar_decoder_new_scan';

(** process next bar/space width from input stream.
 * the width is in arbitrary relative units.  first value of a scan
 * is ::ZBAR_SPACE width, alternating from there.
 * @returns appropriate symbol type if width completes
 * decode of a symbol (data is available for retrieval)
 * @returns ::ZBAR_PARTIAL as a hint if part of a symbol was decoded
 * @returns ::ZBAR_NONE (0) if no new symbol data is available
 *)
function zbar_decode_width(decoder: Pzbar_decoder_t;
                           width: Word): zbar_symbol_type_t;
  cdecl; external libzbar name _PU + 'zbar_decode_width';

(** retrieve color of @em next element passed to
 * zbar_decode_width(). *)
function zbar_decoder_get_color(const decoder: Pzbar_decoder_t): zbar_color_t;
  cdecl; external libzbar name _PU + 'zbar_decoder_get_color';

(** retrieve last decoded data.
 * @returns the data string or NULL if no new data available.
 * the returned data buffer is owned by library, contents are only
 * valid between non-0 return from zbar_decode_width and next library
 * call
 *)
function zbar_decoder_get_data(const decoder: zbar_decoder_t): MarshaledAString;
  cdecl; external libzbar name _PU + 'zbar_decoder_get_data';

(** retrieve length of binary data.
 * @returns the length of the decoded data or 0 if no new data
 * available.
 *)
function zbar_decoder_get_data_length(const decoder: Pzbar_decoder_t): Word;
  cdecl; external libzbar name _PU + 'zbar_decoder_get_data_length';

(** retrieve last decoded symbol type.
 * @returns the type or ::ZBAR_NONE if no new data available
 *)
function zbar_decoder_get_type(const decoder: Pzbar_decoder_t): zbar_symbol_type_t;
  cdecl; external libzbar name _PU + 'zbar_decoder_get_type';

(** retrieve modifier flags for the last decoded symbol.
 * @returns a bitmask indicating which characteristics were detected
 * during decoding.
 * @since 0.11
 *)
function zbar_decoder_get_modifiers(const decoder: Pzbar_decoder_t): Word;
  cdecl; external libzbar name _PU + 'zbar_decoder_get_modifiers';

(** retrieve last decode direction.
 * @returns 1 for forward and -1 for reverse
 * @returns 0 if the decode direction is unknown or does not apply
 * @since 0.11
 *)
function zbar_decoder_get_direction(const decoder: Pzbar_decoder_t): Integer;
  cdecl; external libzbar name _PU + 'zbar_decoder_get_direction';

(** setup data handler callback.
 * the registered function will be called by the decoder
 * just before zbar_decode_width() returns a non-zero value.
 * pass a NULL value to disable callbacks.
 * @returns the previously registered handler
 *)
function zbar_decoder_set_handler(decoder: Pzbar_decoder_t;
                         handler: zbar_decoder_handler_t): zbar_decoder_handler_t;
  cdecl; external libzbar name _PU + 'zbar_decoder_set_handler';

(** associate user specified data value with the decoder. *)
procedure zbar_decoder_set_userdata(decoder: Pzbar_decoder_t;
                                      userdata: Pointer);
  cdecl; external libzbar name _PU + 'zbar_decoder_set_userdata';

(** return user specified data value associated with the decoder. *)
function zbar_decoder_get_userdata(const decoder: Pzbar_decoder_t): Pointer;
  cdecl; external libzbar name _PU + 'zbar_decoder_get_userdata';
(*@}*)

(*------------------------------------------------------------*)
(** @name Scanner interface
 * @anchor c-scanner
 * low-level linear intensity sample stream scanner interface.
 * identifies "bar" edges and measures width between them.
 * optionally passes to bar width decoder
 *)
(*@{*)

type
  Pzbar_scanner_s = ^zbar_scanner_s;
  zbar_scanner_s = packed record

  end;
(** opaque scanner object. *)
  Pzbar_scanner_t = ^zbar_scanner_t;
  zbar_scanner_t = packed record

  end;

(** constructor.
 * if decoder is non-NULL it will be attached to scanner
 * and called automatically at each new edge
 * current color is initialized to ::ZBAR_SPACE
 * (so an initial BAR->SPACE transition may be discarded)
 *)
function zbar_scanner_create(decoder: Pzbar_decoder_t): Pzbar_scanner_t;
  cdecl; external libzbar name _PU + 'zbar_scanner_create';

(** destructor. *)
procedure zbar_scanner_destroy(scanner: Pzbar_scanner_t);
  cdecl; external libzbar name _PU + 'zbar_scanner_destroy';

(** clear all scanner state.
 * also resets an associated decoder
 *)
function zbar_scanner_reset(scanner: Pzbar_scanner_t): zbar_symbol_type_t;
  cdecl; external libzbar name _PU + 'zbar_scanner_reset';

(** mark start of a new scan pass. resets color to ::ZBAR_SPACE.
 * also updates an associated decoder.
 * @returns any decode results flushed from the pipeline
 * @note when not using callback handlers, the return value should
 * be checked the same as zbar_scan_y()
 * @note call zbar_scanner_flush() at least twice before calling this
 * method to ensure no decode results are lost
 *)
function zbar_scanner_new_scan(scanner: Pzbar_scanner_t): zbar_symbol_type_t;
  cdecl; external libzbar name _PU + 'zbar_scanner_reset';

(** flush scanner processing pipeline.
 * forces current scanner position to be a scan boundary.
 * call multiple times (max 3) to completely flush decoder.
 * @returns any decode/scan results flushed from the pipeline
 * @note when not using callback handlers, the return value should
 * be checked the same as zbar_scan_y()
 * @since 0.9
 *)
function zbar_scanner_flush(scanner: Pzbar_scanner_t): zbar_symbol_type_t;
  cdecl; external libzbar name _PU + 'zbar_scanner_flush';

(** process next sample intensity value.
 * intensity (y) is in arbitrary relative units.
 * @returns result of zbar_decode_width() if a decoder is attached,
 * otherwise @returns (::ZBAR_PARTIAL) when new edge is detected
 * or 0 (::ZBAR_NONE) if no new edge is detected
 *)
function zbar_scan_y(scanner: Pzbar_scanner_t;
                                      y: Integer): zbar_symbol_type_t;
  cdecl; external libzbar name _PU + 'zbar_scan_y';

(** process next sample from RGB (or BGR) triple. *)
//static inline zbar_symbol_type_t zbar_scan_rgb24 (zbar_scanner_t *scanner,
//                                                    unsigned char *rgb)
//{
//    return(zbar_scan_y(scanner, rgb[0] + rgb[1] + rgb[2]));
//}

(** retrieve last scanned width. *)
function zbar_scanner_get_width(const scanner: Pzbar_scanner_t): Word;
  cdecl; external libzbar name _PU + 'zbar_scanner_get_width';

(** retrieve sample position of last edge.
 * @since 0.10
 *)
function zbar_scanner_get_edge(const scn: Pzbar_scanner_t;
                                      offset: Word;
                                      prec: Integer): Word;
  cdecl; external libzbar name _PU + 'zbar_scanner_get_edge';

(** retrieve last scanned color. *)
function zbar_scanner_get_color(const scanner: zbar_scanner_t): zbar_color_t;
  cdecl; external libzbar name _PU + 'zbar_scanner_get_color';

(*@}*)

//#ifdef __cplusplus
//    }
//}
//
//# include "zbar/Exception.h"
//# include "zbar/Decoder.h"
//# include "zbar/Scanner.h"
//# include "zbar/Symbol.h"
//# include "zbar/Image.h"
//# include "zbar/ImageScanner.h"
//# include "zbar/Video.h"
//# include "zbar/Window.h"
//# include "zbar/Processor.h"
//#endif
//
//#endif


implementation

end.
