unit Posix.ffmpeg.libavutil.aes_ctr;

interface

uses
  Linker.Helper, Posix.ffmpeg.consts, Posix.ffmpeg.libavutil.aes_internal;

const
  AES_BLOCK_SIZE = 16;
  AES_CTR_KEY_SIZE = 16;
  AES_CTR_IV_SIZE = 8;


type
  PAVAESCTR = ^AVAESCTR;
  AVAESCTR = record
    aes: PAVAES;
    counter: array[0..AES_BLOCK_SIZE-1] of Byte;
    encrypted_counter: array[0..AES_BLOCK_SIZE-1] of Byte;
    block_offset: Integer;
  end;

(**
 * Allocate an AVAESCTR context.
 *)
function av_aes_ctr_alloc: PAVAESCTR; cdecl; external libavutil name _PU + 'av_aes_ctr_alloc';

(**
 * Initialize an AVAESCTR context.
 * @param key encryption key, must have a length of AES_CTR_KEY_SIZE
 *)
function av_aes_ctr_init(var a: AVAESCTR; key: PByte): Integer; cdecl; external libavutil name _PU + 'av_aes_ctr_init';

(**
 * Release an AVAESCTR context.
 *)
procedure av_aes_ctr_free(var a: AVAESCTR); cdecl; external libavutil name _PU + 'av_aes_ctr_free';

(**
 * Process a buffer using a previously initialized context.
 * @param dst destination array, can be equal to src
 * @param src source array, can be equal to dst
 * @param size the size of src and dst
 *)
procedure av_aes_ctr_crypt(var a: AVAESCTR; dst: PByte; src: PByte; size: Integer); cdecl; external libavutil name _PU + 'av_aes_ctr_crypt';

(**
 * Get the current iv
 *)
function av_aes_ctr_get_iv(var a: AVAESCTR):PByte; cdecl; external libavutil name _PU + 'av_aes_ctr_get_iv';

(**
 * Generate a random iv
 *)
procedure av_aes_ctr_set_random_iv(var a: AVAESCTR); cdecl; external libavutil name _PU + 'av_aes_ctr_set_random_iv';

(**
 * Forcefully change the 8-byte iv
 *)
procedure av_aes_ctr_set_iv(var a: AVAESCTR; iv: PByte); cdecl; external libavutil name _PU + 'av_aes_ctr_set_iv';

(**
 * Forcefully change the "full" 16-byte iv, including the counter
 *)
procedure av_aes_ctr_set_full_iv(var a: AVAESCTR; iv: PByte); cdecl; external libavutil name _PU + 'av_aes_ctr_set_full_iv';

(**
 * Increment the top 64 bit of the iv (performed after each frame)
 *)
procedure av_aes_ctr_increment_iv(var a: AVAESCTR); cdecl; external libavutil name _PU + 'av_aes_ctr_increment_iv';


implementation

end.
