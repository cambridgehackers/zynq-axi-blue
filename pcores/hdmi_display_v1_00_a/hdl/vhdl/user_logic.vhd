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
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_S_AXI_DATA_WIDTH             : integer              := 32;
    C_S_AXI_ADDR_WIDTH             : integer              := 32;
    C_S_AXI_ID_WIDTH               : integer              := 4;
    C_S_AXI_MEM0_BASEADDR          : std_logic_vector     := X"FFFFFFFF";
    C_S_AXI_MEM0_HIGHADDR          : std_logic_vector     := X"00000000";
    C_S_AXI_MEM1_BASEADDR          : std_logic_vector     := X"FFFFFFFF";
    C_S_AXI_MEM1_HIGHADDR          : std_logic_vector     := X"00000000";
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

    usr_clk_p : in std_logic;
    usr_clk_n : in std_logic;

    xadc_gpio_0 : out std_logic;
    xadc_gpio_1 : out std_logic;
    xadc_gpio_2 : out std_logic;
    xadc_gpio_3 : out std_logic;

    hdmi_ref_clk : in std_logic;
    hdmi_clk : out std_logic;
    hdmi_vsync : out std_logic;
    hdmi_hsync : out std_logic;
    hdmi_de : out std_logic;
    hdmi_data : out std_logic_vector(15 downto 0);

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
    S_AXI_RLAST                    : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of S_AXI_AClk    : signal is "CLK";
  attribute SIGIS of S_AXI_ARESETN : signal is "RST";
  attribute SIGIS of hdmi_ref_clk  : signal is "CLK";
  attribute SIGIS of hdmi_clk      : signal is "CLK";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  --USER signal declarations added here, as needed for user logic

  signal mem0_araddr_matches : boolean;
  signal mem1_araddr_matches : boolean;
  signal mem0_awaddr_matches : boolean;
  signal mem1_awaddr_matches : boolean;

  signal ctrl_read_readData : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal fifo_read_readData : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal ctrl_write_writeResponse : std_logic_vector(1 downto 0);
  signal fifo_write_writeResponse : std_logic_vector(1 downto 0);

  signal rdy_writeAddr : std_logic;
  signal rdy_writeData : std_logic;

  signal EN_ctrl_read_readAddr : std_logic;
  signal RDY_ctrl_read_readAddr : std_logic;
  signal EN_ctrl_read_readData : std_logic;
  signal RDY_ctrl_read_readData : std_logic;
  signal EN_ctrl_write_writeAddr : std_logic;
  signal RDY_ctrl_write_writeAddr : std_logic;
  signal EN_ctrl_write_writeData : std_logic;
  signal RDY_ctrl_write_writeData : std_logic;
  signal EN_ctrl_write_writeResponse : std_logic;
  signal RDY_ctrl_write_writeResponse : std_logic;
  signal ctrl_read_last : std_logic;

  signal EN_fifo_read_readAddr : std_logic;
  signal RDY_fifo_read_readAddr : std_logic;
  signal EN_fifo_read_readData : std_logic;
  signal RDY_fifo_read_readData : std_logic;
  signal EN_fifo_write_writeAddr : std_logic;
  signal RDY_fifo_write_writeAddr : std_logic;
  signal EN_fifo_write_writeData : std_logic;
  signal RDY_fifo_write_writeData : std_logic;
  signal EN_fifo_write_writeResponse : std_logic;
  signal RDY_fifo_write_writeResponse : std_logic;
  signal fifo_read_last : std_logic;

  signal RDY_axiw0_writeAddr : std_logic;
  signal RDY_axiw0_writeData : std_logic;
  signal RDY_axiw0_writeResponse : std_logic;
  signal RDY_axir0_readAddr : std_logic;
  signal RDY_axir0_readData : std_logic;
  signal WILL_FIRE_axiw0_writeAddr : std_logic;
  signal WILL_FIRE_axiw0_writeData : std_logic;
  signal WILL_FIRE_axiw0_writeResponse : std_logic;
  signal WILL_FIRE_axir0_readAddr : std_logic;
  signal WILL_FIRE_axir0_readData : std_logic;

  signal RDY_axiw1_writeAddr : std_logic;
  signal RDY_axiw1_writeData : std_logic;
  signal RDY_axiw1_writeResponse : std_logic;
  signal RDY_axir1_readAddr : std_logic;
  signal RDY_axir1_readData : std_logic;
  signal WILL_FIRE_axiw1_writeAddr : std_logic;
  signal WILL_FIRE_axiw1_writeData : std_logic;
  signal WILL_FIRE_axiw1_writeResponse : std_logic;
  signal WILL_FIRE_axir1_readAddr : std_logic;
  signal WILL_FIRE_axir1_readData : std_logic;

  signal hdmi_vsync_unbuf, hdmi_hsync_unbuf, hdmi_de_unbuf : std_logic;
  signal hdmi_data_unbuf : std_logic_vector(15 downto 0);
  signal usr_clk : std_logic;
  attribute SIGIS of usr_clk      : signal is "CLK";

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
  IP_SLAVE : entity mkIpSlaveWithMaster
    port map (
      CLK_hdmi_ref_clk => usr_clk,
      CLK => S_AXI_ACLK,
      RST_N  => S_AXI_ARESETN,

      ctrl_read_readAddr_addr => S_AXI_ARADDR,
      ctrl_read_readAddr_burstLen => S_AXI_ARLEN,
      ctrl_read_readAddr_burstWidth => S_AXI_ARSIZE,
      ctrl_read_readAddr_burstType => S_AXI_ARBURST,
      ctrl_read_readAddr_burstProt => S_AXI_ARPROT,
      ctrl_read_readAddr_burstCache => S_AXI_ARCACHE,
      EN_ctrl_read_readAddr => EN_ctrl_read_readAddr,
      RDY_ctrl_read_readAddr => RDY_ctrl_read_readAddr,

      ctrl_read_last => ctrl_read_last,
      EN_ctrl_read_readData => EN_ctrl_read_readData,
      ctrl_read_readData => ctrl_read_readData,
      RDY_ctrl_read_readData => RDY_ctrl_read_readData,

      ctrl_write_writeAddr_addr => S_AXI_AWADDR,
      ctrl_write_writeAddr_burstLen => S_AXI_AWLEN,
      ctrl_write_writeAddr_burstWidth => S_AXI_AWSIZE,
      ctrl_write_writeAddr_burstType => S_AXI_AWBURST,
      ctrl_write_writeAddr_burstProt => S_AXI_AWPROT,
      ctrl_write_writeAddr_burstCache => S_AXI_AWCACHE,
      EN_ctrl_write_writeAddr => EN_ctrl_write_writeAddr,
      RDY_ctrl_write_writeAddr => RDY_ctrl_write_writeAddr,

      ctrl_write_writeData_data => S_AXI_WDATA,
      ctrl_write_writeData_byteEnable => S_AXI_WSTRB,
      ctrl_write_writeData_last => S_AXI_WLAST,
      RDY_ctrl_write_writeData => RDY_ctrl_write_writeData,
      EN_ctrl_write_writeData => EN_ctrl_write_writeData,

      EN_ctrl_write_writeResponse => EN_ctrl_write_writeResponse,
      RDY_ctrl_write_writeResponse => RDY_ctrl_write_writeResponse,
      ctrl_write_writeResponse => ctrl_write_writeResponse,

      fifo_read_readAddr_addr => S_AXI_ARADDR,
      fifo_read_readAddr_burstLen => S_AXI_ARLEN,
      fifo_read_readAddr_burstWidth => S_AXI_ARSIZE,
      fifo_read_readAddr_burstType => S_AXI_ARBURST,
      fifo_read_readAddr_burstProt => S_AXI_ARPROT,
      fifo_read_readAddr_burstCache => S_AXI_ARCACHE,
      EN_fifo_read_readAddr => EN_fifo_read_readAddr,
      RDY_fifo_read_readAddr => RDY_fifo_read_readAddr,

      fifo_read_last => fifo_read_last,
      EN_fifo_read_readData => EN_fifo_read_readData,
      fifo_read_readData => fifo_read_readData,
      RDY_fifo_read_readData => RDY_fifo_read_readData,

      fifo_write_writeAddr_addr => S_AXI_AWADDR,
      fifo_write_writeAddr_burstLen => S_AXI_AWLEN,
      fifo_write_writeAddr_burstWidth => S_AXI_AWSIZE,
      fifo_write_writeAddr_burstType => S_AXI_AWBURST,
      fifo_write_writeAddr_burstProt => S_AXI_AWPROT,
      fifo_write_writeAddr_burstCache => S_AXI_AWCACHE,
      EN_fifo_write_writeAddr => EN_fifo_write_writeAddr,
      RDY_fifo_write_writeAddr => RDY_fifo_write_writeAddr,

      fifo_write_writeData_data => S_AXI_WDATA,
      fifo_write_writeData_byteEnable => S_AXI_WSTRB,
      fifo_write_writeData_last => S_AXI_WLAST,
      EN_fifo_write_writeData => EN_fifo_write_writeData,
      RDY_fifo_write_writeData => RDY_fifo_write_writeData,

      EN_fifo_write_writeResponse => EN_fifo_write_writeResponse,
      RDY_fifo_write_writeResponse => RDY_fifo_write_writeResponse,
      fifo_write_writeResponse => fifo_write_writeResponse,

      interrupt => interrupt,

      EN_axiw0_writeAddr => WILL_FIRE_axiw0_writeAddr,
      axiw0_writeAddr => m_axi0_awaddr,
      axiw0_writeId => m_axi0_awid(0),
      RDY_axiw0_writeAddr => RDY_axiw0_writeAddr,

      axiw0_writeBurstLen => m_axi0_awlen,
      -- RDY_axiw0_writeBurstLen,

      axiw0_writeBurstWidth => m_axi0_awsize,
      -- RDY_axiw0_writeBurstWidth,

      axiw0_writeBurstType => m_axi0_awburst,
      -- RDY_axiw0_writeBurstType,

      axiw0_writeBurstProt => m_axi0_awprot,
      -- RDY_axiw0_writeBurstProt,

      axiw0_writeBurstCache => m_axi0_awcache,
      -- RDY_axiw0_writeBurstCache,

      EN_axiw0_writeData => WILL_FIRE_axiw0_writeData,
      axiw0_writeData => m_axi0_wdata,
      RDY_axiw0_writeData => RDY_axiw0_writeData,

      axiw0_writeDataByteEnable => m_axi0_wstrb,
      -- RDY_axiw0_writeDataByteEnable,

      axiw0_writeLastDataBeat => m_axi0_wlast,
      -- RDY_axiw0_writeLastDataBeat,

      EN_axiw0_writeResponse => WILL_FIRE_axiw0_writeResponse,
      axiw0_writeResponse_responseCode => m_axi0_bresp,
      axiw0_writeResponse_id => m_axi0_bid(0),
      RDY_axiw0_writeResponse => RDY_axiw0_writeResponse,

      EN_axir0_readAddr => WILL_FIRE_axir0_readAddr,
      axir0_readId => m_axi0_arid(0),
      axir0_readAddr => m_axi0_araddr,
      RDY_axir0_readAddr => RDY_axir0_readAddr,

      axir0_readBurstLen => m_axi0_arlen,
      -- RDY_axir0_readBurstLen,

      axir0_readBurstWidth => m_axi0_arsize,
      -- RDY_axir0_readBurstWidth,

      axir0_readBurstType => m_axi0_arburst,
      -- RDY_axir0_readBurstType,

      axir0_readBurstProt => m_axi0_arprot,
      -- RDY_axir0_readBurstProt,

      axir0_readBurstCache => m_axi0_arcache,
      -- RDY_axir0_readBurstCache,

      axir0_readData_data => m_axi0_rdata,
      axir0_readData_resp => m_axi0_rresp,
      axir0_readData_last => m_axi0_rlast,
      axir0_readData_id => m_axi0_rid(0),
      EN_axir0_readData => WILL_FIRE_axir0_readData,
      RDY_axir0_readData => RDY_axir0_readData,

      hdmi_hdmi_vsync => hdmi_vsync_unbuf,
      hdmi_hdmi_hsync => hdmi_hsync_unbuf,
      hdmi_hdmi_de => hdmi_de_unbuf,
      hdmi_hdmi_data => hdmi_data_unbuf
      );

    OBUF_clk : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_clk,
    -- Buffer output (connect directly to top-level port)
    I => usr_clk
    -- Buffer input
    );
    OBUF_hsync : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_hsync,
    -- Buffer output (connect directly to top-level port)
    I => hdmi_hsync_unbuf
    -- Buffer input
    );
    OBUF_vsync : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_vsync,
    -- Buffer output (connect directly to top-level port)
    I => hdmi_vsync_unbuf
    -- Buffer input
    );
    OBUF_de : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_de,
    -- Buffer output (connect directly to top-level port)
    I => hdmi_de_unbuf
    -- Buffer input
    );

    OBUF_data_0 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_data(0),
    -- Buffer output (connect directly to top-level port)
    I => hdmi_data_unbuf(0)
    -- Buffer input
    );
    OBUF_data_1 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_data(1),
    -- Buffer output (connect directly to top-level port)
    I => hdmi_data_unbuf(1)
    -- Buffer input
    );
    OBUF_data_2 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_data(2),
    -- Buffer output (connect directly to top-level port)
    I => hdmi_data_unbuf(2)
    -- Buffer input
    );
    OBUF_data_3 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_data(3),
    -- Buffer output (connect directly to top-level port)
    I => hdmi_data_unbuf(3)
    -- Buffer input
    );
    OBUF_data_4 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_data(4),
    -- Buffer output (connect directly to top-level port)
    I => hdmi_data_unbuf(4)
    -- Buffer input
    );
    OBUF_data_5 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_data(5),
    -- Buffer output (connect directly to top-level port)
    I => hdmi_data_unbuf(5)
    -- Buffer input
    );
    OBUF_data_6 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_data(6),
    -- Buffer output (connect directly to top-level port)
    I => hdmi_data_unbuf(6)
    -- Buffer input
    );
    OBUF_data_7 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_data(7),
    -- Buffer output (connect directly to top-level port)
    I => hdmi_data_unbuf(7)
    -- Buffer input
    );
    OBUF_data_8 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_data(8),
    -- Buffer output (connect directly to top-level port)
    I => hdmi_data_unbuf(8)
    -- Buffer input
    );
    OBUF_data_9 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_data(9),
    -- Buffer output (connect directly to top-level port)
    I => hdmi_data_unbuf(9)
    -- Buffer input
    );
    OBUF_data_10 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_data(10),
    -- Buffer output (connect directly to top-level port)
    I => hdmi_data_unbuf(10)
    -- Buffer input
    );
    OBUF_data_11 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_data(11),
    -- Buffer output (connect directly to top-level port)
    I => hdmi_data_unbuf(11)
    -- Buffer input
    );
    OBUF_data_12 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_data(12),
    -- Buffer output (connect directly to top-level port)
    I => hdmi_data_unbuf(12)
    -- Buffer input
    );
    OBUF_data_13 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_data(13),
    -- Buffer output (connect directly to top-level port)
    I => hdmi_data_unbuf(13)
    -- Buffer input
    );
    OBUF_data_14 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_data(14),
    -- Buffer output (connect directly to top-level port)
    I => hdmi_data_unbuf(14)
    -- Buffer input
    );
    OBUF_data_15 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => hdmi_data(15),
    -- Buffer output (connect directly to top-level port)
    I => hdmi_data_unbuf(15)
    -- Buffer input
    );

    IBUFGDS_ref_clk : IBUFGDS
    generic map (
    DIFF_TERM => FALSE, -- Differential Termination
    IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
    IOSTANDARD => "DEFAULT")
    port map (
    O => usr_clk, -- Clock buffer output
    I => usr_clk_p, -- Diff_p clock buffer input (connect directly to top-level port)
    IB => usr_clk_n -- Diff_n clock buffer input (connect directly to top-level port)
    );

  -- mirror signals for logic analyzer
    OBUF_vsync_mirror : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => xadc_gpio_0,
    -- Buffer output (connect directly to top-level port)
    I => S_AXI_AWVALID -- hdmi_vsync_unbuf
    -- Buffer input
    );
    OBUF_readAddr_mirror : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => xadc_gpio_1,
    -- Buffer output (connect directly to top-level port)
    I => rdy_writeAddr -- WILL_FIRE_axir0_readAddr
    -- Buffer input
    );
    OBUF_readData_mirror : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => xadc_gpio_2,
    -- Buffer output (connect directly to top-level port)
    I => rdy_writeData -- WILL_FIRE_axir0_readData
    -- Buffer input
    );
    OBUF_de_mirror : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => xadc_gpio_3,
    -- Buffer output (connect directly to top-level port)
    I => S_AXI_WLAST -- hdmi_de_unbuf
    -- Buffer input
    );
  
  mem0_araddr_matches <= (S_AXI_ARADDR >= C_S_AXI_MEM0_BASEADDR and S_AXI_ARADDR <= C_S_AXI_MEM0_HIGHADDR);
  mem1_araddr_matches <= (S_AXI_ARADDR >= C_S_AXI_MEM1_BASEADDR and S_AXI_ARADDR <= C_S_AXI_MEM1_HIGHADDR);
  mem0_awaddr_matches <= (S_AXI_AWADDR >= C_S_AXI_MEM0_BASEADDR and S_AXI_AWADDR <= C_S_AXI_MEM0_HIGHADDR);
  mem1_awaddr_matches <= (S_AXI_AWADDR >= C_S_AXI_MEM1_BASEADDR and S_AXI_AWADDR <= C_S_AXI_MEM1_HIGHADDR);

  S_AXI_ARREADY  <= RDY_ctrl_read_readAddr when mem0_araddr_matches else
                    RDY_fifo_read_readAddr when mem1_araddr_matches else
                    '0';
  S_AXI_RVALID <= EN_ctrl_read_readData or EN_fifo_read_readData;
  S_AXI_RRESP  <= "00";

  S_AXI_RDATA  <= ctrl_read_readData when EN_ctrl_read_readData = '1' else
                  fifo_read_readData when EN_fifo_read_readData = '1' else
                  (others => '0');
  S_AXI_RLAST  <= ctrl_read_last when EN_ctrl_read_readData = '1' else
                  fifo_read_last when EN_fifo_read_readData = '1' else
                  '0';


  S_AXI_RID <= (others => '0');
  S_AXI_BID <= (others => '0');
  rdy_writeAddr <= RDY_ctrl_write_writeAddr when mem0_awaddr_matches else
                   RDY_fifo_write_writeAddr when mem1_awaddr_matches else
                   '0';
  S_AXI_AWREADY  <= rdy_writeAddr;

  rdy_writeData  <= RDY_ctrl_write_writeData or RDY_fifo_write_writeData;
  S_AXI_WREADY <= rdy_writeData;

  S_AXI_BVALID  <= EN_ctrl_write_writeResponse or EN_fifo_write_writeResponse;
  S_AXI_BRESP <= ctrl_write_writeResponse when EN_ctrl_write_writeResponse = '1' else
                 fifo_write_writeResponse when EN_fifo_write_writeResponse = '1' else
                 (others => '0');

  -- scheduler
  EN_ctrl_read_readAddr <= RDY_ctrl_read_readAddr and S_AXI_ARVALID when mem0_araddr_matches else '0';
  EN_fifo_read_readAddr <= RDY_fifo_read_readAddr and S_AXI_ARVALID when mem1_araddr_matches else '0';
  EN_ctrl_read_readData <= RDY_ctrl_read_readData and S_AXI_RREADY;
  EN_fifo_read_readData <= RDY_fifo_read_readData and S_AXI_RREADY;

  EN_ctrl_write_writeAddr <= RDY_ctrl_write_writeAddr and S_AXI_AWVALID when mem0_awaddr_matches else '0';
  EN_fifo_write_writeAddr <= RDY_fifo_write_writeAddr and S_AXI_AWVALID when mem1_awaddr_matches else '0';
  EN_ctrl_write_writeData <= RDY_ctrl_write_writeData and S_AXI_WVALID;
  EN_fifo_write_writeData <= RDY_fifo_write_writeData and S_AXI_WVALID;
  EN_ctrl_write_writeResponse <= RDY_ctrl_write_writeResponse and S_AXI_BREADY;
  EN_fifo_write_writeResponse <= RDY_fifo_write_writeResponse and S_AXI_BREADY;

  WILL_FIRE_axir0_readAddr <= (m_axi0_arready and RDY_axir0_readAddr);
  WILL_FIRE_axir0_readData <= (m_axi0_rvalid and RDY_axir0_readData);
  m_axi0_arvalid <= RDY_axir0_readAddr;
  m_axi0_rready <= RDY_axir0_readData;

  WILL_FIRE_axiw0_writeAddr <= (m_axi0_awready and RDY_axiw0_writeAddr);
  WILL_FIRE_axiw0_writeData <= (m_axi0_wready and RDY_axiw0_writeData);
  WILL_FIRE_axiw0_writeResponse <= (m_axi0_bvalid and RDY_axiw0_writeResponse);
  m_axi0_awvalid <= RDY_axiw0_writeAddr;
  m_axi0_wvalid <= RDY_axiw0_writeData;
  m_axi0_bready <= RDY_axiw0_writeResponse;

end IMP;
