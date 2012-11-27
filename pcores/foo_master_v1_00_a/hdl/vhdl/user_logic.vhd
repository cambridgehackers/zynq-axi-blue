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
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_MST_NATIVE_DATA_WIDTH        : integer              := 32;
    C_LENGTH_WIDTH                 : integer              := 12;
    C_MST_AWIDTH                   : integer              := 32;
    C_NUM_REG                      : integer              := 4;
    C_SLV_DWIDTH                   : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
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

  --USER signal declarations added here, as needed for user logic

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
begin

  --USER logic implementation added here

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
  mst_reg_write_req <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3);
  mst_reg_read_req  <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3);
  mst_reg_write_sel <= Bus2IP_WrCE(3 downto 0);
  mst_reg_read_sel  <= Bus2IP_RdCE(3 downto 0);
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

        -- state transition
        case mst_cmd_sm_state is

          when CMD_IDLE =>
            if ( mst_go = '1' ) then
              mst_cmd_sm_state  <= CMD_RUN;
              mst_cmd_sm_clr_go <= '1';
              if ( mst_cntl_rd_req = '1' ) then
                mst_cmd_sm_start_rd_llink <= '1';
              elsif ( mst_cntl_wr_req = '1' ) then
                mst_cmd_sm_start_wr_llink <= '1';
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
            mst_cmd_sm_state    <= CMD_IDLE;
            mst_cmd_sm_set_done <= '1';
            mst_cmd_sm_busy     <= '0';

          when others =>
            mst_cmd_sm_state    <= CMD_IDLE;
            mst_cmd_sm_busy     <= '0';

        end case;

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
      C_DEPTH    => 128
    )
    port map
    (
      Clk        => Bus2IP_Clk,
      Reset      => Bus2IP_Reset,
      FIFO_Write => mst_fifo_valid_write_xfer,
      Data_In    => Bus2IP_MstRd_d,
      FIFO_Read  => mst_fifo_valid_read_xfer,
      Data_Out   => IP2Bus_MstWr_d,
      FIFO_Full  => open,
      FIFO_Empty => open,
      Addr       => open
    );

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data  <= mst_ip2bus_data when mst_read_ack = '1' else
                  (others => '0');

  IP2Bus_WrAck <= mst_write_ack;
  IP2Bus_RdAck <= mst_read_ack;
  IP2Bus_Error <= '0';

  entity FOO_MASTER_BSV is
     
   end FOO_MASTER_BSV :entity mkFifoToAxi
     port (CLK,
		   RST_N,

		   EN_axi_writeAddr,
		   axi_writeAddr,
		   RDY_axi_writeAddr,

		   axi_writeBurstLen,
		   RDY_axi_writeBurstLen,

		   axi_writeBurstWidth,
		   RDY_axi_writeBurstWidth,

		   axi_writeBurstType,
		   RDY_axi_writeBurstType,

		   axi_writeBurstProt,
		   RDY_axi_writeBurstProt,

		   axi_writeBurstCache,
		   RDY_axi_writeBurstCache,

		   EN_axi_writeData,
		   axi_writeData,
		   RDY_axi_writeData,

		   axi_writeDataByteEnable,
		   RDY_axi_writeDataByteEnable,

		   axi_writeLastDataBeat,
		   RDY_axi_writeLastDataBeat,

		   enq_value,
		   EN_enq,
		   RDY_enq);

end IMP;
