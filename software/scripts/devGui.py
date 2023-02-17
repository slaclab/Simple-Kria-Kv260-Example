#!/usr/bin/env python3
#-----------------------------------------------------------------------------
# This file is part of the 'SPACE SMURF RFSOC'. It is subject to
# the license terms in the LICENSE.txt file found in the top-level directory
# of this distribution and at:
#    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
# No part of the 'SPACE SMURF RFSOC', including this file, may be
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

    # Convert str to bool
    argBool = lambda s: s.lower() in ['true', 't', 'yes', '1']

    # Add arguments
    parser.add_argument(
        "--ip",
        type     = str,
        required = False,
        default  = '10.0.0.10',
        help     = "ETH Host Name (or IP address)",
    )

    parser.add_argument(
        "--pollEn",
        type     = argBool,
        required = False,
        default  = True,
        help     = "Enable auto-polling",
    )

    parser.add_argument(
        "--initRead",
        type     = argBool,
        required = False,
        default  = True,
        help     = "Enable read all variables at start",
    )

    # Get the arguments
    args = parser.parse_args()

    #################################################################

    with simple_kria_kv260_example.Root(
        ip          = args.ip,
        pollEn      = args.pollEn,
        initRead    = args.initRead,
    ) as root:
        pyrogue.pydm.runPyDM(
            root  = root,
            sizeX = 800,
            sizeY = 800,
        )

    #################################################################
