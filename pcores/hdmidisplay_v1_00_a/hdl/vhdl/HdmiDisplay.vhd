
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity hdmiDisplay is
  generic
  (

    C_M_AXI_DATA_WIDTH             : integer              := 64;
    C_M_AXI_ADDR_WIDTH             : integer              := 32;
    C_M_AXI_BURSTLEN_WIDTH         : integer              := 4;
    C_M_AXI_PROT_WIDTH             : integer              := 2;
    C_M_AXI_CACHE_WIDTH            : integer              := 3;
    C_M_AXI_ID_WIDTH               : integer              := 1;


    C_CTRL_DATA_WIDTH             : integer              := 32;
    C_CTRL_ADDR_WIDTH             : integer              := 32;
    C_CTRL_ID_WIDTH               : integer              := 4;
    C_CTRL_MEM0_BASEADDR          : std_logic_vector     := X"FFFFFFFF";
    C_CTRL_MEM0_HIGHADDR          : std_logic_vector     := X"00000000";

    C_FIFO_DATA_WIDTH             : integer              := 32;
    C_FIFO_ADDR_WIDTH             : integer              := 32;
    C_FIFO_ID_WIDTH               : integer              := 4;
    C_FIFO_MEM0_BASEADDR          : std_logic_vector     := X"FFFFFFFF";
    C_FIFO_MEM0_HIGHADDR          : std_logic_vector     := X"00000000";

    C_FAMILY                       : string               := "virtex6"
  );
  port
  (
    CLK : in std_logic;
    RST_N : in std_logic;

    xadc_gpio_0 : out std_logic;
    xadc_gpio_1 : out std_logic;
    xadc_gpio_2 : out std_logic;
    xadc_gpio_3 : out std_logic;


    m_axi_aclk                     : in  std_logic;
    m_axi_aresetn                  : in  std_logic;
    m_axi_arready                  : in  std_logic;
    m_axi_arvalid                  : out std_logic;
    m_axi_arid                     : out std_logic_vector(C_m_axi_ID_WIDTH-1 downto 0);
    m_axi_araddr                   : out std_logic_vector(C_m_axi_ADDR_WIDTH-1 downto 0);
    m_axi_arlen                    : out std_logic_vector(C_m_axi_BURSTLEN_WIDTH-1 downto 0);
    m_axi_arsize                   : out std_logic_vector(2 downto 0);
    m_axi_arburst                  : out std_logic_vector(1 downto 0);
    m_axi_arprot                   : out std_logic_vector((C_M_AXI_PROT_WIDTH-1) downto 0);
    m_axi_arcache                  : out std_logic_vector((C_M_AXI_CACHE_WIDTH-1) downto 0);
    m_axi_rready                   : out std_logic;
    m_axi_rvalid                   : in  std_logic;
    m_axi_rid                      : in  std_logic_vector(C_m_axi_ID_WIDTH-1 downto 0);
    m_axi_rdata                    : in  std_logic_vector(C_m_axi_DATA_WIDTH-1 downto 0);
    m_axi_rresp                    : in  std_logic_vector(1 downto 0);
    m_axi_rlast                    : in  std_logic;
    m_axi_awready                  : in  std_logic;
    m_axi_awvalid                  : out std_logic;
    m_axi_awid                     : out std_logic_vector(C_m_axi_ID_WIDTH-1 downto 0);
    m_axi_awaddr                   : out std_logic_vector(C_m_axi_ADDR_WIDTH-1 downto 0);
    m_axi_awlen                    : out std_logic_vector(C_m_axi_BURSTLEN_WIDTH-1 downto 0);
    m_axi_awsize                   : out std_logic_vector(2 downto 0);
    m_axi_awburst                  : out std_logic_vector(1 downto 0);
    m_axi_awprot                   : out std_logic_vector((C_M_AXI_PROT_WIDTH-1) downto 0);
    m_axi_awcache                  : out std_logic_vector((C_M_AXI_CACHE_WIDTH-1) downto 0);
    m_axi_wready                   : in  std_logic;
    m_axi_wvalid                   : out std_logic;
    m_axi_wdata                    : out std_logic_vector(C_m_axi_DATA_WIDTH-1 downto 0);
    m_axi_wstrb                    : out std_logic_vector((C_m_axi_DATA_WIDTH)/8 - 1 downto 0);
    m_axi_wlast                    : out std_logic;
    m_axi_bready                   : out std_logic;
    m_axi_bid                      : in std_logic_vector(C_m_axi_ID_WIDTH-1 downto 0);
    m_axi_bvalid                   : in  std_logic;
    m_axi_bresp                    : in  std_logic_vector(1 downto 0);


    CTRL_ACLK                     : in  std_logic;
    CTRL_ARESETN                  : in  std_logic;
    CTRL_AWADDR                   : in  std_logic_vector(C_CTRL_ADDR_WIDTH-1 downto 0);
    CTRL_AWVALID                  : in  std_logic;
    CTRL_WDATA                    : in  std_logic_vector(C_CTRL_DATA_WIDTH-1 downto 0);
    CTRL_WSTRB                    : in  std_logic_vector((C_CTRL_DATA_WIDTH/8)-1 downto 0);
    CTRL_WVALID                   : in  std_logic;
    CTRL_BREADY                   : in  std_logic;
    CTRL_ARADDR                   : in  std_logic_vector(C_CTRL_ADDR_WIDTH-1 downto 0);
    CTRL_ARVALID                  : in  std_logic;
    CTRL_RREADY                   : in  std_logic;
    CTRL_ARREADY                  : out std_logic;
    CTRL_RDATA                    : out std_logic_vector(C_CTRL_DATA_WIDTH-1 downto 0);
    CTRL_RRESP                    : out std_logic_vector(1 downto 0);
    CTRL_RVALID                   : out std_logic;
    CTRL_WREADY                   : out std_logic;
    CTRL_BRESP                    : out std_logic_vector(1 downto 0);
    CTRL_BVALID                   : out std_logic;
    CTRL_AWREADY                  : out std_logic;
    CTRL_AWID                     : in  std_logic_vector(C_CTRL_ID_WIDTH-1 downto 0);
    CTRL_AWLEN                    : in  std_logic_vector(7 downto 0);
    CTRL_AWSIZE                   : in  std_logic_vector(2 downto 0);
    CTRL_AWBURST                  : in  std_logic_vector(1 downto 0);
    CTRL_AWLOCK                   : in  std_logic;
    CTRL_AWCACHE                  : in  std_logic_vector(3 downto 0);
    CTRL_AWPROT                   : in  std_logic_vector(2 downto 0);
    CTRL_WLAST                    : in  std_logic;
    CTRL_BID                      : out std_logic_vector(C_CTRL_ID_WIDTH-1 downto 0);
    CTRL_ARID                     : in  std_logic_vector(C_CTRL_ID_WIDTH-1 downto 0);
    CTRL_ARLEN                    : in  std_logic_vector(7 downto 0);
    CTRL_ARSIZE                   : in  std_logic_vector(2 downto 0);
    CTRL_ARBURST                  : in  std_logic_vector(1 downto 0);
    CTRL_ARLOCK                   : in  std_logic;
    CTRL_ARCACHE                  : in  std_logic_vector(3 downto 0);
    CTRL_ARPROT                   : in  std_logic_vector(2 downto 0);
    CTRL_RID                      : out std_logic_vector(C_CTRL_ID_WIDTH-1 downto 0);
    CTRL_RLAST                    : out std_logic;

    FIFO_ACLK                     : in  std_logic;
    FIFO_ARESETN                  : in  std_logic;
    FIFO_AWADDR                   : in  std_logic_vector(C_FIFO_ADDR_WIDTH-1 downto 0);
    FIFO_AWVALID                  : in  std_logic;
    FIFO_WDATA                    : in  std_logic_vector(C_FIFO_DATA_WIDTH-1 downto 0);
    FIFO_WSTRB                    : in  std_logic_vector((C_FIFO_DATA_WIDTH/8)-1 downto 0);
    FIFO_WVALID                   : in  std_logic;
    FIFO_BREADY                   : in  std_logic;
    FIFO_ARADDR                   : in  std_logic_vector(C_FIFO_ADDR_WIDTH-1 downto 0);
    FIFO_ARVALID                  : in  std_logic;
    FIFO_RREADY                   : in  std_logic;
    FIFO_ARREADY                  : out std_logic;
    FIFO_RDATA                    : out std_logic_vector(C_FIFO_DATA_WIDTH-1 downto 0);
    FIFO_RRESP                    : out std_logic_vector(1 downto 0);
    FIFO_RVALID                   : out std_logic;
    FIFO_WREADY                   : out std_logic;
    FIFO_BRESP                    : out std_logic_vector(1 downto 0);
    FIFO_BVALID                   : out std_logic;
    FIFO_AWREADY                  : out std_logic;
    FIFO_AWID                     : in  std_logic_vector(C_FIFO_ID_WIDTH-1 downto 0);
    FIFO_AWLEN                    : in  std_logic_vector(7 downto 0);
    FIFO_AWSIZE                   : in  std_logic_vector(2 downto 0);
    FIFO_AWBURST                  : in  std_logic_vector(1 downto 0);
    FIFO_AWLOCK                   : in  std_logic;
    FIFO_AWCACHE                  : in  std_logic_vector(3 downto 0);
    FIFO_AWPROT                   : in  std_logic_vector(2 downto 0);
    FIFO_WLAST                    : in  std_logic;
    FIFO_BID                      : out std_logic_vector(C_FIFO_ID_WIDTH-1 downto 0);
    FIFO_ARID                     : in  std_logic_vector(C_FIFO_ID_WIDTH-1 downto 0);
    FIFO_ARLEN                    : in  std_logic_vector(7 downto 0);
    FIFO_ARSIZE                   : in  std_logic_vector(2 downto 0);
    FIFO_ARBURST                  : in  std_logic_vector(1 downto 0);
    FIFO_ARLOCK                   : in  std_logic;
    FIFO_ARCACHE                  : in  std_logic_vector(3 downto 0);
    FIFO_ARPROT                   : in  std_logic_vector(2 downto 0);
    FIFO_RID                      : out std_logic_vector(C_FIFO_ID_WIDTH-1 downto 0);
    FIFO_RLAST                    : out std_logic;


    usr_clk_p : in std_logic;
    usr_clk_n : in std_logic;
    hdmi_clk : out std_logic;
    hdmi_vsync : out std_logic;
    hdmi_hsync : out std_logic;
    hdmi_de : out std_logic;
    hdmi_data : out std_logic_vector(15 downto 0);


    interrupt : out std_logic
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;
  attribute MAX_FANOUT of CLK       : signal is "10000";
  attribute MAX_FANOUT of RST_N       : signal is "10000";
  attribute SIGIS of CLK       : signal is "Clk";
  attribute SIGIS of RST_N       : signal is "Rst";


  attribute MAX_FANOUT of M_AXI_ACLK       : signal is "10000";
  attribute MAX_FANOUT of M_AXI_ARESETN       : signal is "10000";
  attribute SIGIS of M_AXI_ACLK       : signal is "Clk";
  attribute SIGIS of M_AXI_ARESETN       : signal is "Rst";


  attribute MAX_FANOUT of CTRL_ACLK       : signal is "10000";
  attribute MAX_FANOUT of CTRL_ARESETN       : signal is "10000";
  attribute SIGIS of CTRL_ACLK       : signal is "Clk";
  attribute SIGIS of CTRL_ARESETN       : signal is "Rst";

  attribute MAX_FANOUT of FIFO_ACLK       : signal is "10000";
  attribute MAX_FANOUT of FIFO_ARESETN       : signal is "10000";
  attribute SIGIS of FIFO_ACLK       : signal is "Clk";
  attribute SIGIS of FIFO_ARESETN       : signal is "Rst";


  attribute SIGIS of hdmi_clk : signal is "Clk";

end entity hdmiDisplay;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of hdmiDisplay is


  signal RDY_m_axi_write_writeAddr : std_logic;
  signal RDY_m_axi_write_writeData : std_logic;
  signal RDY_m_axi_write_writeResponse : std_logic;
  signal RDY_m_axi_read_readAddr : std_logic;
  signal RDY_m_axi_read_readData : std_logic;
  signal WILL_FIRE_m_axi_write_writeAddr : std_logic;
  signal WILL_FIRE_m_axi_write_writeData : std_logic;
  signal WILL_FIRE_m_axi_write_writeResponse : std_logic;
  signal WILL_FIRE_m_axi_read_readAddr : std_logic;
  signal WILL_FIRE_m_axi_read_readData : std_logic;


  signal ctrl_mem0_araddr_matches : boolean;
  signal ctrl_mem0_awaddr_matches : boolean;

  signal ctrl_read_readData : std_logic_vector(C_CTRL_DATA_WIDTH-1 downto 0);
  signal ctrl_write_writeResponse : std_logic_vector(1 downto 0);

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

  signal fifo_mem0_araddr_matches : boolean;
  signal fifo_mem0_awaddr_matches : boolean;

  signal fifo_read_readData : std_logic_vector(C_FIFO_DATA_WIDTH-1 downto 0);
  signal fifo_write_writeResponse : std_logic_vector(1 downto 0);

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


  signal usr_clk : std_logic;
  attribute MAX_FANOUT of usr_clk : signal is "10000";
  attribute SIGIS of usr_clk      : signal is "CLK";
  signal hdmi_vsync_unbuf, hdmi_hsync_unbuf, hdmi_de_unbuf : std_logic;
  signal hdmi_data_unbuf : std_logic_vector(15 downto 0);


begin

  HdmiDisplayIMPLEMENTATION : entity mkHdmiDisplayWrapper
    port map (
      CLK_hdmi_clk => usr_clk,
      CLK => CLK,
      RST_N  => RST_N,
      
      EN_m_axi_write_writeAddr => WILL_FIRE_m_axi_write_writeAddr,
      m_axi_write_writeAddr => m_axi_awaddr,
      m_axi_write_writeId => m_axi_awid(0),
      RDY_m_axi_write_writeAddr => RDY_m_axi_write_writeAddr,

      m_axi_write_writeBurstLen => m_axi_awlen,
      -- RDY_m_axi_write_writeBurstLen,

      m_axi_write_writeBurstWidth => m_axi_awsize,
      -- RDY_m_axi_write_writeBurstWidth,

      m_axi_write_writeBurstType => m_axi_awburst,
      -- RDY_m_axi_write_writeBurstType,

      m_axi_write_writeBurstProt => m_axi_awprot,
      -- RDY_m_axi_write_writeBurstProt,

      m_axi_write_writeBurstCache => m_axi_awcache,
      -- RDY_m_axi_write_writeBurstCache,

      EN_m_axi_write_writeData => WILL_FIRE_m_axi_write_writeData,
      m_axi_write_writeData => m_axi_wdata,
      RDY_m_axi_write_writeData => RDY_m_axi_write_writeData,

      m_axi_write_writeDataByteEnable => m_axi_wstrb,
      -- RDY_m_axi_write_writeDataByteEnable,

      m_axi_write_writeLastDataBeat => m_axi_wlast,
      -- RDY_m_axi_write_writeLastDataBeat,

      EN_m_axi_write_writeResponse => WILL_FIRE_m_axi_write_writeResponse,
      m_axi_write_writeResponse_responseCode => m_axi_bresp,
      m_axi_write_writeResponse_id => m_axi_bid(0),
      RDY_m_axi_write_writeResponse => RDY_m_axi_write_writeResponse,

      EN_m_axi_read_readAddr => WILL_FIRE_m_axi_read_readAddr,
      m_axi_read_readId => m_axi_arid(0),
      m_axi_read_readAddr => m_axi_araddr,
      RDY_m_axi_read_readAddr => RDY_m_axi_read_readAddr,

      m_axi_read_readBurstLen => m_axi_arlen,
      -- RDY_m_axi_read_readBurstLen,

      m_axi_read_readBurstWidth => m_axi_arsize,
      -- RDY_m_axi_read_readBurstWidth,

      m_axi_read_readBurstType => m_axi_arburst,
      -- RDY_m_axi_read_readBurstType,

      m_axi_read_readBurstProt => m_axi_arprot,
      -- RDY_m_axi_read_readBurstProt,

      m_axi_read_readBurstCache => m_axi_arcache,
      -- RDY_m_axi_read_readBurstCache,

      m_axi_read_readData_data => m_axi_rdata,
      m_axi_read_readData_resp => m_axi_rresp,
      m_axi_read_readData_last => m_axi_rlast,
      m_axi_read_readData_id => m_axi_rid(0),
      EN_m_axi_read_readData => WILL_FIRE_m_axi_read_readData,
      RDY_m_axi_read_readData => RDY_m_axi_read_readData,

      
      ctrl_read_readAddr_addr => CTRL_ARADDR,
      ctrl_read_readAddr_burstLen => CTRL_ARLEN,
      ctrl_read_readAddr_burstWidth => CTRL_ARSIZE,
      ctrl_read_readAddr_burstType => CTRL_ARBURST,
      ctrl_read_readAddr_burstProt => CTRL_ARPROT,
      ctrl_read_readAddr_burstCache => CTRL_ARCACHE,
      EN_ctrl_read_readAddr => EN_ctrl_read_readAddr,
      RDY_ctrl_read_readAddr => RDY_ctrl_read_readAddr,

      ctrl_read_last => ctrl_read_last,
      EN_ctrl_read_readData => EN_ctrl_read_readData,
      ctrl_read_readData => ctrl_read_readData,
      RDY_ctrl_read_readData => RDY_ctrl_read_readData,

      ctrl_write_writeAddr_addr => CTRL_AWADDR,
      ctrl_write_writeAddr_burstLen => CTRL_AWLEN,
      ctrl_write_writeAddr_burstWidth => CTRL_AWSIZE,
      ctrl_write_writeAddr_burstType => CTRL_AWBURST,
      ctrl_write_writeAddr_burstProt => CTRL_AWPROT,
      ctrl_write_writeAddr_burstCache => CTRL_AWCACHE,
      EN_ctrl_write_writeAddr => EN_ctrl_write_writeAddr,
      RDY_ctrl_write_writeAddr => RDY_ctrl_write_writeAddr,

      ctrl_write_writeData_data => CTRL_WDATA,
      ctrl_write_writeData_byteEnable => CTRL_WSTRB,
      ctrl_write_writeData_last => CTRL_WLAST,
      EN_ctrl_write_writeData => EN_ctrl_write_writeData,
      RDY_ctrl_write_writeData => RDY_ctrl_write_writeData,

      EN_ctrl_write_writeResponse => EN_ctrl_write_writeResponse,
      RDY_ctrl_write_writeResponse => RDY_ctrl_write_writeResponse,
      ctrl_write_writeResponse => ctrl_write_writeResponse,

      fifo_read_readAddr_addr => FIFO_ARADDR,
      fifo_read_readAddr_burstLen => FIFO_ARLEN,
      fifo_read_readAddr_burstWidth => FIFO_ARSIZE,
      fifo_read_readAddr_burstType => FIFO_ARBURST,
      fifo_read_readAddr_burstProt => FIFO_ARPROT,
      fifo_read_readAddr_burstCache => FIFO_ARCACHE,
      EN_fifo_read_readAddr => EN_fifo_read_readAddr,
      RDY_fifo_read_readAddr => RDY_fifo_read_readAddr,

      fifo_read_last => fifo_read_last,
      EN_fifo_read_readData => EN_fifo_read_readData,
      fifo_read_readData => fifo_read_readData,
      RDY_fifo_read_readData => RDY_fifo_read_readData,

      fifo_write_writeAddr_addr => FIFO_AWADDR,
      fifo_write_writeAddr_burstLen => FIFO_AWLEN,
      fifo_write_writeAddr_burstWidth => FIFO_AWSIZE,
      fifo_write_writeAddr_burstType => FIFO_AWBURST,
      fifo_write_writeAddr_burstProt => FIFO_AWPROT,
      fifo_write_writeAddr_burstCache => FIFO_AWCACHE,
      EN_fifo_write_writeAddr => EN_fifo_write_writeAddr,
      RDY_fifo_write_writeAddr => RDY_fifo_write_writeAddr,

      fifo_write_writeData_data => FIFO_WDATA,
      fifo_write_writeData_byteEnable => FIFO_WSTRB,
      fifo_write_writeData_last => FIFO_WLAST,
      EN_fifo_write_writeData => EN_fifo_write_writeData,
      RDY_fifo_write_writeData => RDY_fifo_write_writeData,

      EN_fifo_write_writeResponse => EN_fifo_write_writeResponse,
      RDY_fifo_write_writeResponse => RDY_fifo_write_writeResponse,
      fifo_write_writeResponse => fifo_write_writeResponse,

      
      hdmi_hdmi_vsync => hdmi_vsync_unbuf,
      hdmi_hdmi_hsync => hdmi_hsync_unbuf,
      hdmi_hdmi_de => hdmi_de_unbuf,
      hdmi_hdmi_data => hdmi_data_unbuf,


      interrupt => interrupt
      );


  WILL_FIRE_m_axi_read_readAddr <= (m_axi_arready and RDY_m_axi_read_readAddr);
  WILL_FIRE_m_axi_read_readData <= (m_axi_rvalid and RDY_m_axi_read_readData);
  m_axi_arvalid <= RDY_m_axi_read_readAddr;
  m_axi_rready <= RDY_m_axi_read_readData;

  WILL_FIRE_m_axi_write_writeAddr <= (m_axi_awready and RDY_m_axi_write_writeAddr);
  WILL_FIRE_m_axi_write_writeData <= (m_axi_wready and RDY_m_axi_write_writeData);
  WILL_FIRE_m_axi_write_writeResponse <= (m_axi_bvalid and RDY_m_axi_write_writeResponse);
  m_axi_awvalid <= RDY_m_axi_write_writeAddr;
  m_axi_wvalid <= RDY_m_axi_write_writeData;
  m_axi_bready <= RDY_m_axi_write_writeResponse;


  ctrl_mem0_araddr_matches <= (CTRL_ARADDR >= C_CTRL_MEM0_BASEADDR and CTRL_ARADDR <= C_CTRL_MEM0_HIGHADDR);
  ctrl_mem0_awaddr_matches <= (CTRL_AWADDR >= C_CTRL_MEM0_BASEADDR and CTRL_AWADDR <= C_CTRL_MEM0_HIGHADDR);

  CTRL_ARREADY  <= RDY_ctrl_read_readAddr when ctrl_mem0_araddr_matches else '0';
  CTRL_RVALID <= EN_ctrl_read_readData;
  CTRL_RRESP  <= "00";

  CTRL_RDATA  <= ctrl_read_readData when EN_ctrl_read_readData = '1' else (others => '0');
  CTRL_RLAST  <= ctrl_read_last when EN_ctrl_read_readData = '1' else '0';


  CTRL_RID <= (others => '0');
  CTRL_BID <= (others => '0');
  CTRL_AWREADY  <= RDY_ctrl_write_writeAddr when ctrl_mem0_awaddr_matches else '0';
  CTRL_WREADY <= RDY_ctrl_write_writeData;
  CTRL_BVALID  <= EN_ctrl_write_writeResponse;
  CTRL_BRESP <= ctrl_write_writeResponse when EN_ctrl_write_writeResponse = '1' else
                 (others => '0');

  EN_ctrl_read_readAddr <= RDY_ctrl_read_readAddr and CTRL_ARVALID when ctrl_mem0_araddr_matches else '0';
  EN_ctrl_read_readData <= RDY_ctrl_read_readData and CTRL_RREADY;

  EN_ctrl_write_writeAddr <= RDY_ctrl_write_writeAddr and CTRL_AWVALID when ctrl_mem0_awaddr_matches else '0';
  EN_ctrl_write_writeData <= RDY_ctrl_write_writeData and CTRL_WVALID;
  EN_ctrl_write_writeResponse <= RDY_ctrl_write_writeResponse and CTRL_BREADY;

  fifo_mem0_araddr_matches <= (FIFO_ARADDR >= C_FIFO_MEM0_BASEADDR and FIFO_ARADDR <= C_FIFO_MEM0_HIGHADDR);
  fifo_mem0_awaddr_matches <= (FIFO_AWADDR >= C_FIFO_MEM0_BASEADDR and FIFO_AWADDR <= C_FIFO_MEM0_HIGHADDR);

  FIFO_ARREADY  <= RDY_fifo_read_readAddr when fifo_mem0_araddr_matches else '0';
  FIFO_RVALID <= EN_fifo_read_readData;
  FIFO_RRESP  <= "00";

  FIFO_RDATA  <= fifo_read_readData when EN_fifo_read_readData = '1' else (others => '0');
  FIFO_RLAST  <= fifo_read_last when EN_fifo_read_readData = '1' else '0';


  FIFO_RID <= (others => '0');
  FIFO_BID <= (others => '0');
  FIFO_AWREADY  <= RDY_fifo_write_writeAddr when fifo_mem0_awaddr_matches else '0';
  FIFO_WREADY <= RDY_fifo_write_writeData;
  FIFO_BVALID  <= EN_fifo_write_writeResponse;
  FIFO_BRESP <= fifo_write_writeResponse when EN_fifo_write_writeResponse = '1' else
                 (others => '0');

  EN_fifo_read_readAddr <= RDY_fifo_read_readAddr and FIFO_ARVALID when fifo_mem0_araddr_matches else '0';
  EN_fifo_read_readData <= RDY_fifo_read_readData and FIFO_RREADY;

  EN_fifo_write_writeAddr <= RDY_fifo_write_writeAddr and FIFO_AWVALID when fifo_mem0_awaddr_matches else '0';
  EN_fifo_write_writeData <= RDY_fifo_write_writeData and FIFO_WVALID;
  EN_fifo_write_writeResponse <= RDY_fifo_write_writeResponse and FIFO_BREADY;


    IBUFGDS_usr_clk : IBUFGDS
    generic map (
    DIFF_TERM => FALSE,
    IBUF_LOW_PWR => TRUE,
    IOSTANDARD => "DEFAULT")
    port map (
    O => usr_clk,
    -- Buffer output (connect directly to top-level port)
    I => usr_clk_p,
    IB => usr_clk_n
    -- Buffer input
    );

    OBUF_hdmi_clk : OBUF
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

    OBUF_xadc_gpio_0 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => xadc_gpio_0,
    -- Buffer output (connect directly to top-level port)
    I => hdmi_vsync_unbuf
    -- Buffer input
    );
    OBUF_xadc_gpio_1 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => xadc_gpio_1,
    -- Buffer output (connect directly to top-level port)
    I => WILL_FIRE_m_axi_read_readAddr
    -- Buffer input
    );
    OBUF_xadc_gpio_2 : OBUF
    generic map (
    DRIVE => 12,
    IOSTANDARD => "LVCMOS25",
    SLEW => "SLOW")
    port map (
    O => xadc_gpio_2,
    -- Buffer output (connect directly to top-level port)
    I => WILL_FIRE_m_axi_read_readData
    -- Buffer input
    );
    OBUF_xadc_gpio_3 : OBUF
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


end IMP;
