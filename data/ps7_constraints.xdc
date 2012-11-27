############################################################################
##
##  Xilinx, Inc. 2006            www.xilinx.com
############################################################################
##  File name :       data/ps7_constraints.xdc
##
##  Details :     Constraints file
##                    FPGA family:       zynq
##                    FPGA:              xc7z020clg484-1
##                    Device Size:        xc7z020
##                    Package:            clg484
##                    Speedgrade:         -1
##
##Note: This is a generated file. Configuration settings should not be edited
##
############################################################################
############################################################################
############################################################################
# I/O STANDARDS and Location Constraints                                   #
############################################################################

set_property iostandard "LVCMOS33" [get_ports "PS_PORB"]
set_property PACKAGE_PIN "B5" [get_ports "PS_PORB"]
set_property slew "slow" [get_ports "PS_PORB"]
set_property iostandard "LVCMOS33" [get_ports "PS_SRSTB"]
set_property PACKAGE_PIN "C9" [get_ports "PS_SRSTB"]
set_property slew "slow" [get_ports "PS_SRSTB"]
set_property iostandard "LVCMOS33" [get_ports "PS_CLK"]
set_property PACKAGE_PIN "F7" [get_ports "PS_CLK"]
set_property slew "slow" [get_ports "PS_CLK"]
