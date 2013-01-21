------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair
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
-- Filename:          user_logic.vhd
-- Version:           1.00.a
-- Description:       User logic.
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

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    C_M_AXI0_ADDR_WIDTH : integer := 32;
    C_M_AXI0_DATA_WIDTH : integer := 64;
    C_M_AXI0_ID_WIDTH : integer := 1;

    C_M_AXI1_ADDR_WIDTH : integer := 32;
    C_M_AXI1_DATA_WIDTH : integer := 64;
    C_M_AXI1_ID_WIDTH : integer := 1;

    C_M_AXI2_ADDR_WIDTH : integer := 32;
    C_M_AXI2_DATA_WIDTH : integer := 64;
    C_M_AXI2_ID_WIDTH : integer := 1;
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_SLV_AWIDTH                   : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32;
    C_NUM_MEM                      : integer              := 2
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    interrupt                      : out std_logic;

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
    m_axi2_bresp                    : in  std_logic_vector(1 downto 0);

    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Resetn                  : in  std_logic;
    Bus2IP_Addr                    : in  std_logic_vector(C_SLV_AWIDTH-1 downto 0);
    Bus2IP_CS                      : in  std_logic_vector(C_NUM_MEM-1 downto 0);
    Bus2IP_RNW                     : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    Bus2IP_BE                      : in  std_logic_vector(C_SLV_DWIDTH/8-1 downto 0);
    Bus2IP_RdCE                    : in  std_logic_vector(C_NUM_MEM-1 downto 0);
    Bus2IP_WrCE                    : in  std_logic_vector(C_NUM_MEM-1 downto 0);
    Bus2IP_Burst                   : in  std_logic;
    Bus2IP_BurstLength             : in  std_logic_vector(7 downto 0);
    Bus2IP_RdReq                   : in  std_logic;
    Bus2IP_WrReq                   : in  std_logic;
    IP2Bus_AddrAck                 : out std_logic;
    IP2Bus_Data                    : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic;
    Type_of_xfer                   : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  --USER signal declarations added here, as needed for user logic

  ------------------------------------------
  -- Signals for user logic memory space example
  ------------------------------------------
  type BYTE_RAM_TYPE is array (0 to 255) of std_logic_vector(7 downto 0);
  type DO_TYPE is array (0 to C_NUM_MEM-1) of std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal mem_data_out                   : DO_TYPE;
  signal mem_address                    : std_logic_vector(7 downto 0);
  signal mem_select                     : std_logic_vector(0 to 0);
  signal mem_read_ack                   : std_logic;
  signal mem_write_ack                  : std_logic;

  signal ctrl_get_d : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal fifo_get_d : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal WILL_FIRE_ctrl_put : std_logic;
  signal RDY_ctrl_put : std_logic;
  signal WILL_FIRE_ctrl_get : std_logic;
  signal RDY_ctrl_get : std_logic;

  signal WILL_FIRE_fifo_put : std_logic;
  signal RDY_fifo_put : std_logic;
  signal WILL_FIRE_fifo_get : std_logic;
  signal RDY_fifo_get : std_logic;

  signal RDY_axi0w_writeAddr : std_logic;
  signal RDY_axi0w_writeData : std_logic;
  signal RDY_axi0w_writeResponse : std_logic;
  signal RDY_axi0r_readAddr : std_logic;
  signal RDY_axi0r_readData : std_logic;
  signal WILL_FIRE_axi0w_writeAddr : std_logic;
  signal WILL_FIRE_axi0w_writeData : std_logic;
  signal WILL_FIRE_axi0w_writeResponse : std_logic;
  signal WILL_FIRE_axi0r_readAddr : std_logic;
  signal WILL_FIRE_axi0r_readData : std_logic;

  signal RDY_axi1w_writeAddr : std_logic;
  signal RDY_axi1w_writeData : std_logic;
  signal RDY_axi1w_writeResponse : std_logic;
  signal RDY_axi1r_readAddr : std_logic;
  signal RDY_axi1r_readData : std_logic;
  signal WILL_FIRE_axi1w_writeAddr : std_logic;
  signal WILL_FIRE_axi1w_writeData : std_logic;
  signal WILL_FIRE_axi1w_writeResponse : std_logic;
  signal WILL_FIRE_axi1r_readAddr : std_logic;
  signal WILL_FIRE_axi1r_readData : std_logic;

  signal RDY_axi2w_writeAddr : std_logic;
  signal RDY_axi2w_writeData : std_logic;
  signal RDY_axi2w_writeResponse : std_logic;
  signal RDY_axi2r_readAddr : std_logic;
  signal RDY_axi2r_readData : std_logic;
  signal WILL_FIRE_axi2w_writeAddr : std_logic;
  signal WILL_FIRE_axi2w_writeData : std_logic;
  signal WILL_FIRE_axi2w_writeResponse : std_logic;
  signal WILL_FIRE_axi2r_readAddr : std_logic;
  signal WILL_FIRE_axi2r_readData : std_logic;

begin

  --USER logic implementation added here

  ------------------------------------------
  -- Example code to access user logic memory region
  -- 
  -- Note:
  -- The example code presented here is to show you one way of using
  -- the user logic memory space features. The Bus2IP_Addr, Bus2IP_CS,
  -- and Bus2IP_RNW IPIC signals are dedicated to these user logic
  -- memory spaces. Each user logic memory space has its own address
  -- range and is allocated one bit on the Bus2IP_CS signal to indicated
  -- selection of that memory space. Typically these user logic memory
  -- spaces are used to implement memory controller type cores, but it
  -- can also be used in cores that need to access additional address space
  -- (non C_BASEADDR based), s.t. bridges. This code snippet infers
  -- 1 256x32-bit (byte accessible) single-port Block RAM by XST.
  ------------------------------------------

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data  <= ctrl_get_d when WILL_FIRE_ctrl_get = '1' else
                  fifo_get_d when WILL_FIRE_fifo_get = '1' else
                  (others => '0');

  IP2Bus_AddrAck <= mem_write_ack or mem_read_ack;
  IP2Bus_WrAck <= mem_write_ack;
  IP2Bus_RdAck <= mem_read_ack;
  IP2Bus_Error <= '0';

  WILL_FIRE_ctrl_put <= Bus2IP_CS(0) and Bus2IP_WrCE(0) and RDY_ctrl_put;
  WILL_FIRE_ctrl_get <= Bus2IP_CS(0) and Bus2IP_RdCE(0) and RDY_ctrl_get;
  WILL_FIRE_fifo_put <= Bus2IP_CS(1) and Bus2IP_WrCE(1) and RDY_fifo_put;
  WILL_FIRE_fifo_get <= Bus2IP_CS(1) and Bus2IP_RdCE(1) and RDY_fifo_get;

  mem_read_ack    <= WILL_FIRE_ctrl_get or WILL_FIRE_fifo_get;
  mem_write_ack   <= WILL_FIRE_ctrl_put or WILL_FIRE_fifo_put;

  IP_SLAVE : entity mkFoo
    port map (
      CLK_axi_clk => m_axi0_aclk,
      CLK => Bus2IP_Clk,
      RST_N  => Bus2IP_Resetn,

      ctrl_put_addr => Bus2IP_Addr(11 downto 0),
      ctrl_put_v => Bus2IP_Data,
      EN_ctrl_put => WILL_FIRE_ctrl_put,
      RDY_ctrl_put => RDY_ctrl_put,

      ctrl_get_addr => Bus2IP_Addr(11 downto 0),
      EN_ctrl_get => WILL_FIRE_ctrl_get,
      ctrl_get => ctrl_get_d,
      RDY_ctrl_get => RDY_ctrl_get,

      fifo_put_addr => Bus2IP_Addr(11 downto 0),
      fifo_put_v => Bus2IP_Data,
      EN_fifo_put => WILL_FIRE_fifo_put,
      RDY_fifo_put => RDY_fifo_put,

      fifo_get_addr => Bus2IP_Addr(11 downto 0),
      EN_fifo_get => WILL_FIRE_fifo_get,
      fifo_get => fifo_get_d,
      RDY_fifo_get => RDY_fifo_get,

      interrupt => interrupt,

      EN_axi0w_writeAddr => WILL_FIRE_axi0w_writeAddr,
      axi0w_writeAddr => m_axi0_awaddr,
      axi0w_writeId => m_axi0_awid(0),
      RDY_axi0w_writeAddr => RDY_axi0w_writeAddr,

      axi0w_writeBurstLen => m_axi0_awlen,
      -- RDY_axi0w_writeBurstLen,

      axi0w_writeBurstWidth => m_axi0_awsize,
      -- RDY_axi0w_writeBurstWidth,

      axi0w_writeBurstType => m_axi0_awburst,
      -- RDY_axi0w_writeBurstType,

      axi0w_writeBurstProt => m_axi0_awprot,
      -- RDY_axi0w_writeBurstProt,

      axi0w_writeBurstCache => m_axi0_awcache,
      -- RDY_axi0w_writeBurstCache,

      EN_axi0w_writeData => WILL_FIRE_axi0w_writeData,
      axi0w_writeData => m_axi0_wdata,
      RDY_axi0w_writeData => RDY_axi0w_writeData,

      axi0w_writeDataByteEnable => m_axi0_wstrb,
      -- RDY_axi0w_writeDataByteEnable,

      axi0w_writeLastDataBeat => m_axi0_wlast,
      -- RDY_axi0w_writeLastDataBeat,

      EN_axi0w_writeResponse => WILL_FIRE_axi0w_writeResponse,
      axi0w_writeResponse_responseCode => m_axi0_bresp,
      axi0w_writeResponse_id => m_axi0_bid(0),
      RDY_axi0w_writeResponse => RDY_axi0w_writeResponse,

      EN_axi0r_readAddr => WILL_FIRE_axi0r_readAddr,
      axi0r_readId => m_axi0_arid(0),
      axi0r_readAddr => m_axi0_araddr,
      RDY_axi0r_readAddr => RDY_axi0r_readAddr,

      axi0r_readBurstLen => m_axi0_arlen,
      -- RDY_axi0r_readBurstLen,

      axi0r_readBurstWidth => m_axi0_arsize,
      -- RDY_axi0r_readBurstWidth,

      axi0r_readBurstType => m_axi0_arburst,
      -- RDY_axi0r_readBurstType,

      axi0r_readBurstProt => m_axi0_arprot,
      -- RDY_axi0r_readBurstProt,

      axi0r_readBurstCache => m_axi0_arcache,
      -- RDY_axi0r_readBurstCache,

      axi0r_readData_data => m_axi0_rdata,
      axi0r_readData_resp => m_axi0_rresp,
      axi0r_readData_last => m_axi0_rlast,
      axi0r_readData_id => m_axi0_rid(0),
      EN_axi0r_readData => WILL_FIRE_axi0r_readData,
      RDY_axi0r_readData => RDY_axi0r_readData,

      EN_axi1w_writeAddr => WILL_FIRE_axi1w_writeAddr,
      axi1w_writeAddr => m_axi1_awaddr,
      axi1w_writeId => m_axi1_awid(0),
      RDY_axi1w_writeAddr => RDY_axi1w_writeAddr,

      axi1w_writeBurstLen => m_axi1_awlen,
      -- RDY_axi1w_writeBurstLen,

      axi1w_writeBurstWidth => m_axi1_awsize,
      -- RDY_axi1w_writeBurstWidth,

      axi1w_writeBurstType => m_axi1_awburst,
      -- RDY_axi1w_writeBurstType,

      axi1w_writeBurstProt => m_axi1_awprot,
      -- RDY_axi1w_writeBurstProt,

      axi1w_writeBurstCache => m_axi1_awcache,
      -- RDY_axi1w_writeBurstCache,

      EN_axi1w_writeData => WILL_FIRE_axi1w_writeData,
      axi1w_writeData => m_axi1_wdata,
      RDY_axi1w_writeData => RDY_axi1w_writeData,

      axi1w_writeDataByteEnable => m_axi1_wstrb,
      -- RDY_axi1w_writeDataByteEnable,

      axi1w_writeLastDataBeat => m_axi1_wlast,
      -- RDY_axi1w_writeLastDataBeat,

      EN_axi1w_writeResponse => WILL_FIRE_axi1w_writeResponse,
      axi1w_writeResponse_responseCode => m_axi1_bresp,
      axi1w_writeResponse_id => m_axi1_bid(0),
      RDY_axi1w_writeResponse => RDY_axi1w_writeResponse,

      EN_axi1r_readAddr => WILL_FIRE_axi1r_readAddr,
      axi1r_readId => m_axi1_arid(0),
      axi1r_readAddr => m_axi1_araddr,
      RDY_axi1r_readAddr => RDY_axi1r_readAddr,

      axi1r_readBurstLen => m_axi1_arlen,
      -- RDY_axi1r_readBurstLen,

      axi1r_readBurstWidth => m_axi1_arsize,
      -- RDY_axi1r_readBurstWidth,

      axi1r_readBurstType => m_axi1_arburst,
      -- RDY_axi1r_readBurstType,

      axi1r_readBurstProt => m_axi1_arprot,
      -- RDY_axi1r_readBurstProt,

      axi1r_readBurstCache => m_axi1_arcache,
      -- RDY_axi1r_readBurstCache,

      axi1r_readData_data => m_axi1_rdata,
      axi1r_readData_resp => m_axi1_rresp,
      axi1r_readData_last => m_axi1_rlast,
      axi1r_readData_id => m_axi1_rid(0),
      EN_axi1r_readData => WILL_FIRE_axi1r_readData,
      RDY_axi1r_readData => RDY_axi1r_readData,

      EN_axi2w_writeAddr => WILL_FIRE_axi2w_writeAddr,
      axi2w_writeAddr => m_axi2_awaddr,
      axi2w_writeId => m_axi2_awid(0),
      RDY_axi2w_writeAddr => RDY_axi2w_writeAddr,

      axi2w_writeBurstLen => m_axi2_awlen,
      -- RDY_axi2w_writeBurstLen,

      axi2w_writeBurstWidth => m_axi2_awsize,
      -- RDY_axi2w_writeBurstWidth,

      axi2w_writeBurstType => m_axi2_awburst,
      -- RDY_axi2w_writeBurstType,

      axi2w_writeBurstProt => m_axi2_awprot,
      -- RDY_axi2w_writeBurstProt,

      axi2w_writeBurstCache => m_axi2_awcache,
      -- RDY_axi2w_writeBurstCache,

      EN_axi2w_writeData => WILL_FIRE_axi2w_writeData,
      axi2w_writeData => m_axi2_wdata,
      RDY_axi2w_writeData => RDY_axi2w_writeData,

      axi2w_writeDataByteEnable => m_axi2_wstrb,
      -- RDY_axi2w_writeDataByteEnable,

      axi2w_writeLastDataBeat => m_axi2_wlast,
      -- RDY_axi2w_writeLastDataBeat,

      EN_axi2w_writeResponse => WILL_FIRE_axi2w_writeResponse,
      axi2w_writeResponse_responseCode => m_axi2_bresp,
      axi2w_writeResponse_id => m_axi2_bid(0),
      RDY_axi2w_writeResponse => RDY_axi2w_writeResponse,

      EN_axi2r_readAddr => WILL_FIRE_axi2r_readAddr,
      axi2r_readId => m_axi2_arid(0),
      axi2r_readAddr => m_axi2_araddr,
      RDY_axi2r_readAddr => RDY_axi2r_readAddr,

      axi2r_readBurstLen => m_axi2_arlen,
      -- RDY_axi2r_readBurstLen,

      axi2r_readBurstWidth => m_axi2_arsize,
      -- RDY_axi2r_readBurstWidth,

      axi2r_readBurstType => m_axi2_arburst,
      -- RDY_axi2r_readBurstType,

      axi2r_readBurstProt => m_axi2_arprot,
      -- RDY_axi2r_readBurstProt,

      axi2r_readBurstCache => m_axi2_arcache,
      -- RDY_axi2r_readBurstCache,

      axi2r_readData_data => m_axi2_rdata,
      axi2r_readData_resp => m_axi2_rresp,
      axi2r_readData_last => m_axi2_rlast,
      axi2r_readData_id => m_axi2_rid(0),
      EN_axi2r_readData => WILL_FIRE_axi2r_readData,
      RDY_axi2r_readData => RDY_axi2r_readData
      );

  -- scheduler
  WILL_FIRE_axi0r_readAddr <= (m_axi0_arready and RDY_axi0r_readAddr);
  WILL_FIRE_axi0r_readData <= (m_axi0_rvalid and RDY_axi0r_readData);
  m_axi0_arvalid <= RDY_axi0r_readAddr;
  m_axi0_rready <= RDY_axi0r_readData;

  WILL_FIRE_axi0w_writeAddr <= (m_axi0_awready and RDY_axi0w_writeAddr);
  WILL_FIRE_axi0w_writeData <= (m_axi0_wready and RDY_axi0w_writeData);
  WILL_FIRE_axi0w_writeResponse <= (m_axi0_bvalid and RDY_axi0w_writeResponse);
  m_axi0_awvalid <= RDY_axi0w_writeAddr;
  m_axi0_wvalid <= RDY_axi0w_writeData;
  m_axi0_bready <= RDY_axi0w_writeResponse;


  WILL_FIRE_axi1r_readAddr <= (m_axi1_arready and RDY_axi1r_readAddr);
  WILL_FIRE_axi1r_readData <= (m_axi1_rvalid and RDY_axi1r_readData);
  m_axi1_arvalid <= RDY_axi1r_readAddr;
  m_axi1_rready <= RDY_axi1r_readData;

  WILL_FIRE_axi1w_writeAddr <= (m_axi1_awready and RDY_axi1w_writeAddr);
  WILL_FIRE_axi1w_writeData <= (m_axi1_wready and RDY_axi1w_writeData);
  WILL_FIRE_axi1w_writeResponse <= (m_axi1_bvalid and RDY_axi1w_writeResponse);
  m_axi1_awvalid <= RDY_axi1w_writeAddr;
  m_axi1_wvalid <= RDY_axi1w_writeData;
  m_axi1_bready <= RDY_axi1w_writeResponse;


  WILL_FIRE_axi2r_readAddr <= (m_axi2_arready and RDY_axi2r_readAddr);
  WILL_FIRE_axi2r_readData <= (m_axi2_rvalid and RDY_axi2r_readData);
  m_axi2_arvalid <= RDY_axi2r_readAddr;
  m_axi2_rready <= RDY_axi2r_readData;

  WILL_FIRE_axi2w_writeAddr <= (m_axi2_awready and RDY_axi2w_writeAddr);
  WILL_FIRE_axi2w_writeData <= (m_axi2_wready and RDY_axi2w_writeData);
  WILL_FIRE_axi2w_writeResponse <= (m_axi2_bvalid and RDY_axi2w_writeResponse);
  m_axi2_awvalid <= RDY_axi2w_writeAddr;
  m_axi2_wvalid <= RDY_axi2w_writeData;
  m_axi2_bready <= RDY_axi2w_writeResponse;

end IMP;
