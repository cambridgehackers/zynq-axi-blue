
mk%.v: %.bsv
	cd $(dir $*); bsc -verilog -u -g mk$(notdir $*).v $(notdir $*).bsv

%.v: %.bsv
	cd $(dir $*); bsc -verilog -u -g $(notdir $*).v $(notdir $*).bsv

ALL_VERILOG=

include */*.mk


all: $(ALL_VERILOG)

clean:
	rm -f $(ALL_VERILOG)
