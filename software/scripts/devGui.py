#!/usr/bin/env python3
#-----------------------------------------------------------------------------
# This file is part of the 'Simple-Kria-Kv260-Example'. It is subject to
# the license terms in the LICENSE.txt file found in the top-level directory
# of this distribution and at:
#    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
# No part of the 'Simple-Kria-Kv260-Example', including this file, may be
# copied, modified, propagated, or distributed except according to the terms
# contained in the LICENSE.txt file.
#-----------------------------------------------------------------------------
import setupLibPaths
import simple_kria_kv260_example

import os
import sys
import argparse
import importlib
import rogue

import pyrogue as pr
import pyrogue.pydm

if __name__ == "__main__":

#################################################################

    # Set the argument parser
    parser = argparse.ArgumentParser()

    # Add arguments
    parser.add_argument(
        "--ip",
        type     = str,
        required = True,
        help     = "ETH Host Name (or IP address)",
    )

    # Get the arguments
    args = parser.parse_args()

    #################################################################

    with simple_kria_kv260_example.Root(
        ip = args.ip,
    ) as root:
        pyrogue.pydm.runPyDM(
            serverList = root.zmqServer.address,
            sizeX      = 800,
            sizeY      = 800,
        )

    #################################################################
