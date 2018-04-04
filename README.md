# lj2zstd
LuaJIT ffi binding to zstandard

ZStandard is a recent (2018) compression library https://github.com/facebook/zstd
The compression and decompression were originally created by Yann Collet, and it's very
good, particularly with tradeoffs between size and realtime speed.

The binding found here is for the LuaJIT variant of the Lua language.  It uses the ffi
routines to provide a fairly faithful rendering of the C API, as well as a higher level
set of objects and helper functions that should feel natural to the Lua programmer.

1) The lowest level binding can be found in zstd_ffi.llua
If you simply want access to the standard 'C' functions found within the library,
you will want to simply use this file.

2) zstd.lua is a higher level binding, which presents a number of convenience
functions, making the interaction with the library feel more Lua like.

Other Bindings:
https://github.com/sjnam/lua-resty-zstd
