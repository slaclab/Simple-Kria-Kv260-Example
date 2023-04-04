#-----------------------------------------------------------------------------
# This file is part of the 'Simple-Kria-Kv260-Example'. It is subject to
# the license terms in the LICENSE.txt file found in the top-level directory
# of this distribution and at:
#    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
# No part of the 'Simple-Kria-Kv260-Example', including this file, may be
# copied, modified, propagated, or distributed except according to the terms
# contained in the LICENSE.txt file.
#-----------------------------------------------------------------------------

import pyrogue as pr

import surf.protocols.ssi as ssi

class Application(pr.Device):
    def __init__(self,**kwargs):
        super().__init__(**kwargs)

        self.add(ssi.SsiPrbsTx(
            offset  = 0x0_0000,
            expand  = True,
        ))

        self.add(ssi.SsiPrbsRx(
            offset  = 0x1_0000,
            expand  = True,
        ))

        self.add(pr.RemoteVariable(
            name         = 'HdaInputBus',
            offset       = 0x2_0000,
            bitSize      = 20,
            mode         = 'RO',
            pollInterval = 1,
        ))

        self.add(pr.RemoteVariable(
            name         = 'HdaOutputBus',
            offset       = 0x2_0100,
            bitSize      = 20,
            mode         = 'RW',
        ))

        self.add(pr.RemoteVariable(
            name         = 'HdaTriBus',
            offset       = 0x2_0104,
            bitSize      = 20,
            mode         = 'RW',
        ))
