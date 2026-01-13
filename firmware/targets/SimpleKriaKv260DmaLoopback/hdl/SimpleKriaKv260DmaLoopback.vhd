-------------------------------------------------------------------------------
-- Company    : SLAC National Accelerator Laboratory
-------------------------------------------------------------------------------
-- Description: Top Level Firmware Target
-------------------------------------------------------------------------------
-- This file is part of 'Simple-Kria-Kv260-Example'.
-- It is subject to the license terms in the LICENSE.txt file found in the
-- top-level directory of this distribution and at:
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
-- No part of 'Simple-Kria-Kv260-Example', including this file,
-- may be copied, modified, propagated, or distributed except according to
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiStreamPkg.all;
use surf.AxiLitePkg.all;

library axi_soc_ultra_plus_core;
use axi_soc_ultra_plus_core.AxiSocUltraPlusPkg.all;

entity SimpleKriaKv260DmaLoopback is
   generic (
      TPD_G        : time := 1 ns;
      BUILD_INFO_G : BuildInfoType);
   port (
      -- Kria K26 I/O Ports
      pmod       : inout slv(7 downto 0);
      -- PMU Ports
      fanEnableL : out   sl;
      -- SYSMON Ports
      vPIn       : in    sl;
      vNIn       : in    sl);
end SimpleKriaKv260DmaLoopback;

architecture top_level of SimpleKriaKv260DmaLoopback is

   constant DMA_SIZE_C : positive := 2;

   signal dmaClk       : sl;
   signal dmaRst       : sl;
   signal dmaObMasters : AxiStreamMasterArray(DMA_SIZE_C-1 downto 0) := (others => AXI_STREAM_MASTER_INIT_C);
   signal dmaObSlaves  : AxiStreamSlaveArray(DMA_SIZE_C-1 downto 0)  := (others => AXI_STREAM_SLAVE_FORCE_C);
   signal dmaIbMasters : AxiStreamMasterArray(DMA_SIZE_C-1 downto 0) := (others => AXI_STREAM_MASTER_INIT_C);
   signal dmaIbSlaves  : AxiStreamSlaveArray(DMA_SIZE_C-1 downto 0)  := (others => AXI_STREAM_SLAVE_FORCE_C);

   signal appLoopbackMaster : AxiStreamMasterType := AXI_STREAM_MASTER_INIT_C;
   signal appLoopbackSlave  : AxiStreamSlaveType  := AXI_STREAM_SLAVE_FORCE_C;

   signal axilClk         : sl;
   signal axilRst         : sl;
   signal axilReadMaster  : AxiLiteReadMasterType;
   signal axilReadSlave   : AxiLiteReadSlaveType  := AXI_LITE_READ_SLAVE_EMPTY_DECERR_C;
   signal axilWriteMaster : AxiLiteWriteMasterType;
   signal axilWriteSlave  : AxiLiteWriteSlaveType := AXI_LITE_WRITE_SLAVE_EMPTY_DECERR_C;

   signal xvcClk156 : sl;
   signal xvcRst156 : sl;

begin

   U_XVC_PLL : entity surf.ClockManagerUltraScale
      generic map(
         TPD_G              => TPD_G,
         TYPE_G             => "MMCM",
         INPUT_BUFG_G       => true,
         FB_BUFG_G          => true,
         RST_IN_POLARITY_G  => '1',
         NUM_CLOCKS_G       => 1,
         -- MMCM attributes
         BANDWIDTH_G        => "OPTIMIZED",
         CLKIN_PERIOD_G     => 10.0,    -- 100MHz
         DIVCLK_DIVIDE_G    => 8,       -- 12.5MHz = 100MHz/8
         CLKFBOUT_MULT_F_G  => 96.875,  -- 1210.9375MHz = 96.875 x 12.5MHz
         CLKOUT0_DIVIDE_F_G => 7.75)    -- 156.25MHz = 1210.9375MHz/7.75
      port map(
         -- Clock Input
         clkIn     => axilClk,
         rstIn     => axilRst,
         -- Clock Outputs
         clkOut(0) => xvcClk156,
         -- Reset Outputs
         rstOut(0) => xvcRst156);

   -----------------------
   -- Common Platform Core
   -----------------------
   U_Core : entity axi_soc_ultra_plus_core.AxiSocUltraPlusCore
      generic map (
         TPD_G             => TPD_G,
         BUILD_INFO_G      => BUILD_INFO_G,
         EXT_AXIL_MASTER_G => false,
         DMA_SIZE_G        => DMA_SIZE_C)
      port map (
         ------------------------
         --  Top Level Interfaces
         ------------------------
         -- DSP Clock and Reset Monitoring
         dspClk         => '0',
         dspRst         => '0',
         -- AUX Clock and Reset
         auxClk         => axilClk,     -- 100 MHz
         auxRst         => axilRst,
         -- DMA Interfaces  (dmaClk domain)
         dmaClk         => dmaClk,      -- 250 MHz
         dmaRst         => dmaRst,
         dmaObMasters   => dmaObMasters,
         dmaObSlaves    => dmaObSlaves,
         dmaIbMasters   => dmaIbMasters,
         dmaIbSlaves    => dmaIbSlaves,
         -- Application AXI-Lite Interfaces [0x80000000:0xFFFFFFFF] (appClk domain)
         appClk         => axilClk,
         appRst         => axilRst,
         appReadMaster  => axilReadMaster,
         appReadSlave   => axilReadSlave,
         appWriteMaster => axilWriteMaster,
         appWriteSlave  => axilWriteSlave,
         -- PMU Ports
         fanEnableL     => fanEnableL,
         -- SYSMON Ports
         vPIn           => vPIn,
         vNIn           => vNIn);

   -------------------------------
   --  Loopback the SW AXIS stream
   -------------------------------
   dmaIbMasters(0) <= dmaObMasters(0);
   dmaObSlaves(0)  <= dmaIbSlaves(0);

   --------------
   -- Application
   --------------
   U_App : entity work.Application
      generic map (
         TPD_G            => TPD_G,
         AXIL_BASE_ADDR_G => APP_ADDR_OFFSET_C)
      port map (
         -- Kria K26 I/O Ports
         pmod            => pmod,
         -- DMA Interfaces  (dmaClk domain)
         dmaClk          => dmaClk,
         dmaRst          => dmaRst,
--       dmaObMaster     => dmaObMasters(0),
--       dmaObSlave      => dmaObSlaves(0),
--       dmaIbMaster     => dmaIbMasters(0),
--       dmaIbSlave      => dmaIbSlaves(0),
         dmaObMaster     => appLoopbackMaster,  -- Loopback the FW AXIS stream
         dmaObSlave      => appLoopbackSlave,   -- Loopback the FW AXIS stream
         dmaIbMaster     => appLoopbackMaster,  -- Loopback the FW AXIS stream
         dmaIbSlave      => appLoopbackSlave,   -- Loopback the FW AXIS stream
         -- AXI-Lite Interface (axilClk domain)
         axilClk         => axilClk,
         axilRst         => axilRst,
         axilWriteMaster => axilWriteMaster,
         axilWriteSlave  => axilWriteSlave,
         axilReadMaster  => axilReadMaster,
         axilReadSlave   => axilReadSlave);

   -------------
   -- XVC Module
   -------------
   U_XVC : entity surf.DmaXvcWrapper
      generic map (
         TPD_G             => TPD_G,
         DMA_AXIS_CONFIG_G => DMA_AXIS_CONFIG_C)
      port map (
         -- 156.25MHz XVC Clock/Reset (xvcClk156 domain)
         xvcClk156   => xvcClk156,
         xvcRst156   => xvcRst156,
         -- DMA Interface (dmaClk domain)
         dmaClk      => dmaClk,
         dmaRst      => dmaRst,
         dmaObMaster => dmaObMasters(1),
         dmaObSlave  => dmaObSlaves(1),
         dmaIbMaster => dmaIbMasters(1),
         dmaIbSlave  => dmaIbSlaves(1));

end top_level;
