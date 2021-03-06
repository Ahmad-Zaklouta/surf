#-----------------------------------------------------------------------------
# Title      : PyRogue XauiReg
#-----------------------------------------------------------------------------
# Description:
# PyRogue XauiReg
#-----------------------------------------------------------------------------
# This file is part of the 'SLAC Firmware Standard Library'. It is subject to
# the license terms in the LICENSE.txt file found in the top-level directory
# of this distribution and at:
#    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
# No part of the 'SLAC Firmware Standard Library', including this file, may be
# copied, modified, propagated, or distributed except according to the terms
# contained in the LICENSE.txt file.
#-----------------------------------------------------------------------------

import pyrogue as pr

class XauiReg(pr.Device):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        ##############################
        # Variables
        ##############################

        self.addRemoteVariables(
            name         = "StatusCounters",
            description  = "Status Counters",
            offset       =  0x00,
            bitSize      =  32,
            bitOffset    =  0x00,
            base         = pr.UInt,
            mode         = "RO",
            number       =  25,
            stride       =  4,
        )

        self.add(pr.RemoteVariable(
            name         = "StatusVector",
            description  = "Status Vector",
            offset       =  0x100,
            bitSize      =  25,
            bitOffset    =  0x00,
            base         = pr.UInt,
            mode         = "RO",
        ))

        self.add(pr.RemoteVariable(
            name         = "MacAddress",
            description  = "MAC Address (big-Endian)",
            offset       =  0x200,
            bitSize      =  48,
            bitOffset    =  0x00,
            base         = pr.UInt,
            mode         = "RO",
        ))

        self.add(pr.RemoteVariable(
            name         = "PauseTime",
            description  = "PauseTime",
            offset       =  0x21C,
            bitSize      =  16,
            bitOffset    =  0x00,
            base         = pr.UInt,
            mode         = "RO",
        ))

        self.add(pr.RemoteVariable(
            name         = "FilterEnable",
            description  = "FilterEnable",
            offset       =  0x228,
            bitSize      =  1,
            bitOffset    =  0x00,
            base         = pr.UInt,
            mode         = "RO",
        ))

        self.add(pr.RemoteVariable(
            name         = "PauseEnable",
            description  = "PauseEnable",
            offset       =  0x22C,
            bitSize      =  1,
            bitOffset    =  0x00,
            base         = pr.UInt,
            mode         = "RO",
        ))

        self.add(pr.RemoteVariable(
            name         = "ConfigVector",
            description  = "ConfigVector",
            offset       =  0x230,
            bitSize      =  7,
            bitOffset    =  0x00,
            base         = pr.UInt,
            mode         = "RW",
        ))

        self.add(pr.RemoteVariable(
            name         = "RollOverEn",
            description  = "RollOverEn",
            offset       =  0xF00,
            bitSize      =  25,
            bitOffset    =  0x00,
            base         = pr.UInt,
            mode         = "RW",
        ))

        self.add(pr.RemoteVariable(
            name         = "CounterReset",
            description  = "CounterReset",
            offset       =  0xFF4,
            bitSize      =  1,
            bitOffset    =  0x00,
            base         = pr.UInt,
            mode         = "WO",
        ))

        self.add(pr.RemoteVariable(
            name         = "SoftReset",
            description  = "SoftReset",
            offset       =  0xFF8,
            bitSize      =  1,
            bitOffset    =  0x00,
            base         = pr.UInt,
            mode         = "WO",
        ))

        self.add(pr.RemoteVariable(
            name         = "HardReset",
            description  = "HardReset",
            offset       =  0xFFC,
            bitSize      =  1,
            bitOffset    =  0x00,
            base         = pr.UInt,
            mode         = "WO",
        ))
