local export =  {
	no_error = 0,
	GENERIC = 1,
	prefix_unknown = 2,
	version_unsupported = 3,
	parameter_unknown = 4,
	frameParameter_unsupported = 5,
	frameParameter_unsupportedBy32bits = 6,
	frameParameter_windowTooLarge = 7,
	compressionParameter_unsupported = 8,
	init_missing = 9,
	memory_allocation = 10,
	stage_wrong = 11,
	dstSize_tooSmall = 12,
	srcSize_wrong = 13,
	corruption_detected = 14,
	checksum_wrong = 15,
	tableLog_tooLarge = 16,
	maxSymbolValue_tooLarge = 17,
	maxSymbolValue_tooSmall = 18,
	dictionary_corrupted = 19,
	dictionary_wrong = 20,
	dictionaryCreation_failed = 21,
	maxCode = 22
}

return export
