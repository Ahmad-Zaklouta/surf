-------------------------------------------------------------------------------
-- File       : ClinkPackTbRx.vhd
-- Company    : SLAC National Accelerator Laboratory
-- Created    : 2017-11-13
-------------------------------------------------------------------------------
-- Description:
-- CameraLink data packer tester, tx module
-------------------------------------------------------------------------------
-- This file is part of 'SLAC Firmware Standard Library'.
-- It is subject to the license terms in the LICENSE.txt file found in the 
-- top-level directory of this distribution and at: 
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
-- No part of 'SLAC Firmware Standard Library', including this file, 
-- may be copied, modified, propagated, or distributed except according to 
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.StdRtlPkg.all;
use work.AxiStreamPkg.all;

entity ClinkPackTbRx is
   generic (
      TPD_G         : time                := 1 ns;
      BYTE_SIZE_C   : positive            := 1;
      AXIS_CONFIG_G : AxiStreamConfigType := AXI_STREAM_CONFIG_INIT_C);
   port (
      -- System clock and reset
      sysClk       : in  sl;
      sysRst       : in  sl;
      -- Outbound frame
      sAxisMaster  : in  AxiStreamMasterType;
      fail         : out sl);
end ClinkPackTbRx;

architecture rtl of ClinkPackTbRx is

   type RegType is record
      byteCount  : natural;
      frameCount : natural;
      fail       : sl;
   end record RegType;

   constant REG_INIT_C : RegType := (
      byteCount  => 0,
      frameCount => 0,
      fail       => '0');

   signal r   : RegType := REG_INIT_C;
   signal rin : RegType;

begin

   comb : process (r, sysRst, sAxisMaster ) is
      variable v     : RegType;
      variable inTop : integer;
   begin
      v := r;

      if sAxisMaster.tValid = '1' then

         inTop := getTKeep(sAxisMaster.tKeep(AXIS_CONFIG_G.TDATA_BYTES_C-1 downto 0))-1;

         for i in 0 to inTop loop
            if sAxisMaster.tData(i*8+7 downto i*8) /= toSlv(v.byteCount,8) then
               v.fail := '1';
            end if;
            v.byteCount := v.byteCount + 1;
         end loop;

         if sAxisMaster.tLast = '1' then
            if v.byteCount /= (r.frameCount+1)*BYTE_SIZE_C then
               v.fail := '1';
            end if;
            v.byteCount := 0;
            v.frameCount := r.frameCount + 1;
         end if;
      end if;

      -- Reset
      if (sysRst = '1') then
         v := REG_INIT_C;
      end if;

      rin  <= v;
      fail <= r.fail;

   end process;

   seq : process (sysClk) is
   begin  
      if (rising_edge(sysClk)) then
         r <= rin;
      end if;
   end process;

end architecture rtl;

