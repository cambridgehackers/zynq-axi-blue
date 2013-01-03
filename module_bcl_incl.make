#################################################################
# Makefile generated by Xilinx Platform Studio 
# Project:/home/jamey/bluespec/zedboard_axi_blue/module_bcl.xmp
#
# WARNING : This file will be re-generated every time a command
# to run a make target is invoked. So, any changes made to this  
# file manually, will be lost when make is invoked next. 
#################################################################

XILINX_EDK_DIR = /home/xilinx/14.3/ISE_DS/EDK

SYSTEM = module_bcl

MHSFILE = module_bcl.mhs

PCWPRJFILE = data/ps7_module_bcl_prj.xml

FPGA_ARCH = zynq

DEVICE = xc7z020clg484-1

INTSTYLE = default

XPS_HDL_LANG = verilog
GLOBAL_SEARCHPATHOPT = 
PROJECT_SEARCHPATHOPT =  -lp /home/jamey/bluespec/cf_lib/

SEARCHPATHOPT = $(PROJECT_SEARCHPATHOPT) $(GLOBAL_SEARCHPATHOPT)

SUBMODULE_OPT =  -toplevel no -ti module_bcl_i

PLATGEN_OPTIONS = -p $(DEVICE) -lang $(XPS_HDL_LANG) -intstyle $(INTSTYLE) $(SEARCHPATHOPT) $(SUBMODULE_OPT) -msg __xps/ise/xmsgprops.lst -parallel yes

OBSERVE_PAR_OPTIONS = -error no

MICROBLAZE_BOOTLOOP = $(XILINX_EDK_DIR)/sw/lib/microblaze/mb_bootloop.elf
MICROBLAZE_BOOTLOOP_LE = $(XILINX_EDK_DIR)/sw/lib/microblaze/mb_bootloop_le.elf
PPC405_BOOTLOOP = $(XILINX_EDK_DIR)/sw/lib/ppc405/ppc_bootloop.elf
PPC440_BOOTLOOP = $(XILINX_EDK_DIR)/sw/lib/ppc440/ppc440_bootloop.elf
BOOTLOOP_DIR = bootloops

BRAMINIT_ELF_IMP_FILES =
BRAMINIT_ELF_IMP_FILE_ARGS =

BRAMINIT_ELF_SIM_FILES =
BRAMINIT_ELF_SIM_FILE_ARGS =

SIM_CMD = vsim

BEHAVIORAL_SIM_SCRIPT = simulation/behavioral/$(SYSTEM)_setup.do

STRUCTURAL_SIM_SCRIPT = simulation/structural/$(SYSTEM)_setup.do

TIMING_SIM_SCRIPT = simulation/timing/$(SYSTEM)_setup.do

DEFAULT_SIM_SCRIPT = $(STRUCTURAL_SIM_SCRIPT)

SIMGEN_OPTIONS = -p $(DEVICE) -lang $(XPS_HDL_LANG) -intstyle $(INTSTYLE) $(SEARCHPATHOPT) $(BRAMINIT_ELF_SIM_FILE_ARGS) -msg __xps/ise/xmsgprops.lst -s mgm


CORE_STATE_DEVELOPMENT_FILES = /home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/family.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/family_support.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/coregen_comp_defs.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/common_types_pkg.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/proc_common_pkg.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/conv_funs_pkg.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/ipif_pkg.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/async_fifo_fg.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/sync_fifo_fg.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/basic_sfifo_fg.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/blk_mem_gen_wrapper.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/addsub.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/counter_bit.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/counter.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/direct_path_cntr.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/direct_path_cntr_ai.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/down_counter.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/eval_timer.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/inferred_lut4.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/ipif_steer.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/ipif_steer128.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/ipif_mirror128.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/ld_arith_reg.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/ld_arith_reg2.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/mux_onehot.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/or_bits.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/or_muxcy.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/or_gate.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/or_gate128.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/pf_adder_bit.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/pf_adder.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/pf_counter_bit.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/pf_counter.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/pf_counter_top.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/pf_occ_counter.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/pf_occ_counter_top.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/pf_dpram_select.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/pselect.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/pselect_mask.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/srl16_fifo.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/srl_fifo.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/srl_fifo2.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/srl_fifo3.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/srl_fifo_rbu.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/valid_be.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/or_with_enable_f.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/muxf_struct_f.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/cntr_incr_decr_addn_f.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/dynshreg_f.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/dynshreg_i_f.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/mux_onehot_f.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/srl_fifo_rbu_f.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/srl_fifo_f.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/compare_vectors_f.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/pselect_f.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/counter_f.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/or_muxcy_f.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/or_gate_f.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/soft_reset.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_lite_ipif_v1_01_a/hdl/vhdl/address_decoder.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_lite_ipif_v1_01_a/hdl/vhdl/slave_attachment.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_lite_ipif_v1_01_a/hdl/vhdl/axi_lite_ipif.vhd \
pcores/foo_lite_slave_v1_00_a/hdl/vhdl/user_logic.vhd \
pcores/foo_lite_slave_v1_00_a/hdl/vhdl/foo_lite_slave.vhd \
pcores/foo_lite_slave_v1_00_a/hdl/verilog/mkIP.v \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_slave_burst_v1_00_a/hdl/vhdl/control_state_machine.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_slave_burst_v1_00_a/hdl/vhdl/read_data_path.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_slave_burst_v1_00_a/hdl/vhdl/address_decode.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_slave_burst_v1_00_a/hdl/vhdl/addr_gen.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_slave_burst_v1_00_a/hdl/vhdl/axi_slave_burst.vhd \
pcores/foo_slave_v1_00_a/hdl/vhdl/user_logic.vhd \
pcores/foo_slave_v1_00_a/hdl/vhdl/foo_slave.vhd \
pcores/foo_slave_v1_00_a/hdl/verilog/mkIpSlave.v \
pcores/foo_slave_v1_00_a/hdl/verilog/RegFile.v \
pcores/foo_slave_v1_00_a/hdl/verilog/FIFO2.v \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_rdmux.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_wr_demux.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_skid2mm_buf.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_skid_buf.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_first_stb_offset.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_stbs_set.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_strb_gen.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_fifo.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_pcc.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_addr_cntl.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_rddata_cntl.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_rd_status_cntl.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_wrdata_cntl.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_wr_status_cntl.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_reset.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_cmd_status.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_rd_wr_cntlr.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_rd_llink.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst_wr_llink.vhd \
/home/xilinx/14.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/axi_master_burst_v1_00_a/hdl/vhdl/axi_master_burst.vhd \
pcores/foo_master_v1_00_a/hdl/vhdl/foo_master.vhd \
pcores/foo_master_v1_00_a/hdl/vhdl/user_logic.vhd \
pcores/foo_master_v1_00_a/hdl/verilog/mkIpSlaveWithMaster.v \
pcores/foo_master_v1_00_a/hdl/verilog/mkFifoToAxi.v \
pcores/foo_master_v1_00_a/hdl/verilog/RegFile.v \
pcores/foo_master_v1_00_a/hdl/verilog/SyncFIFO1.v \
pcores/foo_master_v1_00_a/hdl/verilog/FIFO2.v \
pcores/foo_master_v1_00_a/hdl/verilog/SizedFIFO.v \
pcores/foo_master_v1_00_a/hdl/verilog/SyncResetA.v

WRAPPER_NGC_FILES = implementation/module_bcl_processing_system7_0_wrapper.ngc \
implementation/module_bcl_axi4lite_0_wrapper.ngc \
implementation/module_bcl_foo_lite_slave_0_wrapper.ngc \
implementation/module_bcl_foo_slave_0_wrapper.ngc \
implementation/module_bcl_axi_interconnect_1_wrapper.ngc \
implementation/module_bcl_foo_master_0_wrapper.ngc \
implementation/module_bcl_clock_generator_0_wrapper.ngc

POSTSYN_NETLIST = implementation/$(SYSTEM).ngc

SYSTEM_BIT = implementation/$(SYSTEM).bit

DOWNLOAD_BIT = implementation/download.bit

SYSTEM_ACE = implementation/$(SYSTEM).ace

UCF_FILE = data/module_bcl.ucf

BMM_FILE = implementation/$(SYSTEM).bmm

BITGEN_UT_FILE = etc/bitgen.ut

XFLOW_OPT_FILE = etc/fast_runtime.opt
XFLOW_DEPENDENCY = __xps/xpsxflow.opt $(XFLOW_OPT_FILE)

XPLORER_DEPENDENCY = __xps/xplorer.opt
XPLORER_OPTIONS = -p $(DEVICE) -uc $(SYSTEM).ucf -bm $(SYSTEM).bmm -max_runs 7

FPGA_IMP_DEPENDENCY = $(BMM_FILE) $(POSTSYN_NETLIST) $(UCF_FILE) $(XFLOW_DEPENDENCY)

SDK_EXPORT_DIR = SDK/SDK_Export/hw
SYSTEM_HW_HANDOFF = $(SDK_EXPORT_DIR)/$(SYSTEM).xml
SYSTEM_HW_HANDOFF_BIT = $(SDK_EXPORT_DIR)/$(SYSTEM).bit
SYSTEM_HW_HANDOFF_DEP = $(SYSTEM_HW_HANDOFF) $(SYSTEM_HW_HANDOFF_BIT)
