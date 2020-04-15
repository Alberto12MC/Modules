# -*- coding: utf-8 -*-
from os.path import join , dirname, abspath
import subprocess
from vunit.sim_if.ghdl import GHDLInterface
from vunit.sim_if.factory import SIMULATOR_FACTORY
from vunit   import VUnit, VUnitCLI

##############################################################################
##############################################################################
##############################################################################

#pre_check func
def make_pre_check():
  """
  Before test.
  """
#post_check func
def make_post_check():
  """
  After test.
  """
  def post_check(output_path):
    check = True
    return check
  return post_check

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

#Add custom command line argument to standard CLI
#Beware of conflicts with existing arguments
cli = VUnitCLI()
cli.parser.add_argument('--ide',required=False)
args = cli.parse_args()
if (args.ide is None):
  print("IDE not selected. Default: Vivado")
  ide="vivado"
else:
  ide=args.ide

#VUnit instance.
ui = VUnit.from_argv()

#Xilinx Vivado libraries.
if(ide=="vivado"):
  xilinx_libraries_path = "/opt/Xilinx/vivado-lib-comp/xilinx-vivado"
  unisim_path   = join(xilinx_libraries_path,"unisim","v08")
  unifast_path  = join(xilinx_libraries_path,"unifast","v08")
  unimacro_path = join(xilinx_libraries_path,"unimacro","v08")
  secureip_path = join(xilinx_libraries_path,"secureip","v08")
  ui.add_external_library("unisim",unisim_path)
  ui.add_external_library("unifast",unifast_path)
  ui.add_external_library("unimacro",unimacro_path)
  ui.add_external_library("secureip",secureip_path)

#UVVM libraries path.
if (simname=="ghdl" or simname=="GHDL"):
  uvvm_util_root    = "/opt/Xilinx/UVVM-lib/uvvm_util/v08"
  uvvm_axilite_root = "/opt/Xilinx/UVVM-lib/bitvis_vip_axilite/v08"
elif (simname=="modelsim" or simname=="MODELSIM"):
  uvvm_util_root    = "/opt/Xilinx/UVVM-lib/uvvm_util"
  uvvm_axilite_root = "/opt/Xilinx/UVVM-lib/bitvis_vip_axilite"

##############################################################################
##############################################################################
##############################################################################

#Add verification components
ui.add_verification_components()

#Add OSVVM
ui.add_osvvm()

#Add array pkg.
ui.add_array_util()

#Add module sources.
Zybo_top_src_lib = ui.add_library("src_lib")
Zybo_top_src_lib.add_source_files("../../src/zybo_top_pkg.vhd")
Zybo_top_src_lib.add_source_files("../../src/zybo_top.vhd")
Zybo_top_src_lib.add_source_files("../../src/zybo_regs_pkg.vhd")
Zybo_top_src_lib.add_source_files("../../src/zybo_regs.vhd")

#Add tb sources.
Zybo_top_tb_lib = ui.add_library("tb_lib")
Zybo_top_tb_lib.add_source_files("Zybo_top_tb.vhd")

#func checks
tb_generated = Zybo_top_tb_lib.entity("Zybo_top_tb")
for test in tb_generated.get_tests():
  test.add_config(name="Zybo_top", pre_config=make_pre_check(),post_check=make_post_check())

##############################################################################
##############################################################################
##############################################################################

#GHDL parameters.
if(code_coverage==True):
  Zybo_top_src_lib.add_compile_option   ("ghdl.flags"     , ["-frelaxed-rules", "-fprofile-arcs","-ftest-coverage" ])
  Zybo_top_tb_lib.add_compile_option("ghdl.flags"     , ["-frelaxed-rules", "-fprofile-arcs","-ftest-coverage" ])
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
    subprocess.call(["lcov", "--capture", "--directory", "zybo_top.gcda", "--output-file",  "code_0.info" ])
    subprocess.call(["genhtml","code_0.info","--output-directory", "html"])
  else:
    exit(0)
else:
  exit(1)
