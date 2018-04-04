-- test_basic.lua

package.path = "../?.lua;"..package.path;

local ffi = require('ffi')

local zstd_ffi = require("lj2zstd.zstd_ffi")


local ver = ffi.string(zstd_ffi.ZSTD_versionString() or "")
print("ver: ", ver)

print("Version Number: ", zstd_ffi.ZSTD_versionNumber())
