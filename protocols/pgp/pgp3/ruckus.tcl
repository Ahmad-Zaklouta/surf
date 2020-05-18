# Load RUCKUS library
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

# Load the Core
loadRuckusTcl "$::DIR_PATH/core"
loadRuckusTcl "$::DIR_PATH/asic"

# Get the family type
set family [getFpgaFamily]

if { ${family} eq {artix7} } {
   loadRuckusTcl "$::DIR_PATH/gtp7"
}

if { ${family} eq {kintex7} } {
   loadRuckusTcl "$::DIR_PATH/gtx7"
}

if { ${family} eq {zynq} } {
   if { [ regexp "XC7Z(015|012).*" [string toupper "$::env(PRJ_PART)"] ] } {
      loadRuckusTcl "$::DIR_PATH/gtp7"
   } else {
      loadRuckusTcl "$::DIR_PATH/gtx7"
   }
}

# if { ${family} eq {virtex7} } {
   # loadRuckusTcl "$::DIR_PATH/gth7"
# }

if { ${family} eq {kintexu} } {
   loadRuckusTcl "$::DIR_PATH/gthUs"
}

if { ${family} eq {kintexuplus} ||
     ${family} eq {zynquplus} ||
     ${family} eq {zynquplusRFSOC} ||
     ${family} eq {qzynquplusRFSOC} } {
   loadRuckusTcl "$::DIR_PATH/gthUs+"
   # loadRuckusTcl "$::DIR_PATH/gtyUs+"
}

# if { ${family} eq {virtexuplus} ||
     # ${family} eq {virtexuplusHBM} } {
   # loadRuckusTcl "$::DIR_PATH/gtyUs+"
# }
