# Define target output
target: bit

# Using XVC Debug bridge
export USE_XVC_DEBUG = 1

# Define target part
export PRJ_PART = xck26-sfvc784-2lv-c

# Define TOP directory
export TOP_DIR = $(abspath $(PWD)/../..)

# Use top level makefile
include ../shared_version.mk
include $(TOP_DIR)/submodules/ruckus/system_vivado.mk
