#!/bin/sh
####################################################

# Define the hardware type
# Note: Must match the axi-soc-ultra-plus-core/hardware directory name
hwType=XilinxKriaKv260

# Define number of DMA lanes
numLane=2

# Define number of DEST per DMA lane
numDest=1

# Define number of DMA TX/RX Buffers
rxBuffCnt=128
txBuffCnt=128

# Define DMA Buffer Size
buffSize=0x80000 # 512kB

# Not using RFDC utility
rfdc=0

####################################################

if [ $# -ne 1 ]
then
   echo "Usage: CreatePetalinuxProject.sh xsa"
   exit;
fi

# Define the target name
xsaPath=$(realpath "${1}")

# Define the target name
targetName=${PWD##*/}

# Define the base dir
basePath=$(realpath "$PWD/../..")

# Make the build output
mkdir -p $basePath/build
mkdir -p $basePath/build/petalinux
buildPath=$basePath/build/petalinux

# Execute the create petalinux script
../../submodules/axi-soc-ultra-plus-core/CreatePetalinuxProject.sh \
-p $buildPath -n $targetName -x $xsaPath -h $hwType \
-l $numLane -d $numDest -t $txBuffCnt -r $rxBuffCnt -s $buffSize \
-f $rfdc
