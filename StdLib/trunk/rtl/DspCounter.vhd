-------------------------------------------------------------------------------
-- Title      : 
-------------------------------------------------------------------------------
-- File       : DspCounter.vhd
-- Author     : Larry Ruckman  <ruckman@slac.stanford.edu>
-- Company    : SLAC National Accelerator Laboratory
-- Created    : 2013-07-12
-- Last update: 2013-07-12
-- Platform   : ISE 14.5
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: XST will infer DSP resources for this counter
-------------------------------------------------------------------------------
-- Copyright (c) 2013 SLAC National Accelerator Laboratory
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.StdRtlPkg.all;

entity DspCounter is
   generic (
      TPD_G        : time                       := 1 ns;
      DATA_WIDTH_G : integer range 1 to (2**24) := 16;
      INCREMENT_G  : integer range 1 to (2**24) := 1);
   port (
      clk : in  sl := '0';
      rst : in  sl := '0';
      en  : in  sl := '1';
      cnt : out slv(DATA_WIDTH_G-1 downto 0));
begin
   -- INCREMENT_G range check
   assert (INCREMENT_G <= ((2**DATA_WIDTH_G)-1))
      report "INCREMENT_G must be <= ((2**DATA_WIDTH_G)-1)"
      severity failure;
end DspCounter;

architecture rtl of DspCounter is
   -- Constants
   constant INCREMENT_C : slv(DATA_WIDTH_G-1 downto 0) := conv_std_logic_vector(INCREMENT_G, DATA_WIDTH_G);

   -- Signals
   signal counter : slv(DATA_WIDTH_G-1 downto 0) := (others => '0');

   -- Attribute for XST
   attribute use_dsp48            : string;
   attribute use_dsp48 of counter : signal is "yes";
   
begin

   cnt <= counter;

   process(clk)
   begin
      if rising_edge(clk) then
         if rst = '1' then
            counter <= (others => '0') after TPD_G;
         else
            if en = '1' then
               counter <= counter + INCREMENT_C after TPD_G;
            end if;
         end if;
      end if;
   end process;
   
end rtl;
