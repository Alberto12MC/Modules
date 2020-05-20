# -*- coding: utf-8 -*-
from os.path import join , dirname, abspath
import subprocess
from vunit.sim_if.ghdl import GHDLInterface
from vunit.sim_if.factory import SIMULATOR_FACTORY
from vunit   import VUnit, VUnitCLI

##############################################################################
##############################################################################
##############################################################################

#Check GHDL backend.
code_coverage=False
try:
  if( GHDLInterface.determine_backend("")=="gcc" or  GHDLInterface.determine_backend("")=="GCC"):
    code_coverage=True
  else:
    code_coverage=False
except:
  print("")

#Check simulator.
print ("=============================================")
simulator_class = SIMULATOR_FACTORY.select_simulator()
simname = simulator_class.name
print (simname)
if (simname == "modelsim"):
  f= open("modelsim.do","w+")
  f.write("add wave * \nlog -r /*\nvcd file\nvcd add -r /*\n")
  f.close()
print ("=============================================")

##############################################################################
##############################################################################
##############################################################################

#VUnit instance.
ui = VUnit.from_argv()

##############################################################################
##############################################################################
##############################################################################

#Add array pkg.
ui.add_array_util()

#Add module sources.
fsm_src_lib = ui.add_library("src_lib")
fsm_src_lib.add_source_files("../../../src/FSM/fsm.vhd")
fsm_src_lib.add_source_files("../../../src/FSM/fsm_pkg.vhd")

#Add tb sources.
fsm_tb_lib = ui.add_library("tb_lib")
fsm_tb_lib.add_source_files("fsm_tb.vhd")

##############################################################################
##############################################################################
##############################################################################

#GHDL parameters.
if(code_coverage==True):
  fsm_src_lib.add_compile_option   ("ghdl.flags"     , [  "-fprofile-arcs","-ftest-coverage" ])
  fsm_tb_lib.add_compile_option("ghdl.flags"     , [  "-fprofile-arcs","-ftest-coverage" ])
  ui.set_sim_option("ghdl.elab_flags"      , [ "-Wl,-lgcov" ])
  ui.set_sim_option("modelsim.init_files.after_load" ,["modelsim.do"])
else:
  ui.set_sim_option("modelsim.init_files.after_load" ,["modelsim.do"])

ui.set_sim_option("disable_ieee_warnings", True)

#Run tests.
try:
  ui.main()
except SystemExit as exc:
  all_ok = exc.code == 0

#Code coverage.
if all_ok:
  if(code_coverage==True):
    subprocess.call(["lcov", "--capture", "--directory", "fsm.gcda", "--output-file",  "code_0.info" ])
    subprocess.call(["lcov", "--capture", "--directory", "fsm_pkg.gcda", "--output-file",  "code_1.info" ])
    subprocess.call(["genhtml","code_0.info","code_1.info","--output-directory", "html"])
  else:
    exit(0)
else:
  exit(1)
