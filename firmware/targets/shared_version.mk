# Define Firmware Version: v1.7.0.0
export PRJ_VERSION = 0x01070000

# Include .XSA in image dir
export GEN_XSA_IMAGE = 1

# Define release
ifndef RELEASE
export RELEASE = KiraKv260
endif
