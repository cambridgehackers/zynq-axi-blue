##############################################################################
## Filename:          /home/oriol/MIT/projects/ZedBoard/project_bcl/project_bcl.srcs/sources_1/edk/module_bcl/drivers/bcl_glue_v1_00_a/data/bcl_glue_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Mon Oct 15 17:26:59 2012 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "bcl_glue" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
