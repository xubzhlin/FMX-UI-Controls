unit Posix.ffmpeg.libavutil.fifo;

(*
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

(**
 * @file
 * a very simple circular buffer FIFO implementation
 *)

interface

uses
  Linker.Helper, Posix.ffmpeg.consts;

type
  Tfunc = procedure(P1: Pointer; P2: Pointer; P3: Integer); cdecl;
  Tfunc1 = function(P1: Pointer; P2: Pointer; P3: Integer): Integer; cdecl;

  PPAVFifoBuffer = ^PAVFifoBuffer;
  PAVFifoBuffer = ^AVFifoBuffer;
  AVFifoBuffer = record
    buffer: PByte;
    rptr: PByte;
    wptr: PByte;
    &end: PByte;
    rndx: Cardinal;
    wndx: Cardinal;
  end;


(**
 * Initialize an AVFifoBuffer.
 * @param size of FIFO
 * @return AVFifoBuffer or NULL in case of memory allocation failure
 *)
function av_fifo_alloc(size: Cardinal): PAVFifoBuffer; cdecl; external libavutil name _PU + 'av_fifo_alloc';


(**
 * Initialize an AVFifoBuffer.
 * @param nmemb number of elements
 * @param size  size of the single element
 * @return AVFifoBuffer or NULL in case of memory allocation failure
 *)
function av_fifo_alloc_array(nmemb: NativeInt; size: NativeInt): PAVFifoBuffer; cdecl; external libavutil name _PU + 'av_fifo_alloc_array';

(**
 * Free an AVFifoBuffer.
 * @param f AVFifoBuffer to free
 *)
procedure av_fifo_free(var f: AVFifoBuffer); cdecl; external libavutil name _PU + 'av_fifo_free';

(**
 * Free an AVFifoBuffer and reset pointer to NULL.
 * @param f AVFifoBuffer to free
 *)
procedure av_fifo_freep(var f: AVFifoBuffer); cdecl; external libavutil name _PU + 'av_fifo_freep';


(**
 * Reset the AVFifoBuffer to the state right after av_fifo_alloc, in particular it is emptied.
 * @param f AVFifoBuffer to reset
 *)
procedure av_fifo_reset(var f: AVFifoBuffer); cdecl; external libavutil name _PU + 'av_fifo_reset';

(**
 * Return the amount of data in bytes in the AVFifoBuffer, that is the
 * amount of data you can read from it.
 * @param f AVFifoBuffer to read from
 * @return size
 *)
function av_fifo_size(const f: PAVFifoBuffer): Integer; cdecl; external libavutil name _PU + 'av_fifo_size';

(**
 * Return the amount of space in bytes in the AVFifoBuffer, that is the
 * amount of data you can write into it.
 * @param f AVFifoBuffer to write into
 * @return size
 *)
function av_fifo_space(const f: PAVFifoBuffer): Integer; cdecl; external libavutil name _PU + 'av_fifo_space';

(**
 * Feed data at specific position from an AVFifoBuffer to a user-supplied callback.
 * Similar as av_fifo_gereric_read but without discarding data.
 * @param f AVFifoBuffer to read from
 * @param offset offset from current read position
 * @param buf_size number of bytes to read
 * @param func generic read function
 * @param dest data destination
 *)
function av_fifo_generic_peek_at(const f: PAVFifoBuffer; var dest:Pointer; offset: Integer; buf_size: Integer; func: Tfunc): Integer; cdecl; external libavutil name _PU + 'av_fifo_generic_peek_at';


(**
 * Feed data from an AVFifoBuffer to a user-supplied callback.
 * Similar as av_fifo_gereric_read but without discarding data.
 * @param f AVFifoBuffer to read from
 * @param buf_size number of bytes to read
 * @param func generic read function
 * @param dest data destination
 *)
function av_fifo_generic_peek(var f: AVFifoBuffer; var dest:Pointer; buf_size: Integer; func: Tfunc): Integer; cdecl; external libavutil name _PU + 'av_fifo_generic_peek';

(**
 * Feed data from an AVFifoBuffer to a user-supplied callback.
 * @param f AVFifoBuffer to read from
 * @param buf_size number of bytes to read
 * @param func generic read function
 * @param dest data destination
 *)
function av_fifo_generic_read(var f: AVFifoBuffer; var dest:Pointer; buf_size: Integer; func: Tfunc): Integer; cdecl; external libavutil name _PU + 'av_fifo_generic_read';

(**
 * Feed data from a user-supplied callback to an AVFifoBuffer.
 * @param f AVFifoBuffer to write to
 * @param src data source; non-const since it may be used as a
 * modifiable context by the function defined in func
 * @param size number of bytes to write
 * @param func generic write function; the first parameter is src,
 * the second is dest_buf, the third is dest_buf_size.
 * func must return the number of bytes written to dest_buf, or <= 0 to
 * indicate no more data available to write.
 * If func is NULL, src is interpreted as a simple byte array for source data.
 * @return the number of bytes written to the FIFO
 *)
function av_fifo_generic_write(var f: AVFifoBuffer; var src:Pointer; size: Integer; func: Tfunc1): Integer; cdecl; external libavutil name _PU + 'av_fifo_generic_write';

(**
 * Resize an AVFifoBuffer.
 * In case of reallocation failure, the old FIFO is kept unchanged.
 *
 * @param f AVFifoBuffer to resize
 * @param size new AVFifoBuffer size in bytes
 * @return <0 for failure, >=0 otherwise
 *)
function av_fifo_realloc2(var f: AVFifoBuffer; size: Cardinal): Integer; cdecl; external libavutil name _PU + 'av_fifo_realloc2';

(**
 * Enlarge an AVFifoBuffer.
 * In case of reallocation failure, the old FIFO is kept unchanged.
 * The new fifo size may be larger than the requested size.
 *
 * @param f AVFifoBuffer to resize
 * @param additional_space the amount of space in bytes to allocate in addition to av_fifo_size()
 * @return <0 for failure, >=0 otherwise
 *)
function av_fifo_grow(var f: AVFifoBuffer; additional_space: Cardinal): Integer; cdecl; external libavutil name _PU + 'av_fifo_grow';

(**
 * Read and discard the specified amount of data from an AVFifoBuffer.
 * @param f AVFifoBuffer to read from
 * @param size amount of data to read in bytes
 *)
procedure av_fifo_drain(var f: AVFifoBuffer; size: Cardinal); cdecl; external libavutil name _PU + 'av_fifo_drain';


implementation

end.
