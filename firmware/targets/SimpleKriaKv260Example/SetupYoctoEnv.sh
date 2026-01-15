#!/usr/bin/env bash
####################################################

targetName=SimpleKriaKv260Example

####################################################

TOP="$(dirname "${BASH_SOURCE[0]}")"

cd "$TOP/../../build/YoctoProjects/$targetName"

source setupsdk