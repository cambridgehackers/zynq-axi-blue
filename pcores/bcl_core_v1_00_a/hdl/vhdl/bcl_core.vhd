------------------------------------------------------------------------------
-- bcl_glue.vhd - entity/architecture pair
------------------------------------------------------------------------------
-- IMPORTANT:
-- DO NOT MODIFY THIS FILE EXCEPT IN THE DESIGNATED SECTIONS.
--
-- SEARCH FOR --USER TO DETERMINE WHERE CHANGES ARE ALLOWED.
--
-- TYPICALLY, THE ONLY ACCEPTABLE CHANGES INVOLVE ADDING NEW
-- PORTS AND GENERICS THAT GET PASSED THROUGH TO THE INSTANTIATION
-- OF THE USER_LOGIC ENTITY.
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          bcl_glue.vhd
-- Version:           1.00.a
-- Description:       Top level design, instantiates library components and user logic.
-- Date:              Mon Oct 15 17:26:47 2012 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bcl_core is
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    timer : OUT std_logic_vector(63 downto 0);
    reset_timer0 : IN std_logic;
    reset_timer1 : IN std_logic;
    reset_timer2 : IN std_logic;
    reset_timer3 : IN std_logic;
    hw_timer : OUT std_logic_vector(63 downto 0);
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    CLK : IN std_logic;
    RST_N : IN std_logic;
    fsls_0_put_v : IN std_logic_vector(31 downto 0);
    EN_fsls_0_put : IN std_logic;
    EN_fsls_0_get : IN std_logic;
    fsls_1_put_v : IN std_logic_vector(31 downto 0);
    EN_fsls_1_put : IN std_logic;
    EN_fsls_1_get : IN std_logic;
    fsls_2_put_v : IN std_logic_vector(31 downto 0);
    EN_fsls_2_put : IN std_logic;
    EN_fsls_2_get : IN std_logic;
    fsls_3_put_v : IN std_logic_vector(31 downto 0);
    EN_fsls_3_put : IN std_logic;
    EN_fsls_3_get : IN std_logic;          
    fsls_0_canPut : OUT std_logic;
    RDY_fsls_0_canPut : OUT std_logic;
    RDY_fsls_0_put : OUT std_logic;
    fsls_0_canGet : OUT std_logic;
    RDY_fsls_0_canGet : OUT std_logic;
    fsls_0_get : OUT std_logic_vector(31 downto 0);
    RDY_fsls_0_get : OUT std_logic;
    fsls_0_getID : OUT std_logic_vector(31 downto 0);
    RDY_fsls_0_getID : OUT std_logic;
    fsls_0_getTxBSZ : OUT std_logic_vector(31 downto 0);
    RDY_fsls_0_getTxBSZ : OUT std_logic;
    fsls_0_getRxBSZ : OUT std_logic_vector(31 downto 0);
    RDY_fsls_0_getRxBSZ : OUT std_logic;
    fsls_1_canPut : OUT std_logic;
    RDY_fsls_1_canPut : OUT std_logic;
    RDY_fsls_1_put : OUT std_logic;
    fsls_1_canGet : OUT std_logic;
    RDY_fsls_1_canGet : OUT std_logic;
    fsls_1_get : OUT std_logic_vector(31 downto 0);
    RDY_fsls_1_get : OUT std_logic;
    fsls_1_getID : OUT std_logic_vector(31 downto 0);
    RDY_fsls_1_getID : OUT std_logic;
    fsls_1_getTxBSZ : OUT std_logic_vector(31 downto 0);
    RDY_fsls_1_getTxBSZ : OUT std_logic;
    fsls_1_getRxBSZ : OUT std_logic_vector(31 downto 0);
    RDY_fsls_1_getRxBSZ : OUT std_logic;
    fsls_2_canPut : OUT std_logic;
    RDY_fsls_2_canPut : OUT std_logic;
    RDY_fsls_2_put : OUT std_logic;
    fsls_2_canGet : OUT std_logic;
    RDY_fsls_2_canGet : OUT std_logic;
    fsls_2_get : OUT std_logic_vector(31 downto 0);
    RDY_fsls_2_get : OUT std_logic;
    fsls_2_getID : OUT std_logic_vector(31 downto 0);
    RDY_fsls_2_getID : OUT std_logic;
    fsls_2_getTxBSZ : OUT std_logic_vector(31 downto 0);
    RDY_fsls_2_getTxBSZ : OUT std_logic;
    fsls_2_getRxBSZ : OUT std_logic_vector(31 downto 0);
    RDY_fsls_2_getRxBSZ : OUT std_logic;
    fsls_3_canPut : OUT std_logic;
    RDY_fsls_3_canPut : OUT std_logic;
    RDY_fsls_3_put : OUT std_logic;
    fsls_3_canGet : OUT std_logic;
    RDY_fsls_3_canGet : OUT std_logic;
    fsls_3_get : OUT std_logic_vector(31 downto 0);
    RDY_fsls_3_get : OUT std_logic;
    fsls_3_getID : OUT std_logic_vector(31 downto 0);
    RDY_fsls_3_getID : OUT std_logic;
    fsls_3_getTxBSZ : OUT std_logic_vector(31 downto 0);
    RDY_fsls_3_getTxBSZ : OUT std_logic;
    fsls_3_getRxBSZ : OUT std_logic_vector(31 downto 0);
    RDY_fsls_3_getRxBSZ : OUT std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;
  attribute MAX_FANOUT of CLK       : signal is "10000";
  attribute MAX_FANOUT of RST_N       : signal is "10000";
  attribute SIGIS of CLK       : signal is "Clk";
  attribute SIGIS of RST_N     : signal is "Rst";
end entity bcl_core;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of bcl_core is

COMPONENT mkFSLVec
PORT(
	CLK : IN std_logic;
	RST_N : IN std_logic;
	fsls_0_put_v : IN std_logic_vector(31 downto 0);
	EN_fsls_0_put : IN std_logic;
	EN_fsls_0_get : IN std_logic;
	fsls_1_put_v : IN std_logic_vector(31 downto 0);
	EN_fsls_1_put : IN std_logic;
	EN_fsls_1_get : IN std_logic;
	fsls_2_put_v : IN std_logic_vector(31 downto 0);
	EN_fsls_2_put : IN std_logic;
	EN_fsls_2_get : IN std_logic;
	fsls_3_put_v : IN std_logic_vector(31 downto 0);
	EN_fsls_3_put : IN std_logic;
	EN_fsls_3_get : IN std_logic;          
	fsls_0_canPut : OUT std_logic;
	RDY_fsls_0_canPut : OUT std_logic;
	RDY_fsls_0_put : OUT std_logic;
	fsls_0_canGet : OUT std_logic;
	RDY_fsls_0_canGet : OUT std_logic;
	fsls_0_get : OUT std_logic_vector(31 downto 0);
	RDY_fsls_0_get : OUT std_logic;
	fsls_0_getID : OUT std_logic_vector(31 downto 0);
	RDY_fsls_0_getID : OUT std_logic;
	fsls_0_getTxBSZ : OUT std_logic_vector(31 downto 0);
	RDY_fsls_0_getTxBSZ : OUT std_logic;
	fsls_0_getRxBSZ : OUT std_logic_vector(31 downto 0);
	RDY_fsls_0_getRxBSZ : OUT std_logic;
	fsls_1_canPut : OUT std_logic;
	RDY_fsls_1_canPut : OUT std_logic;
	RDY_fsls_1_put : OUT std_logic;
	fsls_1_canGet : OUT std_logic;
	RDY_fsls_1_canGet : OUT std_logic;
	fsls_1_get : OUT std_logic_vector(31 downto 0);
	RDY_fsls_1_get : OUT std_logic;
	fsls_1_getID : OUT std_logic_vector(31 downto 0);
	RDY_fsls_1_getID : OUT std_logic;
	fsls_1_getTxBSZ : OUT std_logic_vector(31 downto 0);
	RDY_fsls_1_getTxBSZ : OUT std_logic;
	fsls_1_getRxBSZ : OUT std_logic_vector(31 downto 0);
	RDY_fsls_1_getRxBSZ : OUT std_logic;
	fsls_2_canPut : OUT std_logic;
	RDY_fsls_2_canPut : OUT std_logic;
	RDY_fsls_2_put : OUT std_logic;
	fsls_2_canGet : OUT std_logic;
	RDY_fsls_2_canGet : OUT std_logic;
	fsls_2_get : OUT std_logic_vector(31 downto 0);
	RDY_fsls_2_get : OUT std_logic;
	fsls_2_getID : OUT std_logic_vector(31 downto 0);
	RDY_fsls_2_getID : OUT std_logic;
	fsls_2_getTxBSZ : OUT std_logic_vector(31 downto 0);
	RDY_fsls_2_getTxBSZ : OUT std_logic;
	fsls_2_getRxBSZ : OUT std_logic_vector(31 downto 0);
	RDY_fsls_2_getRxBSZ : OUT std_logic;
	fsls_3_canPut : OUT std_logic;
	RDY_fsls_3_canPut : OUT std_logic;
	RDY_fsls_3_put : OUT std_logic;
	fsls_3_canGet : OUT std_logic;
	RDY_fsls_3_canGet : OUT std_logic;
	fsls_3_get : OUT std_logic_vector(31 downto 0);
	RDY_fsls_3_get : OUT std_logic;
	fsls_3_getID : OUT std_logic_vector(31 downto 0);
	RDY_fsls_3_getID : OUT std_logic;
	fsls_3_getTxBSZ : OUT std_logic_vector(31 downto 0);
	RDY_fsls_3_getTxBSZ : OUT std_logic;
	fsls_3_getRxBSZ : OUT std_logic_vector(31 downto 0);
	RDY_fsls_3_getRxBSZ : OUT std_logic;
  hw_cnt_write_v : IN std_logic_vector(63 downto 0);
  EN_hw_cnt_write : IN std_logic;
  hw_cnt_read : OUT std_logic_vector(63 downto 0)
	);
END COMPONENT;

  signal timer_reg : std_logic_vector(63 downto 0);

begin

  Inst_mkFSLVec: mkFSLVec PORT MAP(
		CLK => CLK,
		RST_N => RST_N,
		fsls_0_canPut => fsls_0_canPut,
		RDY_fsls_0_canPut => RDY_fsls_0_canPut,
		fsls_0_put_v => fsls_0_put_v,
		EN_fsls_0_put => EN_fsls_0_put,
		RDY_fsls_0_put => RDY_fsls_0_put,
		fsls_0_canGet => fsls_0_canGet,
		RDY_fsls_0_canGet => RDY_fsls_0_canGet,
		EN_fsls_0_get => EN_fsls_0_get,
		fsls_0_get => fsls_0_get,
		RDY_fsls_0_get => RDY_fsls_0_get,
		fsls_0_getID => fsls_0_getID,
		RDY_fsls_0_getID => RDY_fsls_0_getID,
		fsls_0_getTxBSZ => fsls_0_getTxBSZ,
		RDY_fsls_0_getTxBSZ => RDY_fsls_0_getTxBSZ,
		fsls_0_getRxBSZ => fsls_0_getRxBSZ,
		RDY_fsls_0_getRxBSZ => RDY_fsls_0_getRxBSZ,
		fsls_1_canPut => fsls_1_canPut,
		RDY_fsls_1_canPut => RDY_fsls_1_canPut,
		fsls_1_put_v => fsls_1_put_v,
		EN_fsls_1_put => EN_fsls_1_put,
		RDY_fsls_1_put => RDY_fsls_1_put,
		fsls_1_canGet => fsls_1_canGet,
		RDY_fsls_1_canGet => RDY_fsls_1_canGet,
		EN_fsls_1_get => EN_fsls_1_get,
		fsls_1_get => fsls_1_get,
		RDY_fsls_1_get => RDY_fsls_1_get,
		fsls_1_getID => fsls_1_getID,
		RDY_fsls_1_getID => RDY_fsls_1_getID,
		fsls_1_getTxBSZ => fsls_1_getTxBSZ,
		RDY_fsls_1_getTxBSZ => RDY_fsls_1_getTxBSZ,
		fsls_1_getRxBSZ => fsls_1_getRxBSZ,
		RDY_fsls_1_getRxBSZ => RDY_fsls_1_getRxBSZ,
		fsls_2_canPut => fsls_2_canPut,
		RDY_fsls_2_canPut => RDY_fsls_2_canPut,
		fsls_2_put_v => fsls_2_put_v,
		EN_fsls_2_put => EN_fsls_2_put,
		RDY_fsls_2_put => RDY_fsls_2_put,
		fsls_2_canGet => fsls_2_canGet,
		RDY_fsls_2_canGet => RDY_fsls_2_canGet,
		EN_fsls_2_get => EN_fsls_2_get,
		fsls_2_get => fsls_2_get,
		RDY_fsls_2_get => RDY_fsls_2_get,
		fsls_2_getID => fsls_2_getID,
		RDY_fsls_2_getID => RDY_fsls_2_getID,
		fsls_2_getTxBSZ => fsls_2_getTxBSZ,
		RDY_fsls_2_getTxBSZ => RDY_fsls_2_getTxBSZ,
		fsls_2_getRxBSZ => fsls_2_getRxBSZ,
		RDY_fsls_2_getRxBSZ => RDY_fsls_2_getRxBSZ,
		fsls_3_canPut => fsls_3_canPut,
		RDY_fsls_3_canPut => RDY_fsls_3_canPut,
		fsls_3_put_v => fsls_3_put_v,
		EN_fsls_3_put => EN_fsls_3_put,
		RDY_fsls_3_put => RDY_fsls_3_put,
		fsls_3_canGet => fsls_3_canGet,
		RDY_fsls_3_canGet => RDY_fsls_3_canGet,
		EN_fsls_3_get => EN_fsls_3_get,
		fsls_3_get => fsls_3_get,
		RDY_fsls_3_get => RDY_fsls_3_get,
		fsls_3_getID => fsls_3_getID,
		RDY_fsls_3_getID => RDY_fsls_3_getID,
		fsls_3_getTxBSZ => fsls_3_getTxBSZ,
		RDY_fsls_3_getTxBSZ => RDY_fsls_3_getTxBSZ,
		fsls_3_getRxBSZ => fsls_3_getRxBSZ,
		RDY_fsls_3_getRxBSZ => RDY_fsls_3_getRxBSZ,
    hw_cnt_write_v => (others => '0'),
    EN_hw_cnt_write => '0',
    hw_cnt_read => hw_timer
	);
  
  TIMER_PROC : process( CLK ) is
  begin

    if ( CLK'event and CLK = '1' ) then
      if ( RST_N = '0' ) then
        
        timer_reg <= (others => '0');
        
      else
        
        if reset_timer0 = '1' or reset_timer1 = '1' or
            reset_timer2 = '1' or reset_timer3 = '1' then
          timer_reg <= (others => '0');
        else
          timer_reg <= timer_reg + 1;
        end if;
      end if;
    end if;
  end process; --TIMER_PROC
  
  timer <= timer_reg;

end IMP;