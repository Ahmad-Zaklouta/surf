# Makefile automatically generated by ghdl
# Version: GHDL 0.34-dev (2017-03-01) [Dunoon edition] - mcode code generator
# Command used to generate this makefile:
# ghdl --gen-makefile -v -P/afs/slac/g/reseng/vol20/ghdl/lib/ghdl/vendors/xilinx-vivado/ --workdir=work --ieee=synopsys -fexplicit -frelaxed-rules AxiLiteCrossbar

GHDL=ghdl
GHDL_WORKDIR=ghdl
GHDLFLAGS= --workdir=${GHDL_WORKDIR} --work=work --ieee=synopsys -fexplicit -frelaxed-rules  --warn-no-library
GHDLRUNFLAGS=

PATHS = $(shell find -type f -name '*.vhd')

# Exclude all the VHDL2008 files: /usr/bin/ghdl-mcode:warning: library synopsys does not exists for v08
# Exclude all exempt modules with same entity name
EXCLUDE  = $(shell find ./ghdl-build/ -type f -name '*.vhd') \
$(shell find ./dsp/logic/ -type f -name '*.vhd') \
$(shell find . -type f -name '*Ad9249Deserializer.vhd') \
$(shell find . -type f -name '*Ad9249ReadoutGroup.vhd') \
$(shell find . -type f -name '*GigEthGthUltraScale.vhd') \
$(shell find . -type f -name '*GigEthGthUltraScaleWrapper.vhd') \
$(shell find . -type f -name '*TenGigEthGthUltraScale.vhd') \
$(shell find . -type f -name '*TenGigEthGthUltraScaleClk.vhd') \
$(shell find . -type f -name '*TenGigEthGthUltraScaleRst.vhd') \
$(shell find . -type f -name '*TenGigEthGthUltraScaleWrapper.vhd') \
$(shell find . -type f -name '*XauiGthUltraScale.vhd') \
$(shell find . -type f -name '*XauiGthUltraScaleWrapper.vhd') \
$(shell find . -type f -name '*ClinkDataClk.vhd') \
$(shell find . -type f -name '*ClinkDataShift.vhd') \
$(shell find . -type f -name '*Pgp2bGthUltra.vhd') \
$(shell find . -type f -name '*PgpGthCoreWrapper.vhd') \
$(shell find . -type f -name '*Pgp3GthUs.vhd') \
$(shell find . -type f -name '*Pgp3GthUsIpWrapper.vhd') \
$(shell find . -type f -name '*Pgp3GthUsQpll.vhd') \
$(shell find . -type f -name '*Pgp3GthUsWrapper.vhd') \
$(shell find . -type f -name '*InputBufferReg.vhd') \
$(shell find . -type f -name '*OutputBufferReg.vhd') \
$(shell find . -type f -name '*GthUltraScaleQuadPll.vhd') \
$(shell find . -type f -name '*MicroblazeBasicCoreWrapper.vhd') \

FILES = $(filter-out $(EXCLUDE),$(wildcard $(PATHS)))

ENTITY_EXCLUDES = stdlib 

ENTITIES := $(filter-out $(ENTITY_EXCLUDES),$(patsubst %Pkg,,$(patsubst %.vhd,%,$(notdir $(FILES)))))
MAKEFILES = $(patsubst %,%.mk,$(ENTITIES))
   
all: dir import

test:
	@echo GHDLFLAGS: $(GHDLFLAGS)
	@echo FILES: $(FILES)
	@echo ENTITIES:
	@echo "\t$(foreach ARG,$(ENTITIES),  $(ARG)\n)"

clean :
	$(GHDL) --clean $(GHDLFLAGS)

dir:
	test -d $(GHDL_WORKDIR) || mkdir $(GHDL_WORKDIR)

import : $(FILES)
	@echo "============================================================================="
	@echo Importing:
	@echo "============================================================================="
	$(GHDL) -i $(GHDLFLAGS) $(FILES)

syntax: $(FILES)
	@echo "============================================================================="
	@echo Syntax Checking:
	@echo "============================================================================="
	$(GHDL) -s $(GHDLFLAGS) $(FILES)

makefiles: $(MAKEFILES)

elaborate: $(ENTITIES)

$(ENTITIES) : import syntax
	$(GHDL) -e $(GHDLFLAGS) $@

html : $(FILES)
	$(GHDL) --xref-html $(GHDLFLAGS) $(FILES)

$(MAKEFILES) : import
	$(GHDL) --gen-makefile $(GHDLFLAGS) $(patsubst %.mk,%,$@) > work/$@
   
force:
