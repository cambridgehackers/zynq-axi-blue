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

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_SLV_AWIDTH                 -- Slave interface address bus width
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--   C_NUM_MEM                    -- Number of memory spaces
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Resetn                -- Bus to IP reset
--   Bus2IP_Addr                  -- Bus to IP address bus
--   Bus2IP_CS                    -- Bus to IP chip select for user logic memory selection
--   Bus2IP_RNW                   -- Bus to IP read/not write
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   Bus2IP_Burst                 -- Bus to IP burst-mode qualifier
--   Bus2IP_BurstLength           -- Bus to IP burst length
--   Bus2IP_RdReq                 -- Bus to IP read request
--   Bus2IP_WrReq                 -- Bus to IP write request
--   IP2Bus_AddrAck               -- IP to Bus address acknowledgement
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
--   Type_of_xfer                 -- Transfer Type
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    C_M_AXI_ADDR_WIDTH : integer := 32;
    C_M_AXI_DATA_WIDTH : integer := 64;
    C_M_AXI_ID_WIDTH : integer := 1;
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

    m_axi_aclk                     : in  std_logic;
    m_axi_aresetn                  : in  std_logic;
    md_error                       : out std_logic;
    m_axi_arready                  : in  std_logic;
    m_axi_arvalid                  : out std_logic;
    m_axi_arid                     : out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
    m_axi_araddr                   : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    m_axi_arlen                    : out std_logic_vector(7 downto 0);
    m_axi_arsize                   : out std_logic_vector(2 downto 0);
    m_axi_arburst                  : out std_logic_vector(1 downto 0);
    m_axi_arprot                   : out std_logic_vector(2 downto 0);
    m_axi_arcache                  : out std_logic_vector(3 downto 0);
    m_axi_rready                   : out std_logic;
    m_axi_rvalid                   : in  std_logic;
    m_axi_rid                      : in  std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
    m_axi_rdata                    : in  std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    m_axi_rresp                    : in  std_logic_vector(1 downto 0);
    m_axi_rlast                    : in  std_logic;
    m_axi_awready                  : in  std_logic;
    m_axi_awvalid                  : out std_logic;
    m_axi_awid                     : out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
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
    m_axi_bid                      : in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
    m_axi_bvalid                   : in  std_logic;
    m_axi_bresp                    : in  std_logic_vector(1 downto 0);

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

  signal RDY_axiw_writeAddr : std_logic;
  signal RDY_axiw_writeData : std_logic;
  signal RDY_axiw_writeResponse : std_logic;
  signal RDY_axir_readAddr : std_logic;
  signal RDY_axir_readData : std_logic;
  signal WILL_FIRE_axiw_writeAddr : std_logic;
  signal WILL_FIRE_axiw_writeData : std_logic;
  signal WILL_FIRE_axiw_writeResponse : std_logic;
  signal WILL_FIRE_axir_readAddr : std_logic;
  signal WILL_FIRE_axir_readData : std_logic;

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

      EN_axiw_writeAddr => WILL_FIRE_axiw_writeAddr,
      axiw_writeAddr => m_axi_awaddr,
      RDY_axiw_writeAddr => RDY_axiw_writeAddr,

      axiw_writeBurstLen => m_axi_awlen,
      -- RDY_axiw_writeBurstLen,

      axiw_writeBurstWidth => m_axi_awsize,
      -- RDY_axiw_writeBurstWidth,

      axiw_writeBurstType => m_axi_awburst,
      -- RDY_axiw_writeBurstType,

      axiw_writeBurstProt => m_axi_awprot,
      -- RDY_axiw_writeBurstProt,

      axiw_writeBurstCache => m_axi_awcache,
      -- RDY_axiw_writeBurstCache,

      EN_axiw_writeData => WILL_FIRE_axiw_writeData,
      axiw_writeData => m_axi_wdata,
      RDY_axiw_writeData => RDY_axiw_writeData,

      axiw_writeDataByteEnable => m_axi_wstrb,
      -- RDY_axiw_writeDataByteEnable,

      axiw_writeLastDataBeat => m_axi_wlast,
      -- RDY_axiw_writeLastDataBeat,

      EN_axiw_writeResponse => WILL_FIRE_axiw_writeResponse,
      axiw_writeResponse_responseCode => m_axi_bresp,
      RDY_axiw_writeResponse => RDY_axiw_writeResponse,

      EN_axir_readAddr => WILL_FIRE_axir_readAddr,
      axir_readAddr => m_axi_araddr,
      RDY_axir_readAddr => RDY_axir_readAddr,

      axir_readBurstLen => m_axi_arlen,
      -- RDY_axir_readBurstLen,

      axir_readBurstWidth => m_axi_arsize,
      -- RDY_axir_readBurstWidth,

      axir_readBurstType => m_axi_arburst,
      -- RDY_axir_readBurstType,

      axir_readBurstProt => m_axi_arprot,
      -- RDY_axir_readBurstProt,

      axir_readBurstCache => m_axi_arcache,
      -- RDY_axir_readBurstCache,

      axir_readData_data => m_axi_rdata,
      axir_readData_resp => m_axi_rresp,
      axir_readData_last => m_axi_rlast,
      EN_axir_readData => WILL_FIRE_axir_readData,
      RDY_axir_readData => RDY_axir_readData,

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
  WILL_FIRE_axir_readAddr <= (m_axi_arready and RDY_axir_readAddr);
  WILL_FIRE_axir_readData <= (m_axi_rvalid and RDY_axir_readData);
  m_axi_arvalid <= RDY_axir_readAddr;
  m_axi_rready <= RDY_axir_readData;

  WILL_FIRE_axiw_writeAddr <= (m_axi_awready and RDY_axiw_writeAddr);
  WILL_FIRE_axiw_writeData <= (m_axi_wready and RDY_axiw_writeData);
  WILL_FIRE_axiw_writeResponse <= (m_axi_bvalid and RDY_axiw_writeResponse);
  m_axi_awvalid <= RDY_axiw_writeAddr;
  m_axi_wvalid <= RDY_axiw_writeData;
  m_axi_bready <= RDY_axiw_writeResponse;

  -- currently constant
  m_axi_arid <= "0";
  m_axi_awid <= "0";
end IMP;
