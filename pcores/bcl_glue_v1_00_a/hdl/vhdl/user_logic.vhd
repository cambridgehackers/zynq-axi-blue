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

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;
use proc_common_v3_00_a.srl_fifo_f;

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_MST_NATIVE_DATA_WIDTH      -- Internal bus width on user-side
--   C_LENGTH_WIDTH               -- Master interface data bus width
--   C_MST_AWIDTH                 -- Master-Intf address bus width
--   C_NUM_REG                    -- Number of software accessible registers
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Resetn                -- Bus to IP reset
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
--   ip2bus_mstrd_req             -- IP to Bus master read request
--   ip2bus_mstwr_req             -- IP to Bus master write request
--   ip2bus_mst_addr              -- IP to Bus master read/write address
--   ip2bus_mst_be                -- IP to Bus byte enable
--   ip2bus_mst_length            -- Ip to Bus master transfer length
--   ip2bus_mst_type              -- Ip to Bus burst assertion control
--   ip2bus_mst_lock              -- Ip to Bus bus lock
--   ip2bus_mst_reset             -- Ip to Bus master reset
--   bus2ip_mst_cmdack            -- Bus to Ip master command ack
--   bus2ip_mst_cmplt             -- Bus to Ip master trans complete
--   bus2ip_mst_error             -- Bus to Ip master error
--   bus2ip_mst_rearbitrate       -- Bus to Ip master re-arbitrate for bus ownership
--   bus2ip_mst_cmd_timeout       -- Bus to Ip master command time out
--   bus2ip_mstrd_d               -- Bus to Ip master read data
--   bus2ip_mstrd_rem             -- Bus to Ip master read data rem
--   bus2ip_mstrd_sof_n           -- Bus to Ip master read start of frame
--   bus2ip_mstrd_eof_n           -- Bus to Ip master read end of frame
--   bus2ip_mstrd_src_rdy_n       -- Bus to Ip master read source ready
--   bus2ip_mstrd_src_dsc_n       -- Bus to Ip master read source dsc
--   ip2bus_mstrd_dst_rdy_n       -- Ip to Bus master read dest. ready
--   ip2bus_mstrd_dst_dsc_n       -- Ip to Bus master read dest. dsc
--   ip2bus_mstwr_d               -- Ip to Bus master write data
--   ip2bus_mstwr_rem             -- Ip to Bus master write data rem
--   ip2bus_mstwr_src_rdy_n       -- Ip to Bus master write source ready
--   ip2bus_mstwr_src_dsc_n       -- Ip to Bus master write source dsc
--   ip2bus_mstwr_sof_n           -- Ip to Bus master write start of frame
--   ip2bus_mstwr_eof_n           -- Ip to Bus master write end of frame
--   bus2ip_mstwr_dst_rdy_n       -- Bus to Ip master write dest. ready
--   bus2ip_mstwr_dst_dsc_n       -- Bus to Ip master write dest. ready
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    C_MAX_BURST_LEN                : integer              := 128;
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_MST_NATIVE_DATA_WIDTH        : integer              := 32;
    C_LENGTH_WIDTH                 : integer              := 12;
    C_MST_AWIDTH                   : integer              := 32;
    C_NUM_REG                      : integer              := 8;
    C_NUM_SLV_REG                  : integer              := 4;
    C_SLV_DWIDTH                   : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    timer                          : in  std_logic_vector(63 downto 0);
    reset_timer                    : out std_logic;
    hw_timer                       : in  std_logic_vector(63 downto 0);
    FSL_RDY_put                    : in  std_logic;
    FSL_put                        : out std_logic_vector(C_MST_NATIVE_DATA_WIDTH-1 downto 0);
    FSL_EN_put                     : out std_logic;
    FSL_RDY_get                    : in  std_logic;
    FSL_get                        : in  std_logic_vector(C_MST_NATIVE_DATA_WIDTH-1 downto 0);
    FSL_EN_get                     : out std_logic;
		FSL_TxBSZ                      : in  std_logic_vector(31 downto 0);
		FSL_RxBSZ                      : in  std_logic_vector(31 downto 0);
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Resetn                  : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    Bus2IP_BE                      : in  std_logic_vector(C_SLV_DWIDTH/8-1 downto 0);
    Bus2IP_RdCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    Bus2IP_WrCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    IP2Bus_Data                    : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic;
    ip2bus_mstrd_req               : out std_logic;
    ip2bus_mstwr_req               : out std_logic;
    ip2bus_mst_addr                : out std_logic_vector(C_MST_AWIDTH-1 downto 0);
    ip2bus_mst_be                  : out std_logic_vector((C_MST_NATIVE_DATA_WIDTH/8)-1 downto 0);
    ip2bus_mst_length              : out std_logic_vector(C_LENGTH_WIDTH-1 downto 0);
    ip2bus_mst_type                : out std_logic;
    ip2bus_mst_lock                : out std_logic;
    ip2bus_mst_reset               : out std_logic;
    bus2ip_mst_cmdack              : in  std_logic;
    bus2ip_mst_cmplt               : in  std_logic;
    bus2ip_mst_error               : in  std_logic;
    bus2ip_mst_rearbitrate         : in  std_logic;
    bus2ip_mst_cmd_timeout         : in  std_logic;
    bus2ip_mstrd_d                 : in  std_logic_vector(C_MST_NATIVE_DATA_WIDTH-1 downto 0);
    bus2ip_mstrd_rem               : in  std_logic_vector((C_MST_NATIVE_DATA_WIDTH)/8-1 downto 0);
    bus2ip_mstrd_sof_n             : in  std_logic;
    bus2ip_mstrd_eof_n             : in  std_logic;
    bus2ip_mstrd_src_rdy_n         : in  std_logic;
    bus2ip_mstrd_src_dsc_n         : in  std_logic;
    ip2bus_mstrd_dst_rdy_n         : out std_logic;
    ip2bus_mstrd_dst_dsc_n         : out std_logic;
    ip2bus_mstwr_d                 : out std_logic_vector(C_MST_NATIVE_DATA_WIDTH-1 downto 0);
    ip2bus_mstwr_rem               : out std_logic_vector((C_MST_NATIVE_DATA_WIDTH)/8-1 downto 0);
    ip2bus_mstwr_src_rdy_n         : out std_logic;
    ip2bus_mstwr_src_dsc_n         : out std_logic;
    ip2bus_mstwr_sof_n             : out std_logic;
    ip2bus_mstwr_eof_n             : out std_logic;
    bus2ip_mstwr_dst_rdy_n         : in  std_logic;
    bus2ip_mstwr_dst_dsc_n         : in  std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn : signal is "RST";
  attribute SIGIS of ip2bus_mst_reset: signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  --Register logic:
  --
  --Tx = sw -> hw
  --Rx = hw -> sw
  --
  --0	  input fifo size (RO)
  --1	  output fifo size (RO)
  --2	  Tx burst size (RO)
  --3	  Rx burst size (RO)
  --4	  control: {31: SW timer enable, 0: 32-bit transfer} (RW)
  --5
  --6	  global timer lo (RW, writing == reset)
  --7	  global timer hi (RW, writing == reset)
  --8	  sw timer lo (RW, writing == reset)
  --9	  sw timer hi (RW, writing == reset)
  --10	tx timer lo (RW, writing == reset)
  --11	tx timer hi (RW, writing == reset)
  --12	rx timer lo (RO, reading == stop)
  --13	rx timer hi (RO, reading == stop)
  --14  hw timer lo (RO)
  --15  hw timer hi (RO)

  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal slv_reg0                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg1                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg2                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg3                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg4                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg5                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg6                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg7                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg8                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg9                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg10                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg11                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg12                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg13                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg14                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg15                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg_write_sel              : std_logic_vector(C_NUM_SLV_REG-1 downto 0);
  signal slv_reg_read_sel               : std_logic_vector(C_NUM_SLV_REG-1 downto 0);
  signal slv_ip2bus_data                : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;

  ------------------------------------------
  -- Signals for user logic master model example
  ------------------------------------------
  -- signals for master model control/status registers write/read
  signal mst_ip2bus_data                : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal mst_reg_write_req              : std_logic;
  signal mst_reg_read_req               : std_logic;
  signal mst_reg_write_sel              : std_logic_vector(3 downto 0);
  signal mst_reg_read_sel               : std_logic_vector(3 downto 0);
  signal mst_write_ack                  : std_logic;
  signal mst_read_ack                   : std_logic;
  -- signals for master model control/status registers
  type BYTE_REG_TYPE is array(0 to 15) of std_logic_vector(7 downto 0);
  signal mst_reg                        : BYTE_REG_TYPE;
  signal mst_byte_we                    : std_logic_vector(15 downto 0);
  signal mst_cntl_rd_req                : std_logic;
  signal mst_cntl_wr_req                : std_logic;
  signal mst_cntl_bus_lock              : std_logic;
  signal mst_cntl_burst                 : std_logic;
  signal mst_ip2bus_addr                : std_logic_vector(C_MST_AWIDTH-1 downto 0);
  signal mst_xfer_length                : std_logic_vector(C_LENGTH_WIDTH-1 downto 0);
  signal mst_xfer_reg_len               : std_logic_vector(19 downto 0);
  signal mst_ip2bus_be                  : std_logic_vector(15 downto 0);
  signal mst_go                         : std_logic;
  -- signals for master model command interface state machine
  type CMD_CNTL_SM_TYPE is (CMD_IDLE, CMD_RUN, CMD_WAIT_FOR_DATA, CMD_DONE);
  signal mst_cmd_sm_state               : CMD_CNTL_SM_TYPE;
  signal mst_cmd_sm_set_done            : std_logic;
  signal mst_cmd_sm_set_error           : std_logic;
  signal mst_cmd_sm_set_timeout         : std_logic;
  signal mst_cmd_sm_busy                : std_logic;
  signal mst_cmd_sm_clr_go              : std_logic;
  signal mst_cmd_sm_rd_req              : std_logic;
  signal mst_cmd_sm_wr_req              : std_logic;
  signal mst_cmd_sm_reset               : std_logic;
  signal mst_cmd_sm_bus_lock            : std_logic;
  signal mst_cmd_sm_ip2bus_addr         : std_logic_vector(C_MST_AWIDTH-1 downto 0);
  signal mst_cmd_sm_ip2bus_be           : std_logic_vector(C_MST_NATIVE_DATA_WIDTH/8-1 downto 0);
  signal mst_cmd_sm_xfer_type           : std_logic;
  signal mst_cmd_sm_xfer_length         : std_logic_vector(C_LENGTH_WIDTH-1 downto 0);
  signal mst_cmd_sm_start_rd_llink      : std_logic;
  signal mst_cmd_sm_start_wr_llink      : std_logic;
  -- signals for master model read locallink interface state machine
  type RD_LLINK_SM_TYPE is (LLRD_IDLE, LLRD_GO);
  signal mst_llrd_sm_state              : RD_LLINK_SM_TYPE;
  signal mst_llrd_sm_dst_rdy            : std_logic;
  -- signals for master model write locallink interface state machine
  type WR_LLINK_SM_TYPE is (LLWR_IDLE, LLWR_SNGL_INIT, LLWR_SNGL, LLWR_BRST_INIT, LLWR_BRST, LLWR_BRST_LAST_BEAT);
  signal mst_llwr_sm_state              : WR_LLINK_SM_TYPE;
  signal mst_llwr_sm_src_rdy            : std_logic;
  signal mst_llwr_sm_sof                : std_logic;
  signal mst_llwr_sm_eof                : std_logic;
  signal mst_llwr_byte_cnt              : integer;
  signal mst_fifo_valid_write_xfer      : std_logic;
  signal mst_fifo_valid_read_xfer       : std_logic;
  signal Bus2IP_Reset                   : std_logic;
attribute SIGIS of Bus2IP_Reset   : signal is "RST";

  signal fifo_i_push                    : std_logic;
  signal fifo_i_pop                     : std_logic;
  signal fifo_i_data                    : std_logic_vector(C_MST_NATIVE_DATA_WIDTH-1 downto 0);
  signal fifo_i_empty                   : std_logic;

--  signal EN_put                         : std_logic;
--  signal RDY_put                        : std_logic;
--  signal EN_get                         : std_logic;
--  signal RDY_get                        : std_logic;

  signal fifo_o_push                    : std_logic;
  signal fifo_o_pop                     : std_logic;
  signal fifo_o_data                    : std_logic_vector(C_MST_NATIVE_DATA_WIDTH-1 downto 0);
  signal fifo_o_full                    : std_logic;
  signal fifo_o_empty                   : std_logic;

  signal padding_in                     : std_logic;
  signal padding_out                    : std_logic;
  
  signal is_one_word                    : std_logic;
  
  signal sw_timer                       : std_logic_vector(63 downto 0);
  
  signal tx_timer                       : std_logic_vector(63 downto 0);
  signal enable_tx_timer                : std_logic;
  signal stop_tx_timer                  : std_logic;

  signal rx_timer                       : std_logic_vector(63 downto 0);
  signal enable_rx_timer                : std_logic;
  signal stop_rx_timer                  : std_logic;
  
  signal mst_is_wr_cmd                  : std_logic;
begin

  --USER logic implementation added here

  ------------------------------------------
  -- Example code to read/write user logic slave model s/w accessible registers
  -- 
  -- Note:
  -- The example code presented here is to show you one way of reading/writing
  -- software accessible registers implemented in the user logic slave model.
  -- Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  -- to one software accessible register by the top level template. For example,
  -- if you have four 32 bit software accessible registers in the user logic,
  -- you are basically operating on the following memory mapped registers:
  -- 
  --    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  --                     "1000"   C_BASEADDR + 0x0
  --                     "0100"   C_BASEADDR + 0x4
  --                     "0010"   C_BASEADDR + 0x8
  --                     "0001"   C_BASEADDR + 0xC
  -- 
  ------------------------------------------
  slv_reg_write_sel <= Bus2IP_WrCE(C_NUM_SLV_REG-1 downto 0);
  slv_reg_read_sel  <= Bus2IP_RdCE(C_NUM_SLV_REG-1 downto 0);
  
--    slv_write_ack     <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3) or
--      Bus2IP_WrCE(4) or Bus2IP_WrCE(5) or Bus2IP_WrCE(6) or Bus2IP_WrCE(7) or
--      Bus2IP_WrCE(8) or Bus2IP_WrCE(9) or Bus2IP_WrCE(10) or Bus2IP_WrCE(11) or
--      Bus2IP_WrCE(12) or Bus2IP_WrCE(13) or Bus2IP_WrCE(14) or Bus2IP_WrCE(15);
--    slv_read_ack      <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3) or
--      Bus2IP_RdCE(4) or Bus2IP_RdCE(5) or Bus2IP_RdCE(6) or Bus2IP_RdCE(7) or
--      Bus2IP_RdCE(8) or Bus2IP_RdCE(9) or Bus2IP_RdCE(10) or Bus2IP_RdCE(11) or
--      Bus2IP_RdCE(12) or Bus2IP_RdCE(13) or Bus2IP_RdCE(14) or Bus2IP_RdCE(15);

  SLV_REG_PROC: process( Bus2IP_WrCE(C_NUM_SLV_REG-1 downto 0), Bus2IP_RdCE(C_NUM_SLV_REG-1 downto 0) ) is
    variable slv_write_ack_v : std_logic;
    variable slv_read_ack_v : std_logic;
  begin
    slv_write_ack_v := '0';
    slv_read_ack_v := '0';
    for I in 0 to C_NUM_SLV_REG-1 loop
      slv_write_ack_v := slv_write_ack_v or Bus2IP_WrCE(I);
      slv_read_ack_v := slv_read_ack_v or Bus2IP_RdCE(I);
    end loop;
    slv_write_ack <= slv_write_ack_v;
    slv_read_ack <= slv_read_ack_v;
  end process;

  -- implement slave model software accessible register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
    variable reset_timer_v : std_logic;
    variable reset_sw_timer_v : std_logic;
    variable reset_tx_timer_v : std_logic;
    variable reset_rx_timer_v : std_logic;
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Resetn = '0' then
--        slv_reg0 <= (others => '0');
--        slv_reg1 <= (others => '0');
--        slv_reg2 <= (others => '0');
--        slv_reg3 <= (others => '0');
        slv_reg4 <= X"80000000";
        slv_reg5 <= (others => '0');
--        slv_reg6 <= (others => '0');
--        slv_reg7 <= (others => '0');
        
        reset_timer <= '0';
        sw_timer <= (others => '0');

        tx_timer <= (others => '0');
        enable_tx_timer <= '0';

        rx_timer <= (others => '0');
        enable_rx_timer <= '0';
        
      else
        
        reset_timer_v := '0';
        reset_sw_timer_v := '0';
        reset_tx_timer_v := '0';
        reset_rx_timer_v := '0';
      
        case slv_reg_write_sel is
          when "0000100000000000" => --4
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg4(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "0000010000000000" => --5
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg5(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "0000001000000000" => --6
            reset_timer_v := '1';
          when "0000000100000000" => --7
            reset_timer_v := '1';
          when "0000000010000000" => --8
            reset_sw_timer_v := '1';
          when "0000000001000000" => --9
            reset_sw_timer_v := '1';
          when "0000000000100000" => --10
            reset_tx_timer_v := '1';
          when "0000000000010000" => --11
            reset_tx_timer_v := '1';
          when "0000000000001000" => --12
            reset_rx_timer_v := '1';
          when "0000000000000100" => --13
            reset_rx_timer_v := '1';
          when others => null;
        end case;
        
        reset_timer <= reset_timer_v;
        
        if reset_sw_timer_v = '1' then
          sw_timer <= (others => '0');
        elsif slv_reg4(31) = '1' then
          sw_timer <= sw_timer + 1;
        end if;
        
        if reset_tx_timer_v = '1' then
          tx_timer <= (others => '0');
        elsif enable_tx_timer = '1' then
          tx_timer <= tx_timer + 1;
        end if;

        if stop_tx_timer = '1' then
          enable_tx_timer <= '0';
        elsif reset_tx_timer_v = '1' then
          enable_tx_timer <= '1';
        end if;

        if reset_rx_timer_v = '1' then
          rx_timer <= (others => '0');
        elsif enable_rx_timer = '1' then
          rx_timer <= rx_timer + 1;
        end if;
        
        if stop_rx_timer = '1' then
          enable_rx_timer <= '0';
        elsif reset_rx_timer_v = '1' then
          enable_rx_timer <= '1';
        end if;

      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;
  
  is_one_word <= slv_reg4(0);
  
  slv_reg6 <= timer(31 downto 0);
  slv_reg7 <= timer(63 downto 32);
  slv_reg8 <= sw_timer(31 downto 0);
  slv_reg9 <= sw_timer(63 downto 32);
  slv_reg10 <= tx_timer(31 downto 0);
  slv_reg11 <= tx_timer(63 downto 32);
  slv_reg12 <= rx_timer(31 downto 0);
  slv_reg13 <= rx_timer(63 downto 32);
  slv_reg14 <= hw_timer(31 downto 0);
  slv_reg15 <= hw_timer(63 downto 32);

  -- implement slave model software accessible register(s) read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_sel, slv_reg0, slv_reg1, slv_reg2, slv_reg3,
      slv_reg4, slv_reg5, slv_reg6, slv_reg7, slv_reg8, slv_reg9, slv_reg10, slv_reg11,
      slv_reg12, slv_reg13, slv_reg14, slv_reg15 ) is
  begin

    case slv_reg_read_sel is
      when "1000000000000000" => slv_ip2bus_data <= slv_reg0;
      when "0100000000000000" => slv_ip2bus_data <= slv_reg1;
      when "0010000000000000" => slv_ip2bus_data <= slv_reg2;
      when "0001000000000000" => slv_ip2bus_data <= slv_reg3;
      when "0000100000000000" => slv_ip2bus_data <= slv_reg4;
      when "0000010000000000" => slv_ip2bus_data <= slv_reg5;
      when "0000001000000000" => slv_ip2bus_data <= slv_reg6;
      when "0000000100000000" => slv_ip2bus_data <= slv_reg7;
      when "0000000010000000" => slv_ip2bus_data <= slv_reg8;
      when "0000000001000000" => slv_ip2bus_data <= slv_reg9;
      when "0000000000100000" => slv_ip2bus_data <= slv_reg10;
      when "0000000000010000" => slv_ip2bus_data <= slv_reg11;
      when "0000000000001000" => slv_ip2bus_data <= slv_reg12;
      when "0000000000000100" => slv_ip2bus_data <= slv_reg13;
      when "0000000000000010" => slv_ip2bus_data <= slv_reg14;
      when "0000000000000001" => slv_ip2bus_data <= slv_reg15;
      when others => slv_ip2bus_data <= (others => '0');
    end case;
    
  end process SLAVE_REG_READ_PROC;

  ------------------------------------------
  -- Example code to demonstrate user logic master model functionality
  -- 
  -- Note:
  -- The example code presented here is to show you one way of stimulating
  -- the AXI4LITE master interface under user control. It is provided for
  -- demonstration purposes only and allows the user to exercise the AXI4LITE
  -- master interface during test and evaluation of the template.
  -- This user logic master model contains a 16-byte flattened register and
  -- the user is required to initialize the value to desire and then write to
  -- the model's 'Go' port to initiate the user logic master operation.
  -- 
  --    Control Register     (C_BASEADDR + OFFSET + 0x0):
  --       bit 0    - Rd     (Read Request Control)
  --       bit 1    - Wr     (Write Request Control)
  --       bit 2    - BL     (Bus Lock Control)
  --       bit 3    - Brst   (Burst Assertion Control)
  --       bit 4-7  - Spare  (Spare Control Bits)
  --    Status Register      (C_BASEADDR + OFFSET + 0x1):
  --       bit 0    - Done   (Transfer Done Status)
  --       bit 1    - Busy   (User Logic Master is Busy)
  --       bit 2    - Error  (User Logic Master request got error response)
  --       bit 3    - Tmout  (User Logic Master request is timeout)
  --       bit 2-7  - Spare  (Spare Status Bits)
  --    Addrress Register    (C_BASEADDR + OFFSET + 0x4):
  --       bit 0-31 - Target Address (This 32-bit value is used to populate the
  --                  IP2Bus_Mst_Addr(0:31) address bus during a Read or Write
  --                  user logic master operation)
  --    Byte Enable Register (C_BASEADDR + OFFSET + 0x8):
  --       bit 0-15 - Master BE (This 16-bit value is used to populate the
  --                  IP2Bus_Mst_BE byte enable bus during a Read or Write user
  --                  logic master operation for single data beat transfer)
  --    Length Register      (C_BASEADDR + OFFSET + 0xC):
  --       bit 0-3  - Reserved
  --       bit 4-15 - Transfer Length (This 12-bit value is used to populate the
  --                  IP2Bus_Mst_Length(0:11) transfer length bus which specifies
  --                  the number of bytes (1 to 4096) to transfer during user logic
  --                  master Read or Write fixed length burst operations)
  --    Go Register          (C_BASEADDR + OFFSET + 0xF):
  --       bit 0-7  - Go Port (Write to this byte address initiates the user
  --                  logic master transfer, data key value of 0x0A must be used)
  -- 
  --    Note: OFFSET may be different depending on your address space configuration,
  --          by default it's either 0x0 or 0x100. Refer to IPIF address range array
  --          for actual value.
  -- 
  -- Here's an example procedure in your software application to initiate a 4-byte
  -- write operation (single data beat) of this master model:
  --   1. write 0x02 to the control register
  --   2. write the target address to the address register
  --   3. write valid byte lane value to the be register
  --      - note: this value must be aligned with ip2bus address
  --   4. write 0x0004 to the length register
  --   5. write 0x0a to the go register, this will start the master write operation
  -- 
  ------------------------------------------
  mst_reg_write_req <= Bus2IP_WrCE(C_NUM_REG-4) or Bus2IP_WrCE(C_NUM_REG-3) or
    Bus2IP_WrCE(C_NUM_REG-2) or Bus2IP_WrCE(C_NUM_REG-1);
  mst_reg_read_req  <= Bus2IP_RdCE(C_NUM_REG-4) or Bus2IP_RdCE(C_NUM_REG-3) or
    Bus2IP_RdCE(C_NUM_REG-2) or Bus2IP_RdCE(C_NUM_REG-1);
  mst_reg_write_sel <= Bus2IP_WrCE(C_NUM_REG-1 downto C_NUM_REG-4);
  mst_reg_read_sel  <= Bus2IP_RdCE(C_NUM_REG-1 downto C_NUM_REG-4);
  mst_write_ack     <= mst_reg_write_req;
  mst_read_ack      <= mst_reg_read_req;

  -- rip control bits from master model registers
  mst_cntl_rd_req   <= mst_reg(0)(0);
  mst_cntl_wr_req   <= mst_reg(0)(1);
  mst_cntl_bus_lock <= mst_reg(0)(2);
  mst_cntl_burst    <= mst_reg(0)(3);
  mst_ip2bus_addr   <= mst_reg(7) & mst_reg(6) & mst_reg(5) & mst_reg(4);
  mst_ip2bus_be     <= mst_reg(9) & mst_reg(8);
  mst_xfer_reg_len  <= mst_reg(14)(3 downto 0) &  mst_reg(13) & mst_reg(12);
  mst_xfer_length   <= mst_xfer_reg_len(C_LENGTH_WIDTH-1 downto 0 );

  -- implement byte write enable for each byte slice of the master model registers
  MASTER_REG_BYTE_WR_EN : process( Bus2IP_BE, mst_reg_write_req, mst_reg_write_sel ) is
    constant BE_WIDTH : integer := C_SLV_DWIDTH/8;
  begin

    for byte_index in 0 to 15 loop
      mst_byte_we(byte_index) <= mst_reg_write_req and
                                 mst_reg_write_sel(3 - (byte_index/BE_WIDTH) ) and
                                 Bus2IP_BE(byte_index- ((byte_index/BE_WIDTH)*BE_WIDTH));
    end loop;

  end process MASTER_REG_BYTE_WR_EN;

  -- implement master model registers
  MASTER_REG_WRITE_PROC : process( Bus2IP_Clk ) is
    constant BE_WIDTH : integer := C_SLV_DWIDTH/8;
  begin

    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if ( Bus2IP_Resetn = '0' ) then
        mst_reg(0 to 14) <= (others => "00000000");
      else
        -- control register (byte 0)
        if ( mst_byte_we(0) = '1' ) then
          mst_reg(0) <= Bus2IP_Data(7 downto 0);
        end if;
        -- status register (byte 1)
        mst_reg(1)(1) <= mst_cmd_sm_busy;
        if ( mst_byte_we(1) = '1' ) then
          -- allows a clear of the 'Done'/'error'/'timeout'
          mst_reg(1)(0) <= Bus2IP_Data((1-(1/BE_WIDTH)*BE_WIDTH)*8);
          mst_reg(1)(2) <= Bus2IP_Data((1-(1/BE_WIDTH)*BE_WIDTH)*8+2);
          mst_reg(1)(3) <= Bus2IP_Data((1-(1/BE_WIDTH)*BE_WIDTH)*8+3);
        else
          -- 'Done'/'error'/'timeout' from master control state machine
          mst_reg(1)(0)  <= mst_cmd_sm_set_done or mst_reg(1)(0);
          mst_reg(1)(2)  <= mst_cmd_sm_set_error or mst_reg(1)(2);
          mst_reg(1)(3)  <= mst_cmd_sm_set_timeout or mst_reg(1)(3);
        end if;
        -- byte 2 and 3 are reserved
        -- address register (byte 4 to 7)
        -- be register (byte 8 to 9)
        -- length register (byte 12 to 13)
        -- byte 10, 11 and 14 are reserved
        for byte_index in 4 to 14 loop
          if ( mst_byte_we(byte_index) = '1' ) then
            mst_reg(byte_index) <= Bus2IP_Data(
                                     (byte_index-(byte_index/BE_WIDTH)*BE_WIDTH)*8+7 downto
                                     (byte_index-(byte_index/BE_WIDTH)*BE_WIDTH)*8);
          end if;
        end loop;
      end if;
    end if;

  end process MASTER_REG_WRITE_PROC;

  -- implement master model write only 'go' port
  MASTER_WRITE_GO_PORT : process( Bus2IP_Clk ) is
    constant GO_DATA_KEY  : std_logic_vector(7 downto 0) := X"0A";
    constant GO_BYTE_LANE : integer := 15;
    constant BE_WIDTH     : integer := C_SLV_DWIDTH/8;
  begin

    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if ( Bus2IP_Resetn = '0' or mst_cmd_sm_clr_go = '1' ) then
        mst_go   <= '0';
      elsif ( mst_cmd_sm_busy = '0' and mst_byte_we(GO_BYTE_LANE) = '1' and
            Bus2IP_Data((GO_BYTE_LANE-(GO_BYTE_LANE/BE_WIDTH)*BE_WIDTH)*8+7   downto
                         (GO_BYTE_LANE-(GO_BYTE_LANE/BE_WIDTH)*BE_WIDTH)*8)= GO_DATA_KEY ) then
        mst_go   <= '1';
      else
        null;
      end if;
    end if;

  end process MASTER_WRITE_GO_PORT;

  -- implement master model register read mux
  MASTER_REG_READ_PROC : process( mst_reg_read_sel, mst_reg ) is
    constant BE_WIDTH : integer := C_SLV_DWIDTH/8;
  begin

    case mst_reg_read_sel is
      when "1000" =>
        for byte_index in 0 to BE_WIDTH-1 loop
          mst_ip2bus_data(byte_index*8+7 downto byte_index*8) <= mst_reg(byte_index);
        end loop;
      when "0100" =>
        for byte_index in 0 to BE_WIDTH-1 loop
          mst_ip2bus_data(byte_index*8+7 downto byte_index*8) <= mst_reg(BE_WIDTH+byte_index);
        end loop;
      when "0010" =>
        for byte_index in 0 to BE_WIDTH-1 loop
          mst_ip2bus_data(byte_index*8+7 downto byte_index*8) <= mst_reg(BE_WIDTH*2+byte_index);
        end loop;
      when "0001" =>
        for byte_index in 0 to BE_WIDTH-1 loop
          if ( byte_index = BE_WIDTH-1 ) then
            -- go port is not readable
            mst_ip2bus_data(byte_index*8+7 downto byte_index*8) <= (others => '0');
          else
            mst_ip2bus_data(byte_index*8+7 downto byte_index*8) <= mst_reg(BE_WIDTH*3+byte_index);
          end if;
        end loop;
      when others =>
        mst_ip2bus_data <= (others => '0');
    end case;

  end process MASTER_REG_READ_PROC;

  -- user logic master command interface assignments
  IP2Bus_MstRd_Req  <= mst_cmd_sm_rd_req;
  IP2Bus_MstWr_Req  <= mst_cmd_sm_wr_req;
  IP2Bus_Mst_Addr   <= mst_cmd_sm_ip2bus_addr;
  IP2Bus_Mst_BE     <= mst_cmd_sm_ip2bus_be;
  IP2Bus_Mst_Type   <= mst_cmd_sm_xfer_type;
  IP2Bus_Mst_Length <= mst_cmd_sm_xfer_length;
  IP2Bus_Mst_Lock   <= mst_cmd_sm_bus_lock;
  IP2Bus_Mst_Reset  <= mst_cmd_sm_reset;

  --implement master command interface state machine
  MASTER_CMD_SM_PROC : process( Bus2IP_Clk ) is
    variable stop_tx_timer_v : std_logic;
    variable stop_rx_timer_v : std_logic;
  begin

    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if ( Bus2IP_Resetn = '0' ) then

        -- reset condition
        mst_cmd_sm_state          <= CMD_IDLE;
        mst_cmd_sm_clr_go         <= '0';
        mst_cmd_sm_rd_req         <= '0';
        mst_cmd_sm_wr_req         <= '0';
        mst_cmd_sm_bus_lock       <= '0';
        mst_cmd_sm_reset          <= '0';
        mst_cmd_sm_ip2bus_addr    <= (others => '0');
        mst_cmd_sm_ip2bus_be      <= (others => '0');
        mst_cmd_sm_xfer_type      <= '0';
        mst_cmd_sm_xfer_length    <= (others => '0');
        mst_cmd_sm_set_done       <= '0';
        mst_cmd_sm_set_error      <= '0';
        mst_cmd_sm_set_timeout    <= '0';
        mst_cmd_sm_busy           <= '0';
        mst_cmd_sm_start_rd_llink <= '0';
        mst_cmd_sm_start_wr_llink <= '0';
        
        mst_is_wr_cmd <= '0';
        stop_tx_timer <= '0';
        stop_rx_timer <= '0';

      else

        -- default condition
        mst_cmd_sm_clr_go         <= '0';
        mst_cmd_sm_rd_req         <= '0';
        mst_cmd_sm_wr_req         <= '0';
        mst_cmd_sm_bus_lock       <= '0';
        mst_cmd_sm_reset          <= '0';
        mst_cmd_sm_ip2bus_addr    <= (others => '0');
        mst_cmd_sm_ip2bus_be      <= (others => '0');
        mst_cmd_sm_xfer_type      <= '0';
        mst_cmd_sm_xfer_length    <= (others => '0');
        mst_cmd_sm_set_done       <= '0';
        mst_cmd_sm_set_error      <= '0';
        mst_cmd_sm_set_timeout    <= '0';
        mst_cmd_sm_busy           <= '1';
        mst_cmd_sm_start_rd_llink <= '0';
        mst_cmd_sm_start_wr_llink <= '0';
        
        stop_tx_timer_v := '0';
        stop_rx_timer_v := '0';

        -- state transition
        case mst_cmd_sm_state is

          when CMD_IDLE =>
            if ( mst_go = '1' ) then
              mst_cmd_sm_state  <= CMD_RUN;
              mst_cmd_sm_clr_go <= '1';
              if ( mst_cntl_rd_req = '1' ) then
                mst_cmd_sm_start_rd_llink <= '1';
                mst_is_wr_cmd <= '0';
              elsif ( mst_cntl_wr_req = '1' ) then
                mst_cmd_sm_start_wr_llink <= '1';
                mst_is_wr_cmd <= '1';
              end if;
            else
              mst_cmd_sm_state  <= CMD_IDLE;
              mst_cmd_sm_busy   <= '0';
            end if;

          when CMD_RUN =>
            if ( Bus2IP_Mst_CmdAck = '1' and Bus2IP_Mst_Cmplt = '0' ) then
              mst_cmd_sm_state <= CMD_WAIT_FOR_DATA;
            elsif ( Bus2IP_Mst_Cmplt = '1' ) then
              mst_cmd_sm_state <= CMD_DONE;
              if ( Bus2IP_Mst_Cmd_Timeout = '1' ) then
                -- AXI4LITE address phase timeout
                mst_cmd_sm_set_error   <= '1';
                mst_cmd_sm_set_timeout <= '1';
              elsif ( Bus2IP_Mst_Error = '1' ) then
                -- AXI4LITE data transfer error
                mst_cmd_sm_set_error   <= '1';
              end if;
            else
              mst_cmd_sm_state       <= CMD_RUN;
              mst_cmd_sm_rd_req      <= mst_cntl_rd_req;
              mst_cmd_sm_wr_req      <= mst_cntl_wr_req;
              mst_cmd_sm_ip2bus_addr <= mst_ip2bus_addr;
              mst_cmd_sm_ip2bus_be   <= mst_ip2bus_be(15 downto 16-C_MST_NATIVE_DATA_WIDTH/8 );
              mst_cmd_sm_xfer_type   <= mst_cntl_burst;
              mst_cmd_sm_xfer_length <= mst_xfer_length;
              mst_cmd_sm_bus_lock    <= mst_cntl_bus_lock;
            end if;

          when CMD_WAIT_FOR_DATA =>
            if ( Bus2IP_Mst_Cmplt = '1' ) then
              mst_cmd_sm_state <= CMD_DONE;
              if ( Bus2IP_Mst_Cmd_Timeout = '1' ) then
                -- AXI4LITE address phase timeout
                mst_cmd_sm_set_error   <= '1';
                mst_cmd_sm_set_timeout <= '1';
              elsif ( Bus2IP_Mst_Error = '1' ) then
                -- AXI4LITE data transfer error
                mst_cmd_sm_set_error   <= '1';
              end if;
            else
              mst_cmd_sm_state <= CMD_WAIT_FOR_DATA;
            end if;

          when CMD_DONE =>
            
            if mst_is_wr_cmd = '1' then
              stop_rx_timer_v := '1';
            else
              stop_tx_timer_v := '1';
            end if;
            
            mst_cmd_sm_state    <= CMD_IDLE;
            mst_cmd_sm_set_done <= '1';
            mst_cmd_sm_busy     <= '0';

          when others =>
            mst_cmd_sm_state    <= CMD_IDLE;
            mst_cmd_sm_busy     <= '0';

        end case;
        
        stop_tx_timer <= stop_tx_timer_v;
        stop_rx_timer <= stop_rx_timer_v;

      end if;
    end if;

  end process MASTER_CMD_SM_PROC;

  -- user logic master read locallink interface assignments
  IP2Bus_MstRd_dst_rdy_n <= not(mst_llrd_sm_dst_rdy);
  IP2Bus_MstRd_dst_dsc_n <= '1'; -- do not throttle data

  -- implement a simple state machine to enable the
  -- read locallink interface to transfer data
  LLINK_RD_SM_PROCESS : process( Bus2IP_Clk ) is
  begin

    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if ( Bus2IP_Resetn = '0' ) then

        -- reset condition
        mst_llrd_sm_state   <= LLRD_IDLE;
        mst_llrd_sm_dst_rdy <= '0';

      else

        -- default condition
        mst_llrd_sm_state   <= LLRD_IDLE;
        mst_llrd_sm_dst_rdy <= '0';

        -- state transition
        case mst_llrd_sm_state is

          when LLRD_IDLE =>
            if ( mst_cmd_sm_start_rd_llink = '1') then
              mst_llrd_sm_state <= LLRD_GO;
            else
              mst_llrd_sm_state <= LLRD_IDLE;
            end if;

          when LLRD_GO =>
            -- done, end of packet
            if ( mst_llrd_sm_dst_rdy    = '1' and
                 Bus2IP_MstRd_src_rdy_n = '0' and
                 Bus2IP_MstRd_eof_n     = '0' ) then
              mst_llrd_sm_state   <= LLRD_IDLE;
            -- not done yet, continue receiving data
            else
              mst_llrd_sm_state   <= LLRD_GO;
              mst_llrd_sm_dst_rdy <= '1';
            end if;

          when others =>
            mst_llrd_sm_state <= LLRD_IDLE;

        end case;

      end if;
    else
      null;
    end if;

  end process LLINK_RD_SM_PROCESS;

  -- user logic master write locallink interface assignments
  IP2Bus_MstWr_src_rdy_n <= not(mst_llwr_sm_src_rdy);
  IP2Bus_MstWr_src_dsc_n <= '1'; -- do not throttle data
  IP2Bus_MstWr_rem       <= (others => '0');
  IP2Bus_MstWr_sof_n     <= not(mst_llwr_sm_sof);
  IP2Bus_MstWr_eof_n     <= not(mst_llwr_sm_eof);

  -- implement a simple state machine to enable the
  -- write locallink interface to transfer data
  LLINK_WR_SM_PROC : process( Bus2IP_Clk ) is
    constant BYTES_PER_BEAT : integer := C_MST_NATIVE_DATA_WIDTH/8;
  begin

    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if ( Bus2IP_Resetn = '0' ) then

        -- reset condition
        mst_llwr_sm_state   <= LLWR_IDLE;
        mst_llwr_sm_src_rdy <= '0';
        mst_llwr_sm_sof     <= '0';
        mst_llwr_sm_eof     <= '0';
        mst_llwr_byte_cnt   <= 0;

      else

        -- default condition
        mst_llwr_sm_state   <= LLWR_IDLE;
        mst_llwr_sm_src_rdy <= '0';
        mst_llwr_sm_sof     <= '0';
        mst_llwr_sm_eof     <= '0';
        mst_llwr_byte_cnt   <= 0;

        -- state transition
        case mst_llwr_sm_state is

          when LLWR_IDLE =>
            if ( mst_cmd_sm_start_wr_llink = '1' and mst_cntl_burst = '0' ) then
              mst_llwr_sm_state <= LLWR_SNGL_INIT;
            elsif ( mst_cmd_sm_start_wr_llink = '1' and mst_cntl_burst = '1' ) then
              mst_llwr_sm_state <= LLWR_BRST_INIT;
            else
              mst_llwr_sm_state <= LLWR_IDLE;
            end if;

          when LLWR_SNGL_INIT =>
            mst_llwr_sm_state   <= LLWR_SNGL;
            mst_llwr_sm_src_rdy <= '1';
            mst_llwr_sm_sof     <= '1';
            mst_llwr_sm_eof     <= '1';

          when LLWR_SNGL =>
            -- destination discontinue write
            if ( Bus2IP_MstWr_dst_dsc_n = '0' and Bus2IP_MstWr_dst_rdy_n = '0' ) then
              mst_llwr_sm_state   <= LLWR_IDLE;
              mst_llwr_sm_src_rdy <= '0';
              mst_llwr_sm_eof     <= '0';
            -- single data beat transfer complete
            elsif ( mst_fifo_valid_read_xfer = '1' ) then
              mst_llwr_sm_state   <= LLWR_IDLE;
              mst_llwr_sm_src_rdy <= '0';
              mst_llwr_sm_sof     <= '0';
              mst_llwr_sm_eof     <= '0';
            -- wait on destination
            else
              mst_llwr_sm_state   <= LLWR_SNGL;
              mst_llwr_sm_src_rdy <= '1';
              mst_llwr_sm_sof     <= '1';
              mst_llwr_sm_eof     <= '1';
            end if;

          when LLWR_BRST_INIT =>
            mst_llwr_sm_state   <= LLWR_BRST;
            mst_llwr_sm_src_rdy <= '1';
            mst_llwr_sm_sof     <= '1';
            mst_llwr_byte_cnt   <= CONV_INTEGER(mst_xfer_length);

          when LLWR_BRST =>
            if ( mst_fifo_valid_read_xfer = '1' ) then
              mst_llwr_sm_sof <= '0';
            else
              mst_llwr_sm_sof <= mst_llwr_sm_sof;
            end if;
            -- destination discontinue write
            if ( Bus2IP_MstWr_dst_dsc_n = '0' and
                 Bus2IP_MstWr_dst_rdy_n = '0' ) then
              mst_llwr_sm_state   <= LLWR_IDLE;
              mst_llwr_sm_src_rdy <= '1';
              mst_llwr_sm_eof     <= '1';
            -- last data beat write
            elsif ( mst_fifo_valid_read_xfer = '1' and
                   (mst_llwr_byte_cnt-BYTES_PER_BEAT) <= BYTES_PER_BEAT ) then
              mst_llwr_sm_state   <= LLWR_BRST_LAST_BEAT;
              mst_llwr_sm_src_rdy <= '1';
              mst_llwr_sm_eof     <= '1';
            -- wait on destination
            else
              mst_llwr_sm_state   <= LLWR_BRST;
              mst_llwr_sm_src_rdy <= '1';
              -- decrement write transfer counter if it's a valid write
              if ( mst_fifo_valid_read_xfer = '1' ) then
                mst_llwr_byte_cnt <= mst_llwr_byte_cnt - BYTES_PER_BEAT;
              else
                mst_llwr_byte_cnt <= mst_llwr_byte_cnt;
              end if;
            end if;

          when LLWR_BRST_LAST_BEAT =>
            -- destination discontinue write
            if ( Bus2IP_MstWr_dst_dsc_n = '0' and
                 Bus2IP_MstWr_dst_rdy_n = '0' ) then
              mst_llwr_sm_state   <= LLWR_IDLE;
              mst_llwr_sm_src_rdy <= '0';
            -- last data beat done
            elsif ( mst_fifo_valid_read_xfer = '1' ) then
              mst_llwr_sm_state   <= LLWR_IDLE;
              mst_llwr_sm_src_rdy <= '0';
            -- wait on destination
            else
              mst_llwr_sm_state   <= LLWR_BRST_LAST_BEAT;
              mst_llwr_sm_src_rdy <= '1';
              mst_llwr_sm_eof     <= '1';
            end if;

          when others =>
            mst_llwr_sm_state <= LLWR_IDLE;

        end case;

      end if;
    else
      null;
    end if;

  end process LLINK_WR_SM_PROC;

  -- local srl fifo for data storage
  mst_fifo_valid_write_xfer <= not(Bus2IP_MstRd_src_rdy_n) and mst_llrd_sm_dst_rdy;
  mst_fifo_valid_read_xfer  <= not(Bus2IP_MstWr_dst_rdy_n) and mst_llwr_sm_src_rdy;
  Bus2IP_Reset   <= not (Bus2IP_Resetn);

  DATA_CAPTURE_FIFO_I : entity proc_common_v3_00_a.srl_fifo_f
    generic map
    (
      C_DWIDTH   => C_MST_NATIVE_DATA_WIDTH,
      C_DEPTH    => C_MAX_BURST_LEN
    )
    port map
    (
      Clk        => Bus2IP_Clk,
      Reset      => Bus2IP_Reset,
      FIFO_Write => fifo_i_push, --mst_fifo_valid_write_xfer,
      Data_In    => Bus2IP_MstRd_d,
      FIFO_Read  => fifo_i_pop,
      Data_Out   => fifo_i_data,
      FIFO_Full  => open,
      FIFO_Empty => fifo_i_empty,
      Addr       => open
    );

  PUSH_PROC : process( Bus2IP_Clk ) is
  begin

    fifo_i_push <= mst_fifo_valid_write_xfer and not padding_in;
    fifo_i_pop <= (not fifo_i_empty) and FSL_RDY_put;
    FSL_EN_put <= fifo_i_pop;
    FSL_put <= fifo_i_data;
  
    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if ( Bus2IP_Resetn = '0' ) then

        -- reset condition
        slv_reg0 <= (others => '0');
        padding_in <= '0';

      else
        
        if is_one_word = '1' and mst_fifo_valid_write_xfer = '1' and padding_in = '0' then
          padding_in <= '1';
        else
          padding_in <= '0';
        end if;

        if fifo_i_push = '1' and fifo_i_pop = '0' then
          slv_reg0 <= slv_reg0 + 1;
        elsif fifo_i_push = '0' and fifo_i_pop = '1' then
          slv_reg0 <= slv_reg0 - 1;
        end if;

      end if;
    end if;
  end process; --POP_PROC
  
  POP_PROC : process( Bus2IP_Clk ) is
    variable FSL_EN_get_v : std_logic;
  begin
  
    FSL_EN_get_v := '0';

    if FSL_RDY_get = '1' and fifo_o_full = '0' then
      FSL_EN_get_v := '1';
    end if;
    
    FSL_EN_get <= FSL_EN_get_v;
    fifo_o_push <= FSL_EN_get_v;
    fifo_o_data <= FSL_get;
    fifo_o_pop <= mst_fifo_valid_read_xfer and not padding_out;

    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if ( Bus2IP_Resetn = '0' ) then

        -- reset condition
        slv_reg1 <= (others => '0');
        padding_out <= '0';

      else
        
        if is_one_word = '1' and mst_fifo_valid_read_xfer = '1' and padding_out = '0' then
          padding_out <= '1';
        else
          padding_out <= '0';
        end if;

        if FSL_EN_get_v = '1' and fifo_o_pop = '0' then
          slv_reg1 <= slv_reg1 + 1;
        elsif FSL_EN_get_v = '0' and fifo_o_pop = '1' then
          if fifo_o_empty = '0' then
            slv_reg1 <= slv_reg1 - 1;
          end if;
        end if;

      end if;
    end if;
  end process; --POP_PROC

  DATA_CAPTURE_FIFO_O : entity proc_common_v3_00_a.srl_fifo_f
    generic map
    (
      C_DWIDTH   => C_MST_NATIVE_DATA_WIDTH,
      C_DEPTH    => C_MAX_BURST_LEN
    )
    port map
    (
      Clk        => Bus2IP_Clk,
      Reset      => Bus2IP_Reset,
      FIFO_Write => fifo_o_push,
      Data_In    => fifo_o_data,
      FIFO_Read  => fifo_o_pop,
      Data_Out   => IP2Bus_MstWr_d,
      FIFO_Full  => fifo_o_full,
      FIFO_Empty => fifo_o_empty,
      Addr       => open
    );
  
  slv_reg2 <= FSL_TxBSZ;
  slv_reg3 <= FSL_RxBSZ;
  
  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data  <= slv_ip2bus_data when slv_read_ack = '1' else
                  mst_ip2bus_data when mst_read_ack = '1' else
                  (others => '0');

  IP2Bus_WrAck <= slv_write_ack or mst_write_ack;
  IP2Bus_RdAck <= slv_read_ack or mst_read_ack;
  IP2Bus_Error <= '0';

end IMP;