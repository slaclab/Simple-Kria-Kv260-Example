#-----------------------------------------------------------------------------
# This file is part of the 'Simple-Kria-Kv260-Example'. It is subject to
# the license terms in the LICENSE.txt file found in the top-level directory
# of this distribution and at:
#    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
# No part of the 'Simple-Kria-Kv260-Example', including this file, may be
# copied, modified, propagated, or distributed except according to the terms
# contained in the LICENSE.txt file.
#-----------------------------------------------------------------------------

import rogue
import rogue.interfaces.stream as stream

import pyrogue as pr
import pyrogue.protocols
import pyrogue.utilities.prbs

import axi_soc_ultra_plus_core   as socCore
import simple_kria_kv260_example as rfsoc

rogue.Version.minVersion('6.0.0')

class Root(pr.Root):
    def __init__(self,
            ip       = '10.0.0.200', # ETH Host Name (or IP address)
            zmqSrvEn = True,  # Flag to include the ZMQ server
            **kwargs):
        super().__init__(**kwargs)

        #################################################################
        if zmqSrvEn:
            self.zmqServer = pyrogue.interfaces.ZmqServer(root=self, addr='*', port=0)
            self.addInterface(self.zmqServer)

        #################################################################

        #-----------------------------------------------------------------------------

        # Start a TCP Bridge Client, Connect remote server at 'ethReg' ports 9000 & 9001.
        self.tcpMemBase = rogue.interfaces.memory.TcpClient(ip,9000)

        # DMA[lane=0][TDEST=0] = ports 10000 & 10001
        self.tcpStream = stream.TcpClient(ip,10000)

        #-----------------------------------------------------------------------------

        # Added the device
        self.add(socCore.AxiSocCore(
            memBase      = self.tcpMemBase,
            offset       = 0x04_0000_0000,
            numDmaLanes  = 1,
        ))

        self.add(rfsoc.Application(
            memBase = self.tcpMemBase,
            offset  = 0x04_8000_0000,
            expand  = True,
        ))

        #-----------------------------------------------------------------------------

        self.prbsRx    = pr.utilities.prbs.PrbsRx(
            width        = 64,
            checkPayload = True,
            expand       = True,
        )
        self.tcpStream >> self.prbsRx
        self.add(self.prbsRx)

        self.prbTx = pr.utilities.prbs.PrbsTx(
            width   = 64,
            expand  = True,
        )
        self.prbTx >> self.tcpStream
        self.add(self.prbTx)

        #-----------------------------------------------------------------------------
