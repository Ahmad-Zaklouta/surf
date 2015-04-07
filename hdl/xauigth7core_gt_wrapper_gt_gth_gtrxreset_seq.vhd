------------------------------------------------------------------------------/
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version : 3.2
--  \   \         Application : 7 Series FPGAs Transceivers Wizard
--  /   /         Filename : xauigth7core_gt_wrapper_gt_gth_gtrxreset_seq.vhd
-- /___/   /\
-- \   \  /  \
--  \___\/\___\
--
--
-- Module XauiGth7Core_gt_wrapper_GT_gth_gtrxreset_seq (a GT Wrapper)
-- Generated by Xilinx 7 Series FPGAs Transceivers Wizard
--
--
-- (c) Copyright 2002 - 2014 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY XauiGth7Core_gt_wrapper_GT_gth_gtrxreset_seq is
  port (
    RST           : IN  std_logic; --Please add a synchroniser if it is not generated in DRPCLK domain.
    GTRXRESET_IN  : IN  std_logic; --Please add a synchroniser if it is not generated in DRPCLK domain.
    RXPMARESETDONE: IN  std_logic;
    GTRXRESET_OUT : OUT std_logic;

    DRPCLK        : IN  std_logic;
    DRPADDR       : OUT std_logic_vector(8 downto 0);
    DRPDO     : IN  std_logic_vector(15 downto 0);
    DRPDI         : OUT std_logic_vector(15 downto 0);
    DRPRDY        : IN  std_logic;
    DRPEN     : OUT std_logic;
    DRPWE         : OUT std_logic;
    DRP_OP_DONE   : OUT std_logic
);
END XauiGth7Core_gt_wrapper_GT_gth_gtrxreset_seq;

ARCHITECTURE Behavioral of XauiGth7Core_gt_wrapper_GT_gth_gtrxreset_seq is

  component XauiGth7Core_gt_wrapper_tx_sync_manual_block
   generic (
     INITIALISE : bit_vector(5 downto 0) := "000000"
   );
   port  (
             clk           : in  std_logic;
             data_in       : in  std_logic;
             data_out      : out std_logic
          );
   end component;

  constant DLY                : time := 1 ns;
  type state_type is (idle,
                      drp_rd,
                      wait_rd_data,
                      wr_16,
                      wait_wr_done1,
                      wait_pmareset,
                      wr_20,
                      wait_wr_done2);

  signal  state               : state_type := idle;
  signal  next_state          : state_type := idle;
  signal  gtrxreset_s         : std_logic;
  signal  gtrxreset_ss        : std_logic;
  signal  rxpmaresetdone_ss   : std_logic;
  signal  rxpmaresetdone_sss  : std_logic;
  signal  rd_data             : std_logic_vector(15 downto 0);
  signal  next_rd_data        : std_logic_vector(15 downto 0);
  signal  pmarstdone_fall_edge:std_logic;
  signal  gtrxreset_i         :std_logic;
  signal  gtrxreset_o         :std_logic;
  signal  drpen_o             :std_logic;
  signal  drpwe_o             :std_logic;
  signal  drpaddr_o           :std_logic_vector(8 downto 0);
  signal  drpdi_o             :std_logic_vector(15 downto 0);
  signal  drp_op_done_o       :std_logic;

BEGIN

 sync0_RXPMARESETDONE : XauiGth7Core_gt_wrapper_tx_sync_manual_block
  port map
         (
            clk             =>  DRPCLK,
            data_in         =>  RXPMARESETDONE,
            data_out        =>  rxpmaresetdone_ss
         );

--output assignment
  GTRXRESET_OUT <= gtrxreset_o;
  DRPEN         <= drpen_o;
  DRPWE         <= drpwe_o;
  DRPADDR       <= drpaddr_o;
  DRPDI         <= drpdi_o;
  DRP_OP_DONE   <= drp_op_done_o;

  PROCESS (DRPCLK,RST)
  BEGIN
    IF (RST = '1') THEN
      state              <= idle              after DLY;
      gtrxreset_s        <= '0'               after DLY;
      gtrxreset_ss       <= '0'               after DLY;
      rxpmaresetdone_sss <= '0'               after DLY;
      rd_data            <= x"0000"           after DLY;
      gtrxreset_o        <= '0'               after DLY;
    ELSIF (DRPCLK'event and DRPCLK='1') THEN
      state              <= next_state        after DLY;
      gtrxreset_s        <= GTRXRESET_IN      after DLY;
      gtrxreset_ss       <= gtrxreset_s       after DLY;
      rxpmaresetdone_sss <= rxpmaresetdone_ss after DLY;
      rd_data            <= next_rd_data      after DLY;
      gtrxreset_o        <= gtrxreset_i       after DLY;
    END IF;
  END PROCESS;

  PROCESS (DRPCLK,GTRXRESET_IN)
  BEGIN
    IF (GTRXRESET_IN = '1') THEN
       drp_op_done_o  <= '0'       after DLY;

    ELSIF (DRPCLK'event and DRPCLK='1') THEN
      IF (state = wait_wr_done2 and DRPRDY = '1') THEN
         drp_op_done_o  <= '1'       after DLY;
      ELSE
         drp_op_done_o  <= drp_op_done_o       after DLY;
      END IF;
    END IF;
  END PROCESS;

  pmarstdone_fall_edge <= (not rxpmaresetdone_ss) and (rxpmaresetdone_sss);

  PROCESS (gtrxreset_ss,DRPRDY,state,pmarstdone_fall_edge)
  BEGIN
    CASE state IS

      WHEN idle         =>
        IF (gtrxreset_ss='1') THEN
          next_state <= drp_rd;
        ELSE
          next_state <= idle;
    END IF;

      WHEN drp_rd       =>
    next_state<= wait_rd_data;

      WHEN wait_rd_data =>
        IF (DRPRDY='1')THEN
          next_state <= wr_16;
        ELSE
          next_state <= wait_rd_data;
        END IF;

      WHEN wr_16 =>
    next_state <= wait_wr_done1;

      WHEN wait_wr_done1 =>
    IF (DRPRDY='1') THEN
      next_state <= wait_pmareset;
        ELSE
      next_state <= wait_wr_done1;
        END IF;

      WHEN wait_pmareset =>
    IF (pmarstdone_fall_edge='1') THEN
          next_state <= wr_20;
        ELSE
          next_state <= wait_pmareset;
        END IF;

      WHEN wr_20         =>
        next_state <= wait_wr_done2;

      WHEN wait_wr_done2 =>
    IF (DRPRDY='1') THEN
          next_state <= idle;
        ELSE
          next_state <= wait_wr_done2;
    END IF;

      WHEN others=>
          next_state <= idle;

    END CASE;
  END PROCESS;

-- drives DRP interface and GTRXRESET_OUT
  PROCESS(DRPRDY,state,rd_data,DRPDO,gtrxreset_ss)
  BEGIN
-- assert gtrxreset_out until wr to 16-bit is complete
-- RX_DATA_WIDTH is located at addr x"0011", [13 downto 11]
-- encoding is this : /16 = x "2", /20 = x"3", /32 = x"4", /40 = x"5"
    gtrxreset_i  <= '0';
    drpaddr_o    <= '0'& x"11"; -- 000010001
    drpen_o      <= '0';
    drpwe_o      <= '0';
    drpdi_o      <= x"0000";
    next_rd_data <= rd_data;

    CASE state IS

     --do nothing to DRP or reset
      WHEN idle   => null;

      --assert reset and issue rd
      WHEN drp_rd =>
    gtrxreset_i <= '1';
        drpen_o     <= '1';
    drpwe_o     <= '0';

      --assert reset and wait to load rd data
      WHEN wait_rd_data =>
        gtrxreset_i <= '1';
          IF (DRPRDY='1') THEN
            next_rd_data <= DRPDO;
          ELSE
            next_rd_data <= rd_data;
          END IF;

      --assert reset and write to 16-bit mode
      WHEN wr_16=>
    gtrxreset_i<= '1';
    drpen_o    <= '1';
    drpwe_o    <= '1';
        -- Addr "00001001" [11] = '0' puts width mode in /16 or /32
       drpdi_o <= rd_data(15 downto 12) & '0' & rd_data(10 downto 0);

      --keep asserting reset until write to 16-bit mode is complete
      WHEN wait_wr_done1=>
    gtrxreset_i <= '1';

      --deassert reset and no DRP access until 2nd pmareset
      WHEN wait_pmareset => null;
          IF (gtrxreset_ss='1') THEN
             gtrxreset_i <= '1';
          ELSE
             gtrxreset_i <= '0';
          END IF;

      --write to 20-bit mode
      WHEN wr_20 =>
        drpen_o <='1';
        drpwe_o <= '1';
        drpdi_o <= rd_data(15 downto 12) & '1' & rd_data(10 downto 0); --restore 20-bit mode

      --wait to complete write to 20-bit mode
      WHEN wait_wr_done2 => null;

      WHEN others        => null;

     END CASE;
  END PROCESS;

END Behavioral;


