##############################################################################
## This file is part of 'Simple-Kria-Kv260-Example'.
## It is subject to the license terms in the LICENSE.txt file found in the
## top-level directory of this distribution and at:
##    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
## No part of 'Simple-Kria-Kv260-Example', including this file,
## may be copied, modified, propagated, or distributed except according to
## the terms contained in the LICENSE.txt file.
##############################################################################

##############################
# Get variables and procedures
##############################
source -quiet $::env(RUCKUS_DIR)/vivado_env_var.tcl
source $::env(RUCKUS_PROC_TCL)

######################################################
# Bypass the debug chipscope generation via return cmd
# ELSE ... comment out the return to include chipscope
######################################################
# return

############################
## Open the synthesis design
############################
open_run synth_1

###############################
## Set the name of the ILA core
###############################
set ilaName u_ila_0

##################
## Create the core
##################
CreateDebugCore ${ilaName}

#######################
## Set the record depth
#######################
set_property C_DATA_DEPTH 1024 [get_debug_cores ${ilaName}]

#################################
## Set the clock for the ILA core
#################################
SetDebugCoreClk ${ilaName} {U_App/axilClk}

#######################
## Set the debug Probes
#######################

ConfigProbe ${ilaName} {U_App/axilRst}
ConfigProbe ${ilaName} {U_App/axilReadMaster[*}
ConfigProbe ${ilaName} {U_App/axilReadSlave[*}
ConfigProbe ${ilaName} {U_App/axilWriteMaster[*}
ConfigProbe ${ilaName} {U_App/axilWriteSlave[*}
ConfigProbe ${ilaName} {U_App/axilReadMasters[*}
ConfigProbe ${ilaName} {U_App/axilReadSlaves[*}
ConfigProbe ${ilaName} {U_App/axilWriteMasters[*}
ConfigProbe ${ilaName} {U_App/axilWriteSlaves[*}

##########################
## Write the port map file
##########################
WriteDebugProbes ${ilaName}
