------------------------------------------------------------------------------
-- foo_master.vhd - entity/architecture pair
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
-- Filename:          foo_master.vhd
-- Version:           1.00.a
-- Description:       Top level design, instantiates library components and user logic.
-- Date:              Tue Nov 20 15:03:36 2012 (by Create and Import Peripheral Wizard)
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

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;
use proc_common_v3_00_a.ipif_pkg.all;

library axi_slave_burst_v1_00_a;
use axi_slave_burst_v1_00_a.axi_slave_burst;

library foo_master_v1_00_a;
use foo_master_v1_00_a.user_logic;

entity foo_master is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    C_M_AXI0_DATA_WIDTH             : integer              := 32;
    C_M_AXI0_ADDR_WIDTH             : integer              := 32;
    C_M_AXI0_ID_WIDTH               : integer              := 1;

    C_M_AXI1_DATA_WIDTH             : integer              := 32;
    C_M_AXI1_ADDR_WIDTH             : integer              := 32;
    C_M_AXI1_ID_WIDTH               : integer              := 1;

    C_M_AXI2_DATA_WIDTH             : integer              := 32;
    C_M_AXI2_ADDR_WIDTH             : integer              := 32;
    C_M_AXI2_ID_WIDTH               : integer              := 1;
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_S_AXI_DATA_WIDTH             : integer              := 32;
    C_S_AXI_ADDR_WIDTH             : integer              := 32;
    C_S_AXI_ID_WIDTH               : integer              := 4;
    C_RDATA_FIFO_DEPTH             : integer              := 0;
    C_INCLUDE_TIMEOUT_CNT          : integer              := 1;
    C_TIMEOUT_CNTR_VAL             : integer              := 8;
    C_ALIGN_BE_RDADDR              : integer              := 0;
    C_S_AXI_SUPPORTS_WRITE         : integer              := 1;
    C_S_AXI_SUPPORTS_READ          : integer              := 1;
    C_FAMILY                       : string               := "virtex6";
    C_S_AXI_MEM0_BASEADDR          : std_logic_vector     := X"FFFFFFFF";
    C_S_AXI_MEM0_HIGHADDR          : std_logic_vector     := X"00000000";
    C_S_AXI_MEM1_BASEADDR          : std_logic_vector     := X"FFFFFFFF";
    C_S_AXI_MEM1_HIGHADDR          : std_logic_vector     := X"00000000"
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    interrupt : out std_logic;

    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    S_AXI_ACLK                     : in  std_logic;
    S_AXI_ARESETN                  : in  std_logic;
    S_AXI_AWADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID                  : in  std_logic;
    S_AXI_WDATA                    : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB                    : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    S_AXI_WVALID                   : in  std_logic;
    S_AXI_BREADY                   : in  std_logic;
    S_AXI_ARADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID                  : in  std_logic;
    S_AXI_RREADY                   : in  std_logic;
    S_AXI_ARREADY                  : out std_logic;
    S_AXI_RDATA                    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_RVALID                   : out std_logic;
    S_AXI_WREADY                   : out std_logic;
    S_AXI_BRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_BVALID                   : out std_logic;
    S_AXI_AWREADY                  : out std_logic;
    S_AXI_AWID                     : in  std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
    S_AXI_AWLEN                    : in  std_logic_vector(7 downto 0);
    S_AXI_AWSIZE                   : in  std_logic_vector(2 downto 0);
    S_AXI_AWBURST                  : in  std_logic_vector(1 downto 0);
    S_AXI_AWLOCK                   : in  std_logic;
    S_AXI_AWCACHE                  : in  std_logic_vector(3 downto 0);
    S_AXI_AWPROT                   : in  std_logic_vector(2 downto 0);
    S_AXI_WLAST                    : in  std_logic;
    S_AXI_BID                      : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
    S_AXI_ARID                     : in  std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
    S_AXI_ARLEN                    : in  std_logic_vector(7 downto 0);
    S_AXI_ARSIZE                   : in  std_logic_vector(2 downto 0);
    S_AXI_ARBURST                  : in  std_logic_vector(1 downto 0);
    S_AXI_ARLOCK                   : in  std_logic;
    S_AXI_ARCACHE                  : in  std_logic_vector(3 downto 0);
    S_AXI_ARPROT                   : in  std_logic_vector(2 downto 0);
    S_AXI_RID                      : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
    S_AXI_RLAST                    : out std_logic;

    md_error                       : out std_logic;

    m_axi0_aclk                     : in  std_logic;
    m_axi0_aresetn                  : in  std_logic;
    m_axi0_arready                  : in  std_logic;
    m_axi0_arvalid                  : out std_logic;
    m_axi0_arid                     : out std_logic_vector(C_M_AXI0_ID_WIDTH-1 downto 0);
    m_axi0_araddr                   : out std_logic_vector(C_M_AXI0_ADDR_WIDTH-1 downto 0);
    m_axi0_arlen                    : out std_logic_vector(7 downto 0);
    m_axi0_arsize                   : out std_logic_vector(2 downto 0);
    m_axi0_arburst                  : out std_logic_vector(1 downto 0);
    m_axi0_arprot                   : out std_logic_vector(2 downto 0);
    m_axi0_arcache                  : out std_logic_vector(3 downto 0);
    m_axi0_rready                   : out std_logic;
    m_axi0_rvalid                   : in  std_logic;
    m_axi0_rid                      : in  std_logic_vector(C_M_AXI0_ID_WIDTH-1 downto 0);
    m_axi0_rdata                    : in  std_logic_vector(C_M_AXI0_DATA_WIDTH-1 downto 0);
    m_axi0_rresp                    : in  std_logic_vector(1 downto 0);
    m_axi0_rlast                    : in  std_logic;
    m_axi0_awready                  : in  std_logic;
    m_axi0_awvalid                  : out std_logic;
    m_axi0_awid                     : out std_logic_vector(C_M_AXI0_ID_WIDTH-1 downto 0);
    m_axi0_awaddr                   : out std_logic_vector(C_M_AXI0_ADDR_WIDTH-1 downto 0);
    m_axi0_awlen                    : out std_logic_vector(7 downto 0);
    m_axi0_awsize                   : out std_logic_vector(2 downto 0);
    m_axi0_awburst                  : out std_logic_vector(1 downto 0);
    m_axi0_awprot                   : out std_logic_vector(2 downto 0);
    m_axi0_awcache                  : out std_logic_vector(3 downto 0);
    m_axi0_wready                   : in  std_logic;
    m_axi0_wvalid                   : out std_logic;
    m_axi0_wdata                    : out std_logic_vector(C_M_AXI0_DATA_WIDTH-1 downto 0);
    m_axi0_wstrb                    : out std_logic_vector((C_M_AXI0_DATA_WIDTH)/8 - 1 downto 0);
    m_axi0_wlast                    : out std_logic;
    m_axi0_bready                   : out std_logic;
    m_axi0_bid                      : in std_logic_vector(C_M_AXI0_ID_WIDTH-1 downto 0);
    m_axi0_bvalid                   : in  std_logic;
    m_axi0_bresp                    : in  std_logic_vector(1 downto 0);


    m_axi1_aclk                     : in  std_logic;
    m_axi1_aresetn                  : in  std_logic;
    m_axi1_arready                  : in  std_logic;
    m_axi1_arvalid                  : out std_logic;
    m_axi1_arid                     : out std_logic_vector(C_M_AXI1_ID_WIDTH-1 downto 0);
    m_axi1_araddr                   : out std_logic_vector(C_M_AXI1_ADDR_WIDTH-1 downto 0);
    m_axi1_arlen                    : out std_logic_vector(7 downto 0);
    m_axi1_arsize                   : out std_logic_vector(2 downto 0);
    m_axi1_arburst                  : out std_logic_vector(1 downto 0);
    m_axi1_arprot                   : out std_logic_vector(2 downto 0);
    m_axi1_arcache                  : out std_logic_vector(3 downto 0);
    m_axi1_rready                   : out std_logic;
    m_axi1_rvalid                   : in  std_logic;
    m_axi1_rid                      : in  std_logic_vector(C_M_AXI1_ID_WIDTH-1 downto 0);
    m_axi1_rdata                    : in  std_logic_vector(C_M_AXI1_DATA_WIDTH-1 downto 0);
    m_axi1_rresp                    : in  std_logic_vector(1 downto 0);
    m_axi1_rlast                    : in  std_logic;
    m_axi1_awready                  : in  std_logic;
    m_axi1_awvalid                  : out std_logic;
    m_axi1_awid                     : out std_logic_vector(C_M_AXI1_ID_WIDTH-1 downto 0);
    m_axi1_awaddr                   : out std_logic_vector(C_M_AXI1_ADDR_WIDTH-1 downto 0);
    m_axi1_awlen                    : out std_logic_vector(7 downto 0);
    m_axi1_awsize                   : out std_logic_vector(2 downto 0);
    m_axi1_awburst                  : out std_logic_vector(1 downto 0);
    m_axi1_awprot                   : out std_logic_vector(2 downto 0);
    m_axi1_awcache                  : out std_logic_vector(3 downto 0);
    m_axi1_wready                   : in  std_logic;
    m_axi1_wvalid                   : out std_logic;
    m_axi1_wdata                    : out std_logic_vector(C_M_AXI1_DATA_WIDTH-1 downto 0);
    m_axi1_wstrb                    : out std_logic_vector((C_M_AXI1_DATA_WIDTH)/8 - 1 downto 0);
    m_axi1_wlast                    : out std_logic;
    m_axi1_bready                   : out std_logic;
    m_axi1_bid                      : in std_logic_vector(C_M_AXI1_ID_WIDTH-1 downto 0);
    m_axi1_bvalid                   : in  std_logic;
    m_axi1_bresp                    : in  std_logic_vector(1 downto 0);

    m_axi2_aclk                     : in  std_logic;
    m_axi2_aresetn                  : in  std_logic;
    m_axi2_arready                  : in  std_logic;
    m_axi2_arvalid                  : out std_logic;
    m_axi2_arid                     : out std_logic_vector(C_M_AXI2_ID_WIDTH-1 downto 0);
    m_axi2_araddr                   : out std_logic_vector(C_M_AXI2_ADDR_WIDTH-1 downto 0);
    m_axi2_arlen                    : out std_logic_vector(7 downto 0);
    m_axi2_arsize                   : out std_logic_vector(2 downto 0);
    m_axi2_arburst                  : out std_logic_vector(1 downto 0);
    m_axi2_arprot                   : out std_logic_vector(2 downto 0);
    m_axi2_arcache                  : out std_logic_vector(3 downto 0);
    m_axi2_rready                   : out std_logic;
    m_axi2_rvalid                   : in  std_logic;
    m_axi2_rid                      : in  std_logic_vector(C_M_AXI2_ID_WIDTH-1 downto 0);
    m_axi2_rdata                    : in  std_logic_vector(C_M_AXI2_DATA_WIDTH-1 downto 0);
    m_axi2_rresp                    : in  std_logic_vector(1 downto 0);
    m_axi2_rlast                    : in  std_logic;
    m_axi2_awready                  : in  std_logic;
    m_axi2_awvalid                  : out std_logic;
    m_axi2_awid                     : out std_logic_vector(C_M_AXI2_ID_WIDTH-1 downto 0);
    m_axi2_awaddr                   : out std_logic_vector(C_M_AXI2_ADDR_WIDTH-1 downto 0);
    m_axi2_awlen                    : out std_logic_vector(7 downto 0);
    m_axi2_awsize                   : out std_logic_vector(2 downto 0);
    m_axi2_awburst                  : out std_logic_vector(1 downto 0);
    m_axi2_awprot                   : out std_logic_vector(2 downto 0);
    m_axi2_awcache                  : out std_logic_vector(3 downto 0);
    m_axi2_wready                   : in  std_logic;
    m_axi2_wvalid                   : out std_logic;
    m_axi2_wdata                    : out std_logic_vector(C_M_AXI2_DATA_WIDTH-1 downto 0);
    m_axi2_wstrb                    : out std_logic_vector((C_M_AXI2_DATA_WIDTH)/8 - 1 downto 0);
    m_axi2_wlast                    : out std_logic;
    m_axi2_bready                   : out std_logic;
    m_axi2_bid                      : in std_logic_vector(C_M_AXI2_ID_WIDTH-1 downto 0);
    m_axi2_bvalid                   : in  std_logic;
    m_axi2_bresp                    : in  std_logic_vector(1 downto 0)
   -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;
  attribute MAX_FANOUT of S_AXI_ACLK       : signal is "10000";
  attribute MAX_FANOUT of S_AXI_ARESETN       : signal is "10000";
  attribute SIGIS of S_AXI_ACLK       : signal is "Clk";
  attribute SIGIS of S_AXI_ARESETN       : signal is "Rst";

  attribute MAX_FANOUT of m_axi0_aclk       : signal is "10000";
  attribute MAX_FANOUT of m_axi0_aresetn       : signal is "10000";
  attribute SIGIS of m_axi0_aclk       : signal is "Clk";
  attribute SIGIS of m_axi0_aresetn       : signal is "Rst";

  attribute MAX_FANOUT of m_axi2_aclk       : signal is "10000";
  attribute MAX_FANOUT of m_axi2_aresetn       : signal is "10000";
  attribute SIGIS of m_axi2_aclk       : signal is "Clk";
  attribute SIGIS of m_axi2_aresetn       : signal is "Rst";

end entity foo_master;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of foo_master is

  constant USER_SLV_DWIDTH                : integer              := C_S_AXI_DATA_WIDTH;

  constant IPIF_SLV_DWIDTH                : integer              := C_S_AXI_DATA_WIDTH;

  constant ZERO_ADDR_PAD                  : std_logic_vector(0 to 31) := (others => '0');

  constant IPIF_ARD_ADDR_RANGE_ARRAY      : SLV64_ARRAY_TYPE     := 
    (
      ZERO_ADDR_PAD & C_S_AXI_MEM0_BASEADDR,-- user logic memory space 0 base address
      ZERO_ADDR_PAD & C_S_AXI_MEM0_HIGHADDR, -- user logic memory space 0 high address
      ZERO_ADDR_PAD & C_S_AXI_MEM1_BASEADDR,-- user logic memory space 0 base address
      ZERO_ADDR_PAD & C_S_AXI_MEM1_HIGHADDR -- user logic memory space 0 high address
    );

  constant USER_NUM_MEM                   : integer              := 2;

  constant IPIF_ARD_NUM_CE_ARRAY          : INTEGER_ARRAY_TYPE   := 
    (
      0  => 1,                            -- number of ce for user logic memory space 0 (always 1 chip enable)
      1  => 1                             -- number of ce for user logic memory space 1 (always 1 chip enable)
    );

  ------------------------------------------
  -- Width of the slave address bus (32 only)
  ------------------------------------------
  constant USER_SLV_AWIDTH                : integer              := C_S_AXI_ADDR_WIDTH;

  ------------------------------------------
  -- Index for CS/CE
  ------------------------------------------
  constant USER_MEM0_CS_INDEX             : integer              := 0;

  constant USER_CS_INDEX                  : integer              := USER_MEM0_CS_INDEX;

  ------------------------------------------
  -- IP Interconnect (IPIC) signal declarations
  ------------------------------------------
  signal ipif_Bus2IP_Clk                : std_logic;
  signal ipif_Bus2IP_Resetn             : std_logic;
  signal ipif_Bus2IP_Addr               : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal ipif_Bus2IP_RNW                : std_logic;
  signal ipif_Bus2IP_BE                 : std_logic_vector(IPIF_SLV_DWIDTH/8-1 downto 0);
  signal ipif_Bus2IP_CS                 : std_logic_vector((IPIF_ARD_ADDR_RANGE_ARRAY'LENGTH)/2-1 downto 0);
  signal ipif_Bus2IP_RdCE               : std_logic_vector(calc_num_ce(IPIF_ARD_NUM_CE_ARRAY)-1 downto 0);
  signal ipif_Bus2IP_WrCE               : std_logic_vector(calc_num_ce(IPIF_ARD_NUM_CE_ARRAY)-1 downto 0);
  signal ipif_Bus2IP_Data               : std_logic_vector(IPIF_SLV_DWIDTH-1 downto 0);
  signal ipif_Bus2IP_Burst              : std_logic;
  signal ipif_Bus2IP_BurstLength        : std_logic_vector(7 downto 0);
  signal ipif_Bus2IP_WrReq              : std_logic;
  signal ipif_Bus2IP_RdReq              : std_logic;
  signal ipif_IP2Bus_AddrAck            : std_logic;
  signal ipif_IP2Bus_RdAck              : std_logic;
  signal ipif_IP2Bus_WrAck              : std_logic;
  signal ipif_IP2Bus_Error              : std_logic;
  signal ipif_IP2Bus_Data               : std_logic_vector(IPIF_SLV_DWIDTH-1 downto 0);
  signal ipif_Type_of_xfer              : std_logic;
  signal user_Bus2IP_BurstLength        : std_logic_vector(7 downto 0)   := (others => '0');
  signal user_IP2Bus_AddrAck            : std_logic;
  signal user_IP2Bus_Data               : std_logic_vector(USER_SLV_DWIDTH-1 downto 0);
  signal user_IP2Bus_RdAck              : std_logic;
  signal user_IP2Bus_WrAck              : std_logic;
  signal user_IP2Bus_Error              : std_logic;
  signal user_Type_of_xfer              : std_logic;

begin

  ------------------------------------------
  -- instantiate axi_slave_burst
  ------------------------------------------
  AXI_SLAVE_BURST_I : entity axi_slave_burst_v1_00_a.axi_slave_burst
    generic map
    (
      C_S_AXI_DATA_WIDTH             => IPIF_SLV_DWIDTH,
      C_S_AXI_ADDR_WIDTH             => C_S_AXI_ADDR_WIDTH,
      C_S_AXI_ID_WIDTH               => C_S_AXI_ID_WIDTH,
      C_RDATA_FIFO_DEPTH             => C_RDATA_FIFO_DEPTH,
      C_INCLUDE_TIMEOUT_CNT          => C_INCLUDE_TIMEOUT_CNT,
      C_TIMEOUT_CNTR_VAL             => C_TIMEOUT_CNTR_VAL,
      C_ALIGN_BE_RDADDR              => C_ALIGN_BE_RDADDR,
      C_S_AXI_SUPPORTS_WRITE         => C_S_AXI_SUPPORTS_WRITE,
      C_S_AXI_SUPPORTS_READ          => C_S_AXI_SUPPORTS_READ,
      C_ARD_ADDR_RANGE_ARRAY         => IPIF_ARD_ADDR_RANGE_ARRAY,
      C_ARD_NUM_CE_ARRAY             => IPIF_ARD_NUM_CE_ARRAY,
      C_FAMILY                       => C_FAMILY
    )
    port map
    (
      S_AXI_ACLK                     => S_AXI_ACLK,
      S_AXI_ARESETN                  => S_AXI_ARESETN,
      S_AXI_AWADDR                   => S_AXI_AWADDR,
      S_AXI_AWVALID                  => S_AXI_AWVALID,
      S_AXI_WDATA                    => S_AXI_WDATA,
      S_AXI_WSTRB                    => S_AXI_WSTRB,
      S_AXI_WVALID                   => S_AXI_WVALID,
      S_AXI_BREADY                   => S_AXI_BREADY,
      S_AXI_ARADDR                   => S_AXI_ARADDR,
      S_AXI_ARVALID                  => S_AXI_ARVALID,
      S_AXI_RREADY                   => S_AXI_RREADY,
      S_AXI_ARREADY                  => S_AXI_ARREADY,
      S_AXI_RDATA                    => S_AXI_RDATA,
      S_AXI_RRESP                    => S_AXI_RRESP,
      S_AXI_RVALID                   => S_AXI_RVALID,
      S_AXI_WREADY                   => S_AXI_WREADY,
      S_AXI_BRESP                    => S_AXI_BRESP,
      S_AXI_BVALID                   => S_AXI_BVALID,
      S_AXI_AWREADY                  => S_AXI_AWREADY,
      S_AXI_AWID                     => S_AXI_AWID,
      S_AXI_AWLEN                    => S_AXI_AWLEN,
      S_AXI_AWSIZE                   => S_AXI_AWSIZE,
      S_AXI_AWBURST                  => S_AXI_AWBURST,
      S_AXI_AWLOCK                   => S_AXI_AWLOCK,
      S_AXI_AWCACHE                  => S_AXI_AWCACHE,
      S_AXI_AWPROT                   => S_AXI_AWPROT,
      S_AXI_WLAST                    => S_AXI_WLAST,
      S_AXI_BID                      => S_AXI_BID,
      S_AXI_ARID                     => S_AXI_ARID,
      S_AXI_ARLEN                    => S_AXI_ARLEN,
      S_AXI_ARSIZE                   => S_AXI_ARSIZE,
      S_AXI_ARBURST                  => S_AXI_ARBURST,
      S_AXI_ARLOCK                   => S_AXI_ARLOCK,
      S_AXI_ARCACHE                  => S_AXI_ARCACHE,
      S_AXI_ARPROT                   => S_AXI_ARPROT,
      S_AXI_RID                      => S_AXI_RID,
      S_AXI_RLAST                    => S_AXI_RLAST,
      Bus2IP_Clk                     => ipif_Bus2IP_Clk,
      Bus2IP_Resetn                  => ipif_Bus2IP_Resetn,
      Bus2IP_Addr                    => ipif_Bus2IP_Addr,
      Bus2IP_RNW                     => ipif_Bus2IP_RNW,
      Bus2IP_BE                      => ipif_Bus2IP_BE,
      Bus2IP_CS                      => ipif_Bus2IP_CS,
      Bus2IP_RdCE                    => ipif_Bus2IP_RdCE,
      Bus2IP_WrCE                    => ipif_Bus2IP_WrCE,
      Bus2IP_Data                    => ipif_Bus2IP_Data,
      Bus2IP_Burst                   => ipif_Bus2IP_Burst,
      Bus2IP_BurstLength             => ipif_Bus2IP_BurstLength,
      Bus2IP_WrReq                   => ipif_Bus2IP_WrReq,
      Bus2IP_RdReq                   => ipif_Bus2IP_RdReq,
      IP2Bus_AddrAck                 => ipif_IP2Bus_AddrAck,
      IP2Bus_RdAck                   => ipif_IP2Bus_RdAck,
      IP2Bus_WrAck                   => ipif_IP2Bus_WrAck,
      IP2Bus_Error                   => ipif_IP2Bus_Error,
      IP2Bus_Data                    => ipif_IP2Bus_Data,
      Type_of_xfer                   => ipif_Type_of_xfer
    );

  ------------------------------------------
  -- instantiate User Logic
  ------------------------------------------
  USER_LOGIC_I : entity foo_master_v1_00_a.user_logic
    generic map
    (
      -- MAP USER GENERICS BELOW THIS LINE ---------------
      --USER generics mapped here
      C_M_AXI0_ADDR_WIDTH => C_M_AXI0_ADDR_WIDTH,
      C_M_AXI0_DATA_WIDTH => C_M_AXI0_DATA_WIDTH,
      C_M_AXI0_ID_WIDTH => C_M_AXI0_ID_WIDTH,

      C_M_AXI2_ADDR_WIDTH => C_M_AXI2_ADDR_WIDTH,
      C_M_AXI2_DATA_WIDTH => C_M_AXI2_DATA_WIDTH,
      C_M_AXI2_ID_WIDTH => C_M_AXI2_ID_WIDTH,
      -- MAP USER GENERICS ABOVE THIS LINE ---------------

      C_SLV_AWIDTH                   => USER_SLV_AWIDTH,
      C_SLV_DWIDTH                   => USER_SLV_DWIDTH,
      C_NUM_MEM                      => USER_NUM_MEM
    )
    port map
    (
      -- MAP USER PORTS BELOW THIS LINE ------------------
      interrupt                     => interrupt,

      md_error				=> md_error,

      m_axi0_aclk			=> m_axi0_aclk,
      m_axi0_aresetn 			=> m_axi0_aresetn,
      m_axi0_arready			=> m_axi0_arready,
      m_axi0_arvalid			=> m_axi0_arvalid,
      m_axi0_arid			=> m_axi0_arid,
      m_axi0_araddr			=> m_axi0_araddr,
      m_axi0_arlen			=> m_axi0_arlen,
      m_axi0_arsize			=> m_axi0_arsize,
      m_axi0_arburst			=> m_axi0_arburst,
      m_axi0_arprot			=> m_axi0_arprot,
      m_axi0_arcache			=> m_axi0_arcache,
      m_axi0_rready			=> m_axi0_rready,
      m_axi0_rvalid			=> m_axi0_rvalid,
      m_axi0_rid			=> m_axi0_rid,
      m_axi0_rdata			=> m_axi0_rdata,
      m_axi0_rresp			=> m_axi0_rresp,
      m_axi0_rlast			=> m_axi0_rlast,
      m_axi0_awready			=> m_axi0_awready,
      m_axi0_awvalid			=> m_axi0_awvalid,
      m_axi0_awid			=> m_axi0_awid,
      m_axi0_awaddr			=> m_axi0_awaddr,
      m_axi0_awlen			=> m_axi0_awlen,
      m_axi0_awsize			=> m_axi0_awsize,
      m_axi0_awburst			=> m_axi0_awburst,
      m_axi0_awprot			=> m_axi0_awprot,
      m_axi0_awcache			=> m_axi0_awcache,
      m_axi0_wready			=> m_axi0_wready,
      m_axi0_wvalid			=> m_axi0_wvalid,
      m_axi0_wdata			=> m_axi0_wdata,
      m_axi0_wstrb			=> m_axi0_wstrb,
      m_axi0_wlast			=> m_axi0_wlast,
      m_axi0_bready			=> m_axi0_bready,
      m_axi0_bid			=> m_axi0_bid,
      m_axi0_bvalid			=> m_axi0_bvalid,
      m_axi0_bresp			=> m_axi0_bresp,

      m_axi1_aclk			=> m_axi1_aclk,
      m_axi1_aresetn 			=> m_axi1_aresetn,
      m_axi1_arready			=> m_axi1_arready,
      m_axi1_arvalid			=> m_axi1_arvalid,
      m_axi1_arid			=> m_axi1_arid,
      m_axi1_araddr			=> m_axi1_araddr,
      m_axi1_arlen			=> m_axi1_arlen,
      m_axi1_arsize			=> m_axi1_arsize,
      m_axi1_arburst			=> m_axi1_arburst,
      m_axi1_arprot			=> m_axi1_arprot,
      m_axi1_arcache			=> m_axi1_arcache,
      m_axi1_rready			=> m_axi1_rready,
      m_axi1_rvalid			=> m_axi1_rvalid,
      m_axi1_rid			=> m_axi1_rid,
      m_axi1_rdata			=> m_axi1_rdata,
      m_axi1_rresp			=> m_axi1_rresp,
      m_axi1_rlast			=> m_axi1_rlast,
      m_axi1_awready			=> m_axi1_awready,
      m_axi1_awvalid			=> m_axi1_awvalid,
      m_axi1_awid			=> m_axi1_awid,
      m_axi1_awaddr			=> m_axi1_awaddr,
      m_axi1_awlen			=> m_axi1_awlen,
      m_axi1_awsize			=> m_axi1_awsize,
      m_axi1_awburst			=> m_axi1_awburst,
      m_axi1_awprot			=> m_axi1_awprot,
      m_axi1_awcache			=> m_axi1_awcache,
      m_axi1_wready			=> m_axi1_wready,
      m_axi1_wvalid			=> m_axi1_wvalid,
      m_axi1_wdata			=> m_axi1_wdata,
      m_axi1_wstrb			=> m_axi1_wstrb,
      m_axi1_wlast			=> m_axi1_wlast,
      m_axi1_bready			=> m_axi1_bready,
      m_axi1_bid			=> m_axi1_bid,
      m_axi1_bvalid			=> m_axi1_bvalid,
      m_axi1_bresp			=> m_axi1_bresp,

      m_axi2_aclk			=> m_axi2_aclk,
      m_axi2_aresetn 			=> m_axi2_aresetn,
      m_axi2_arready			=> m_axi2_arready,
      m_axi2_arvalid			=> m_axi2_arvalid,
      m_axi2_arid			=> m_axi2_arid,
      m_axi2_araddr			=> m_axi2_araddr,
      m_axi2_arlen			=> m_axi2_arlen,
      m_axi2_arsize			=> m_axi2_arsize,
      m_axi2_arburst			=> m_axi2_arburst,
      m_axi2_arprot			=> m_axi2_arprot,
      m_axi2_arcache			=> m_axi2_arcache,
      m_axi2_rready			=> m_axi2_rready,
      m_axi2_rvalid			=> m_axi2_rvalid,
      m_axi2_rid			=> m_axi2_rid,
      m_axi2_rdata			=> m_axi2_rdata,
      m_axi2_rresp			=> m_axi2_rresp,
      m_axi2_rlast			=> m_axi2_rlast,
      m_axi2_awready			=> m_axi2_awready,
      m_axi2_awvalid			=> m_axi2_awvalid,
      m_axi2_awid			=> m_axi2_awid,
      m_axi2_awaddr			=> m_axi2_awaddr,
      m_axi2_awlen			=> m_axi2_awlen,
      m_axi2_awsize			=> m_axi2_awsize,
      m_axi2_awburst			=> m_axi2_awburst,
      m_axi2_awprot			=> m_axi2_awprot,
      m_axi2_awcache			=> m_axi2_awcache,
      m_axi2_wready			=> m_axi2_wready,
      m_axi2_wvalid			=> m_axi2_wvalid,
      m_axi2_wdata			=> m_axi2_wdata,
      m_axi2_wstrb			=> m_axi2_wstrb,
      m_axi2_wlast			=> m_axi2_wlast,
      m_axi2_bready			=> m_axi2_bready,
      m_axi2_bid			=> m_axi2_bid,
      m_axi2_bvalid			=> m_axi2_bvalid,
      m_axi2_bresp			=> m_axi2_bresp,

      -- MAP USER PORTS ABOVE THIS LINE ------------------

      Bus2IP_Clk                     => ipif_Bus2IP_Clk,
      Bus2IP_Resetn                  => ipif_Bus2IP_Resetn,
      Bus2IP_Addr                    => ipif_Bus2IP_Addr,
      Bus2IP_CS                      => ipif_Bus2IP_CS(USER_NUM_MEM-1 downto 0),
      Bus2IP_RNW                     => ipif_Bus2IP_RNW,
      Bus2IP_Data                    => ipif_Bus2IP_Data,
      Bus2IP_BE                      => ipif_Bus2IP_BE,
      Bus2IP_RdCE                    => ipif_Bus2IP_RdCE,
      Bus2IP_WrCE                    => ipif_Bus2IP_WrCE,
      Bus2IP_Burst                   => ipif_Bus2IP_Burst,
      Bus2IP_BurstLength             => user_Bus2IP_BurstLength,
      Bus2IP_RdReq                   => ipif_Bus2IP_RdReq,
      Bus2IP_WrReq                   => ipif_Bus2IP_WrReq,
      IP2Bus_AddrAck                 => user_IP2Bus_AddrAck,
      IP2Bus_Data                    => user_IP2Bus_Data,
      IP2Bus_RdAck                   => user_IP2Bus_RdAck,
      IP2Bus_WrAck                   => user_IP2Bus_WrAck,
      IP2Bus_Error                   => user_IP2Bus_Error,
      Type_of_xfer                   => user_Type_of_xfer
    );

  ------------------------------------------
  -- connect internal signals
  ------------------------------------------

  ipif_IP2Bus_Data <= user_IP2Bus_Data;
  ipif_IP2Bus_AddrAck <= user_IP2Bus_AddrAck;
  ipif_IP2Bus_WrAck <= user_IP2Bus_WrAck;
  ipif_IP2Bus_RdAck <= user_IP2Bus_RdAck;
  ipif_IP2Bus_Error <= user_IP2Bus_Error;

  user_Bus2IP_BurstLength(7 downto 0)<= ipif_Bus2IP_BurstLength(7 downto 0);

end IMP;
