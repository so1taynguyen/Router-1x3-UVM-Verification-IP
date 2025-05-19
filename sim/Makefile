RTL = +incdir+../rtl
INC = +incdir+../env +incdir+../test +incdir+../agt_top +incdir+../packages +incdir+../tb
PKG = ../packages/router_pkg.sv
TB  =  ../tb/top.sv
work = work
SIMULATOR ?= RIV
TOOL = $(MTI_HOME)/bin
BITS = -64
CVG  = -cvg63
cover?= 1
UVMVER =
ifeq ($(SIMULATOR),RIV)
override TOOL = $(RIV_HOME)/bin
override BITS =
override CVG =
override UVMVER = -uvmver 1.1d 
endif

COMPFILE= $(RTL) $(INC) $(PKG)
TOPFILE= $(TB) 
TOPMODULE=top 
COMPDEFINE=
RUNDEFINE=
DPI=

cover?=0
ifeq ($(SIMULATOR),Q)
ifeq ($(cover),1)
COMPCOVER= +cover
SIMCOVER = coverage save -onexit cov.ucdb;
endif
endif

dump?=0
ifeq ($(dump),1)
SIMDUMP= add log -r /*;
endif

VSIMOPT= -sva -assertdebug -sv_seed 1672971912 work.$(TOPMODULE)
VSIMBATCH= -c -do "$(SIMCOVER) $(SIMDUMP) $(CVG) ; run -all; exit"

uvm?=0
ifeq ($(uvm),1)
UVMSWITCH= +UVM_OBJECTION_TRACE +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=UVM_HIGH 
endif

clean:
	rm -rf *.asdb *.acdb modelsim.* transcript* *.log work vsim.wlf *.ucdb final_cov_dir library.cfg questa.tops cov_dir *cov* \
	clear

lib: 
	$(TOOL)/vlib $(work) 
	$(TOOL)/vmap work $(work)

comp:
	$(TOOL)/vlog -work $(work) $(BITS) $(UVMVER) $(COMPCOVER) $(COMPDEFINE) \
	-l compile.log $(COMPFILE) $(TOPFILE)

run: 
	$(TOOL)/vsim  $(BITS) $(VSIMOPT) $(UVMSWITCH) $(RUNDEFINE) $(VSIMBATCH)  $(DPI) -l run.log +access+r


ifeq ($(SIMULATOR),Q)
ifeq ($(cover),1)
	echo "Merging UCDB results..."
	vcover merge *.ucdb -o final_cov.ucdb
	vcover report -details -html cov.ucdb -output final_cov_dir
endif
endif

ifeq ($(SIMULATOR),RIV)
ifeq ($(cover),1)
	echo "Merging ACDB results..."
	$(TOOL)/vsim -c -do "acdb merge -o final_cov.acdb -i *.acdb; acdb report -html -i final_cov.acdb -o final_cov.html; exit"
endif
endif

ifeq ($(DUMP),1)
	echo "generating wlf to vcd file"
	$(WLF2VCD)
	perl -i -pe 's/\.\.\.//g' zxc.vcd	
endif

all: clean lib comp run
