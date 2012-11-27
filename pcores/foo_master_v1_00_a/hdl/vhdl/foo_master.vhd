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
-- Date:              Wed Nov 21 14:38:14 2012 (by Create and Import Peripheral Wizard)
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

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_S_AXI_DATA_WIDTH           -- AXI4 slave: Data Width
--   C_S_AXI_ADDR_WIDTH           -- AXI4 slave: Address Width
--   C_S_AXI_ID_WIDTH             -- AXI4 slave: ID Width
--   C_RDATA_FIFO_DEPTH           -- AXI4 slave: FIFO Depth
--   C_INCLUDE_TIMEOUT_CNT        -- AXI4 slave: Data Timeout Count
--   C_TIMEOUT_CNTR_VAL           -- AXI4 slave: Timeout Counter Value
--   C_ALIGN_BE_RDADDR            -- AXI4 slave: Align Byte Enable read Data Address
--   C_S_AXI_SUPPORTS_WRITE       -- AXI4 slave: Support Write
--   C_S_AXI_SUPPORTS_READ        -- AXI4 slave: Support Read
--   C_FAMILY                     -- FPGA Family
--   C_S_AXI_MEM0_BASEADDR        -- User memory space 0 base address
--   C_S_AXI_MEM0_HIGHADDR        -- User memory space 0 high address
--   C_NUM_MEM                    -- Number of address-ranges

--   C_M_AXI_ADDR_WIDTH           -- Master-Intf address bus width
--   C_M_AXI_DATA_WIDTH           -- Master-Intf data bus width
--   C_MAX_BURST_LEN              -- Max no. of data-beats allowed in burst
--   C_NATIVE_DATA_WIDTH          -- Internal bus width on user-side
--   C_LENGTH_WIDTH               -- Master interface data bus width
--   C_ADDR_PIPE_DEPTH            -- Depth of Address pipelining
--
-- Definition of Ports:
--   S_AXI_ACLK                   -- AXI4LITE slave: Clock 
--   S_AXI_ARESETN                -- AXI4LITE slave: Reset
--   S_AXI_AWADDR                 -- AXI4LITE slave: Write address
--   S_AXI_AWVALID                -- AXI4LITE slave: Write address valid
--   S_AXI_WDATA                  -- AXI4LITE slave: Write data
--   S_AXI_WSTRB                  -- AXI4LITE slave: Write strobe
--   S_AXI_WVALID                 -- AXI4LITE slave: Write data valid
--   S_AXI_BREADY                 -- AXI4LITE slave: Response ready
--   S_AXI_ARADDR                 -- AXI4LITE slave: Read address
--   S_AXI_ARVALID                -- AXI4LITE slave: Read address valid
--   S_AXI_RREADY                 -- AXI4LITE slave: Read data ready
--   S_AXI_ARREADY                -- AXI4LITE slave: read addres ready
--   S_AXI_RDATA                  -- AXI4LITE slave: Read data
--   S_AXI_RRESP                  -- AXI4LITE slave: Read data response
--   S_AXI_RVALID                 -- AXI4LITE slave: Read data valid
--   S_AXI_WREADY                 -- AXI4LITE slave: Write data ready
--   S_AXI_BRESP                  -- AXI4LITE slave: Response
--   S_AXI_BVALID                 -- AXI4LITE slave: Resonse valid
--   S_AXI_AWREADY                -- AXI4LITE slave: Wrte address ready
--   m_axi_aclk                   -- AXI4 master: Clock
--   m_axi_aresetn                -- AXI4 master: Reset
--   md_error                     -- AXI4 master: Error
--   m_axi_arready                -- AXI4 master: read address ready
--   m_axi_arvalid                -- AXI4 master: read address valid
--   m_axi_araddr                 -- AXI4 master: read address
--   m_axi_arlen                  -- AXI4 master: read adress length
--   m_axi_arsize                 -- AXI4 master: read address size
--   m_axi_arburst                -- AXI4 master: read address burst
--   m_axi_arprot                 -- AXI4 master: read address protection
--   m_axi_arcache                -- AXI4 master: read adddress cache
--   m_axi_rready                 -- AXI4 master: read data ready
--   m_axi_rvalid                 -- AXI4 master: read data valid
--   m_axi_rdata                  -- AXI4 master: read data
--   m_axi_rresp                  -- AXI4 master: read data response
--   m_axi_rlast                  -- AXI4 master: read data last
--   m_axi_awready                -- AXI4 master: write address ready
--   m_axi_awvalid                -- AXI4 master: write address valid
--   m_axi_awaddr                 -- AXI4 master: write address
--   m_axi_awlen                  -- AXI4 master: write address length
--   m_axi_awsize                 -- AXI4 master: write address size
--   m_axi_awburst                -- AXI4 master: write address burst
--   m_axi_awprot                 -- AXI4 master: write address protection
--   m_axi_awcache                -- AXI4 master: write address cache
--   m_axi_wready                 -- AXI4 master: write data ready
--   m_axi_wvalid                 -- AXI4 master: write data valid
--   m_axi_wdata                  -- AXI4 master: write data 
--   m_axi_wstrb                  -- AXI4 master: write data strobe
--   m_axi_wlast                  -- AXI4 master: write data last
--   m_axi_bready                 -- AXI4 master: read response ready
--   m_axi_bvalid                 -- AXI4 master: read response valid
--   m_axi_bresp                  -- AXI4 master: read response 
------------------------------------------------------------------------------

entity foo_master is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
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
    C_S_AXI_MEM0_BASEADDR          : std_logic_vector     := X"FFFFFFFF";
    C_S_AXI_MEM0_HIGHADDR          : std_logic_vector     := X"00000000";
    C_USE_WSTRB                    : integer              := 0;
    C_DPHASE_TIMEOUT               : integer              := 8;
    C_FAMILY                       : string               := "virtex6";
    C_NUM_REG                      : integer              := 0;
    C_NUM_MEM                      : integer              := 1;
    C_SLV_AWIDTH                   : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32;
    C_M_AXI_ADDR_WIDTH             : integer              := 32;
    C_M_AXI_DATA_WIDTH             : integer              := 32;
    C_MAX_BURST_LEN                : integer              := 16;
    C_NATIVE_DATA_WIDTH            : integer              := 32;
    C_LENGTH_WIDTH                 : integer              := 12;
    C_ADDR_PIPE_DEPTH              : integer              := 1
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

    m_axi_aclk                     : in  std_logic;
    m_axi_aresetn                  : in  std_logic;
    md_error                       : out std_logic;
    m_axi_arready                  : in  std_logic;
    m_axi_arvalid                  : out std_logic;
    m_axi_araddr                   : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    m_axi_arlen                    : out std_logic_vector(7 downto 0);
    m_axi_arsize                   : out std_logic_vector(2 downto 0);
    m_axi_arburst                  : out std_logic_vector(1 downto 0);
    m_axi_arprot                   : out std_logic_vector(2 downto 0);
    m_axi_arcache                  : out std_logic_vector(3 downto 0);
    m_axi_rready                   : out std_logic;
    m_axi_rvalid                   : in  std_logic;
    m_axi_rdata                    : in  std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    m_axi_rresp                    : in  std_logic_vector(1 downto 0);
    m_axi_rlast                    : in  std_logic;
    m_axi_awready                  : in  std_logic;
    m_axi_awvalid                  : out std_logic;
    m_axi_awaddr                   : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    m_axi_awlen                    : out std_logic_vector(7 downto 0);
    m_axi_awsize                   : out std_logic_vector(2 downto 0);
    m_axi_awburst                  : out std_logic_vector(1 downto 0);
    m_axi_awprot                   : out std_logic_vector(2 downto 0);
    m_axi_awcache                  : out std_logic_vector(3 downto 0);
    m_axi_wready                   : in  std_logic;
    m_axi_wvalid                   : out std_logic;
    m_axi_wdata                    : out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    m_axi_wstrb                    : out std_logic_vector((C_M_AXI_DATA_WIDTH)/8 - 1 downto 0);
    m_axi_wlast                    : out std_logic;
    m_axi_bready                   : out std_logic;
    m_axi_bvalid                   : in  std_logic;
    m_axi_bresp                    : in  std_logic_vector(1 downto 0)
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;
  attribute MAX_FANOUT of S_AXI_ACLK       : signal is "10000";
  attribute MAX_FANOUT of S_AXI_ARESETN       : signal is "10000";
  attribute SIGIS of S_AXI_ACLK       : signal is "Clk";
  attribute SIGIS of S_AXI_ARESETN       : signal is "Rst";

  attribute MAX_FANOUT of m_axi_aclk       : signal is "10000";
  attribute MAX_FANOUT of m_axi_aresetn       : signal is "10000";
  attribute SIGIS of m_axi_aclk       : signal is "Clk";
  attribute SIGIS of m_axi_aresetn       : signal is "Rst";
end entity foo_master;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of foo_master is

  constant USER_SLV_DWIDTH                : integer              := C_S_AXI_DATA_WIDTH;

  constant IPIF_SLV_DWIDTH                : integer              := C_S_AXI_DATA_WIDTH;

  constant ZERO_ADDR_PAD                  : std_logic_vector(0 to 31) := (others => '0');
  constant USER_MST_BASEADDR              : std_logic_vector     := C_S_AXI_MEM0_BASEADDR or X"00000000";
  constant USER_MST_HIGHADDR              : std_logic_vector     := C_S_AXI_MEM0_HIGHADDR or X"000000FF";

  constant IPIF_ARD_ADDR_RANGE_ARRAY      : SLV64_ARRAY_TYPE     := 
    (
      ZERO_ADDR_PAD & USER_MST_BASEADDR,  -- user logic master space base address
      ZERO_ADDR_PAD & USER_MST_HIGHADDR   -- user logic master space high address
    );

  constant USER_MST_NUM_REG               : integer              := 4;
  constant USER_NUM_REG                   : integer              := USER_MST_NUM_REG;
  constant TOTAL_IPIF_CE                  : integer              := USER_NUM_REG;

  constant IPIF_ARD_NUM_CE_ARRAY          : INTEGER_ARRAY_TYPE   := 
    (
      0  =>  USER_MST_NUM_REG             -- number of ce for user logic master space
    );

  ------------------------------------------
  -- Width of the master address bus (32 only)
  ------------------------------------------
  constant USER_MST_AWIDTH                : integer              := C_M_AXI_ADDR_WIDTH;

  ------------------------------------------
  -- Width of the master data bus 
  ------------------------------------------
  constant USER_MST_DWIDTH                : integer              := C_M_AXI_DATA_WIDTH;

  ------------------------------------------
  -- Width of data-bus going to user-logic
  ------------------------------------------
  constant USER_MST_NATIVE_DATA_WIDTH     : integer              := C_NATIVE_DATA_WIDTH;

  ------------------------------------------
  -- Width of the master data bus (12-20 )
  ------------------------------------------
  constant USER_LENGTH_WIDTH              : integer              := C_LENGTH_WIDTH;

  ------------------------------------------
  -- Index for CS/CE
  ------------------------------------------
  constant USER_MST_CS_INDEX              : integer              := 0;
  constant USER_MST_CE_INDEX              : integer              := calc_start_ce_index(IPIF_ARD_NUM_CE_ARRAY, USER_MST_CS_INDEX);

  constant USER_CE_INDEX                  : integer              := USER_MST_CE_INDEX;

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

  signal mem_read_ack                   : std_logic;
  signal mem_write_ack                  : std_logic;

  signal ip_slave_d : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal ip_slave_rdy_put : std_logic;
  signal ip_slave_rdy_get : std_logic;
  signal ip_slave_en_put : std_logic;
  signal ip_slave_en_get : std_logic;

begin

  ------------------------------------------
  -- instantiate axi_lite_ipif
  ------------------------------------------
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

   IP_SLAVE_WITH_MASTER : entity mkIpSlaveWithMaster
     port map (CLK => m_axi_aclk,
           RST_N => m_axi_aresetn,

           put_addr => ipif_Bus2IP_Addr(11 downto 0),
           put_v    => ipif_Bus2IP_Data,
           EN_put   => ip_slave_en_put,
           RDY_put  => ip_slave_rdy_put,

           get_addr => ipif_Bus2IP_Addr(11 downto 0),
           EN_get   => ip_slave_en_get,
           get      => ip_slave_d,
           RDY_get  => ip_slave_rdy_get,

           --error    => ,
           --RDY_error,

           EN_axi_writeAddr => m_axi_awready,
           axi_writeAddr => m_axi_awaddr,
           RDY_axi_writeAddr => m_axi_awvalid,

           axi_writeBurstLen => m_axi_awlen,
           --RDY_axi_writeBurstLen,

           axi_writeBurstWidth => m_axi_awsize,
           -- RDY_axi_writeBurstWidth,

           axi_writeBurstType => m_axi_awburst,
           --RDY_axi_writeBurstType,

           axi_writeBurstProt => m_axi_awprot,
           --RDY_axi_writeBurstProt,

           axi_writeBurstCache => m_axi_awcache,
           --RDY_axi_writeBurstCache,

           EN_axi_writeData => m_axi_wready,
           axi_writeData => m_axi_wdata,
           RDY_axi_writeData => m_axi_wvalid,

           axi_writeDataByteEnable => m_axi_wstrb,
           --RDY_axi_writeDataByteEnable, 

           axi_writeLastDataBeat => m_axi_wlast,
           --RDY_axi_writeLastDataBeat,

           axi_writeResponse_responseCode => m_axi_bresp,
           EN_axi_writeResponse           => m_axi_bvalid,
           RDY_axi_writeResponse          => m_axi_bready);



  ------------------------------------------
  -- connect internal signals
  ------------------------------------------

  ipif_IP2Bus_Data  <= ip_slave_d when mem_read_ack = '1' else
                       (others => '0');

  ipif_IP2Bus_AddrAck <= mem_write_ack or mem_read_ack;
  ipif_IP2Bus_WrAck <= mem_write_ack;
  ipif_IP2Bus_RdAck <= mem_read_ack;
  ipif_IP2Bus_Error <= '0';

  ip_slave_en_put <= ipif_Bus2IP_CS(0) and ipif_Bus2IP_WrCE(0);
  ip_slave_en_get <= ipif_Bus2IP_CS(0) and ipif_Bus2IP_RdCE(0);

  mem_read_ack    <= ip_slave_en_get and ip_slave_rdy_get;
  mem_write_ack   <= ip_slave_en_put and ip_slave_rdy_put;

  -- no M_AXI reads
  m_axi_arvalid <= '0';
  m_axi_araddr <= "00000000000000000000000000000000";
  m_axi_arlen <= "00000000";
  m_axi_arsize <= "000";
  m_axi_arburst <= "00";
  m_axi_arprot <= "000";
  m_axi_arcache <= "0000";
  m_axi_rready <= '0';

end IMP;
