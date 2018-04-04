local ffi = require("ffi")


--[[
 * Copyright (c) 2016-present, Yann Collet, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under both the BSD-style license (found in the
 * LICENSE file in the root directory of this source tree) and the GPLv2 (found
 * in the COPYING file in the root directory of this source tree).
 * You may select, at your option, one of the above-listed licenses.
--]]

local bit = require("bit")
local bor = bit.bor;
local band = bit.band;
local rshift = bit.rshift;
local lshift = bit.lshift;

ZSTD_H_235446 = true;

ffi.cdef[[
static const int ZSTD_VERSION_MAJOR    = 1;
static const int ZSTD_VERSION_MINOR    = 3;
static const int ZSTD_VERSION_RELEASE  = 4;
]]

ffi.cdef[[
static const int ZSTD_VERSION_NUMBER  = (ZSTD_VERSION_MAJOR *100*100 + ZSTD_VERSION_MINOR *100 + ZSTD_VERSION_RELEASE);
static const unsigned int ZSTD_versionNumber(void);
]]

--[[
#define ZSTD_LIB_VERSION ZSTD_VERSION_MAJOR.ZSTD_VERSION_MINOR.ZSTD_VERSION_RELEASE
#define ZSTD_QUOTE(str) #str
#define ZSTD_EXPAND_AND_QUOTE(str) ZSTD_QUOTE(str)
#define ZSTD_VERSION_STRING ZSTD_EXPAND_AND_QUOTE(ZSTD_LIB_VERSION)
--]]

ffi.cdef[[
const char* ZSTD_versionString(void);   // added in v1.3.0 
]]

--[[
/***************************************
*  Simple API
***************************************/
--]]

ffi.cdef[[
 size_t ZSTD_compress( void* dst, size_t dstCapacity,
                            const void* src, size_t srcSize,
                                  int compressionLevel);
]]


ffi.cdef[[
  size_t ZSTD_decompress( void* dst, size_t dstCapacity,
                              const void* src, size_t compressedSize);
]]


--[=[
ffi.cdef[[
#define ZSTD_CONTENTSIZE_UNKNOWN (0ULL - 1)
#define ZSTD_CONTENTSIZE_ERROR   (0ULL - 2)
unsigned long long ZSTD_getFrameContentSize(const void *src, size_t srcSize);
]]
--]=]

--[[! ZSTD_getDecompressedSize() :
 *  NOTE: This function is now obsolete, in favor of ZSTD_getFrameContentSize().
 *  Both functions work the same way, but ZSTD_getDecompressedSize() blends
 *  "empty", "unknown" and "error" results to the same return value (0),
 *  while ZSTD_getFrameContentSize() gives them separate return values.
 * `src` is the start of a zstd compressed frame.
 * @return : content size to be decompressed, as a 64-bits value _if known and not empty_, 0 otherwise. --]]
--unsigned long long ZSTD_getDecompressedSize(const void* src, size_t srcSize);


--======  Helper functions  ======*/
-- margin, from 64 to 0
-- this formula ensures that bound(A) + bound(B) <= bound(A+B) as long as A and B >= 128 KB
--local function ZSTD_COMPRESSBOUND(srcSize)   
--  return ((srcSize) + ((srcSize)>>8) + (((srcSize) < (128<<10)) ? (((128<<10) - (srcSize)) >> 11)  : 0))  
--end

ffi.cdef[[
size_t      ZSTD_compressBound(size_t srcSize); 
unsigned    ZSTD_isError(size_t code);          
const char* ZSTD_getErrorName(size_t code);     
int         ZSTD_maxCLevel(void);               
]]



ffi.cdef[[
typedef struct ZSTD_CCtx_s ZSTD_CCtx;
ZSTD_CCtx* ZSTD_createCCtx(void);
size_t     ZSTD_freeCCtx(ZSTD_CCtx* cctx);


size_t ZSTD_compressCCtx(ZSTD_CCtx* ctx,
                                     void* dst, size_t dstCapacity,
                               const void* src, size_t srcSize,
                                     int compressionLevel);


typedef struct ZSTD_DCtx_s ZSTD_DCtx;
ZSTD_DCtx* ZSTD_createDCtx(void);
size_t     ZSTD_freeDCtx(ZSTD_DCtx* dctx);


size_t ZSTD_decompressDCtx(ZSTD_DCtx* ctx,
                                       void* dst, size_t dstCapacity,
                                 const void* src, size_t srcSize);
]]



ffi.cdef[[
size_t ZSTD_compress_usingDict(ZSTD_CCtx* ctx,
                                           void* dst, size_t dstCapacity,
                                     const void* src, size_t srcSize,
                                     const void* dict,size_t dictSize,
                                           int compressionLevel);


size_t ZSTD_decompress_usingDict(ZSTD_DCtx* dctx,
                                             void* dst, size_t dstCapacity,
                                       const void* src, size_t srcSize,
                                       const void* dict,size_t dictSize);
]]


ffi.cdef[[
typedef struct ZSTD_CDict_s ZSTD_CDict;


ZSTD_CDict* ZSTD_createCDict(const void* dictBuffer, size_t dictSize,
                                         int compressionLevel);


size_t      ZSTD_freeCDict(ZSTD_CDict* CDict);


size_t ZSTD_compress_usingCDict(ZSTD_CCtx* cctx,
                                            void* dst, size_t dstCapacity,
                                      const void* src, size_t srcSize,
                                      const ZSTD_CDict* cdict);


typedef struct ZSTD_DDict_s ZSTD_DDict;


ZSTD_DDict* ZSTD_createDDict(const void* dictBuffer, size_t dictSize);


size_t      ZSTD_freeDDict(ZSTD_DDict* ddict);


size_t ZSTD_decompress_usingDDict(ZSTD_DCtx* dctx,
                                              void* dst, size_t dstCapacity,
                                        const void* src, size_t srcSize,
                                        const ZSTD_DDict* ddict);
]]



ffi.cdef[[
typedef struct ZSTD_inBuffer_s {
  const void* src;    //*< start of input buffer
  size_t size;        //*< size of input buffer
  size_t pos;         //*< position where reading stopped. Will be updated. Necessarily 0 <= pos <= size
} ZSTD_inBuffer;

typedef struct ZSTD_outBuffer_s {
  void*  dst;         //*< start of output buffer
  size_t size;        //*< size of output buffer
  size_t pos;         //*< position where writing stopped. Will be updated. Necessarily 0 <= pos <= size
} ZSTD_outBuffer;
]]




ffi.cdef[[
//*< CCtx and CStream are now effectively same object (>= v1.3.0)
// Continue to distinguish them for compatibility with versions <= v1.2.0
typedef ZSTD_CCtx ZSTD_CStream;  
                                 
//===== ZSTD_CStream management functions =====
ZSTD_CStream* ZSTD_createCStream(void);
size_t ZSTD_freeCStream(ZSTD_CStream* zcs);

//===== Streaming compression functions =====
size_t ZSTD_initCStream(ZSTD_CStream* zcs, int compressionLevel);
size_t ZSTD_compressStream(ZSTD_CStream* zcs, ZSTD_outBuffer* output, ZSTD_inBuffer* input);
size_t ZSTD_flushStream(ZSTD_CStream* zcs, ZSTD_outBuffer* output);
size_t ZSTD_endStream(ZSTD_CStream* zcs, ZSTD_outBuffer* output);

//*< recommended size for input buffer
size_t ZSTD_CStreamInSize(void);    
//*< recommended size for output buffer. Guarantee to successfully flush at least one complete compressed block in all circumstances.
size_t ZSTD_CStreamOutSize(void);   
]]



ffi.cdef[[
typedef ZSTD_DCtx ZSTD_DStream;  
                                 
ZSTD_DStream* ZSTD_createDStream(void);
size_t ZSTD_freeDStream(ZSTD_DStream* zds);

size_t ZSTD_initDStream(ZSTD_DStream* zds);
size_t ZSTD_decompressStream(ZSTD_DStream* zds, ZSTD_outBuffer* output, ZSTD_inBuffer* input);

size_t ZSTD_DStreamInSize(void);    
size_t ZSTD_DStreamOutSize(void);
]]




--[[
  /****************************************************************************************
 * START OF ADVANCED AND EXPERIMENTAL FUNCTIONS
 * The definitions in this section are considered experimental.
 * They should never be used with a dynamic library, as prototypes may change in the future.
 * They are provided for advanced scenarios.
 * Use them only in association with static linking.
 * ***************************************************************************************/
--]]
 --[=[
#if defined(ZSTD_STATIC_LINKING_ONLY) && !defined(ZSTD_H_ZSTD_STATIC_LINKING_ONLY)
#define ZSTD_H_ZSTD_STATIC_LINKING_ONLY

/* --- Constants ---*/
#define ZSTD_MAGICNUMBER            0xFD2FB528   /* >= v0.8.0 */
#define ZSTD_MAGIC_SKIPPABLE_START  0x184D2A50U
#define ZSTD_MAGIC_DICTIONARY       0xEC30A437   /* >= v0.7.0 */

#define ZSTD_WINDOWLOG_MAX_32   30
#define ZSTD_WINDOWLOG_MAX_64   31
#define ZSTD_WINDOWLOG_MAX    ((unsigned)(sizeof(size_t) == 4 ? ZSTD_WINDOWLOG_MAX_32 : ZSTD_WINDOWLOG_MAX_64))
#define ZSTD_WINDOWLOG_MIN      10
#define ZSTD_HASHLOG_MAX      ((ZSTD_WINDOWLOG_MAX < 30) ? ZSTD_WINDOWLOG_MAX : 30)
#define ZSTD_HASHLOG_MIN         6
#define ZSTD_CHAINLOG_MAX_32    29
#define ZSTD_CHAINLOG_MAX_64    30
#define ZSTD_CHAINLOG_MAX     ((unsigned)(sizeof(size_t) == 4 ? ZSTD_CHAINLOG_MAX_32 : ZSTD_CHAINLOG_MAX_64))
#define ZSTD_CHAINLOG_MIN       ZSTD_HASHLOG_MIN
#define ZSTD_HASHLOG3_MAX       17
#define ZSTD_SEARCHLOG_MAX     (ZSTD_WINDOWLOG_MAX-1)
#define ZSTD_SEARCHLOG_MIN       1
#define ZSTD_SEARCHLENGTH_MAX    7   /* only for ZSTD_fast, other strategies are limited to 6 */
#define ZSTD_SEARCHLENGTH_MIN    3   /* only for ZSTD_btopt, other strategies are limited to 4 */
#define ZSTD_TARGETLENGTH_MIN    1   /* only used by btopt, btultra and btfast */
#define ZSTD_LDM_MINMATCH_MIN    4
#define ZSTD_LDM_MINMATCH_MAX 4096
#define ZSTD_LDM_BUCKETSIZELOG_MAX 8

#define ZSTD_FRAMEHEADERSIZE_PREFIX 5   /* minimum input size to know frame header size */
#define ZSTD_FRAMEHEADERSIZE_MIN    6
#define ZSTD_FRAMEHEADERSIZE_MAX   18   /* for static allocation */
static const size_t ZSTD_frameHeaderSize_prefix = ZSTD_FRAMEHEADERSIZE_PREFIX;
static const size_t ZSTD_frameHeaderSize_min = ZSTD_FRAMEHEADERSIZE_MIN;
static const size_t ZSTD_frameHeaderSize_max = ZSTD_FRAMEHEADERSIZE_MAX;
static const size_t ZSTD_skippableHeaderSize = 8;  /* magic number + skippable frame length */
]=]


ffi.cdef[[
typedef enum { 
  ZSTD_fast=1, 
  ZSTD_dfast, 
  ZSTD_greedy, 
  ZSTD_lazy, 
  ZSTD_lazy2,
  ZSTD_btlazy2, 
  ZSTD_btopt, 
  ZSTD_btultra 
} ZSTD_strategy;

typedef struct {
    unsigned windowLog;      //*< largest match distance : larger == more compression, more memory needed during decompression 
    unsigned chainLog;       //*< fully searched segment : larger == more compression, slower, more memory (useless for fast) 
    unsigned hashLog;        //*< dispatch table : larger == faster, more memory 
    unsigned searchLog;      //*< nb of searches : larger == more compression, slower 
    unsigned searchLength;   //*< match length searched : larger == faster decompression, sometimes less compression 
    unsigned targetLength;   //*< acceptable match size for optimal parser (only) : larger == more compression, slower 
    ZSTD_strategy strategy;
} ZSTD_compressionParameters;

typedef struct {
    unsigned contentSizeFlag; //*< 1: content size will be in frame header (when known) 
    unsigned checksumFlag;    //*< 1: generate a 32-bits checksum at end of frame, for error detection 
    unsigned noDictIDFlag;    //*< 1: no dictID will be saved into frame header (if dictionary compression) 
} ZSTD_frameParameters;

typedef struct {
    ZSTD_compressionParameters cParams;
    ZSTD_frameParameters fParams;
} ZSTD_parameters;

typedef struct ZSTD_CCtx_params_s ZSTD_CCtx_params;

typedef enum {
    ZSTD_dct_auto=0,      
    ZSTD_dct_rawContent,  
    ZSTD_dct_fullDict     
} ZSTD_dictContentType_e;

typedef enum {
    ZSTD_dlm_byCopy = 0, 
    ZSTD_dlm_byRef,      
} ZSTD_dictLoadMethod_e;
]]



ffi.cdef[[
size_t ZSTD_findFrameCompressedSize(const void* src, size_t srcSize);

unsigned long long ZSTD_findDecompressedSize(const void* src, size_t srcSize);

size_t ZSTD_frameHeaderSize(const void* src, size_t srcSize);
]]




ffi.cdef[[
size_t ZSTD_sizeof_CCtx(const ZSTD_CCtx* cctx);
size_t ZSTD_sizeof_DCtx(const ZSTD_DCtx* dctx);
size_t ZSTD_sizeof_CStream(const ZSTD_CStream* zcs);
size_t ZSTD_sizeof_DStream(const ZSTD_DStream* zds);
size_t ZSTD_sizeof_CDict(const ZSTD_CDict* cdict);
size_t ZSTD_sizeof_DDict(const ZSTD_DDict* ddict);
]]

ffi.cdef[[
size_t ZSTD_estimateCCtxSize(int compressionLevel);
size_t ZSTD_estimateCCtxSize_usingCParams(ZSTD_compressionParameters cParams);
size_t ZSTD_estimateCCtxSize_usingCCtxParams(const ZSTD_CCtx_params* params);
size_t ZSTD_estimateDCtxSize(void);
]]

ffi.cdef[[
size_t ZSTD_estimateCStreamSize(int compressionLevel);
size_t ZSTD_estimateCStreamSize_usingCParams(ZSTD_compressionParameters cParams);
size_t ZSTD_estimateCStreamSize_usingCCtxParams(const ZSTD_CCtx_params* params);
size_t ZSTD_estimateDStreamSize(size_t windowSize);
size_t ZSTD_estimateDStreamSize_fromFrame(const void* src, size_t srcSize);
]]

ffi.cdef[[
size_t ZSTD_estimateCDictSize(size_t dictSize, int compressionLevel);
size_t ZSTD_estimateCDictSize_advanced(size_t dictSize, ZSTD_compressionParameters cParams, ZSTD_dictLoadMethod_e dictLoadMethod);
size_t ZSTD_estimateDDictSize(size_t dictSize, ZSTD_dictLoadMethod_e dictLoadMethod);
]]


ffi.cdef[[
ZSTD_CCtx*    ZSTD_initStaticCCtx(void* workspace, size_t workspaceSize);
ZSTD_CStream* ZSTD_initStaticCStream(void* workspace, size_t workspaceSize);    

ZSTD_DCtx*    ZSTD_initStaticDCtx(void* workspace, size_t workspaceSize);
ZSTD_DStream* ZSTD_initStaticDStream(void* workspace, size_t workspaceSize);    

const ZSTD_CDict* ZSTD_initStaticCDict(
                                        void* workspace, size_t workspaceSize,
                                        const void* dict, size_t dictSize,
                                        ZSTD_dictLoadMethod_e dictLoadMethod,
                                        ZSTD_dictContentType_e dictContentType,
                                        ZSTD_compressionParameters cParams);

const ZSTD_DDict* ZSTD_initStaticDDict(
                                        void* workspace, size_t workspaceSize,
                                        const void* dict, size_t dictSize,
                                        ZSTD_dictLoadMethod_e dictLoadMethod,
                                        ZSTD_dictContentType_e dictContentType);
]]


ffi.cdef[[
typedef void* (*ZSTD_allocFunction) (void* opaque, size_t size);
typedef void  (*ZSTD_freeFunction) (void* opaque, void* address);
typedef struct { ZSTD_allocFunction customAlloc; ZSTD_freeFunction customFree; void* opaque; } ZSTD_customMem;
//static ZSTD_customMem const ZSTD_defaultCMem = { NULL, NULL, NULL };
]]

ffi.cdef[[
ZSTD_CCtx*    ZSTD_createCCtx_advanced(ZSTD_customMem customMem);
ZSTD_CStream* ZSTD_createCStream_advanced(ZSTD_customMem customMem);
ZSTD_DCtx*    ZSTD_createDCtx_advanced(ZSTD_customMem customMem);
ZSTD_DStream* ZSTD_createDStream_advanced(ZSTD_customMem customMem);

ZSTD_CDict* ZSTD_createCDict_advanced(const void* dict, size_t dictSize,
                                                  ZSTD_dictLoadMethod_e dictLoadMethod,
                                                  ZSTD_dictContentType_e dictContentType,
                                                  ZSTD_compressionParameters cParams,
                                                  ZSTD_customMem customMem);

ZSTD_DDict* ZSTD_createDDict_advanced(const void* dict, size_t dictSize,
                                                  ZSTD_dictLoadMethod_e dictLoadMethod,
                                                  ZSTD_dictContentType_e dictContentType,
                                                  ZSTD_customMem customMem);
]]




ffi.cdef[[
ZSTD_CDict* ZSTD_createCDict_byReference(const void* dictBuffer, size_t dictSize, int compressionLevel);

ZSTD_compressionParameters ZSTD_getCParams(int compressionLevel, unsigned long long estimatedSrcSize, size_t dictSize);

ZSTD_parameters ZSTD_getParams(int compressionLevel, unsigned long long estimatedSrcSize, size_t dictSize);

size_t ZSTD_checkCParams(ZSTD_compressionParameters params);

ZSTD_compressionParameters ZSTD_adjustCParams(ZSTD_compressionParameters cPar, unsigned long long srcSize, size_t dictSize);

size_t ZSTD_compress_advanced (ZSTD_CCtx* cctx,
                                  void* dst, size_t dstCapacity,
                            const void* src, size_t srcSize,
                            const void* dict,size_t dictSize,
                                  ZSTD_parameters params);

size_t ZSTD_compress_usingCDict_advanced(ZSTD_CCtx* cctx,
                                  void* dst, size_t dstCapacity,
                            const void* src, size_t srcSize,
                            const ZSTD_CDict* cdict, ZSTD_frameParameters fParams);
]]



ffi.cdef[[
unsigned ZSTD_isFrame(const void* buffer, size_t size);

ZSTD_DDict* ZSTD_createDDict_byReference(const void* dictBuffer, size_t dictSize);

unsigned ZSTD_getDictID_fromDict(const void* dict, size_t dictSize);

unsigned ZSTD_getDictID_fromDDict(const ZSTD_DDict* ddict);

unsigned ZSTD_getDictID_fromFrame(const void* src, size_t srcSize);
]]


ffi.cdef[[
/*=====   Advanced Streaming compression functions  =====*/
size_t ZSTD_initCStream_srcSize(ZSTD_CStream* zcs, int compressionLevel, unsigned long long pledgedSrcSize);   /**< pledgedSrcSize must be correct. If it is not known at init time, use ZSTD_CONTENTSIZE_UNKNOWN. Note that, for compatibility with older programs, "0" also disables frame content size field. It may be enabled in the future. */
size_t ZSTD_initCStream_usingDict(ZSTD_CStream* zcs, const void* dict, size_t dictSize, int compressionLevel); /**< creates of an internal CDict (incompatible with static CCtx), except if dict == NULL or dictSize < 8, in which case no dict is used. Note: dict is loaded with ZSTD_dm_auto (treated as a full zstd dictionary if it begins with ZSTD_MAGIC_DICTIONARY, else as raw content) and ZSTD_dlm_byCopy.*/
size_t ZSTD_initCStream_advanced(ZSTD_CStream* zcs, const void* dict, size_t dictSize,
                                             ZSTD_parameters params, unsigned long long pledgedSrcSize);  /**< pledgedSrcSize must be correct. If srcSize is not known at init time, use value ZSTD_CONTENTSIZE_UNKNOWN. dict is loaded with ZSTD_dm_auto and ZSTD_dlm_byCopy. */
size_t ZSTD_initCStream_usingCDict(ZSTD_CStream* zcs, const ZSTD_CDict* cdict);  /**< note : cdict will just be referenced, and must outlive compression session */
size_t ZSTD_initCStream_usingCDict_advanced(ZSTD_CStream* zcs, const ZSTD_CDict* cdict, ZSTD_frameParameters fParams, unsigned long long pledgedSrcSize);  /**< same as ZSTD_initCStream_usingCDict(), with control over frame parameters. pledgedSrcSize must be correct. If srcSize is not known at init time, use value ZSTD_CONTENTSIZE_UNKNOWN. */


size_t ZSTD_resetCStream(ZSTD_CStream* zcs, unsigned long long pledgedSrcSize);
]]

ffi.cdef[[
typedef struct {
    unsigned long long ingested;
    unsigned long long consumed;
    unsigned long long produced;
} ZSTD_frameProgression;


ZSTD_frameProgression ZSTD_getFrameProgression(const ZSTD_CCtx* cctx);
]]


ffi.cdef[[
/*=====   Advanced Streaming decompression functions  =====*/
typedef enum { DStream_p_maxWindowSize } ZSTD_DStreamParameter_e;
size_t ZSTD_setDStreamParameter(ZSTD_DStream* zds, ZSTD_DStreamParameter_e paramType, unsigned paramValue);   /* obsolete : this API will be removed in a future version */
size_t ZSTD_initDStream_usingDict(ZSTD_DStream* zds, const void* dict, size_t dictSize); /**< note: no dictionary will be used if dict == NULL or dictSize < 8 */
size_t ZSTD_initDStream_usingDDict(ZSTD_DStream* zds, const ZSTD_DDict* ddict);  /**< note : ddict is referenced, it must outlive decompression session */
size_t ZSTD_resetDStream(ZSTD_DStream* zds);  /**< re-use decompression parameters from previous init; saves dictionary loading */
]]


ffi.cdef[[
/*=====   Buffer-less streaming compression functions  =====*/
size_t ZSTD_compressBegin(ZSTD_CCtx* cctx, int compressionLevel);
size_t ZSTD_compressBegin_usingDict(ZSTD_CCtx* cctx, const void* dict, size_t dictSize, int compressionLevel);
size_t ZSTD_compressBegin_advanced(ZSTD_CCtx* cctx, const void* dict, size_t dictSize, ZSTD_parameters params, unsigned long long pledgedSrcSize); /**< pledgedSrcSize : If srcSize is not known at init time, use ZSTD_CONTENTSIZE_UNKNOWN */
size_t ZSTD_compressBegin_usingCDict(ZSTD_CCtx* cctx, const ZSTD_CDict* cdict); /**< note: fails if cdict==NULL */
size_t ZSTD_compressBegin_usingCDict_advanced(ZSTD_CCtx* const cctx, const ZSTD_CDict* const cdict, ZSTD_frameParameters const fParams, unsigned long long const pledgedSrcSize);   /* compression parameters are already set within cdict. pledgedSrcSize must be correct. If srcSize is not known, use macro ZSTD_CONTENTSIZE_UNKNOWN */
size_t ZSTD_copyCCtx(ZSTD_CCtx* cctx, const ZSTD_CCtx* preparedCCtx, unsigned long long pledgedSrcSize); /**<  note: if pledgedSrcSize is not known, use ZSTD_CONTENTSIZE_UNKNOWN */

size_t ZSTD_compressContinue(ZSTD_CCtx* cctx, void* dst, size_t dstCapacity, const void* src, size_t srcSize);
size_t ZSTD_compressEnd(ZSTD_CCtx* cctx, void* dst, size_t dstCapacity, const void* src, size_t srcSize);
]]


ffi.cdef[[
/*=====   Buffer-less streaming decompression functions  =====*/
typedef enum { ZSTD_frame, ZSTD_skippableFrame } ZSTD_frameType_e;
typedef struct {
    unsigned long long frameContentSize; /* if == ZSTD_CONTENTSIZE_UNKNOWN, it means this field is not available. 0 means "empty" */
    unsigned long long windowSize;       /* can be very large, up to <= frameContentSize */
    unsigned blockSizeMax;
    ZSTD_frameType_e frameType;          /* if == ZSTD_skippableFrame, frameContentSize is the size of skippable content */
    unsigned headerSize;
    unsigned dictID;
    unsigned checksumFlag;
} ZSTD_frameHeader;
size_t ZSTD_getFrameHeader(ZSTD_frameHeader* zfhPtr, const void* src, size_t srcSize);   /**< doesn't consume input */
size_t ZSTD_decodingBufferSize_min(unsigned long long windowSize, unsigned long long frameContentSize);  /**< when frame content size is not known, pass in frameContentSize == ZSTD_CONTENTSIZE_UNKNOWN */

size_t ZSTD_decompressBegin(ZSTD_DCtx* dctx);
size_t ZSTD_decompressBegin_usingDict(ZSTD_DCtx* dctx, const void* dict, size_t dictSize);
size_t ZSTD_decompressBegin_usingDDict(ZSTD_DCtx* dctx, const ZSTD_DDict* ddict);

size_t ZSTD_nextSrcSizeToDecompress(ZSTD_DCtx* dctx);
size_t ZSTD_decompressContinue(ZSTD_DCtx* dctx, void* dst, size_t dstCapacity, const void* src, size_t srcSize);

/* misc */
void   ZSTD_copyDCtx(ZSTD_DCtx* dctx, const ZSTD_DCtx* preparedDCtx);
typedef enum { ZSTDnit_frameHeader, ZSTDnit_blockHeader, ZSTDnit_block, ZSTDnit_lastBlock, ZSTDnit_checksum, ZSTDnit_skippableFrame } ZSTD_nextInputType_e;
ZSTD_nextInputType_e ZSTD_nextInputType(ZSTD_DCtx* dctx);
]]


ffi.cdef[[
/* ============================================ */
/**       New advanced API (experimental)       */
/* ============================================ */

typedef enum {
    ZSTD_f_zstd1 = 0,        
    ZSTD_f_zstd1_magicless,  
} ZSTD_format_e;

typedef enum {
    ZSTD_p_format = 10,     

    /* compression parameters */
    ZSTD_p_compressionLevel=100, 
    ZSTD_p_windowLog,        
    ZSTD_p_hashLog,          
    ZSTD_p_chainLog,         
    ZSTD_p_searchLog,        
    ZSTD_p_minMatch,         
    ZSTD_p_targetLength,     
    ZSTD_p_compressionStrategy, 

    ZSTD_p_enableLongDistanceMatching=160, 
    ZSTD_p_ldmHashLog,       
    ZSTD_p_ldmMinMatch,      
    ZSTD_p_ldmBucketSizeLog, 
    ZSTD_p_ldmHashEveryLog,  

    // frame parameters 
    ZSTD_p_contentSizeFlag=200, 
    ZSTD_p_checksumFlag,     
    ZSTD_p_dictIDFlag,       

    
    
    ZSTD_p_nbWorkers=400,    
    ZSTD_p_jobSize,          
    ZSTD_p_overlapSizeLog,   

    // =================================================================== 
    // experimental parameters - no stability guaranteed                   
    // =================================================================== 

    ZSTD_p_compressLiterals=1000, 

    ZSTD_p_forceMaxWindow=1100, 

} ZSTD_cParameter;



size_t ZSTD_CCtx_setParameter(ZSTD_CCtx* cctx, ZSTD_cParameter param, unsigned value);


size_t ZSTD_CCtx_setPledgedSrcSize(ZSTD_CCtx* cctx, unsigned long long pledgedSrcSize);


size_t ZSTD_CCtx_loadDictionary(ZSTD_CCtx* cctx, const void* dict, size_t dictSize);
size_t ZSTD_CCtx_loadDictionary_byReference(ZSTD_CCtx* cctx, const void* dict, size_t dictSize);
size_t ZSTD_CCtx_loadDictionary_advanced(ZSTD_CCtx* cctx, const void* dict, size_t dictSize, ZSTD_dictLoadMethod_e dictLoadMethod, ZSTD_dictContentType_e dictContentType);



size_t ZSTD_CCtx_refCDict(ZSTD_CCtx* cctx, const ZSTD_CDict* cdict);


size_t ZSTD_CCtx_refPrefix(ZSTD_CCtx* cctx, const void* prefix, size_t prefixSize);
size_t ZSTD_CCtx_refPrefix_advanced(ZSTD_CCtx* cctx, const void* prefix, size_t prefixSize, ZSTD_dictContentType_e dictContentType);


void ZSTD_CCtx_reset(ZSTD_CCtx* cctx);
]]

ffi.cdef[[
typedef enum {
    ZSTD_e_continue=0, /* collect more data, encoder decides when to output compressed result, for optimal conditions */
    ZSTD_e_flush,      /* flush any data provided so far - frame will continue, future data can still reference previous data for better compression */
    ZSTD_e_end         /* flush any remaining data and close current frame. Any additional data starts a new frame. */
} ZSTD_EndDirective;


size_t ZSTD_compress_generic (ZSTD_CCtx* cctx,
                                          ZSTD_outBuffer* output,
                                          ZSTD_inBuffer* input,
                                          ZSTD_EndDirective endOp);



size_t ZSTD_compress_generic_simpleArgs (
                            ZSTD_CCtx* cctx,
                            void* dst, size_t dstCapacity, size_t* dstPos,
                      const void* src, size_t srcSize, size_t* srcPos,
                            ZSTD_EndDirective endOp);



ZSTD_CCtx_params* ZSTD_createCCtxParams(void);
size_t ZSTD_freeCCtxParams(ZSTD_CCtx_params* params);



size_t ZSTD_CCtxParams_reset(ZSTD_CCtx_params* params);


size_t ZSTD_CCtxParams_init(ZSTD_CCtx_params* cctxParams, int compressionLevel);


size_t ZSTD_CCtxParams_init_advanced(ZSTD_CCtx_params* cctxParams, ZSTD_parameters params);



size_t ZSTD_CCtxParam_setParameter(ZSTD_CCtx_params* params, ZSTD_cParameter param, unsigned value);


size_t ZSTD_CCtx_setParametersUsingCCtxParams(
        ZSTD_CCtx* cctx, const ZSTD_CCtx_params* params);
]]



ffi.cdef[[

size_t ZSTD_DCtx_loadDictionary(ZSTD_DCtx* dctx, const void* dict, size_t dictSize);
size_t ZSTD_DCtx_loadDictionary_byReference(ZSTD_DCtx* dctx, const void* dict, size_t dictSize);
size_t ZSTD_DCtx_loadDictionary_advanced(ZSTD_DCtx* dctx, const void* dict, size_t dictSize, ZSTD_dictLoadMethod_e dictLoadMethod, ZSTD_dictContentType_e dictContentType);



size_t ZSTD_DCtx_refDDict(ZSTD_DCtx* dctx, const ZSTD_DDict* ddict);



size_t ZSTD_DCtx_refPrefix(ZSTD_DCtx* dctx, const void* prefix, size_t prefixSize);
size_t ZSTD_DCtx_refPrefix_advanced(ZSTD_DCtx* dctx, const void* prefix, size_t prefixSize, ZSTD_dictContentType_e dictContentType);
]]

ffi.cdef[[
size_t ZSTD_DCtx_setMaxWindowSize(ZSTD_DCtx* dctx, size_t maxWindowSize);



size_t ZSTD_DCtx_setFormat(ZSTD_DCtx* dctx, ZSTD_format_e format);



size_t ZSTD_decompress_generic(ZSTD_DCtx* dctx,
                                           ZSTD_outBuffer* output,
                                           ZSTD_inBuffer* input);



size_t ZSTD_decompress_generic_simpleArgs (
                            ZSTD_DCtx* dctx,
                            void* dst, size_t dstCapacity, size_t* dstPos,
                      const void* src, size_t srcSize, size_t* srcPos);



void ZSTD_DCtx_reset(ZSTD_DCtx* dctx);
]]

ffi.cdef[[
/* ============================ */
/**       Block level API       */
/* ============================ */



static const int ZSTD_BLOCKSIZELOG_MAX = 17;
static const int ZSTD_BLOCKSIZE_MAX   = (1<<ZSTD_BLOCKSIZELOG_MAX);   

/*=====   Raw zstd block functions  =====*/
size_t ZSTD_getBlockSize   (const ZSTD_CCtx* cctx);
size_t ZSTD_compressBlock  (ZSTD_CCtx* cctx, void* dst, size_t dstCapacity, const void* src, size_t srcSize);
size_t ZSTD_decompressBlock(ZSTD_DCtx* dctx, void* dst, size_t dstCapacity, const void* src, size_t srcSize);
size_t ZSTD_insertBlock    (ZSTD_DCtx* dctx, const void* blockStart, size_t blockSize);
]]


local Lib = ffi.load("libzstd")

return Lib