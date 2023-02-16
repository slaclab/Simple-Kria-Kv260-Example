#-----------------------------------------------------------------------------
# This file is part of the 'SPACE SMURF RFSOC'. It is subject to
# the license terms in the LICENSE.txt file found in the top-level directory
# of this distribution and at:
#    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
# No part of the 'SPACE SMURF RFSOC', including this file, may be
# copied, modified, propagated, or distributed except according to the terms
# contained in the LICENSE.txt file.
#-----------------------------------------------------------------------------

import rogue
import rogue.interfaces.stream as stream

import pyrogue as pr
import pyrogue.protocols

import axi_soc_ultra_plus_core  as socCore
import simple_kria_kv260_example as rfsoc

class Root(pr.Root):
    def __init__(self,
            ip = '10.0.0.200', # ETH Host Name (or IP address)
        **kwargs):

        # Pass custom value to parent via super function
        super().__init__(**kwargs)

        # Start a TCP Bridge Client, Connect remote server at 'ethReg' ports 9000 & 9001.
        self.tcpMemBase = rogue.interfaces.memory.TcpClient(ip,9000)

        # DMA[lane=0][TDEST=0] = ports 10000 & 10001
        self.tcpStream = stream.TcpClient(ip,10000)

        # Added the devices
        self.add(socCore.AxiSocCore(
            memBase      = self.tcpMemBase,
            offset       = 0x04_0000_0000,
            numDmaLanes  = 1,
        ))
