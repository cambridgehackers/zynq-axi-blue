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
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_SLV_AWIDTH                   : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32;
    C_NUM_MEM                      : integer              := 1
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
  attribute SIGIS of hdmi_ref_clk  : signal is "CLK";
  attribute SIGIS of hdmi_clk      : signal is "CLK";

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

  signal ip_slave_d : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal ip_slave_rdy_put : std_logic;
  signal ip_slave_rdy_get : std_logic;
  signal ip_slave_en_put : std_logic;
  signal ip_slave_en_get : std_logic;

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
  IP2Bus_Data  <= ip_slave_d when mem_read_ack = '1' else
                  (others => '0');

  IP2Bus_AddrAck <= mem_write_ack or mem_read_ack;
  IP2Bus_WrAck <= mem_write_ack;
  IP2Bus_RdAck <= mem_read_ack;
  IP2Bus_Error <= '0';

  ip_slave_en_put <= Bus2IP_CS(0) and Bus2IP_WrCE(0);
  ip_slave_en_get <= Bus2IP_CS(0) and Bus2IP_RdCE(0);

  mem_read_ack    <= ip_slave_en_get and ip_slave_rdy_get;
  mem_write_ack   <= ip_slave_en_put and ip_slave_rdy_put;

  IP_SLAVE : entity mkIpSlaveWithMaster
    port map (
      CLK_hdmi_ref_clk => usr_clk,
      CLK => Bus2IP_Clk,
      RST_N  => Bus2IP_Resetn,

      put_addr => Bus2IP_Addr(11 downto 0),
      put_v => Bus2IP_Data,
      EN_put => ip_slave_en_put,
      RDY_put => ip_slave_rdy_put,

      get_addr => Bus2IP_Addr(11 downto 0),
      EN_get => ip_slave_en_get,
      get => ip_slave_d,
      RDY_get => ip_slave_rdy_get,

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

      EN_axiw1_writeAddr => WILL_FIRE_axiw1_writeAddr,
      axiw1_writeAddr => m_axi1_awaddr,
      axiw1_writeId => m_axi1_awid(0),
      RDY_axiw1_writeAddr => RDY_axiw1_writeAddr,

      axiw1_writeBurstLen => m_axi1_awlen,
      -- RDY_axiw1_writeBurstLen,

      axiw1_writeBurstWidth => m_axi1_awsize,
      -- RDY_axiw1_writeBurstWidth,

      axiw1_writeBurstType => m_axi1_awburst,
      -- RDY_axiw1_writeBurstType,

      axiw1_writeBurstProt => m_axi1_awprot,
      -- RDY_axiw1_writeBurstProt,

      axiw1_writeBurstCache => m_axi1_awcache,
      -- RDY_axiw1_writeBurstCache,

      EN_axiw1_writeData => WILL_FIRE_axiw1_writeData,
      axiw1_writeData => m_axi1_wdata,
      RDY_axiw1_writeData => RDY_axiw1_writeData,

      axiw1_writeDataByteEnable => m_axi1_wstrb,
      -- RDY_axiw1_writeDataByteEnable,

      axiw1_writeLastDataBeat => m_axi1_wlast,
      -- RDY_axiw1_writeLastDataBeat,

      EN_axiw1_writeResponse => WILL_FIRE_axiw1_writeResponse,
      axiw1_writeResponse_responseCode => m_axi1_bresp,
      axiw1_writeResponse_id => m_axi1_bid(0),
      RDY_axiw1_writeResponse => RDY_axiw1_writeResponse,

      EN_axir1_readAddr => WILL_FIRE_axir1_readAddr,
      axir1_readId => m_axi1_arid(0),
      axir1_readAddr => m_axi1_araddr,
      RDY_axir1_readAddr => RDY_axir1_readAddr,

      axir1_readBurstLen => m_axi1_arlen,
      -- RDY_axir1_readBurstLen,

      axir1_readBurstWidth => m_axi1_arsize,
      -- RDY_axir1_readBurstWidth,

      axir1_readBurstType => m_axi1_arburst,
      -- RDY_axir1_readBurstType,

      axir1_readBurstProt => m_axi1_arprot,
      -- RDY_axir1_readBurstProt,

      axir1_readBurstCache => m_axi1_arcache,
      -- RDY_axir1_readBurstCache,

      axir1_readData_data => m_axi1_rdata,
      axir1_readData_resp => m_axi1_rresp,
      axir1_readData_last => m_axi1_rlast,
      axir1_readData_id => m_axi1_rid(0),
      EN_axir1_readData => WILL_FIRE_axir1_readData,
      RDY_axir1_readData => RDY_axir1_readData,

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
    OBUF_clk_mirror : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => xadc_gpio_0,
    -- Buffer output (connect directly to top-level port)
    I => usr_clk
    -- Buffer input
    );
    OBUF_vsync_mirror : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => xadc_gpio_1,
    -- Buffer output (connect directly to top-level port)
    I => hdmi_vsync_unbuf
    -- Buffer input
    );
    OBUF_hsync_mirror : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => xadc_gpio_2,
    -- Buffer output (connect directly to top-level port)
    I => hdmi_hsync_unbuf
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
    I => hdmi_de_unbuf
    -- Buffer input
    );
  

  -- scheduler
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

  WILL_FIRE_axir1_readAddr <= (m_axi1_arready and RDY_axir1_readAddr);
  WILL_FIRE_axir1_readData <= (m_axi1_rvalid and RDY_axir1_readData);
  m_axi1_arvalid <= RDY_axir1_readAddr;
  m_axi1_rready <= RDY_axir1_readData;

  WILL_FIRE_axiw1_writeAddr <= (m_axi1_awready and RDY_axiw1_writeAddr);
  WILL_FIRE_axiw1_writeData <= (m_axi1_wready and RDY_axiw1_writeData);
  WILL_FIRE_axiw1_writeResponse <= (m_axi1_bvalid and RDY_axiw1_writeResponse);
  m_axi1_awvalid <= RDY_axiw1_writeAddr;
  m_axi1_wvalid <= RDY_axiw1_writeData;
  m_axi1_bready <= RDY_axiw1_writeResponse;

end IMP;
