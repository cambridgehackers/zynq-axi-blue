
ALL_VERILOG += $(CURDIR)/foo_master_v1_00_a/hdl/verilog/mkIpSlaveWithMaster.v

$(CURDIR)/foo_master_v1_00_a/hdl/verilog/mkIpSlaveWithMaster.v: \
    $(CURDIR)/foo_master_v1_00_a/hdl/verilog/FifoToAxi.bsv \
    $(CURDIR)/foo_master_v1_00_a/hdl/verilog/DUT.bsv \
    $(CURDIR)/foo_master_v1_00_a/hdl/verilog/DUTWrapper.bsv \
    $(CURDIR)/foo_master_v1_00_a/hdl/verilog/Adapter.bsv \
    $(CURDIR)/foo_master_v1_00_a/hdl/verilog/IpSlaveWithMaster.bsv

$(CURDIR)/foo_master_v1_00_a/hdl/verilog/DUTWrapper.bsv: $(CURDIR)/foo_master_v1_00_a/hdl/verilog/TypesAndInterfaces.bsv
	cd $(CURDIR)/foo_master_v1_00_a/hdl/verilog; ~/bluespec/klaatu-language/genctypes.py $(CURDIR)/foo_master_v1_00_a/hdl/verilog/TypesAndInterfaces.bsv DUT

Sobel: $(CURDIR)/foo_master_v1_00_a/hdl/verilog/Sobel.bsv
	cd $(CURDIR)/foo_master_v1_00_a/hdl/verilog; source ~/.bash_profile; bsc -o sobel -sim -suppress-warnings G0010 -u -g mkSobelTb Sobel.bsv