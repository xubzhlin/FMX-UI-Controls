unit Posix.ffmpeg.libavutil.buffer_internal;

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

interface

const
  (**
   * The buffer is always treated as read-only.
   *)
  BUFFERFLAG_READONLY = 1 shl 0;
  (**
   * The buffer was av_realloc()ed, so it is reallocatable.
   *)
  BUFFER_FLAG_REALLOCATABLE = 1 shl 1;

type
  TFreeCallback = procedure(opaque: Pointer; data: PByte);

  PAVBuffer = ^AVBuffer;
  AVBuffer = packed record
    data: PByte;   //**< data described by this buffer */
    size: Integer; //**< size of data in bytes */
    (**
     *  number of existing AVBufferRef instances referring to this buffer
     *)
    refcount: Integer;

    (**
     * a callback for freeing the data
     *)
    free: TFreeCallback;

    (**
     * an opaque pointer, to be used by the freeing callback
     *)
    opaque: Pointer;

    (**
     * A combination of BUFFER_FLAG_*
     *)
    flag: Integer;
  end;

  (**
   * A reference counted buffer type. It is opaque and is meant to be used through
   * references (AVBufferRef).
   *)
  PAVBufferRef = ^AVBufferRef;
  AVBufferRef = packed record
    buffer: PAVBuffer;
    (**
     * The data buffer. It is considered writable if and only if
     * this is the only reference to the buffer, in which case
     * av_buffer_is_writable() returns 1.
     *)
    data: PByte;
    (**
     * Size of data in bytes.
     *)
    size: Integer;
 end;


  TallocCallback   = function(size: Integer): PAVBufferRef  of object;
  Talloc2Callback = function(opaque: Pointer; data: PByte): PAVBufferRef  of object;
  Tpool_freeCallback = procedure(opaque: Pointer) of object;

  PAVBufferPool = ^AVBufferPool;
  PBufferPoolEntry = ^BufferPoolEntry;
  BufferPoolEntry = packed record
    data: PByte;

    (*
     * Backups of the original opaque/free of the AVBuffer corresponding to
     * data. They will be used to free the buffer when the pool is freed.
     *)
    opaque: Pointer;
    free: TFreeCallback;

    pool: PAVBufferPool;
    next: PBufferPoolEntry;
  end;

  AVMutex = packed record

  end;

  AVBufferPool = packed record
    mutex: AVMutex;
    pool: PBufferPoolEntry;

    (*
     * This is used to track when the pool is to be freed.
     * The pointer to the pool itself held by the caller is considered to
     * be one reference. Each buffer requested by the caller increases refcount
     * by one, returning the buffer to the pool decreases it by one.
     * refcount reaches zero when the buffer has been uninited AND all the
     * buffers have been released, then it's safe to free the pool and all
     * the buffers in it.
     *)
    refcount: Cardinal;

    size: Integer ;
    opaque: Pointer;
    alloc: TallocCallback;
    alloc2: Talloc2Callback;
    pool_free: Tpool_freeCallback;
  end;

implementation

end.
