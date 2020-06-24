-- -----------------------------------------------------------------------------
-- 'AXIS_MUX' Register Definitions
-- Revision: 3
-- -----------------------------------------------------------------------------
-- Generated on 2020-06-23 at 22:15 (UTC) by airhdl version 2020.06.1
-- -----------------------------------------------------------------------------
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package AXIS_MUX_regs_pkg is

    -- Type definitions
    type slv1_array_t is array(natural range <>) of std_logic_vector(0 downto 0);
    type slv2_array_t is array(natural range <>) of std_logic_vector(1 downto 0);
    type slv3_array_t is array(natural range <>) of std_logic_vector(2 downto 0);
    type slv4_array_t is array(natural range <>) of std_logic_vector(3 downto 0);
    type slv5_array_t is array(natural range <>) of std_logic_vector(4 downto 0);
    type slv6_array_t is array(natural range <>) of std_logic_vector(5 downto 0);
    type slv7_array_t is array(natural range <>) of std_logic_vector(6 downto 0);
    type slv8_array_t is array(natural range <>) of std_logic_vector(7 downto 0);
    type slv9_array_t is array(natural range <>) of std_logic_vector(8 downto 0);
    type slv10_array_t is array(natural range <>) of std_logic_vector(9 downto 0);
    type slv11_array_t is array(natural range <>) of std_logic_vector(10 downto 0);
    type slv12_array_t is array(natural range <>) of std_logic_vector(11 downto 0);
    type slv13_array_t is array(natural range <>) of std_logic_vector(12 downto 0);
    type slv14_array_t is array(natural range <>) of std_logic_vector(13 downto 0);
    type slv15_array_t is array(natural range <>) of std_logic_vector(14 downto 0);
    type slv16_array_t is array(natural range <>) of std_logic_vector(15 downto 0);
    type slv17_array_t is array(natural range <>) of std_logic_vector(16 downto 0);
    type slv18_array_t is array(natural range <>) of std_logic_vector(17 downto 0);
    type slv19_array_t is array(natural range <>) of std_logic_vector(18 downto 0);
    type slv20_array_t is array(natural range <>) of std_logic_vector(19 downto 0);
    type slv21_array_t is array(natural range <>) of std_logic_vector(20 downto 0);
    type slv22_array_t is array(natural range <>) of std_logic_vector(21 downto 0);
    type slv23_array_t is array(natural range <>) of std_logic_vector(22 downto 0);
    type slv24_array_t is array(natural range <>) of std_logic_vector(23 downto 0);
    type slv25_array_t is array(natural range <>) of std_logic_vector(24 downto 0);
    type slv26_array_t is array(natural range <>) of std_logic_vector(25 downto 0);
    type slv27_array_t is array(natural range <>) of std_logic_vector(26 downto 0);
    type slv28_array_t is array(natural range <>) of std_logic_vector(27 downto 0);
    type slv29_array_t is array(natural range <>) of std_logic_vector(28 downto 0);
    type slv30_array_t is array(natural range <>) of std_logic_vector(29 downto 0);
    type slv31_array_t is array(natural range <>) of std_logic_vector(30 downto 0);
    type slv32_array_t is array(natural range <>) of std_logic_vector(31 downto 0);

    -- User-logic ports (from user-logic to register file)
    type user2regs_t is record
        dummy : std_logic; -- a dummy element to prevent empty records
    end record;

    -- User-logic ports (from register file to user-logic)
    type regs2user_t is record
        axis_mux_control_strobe : std_logic; -- Strobe signal for register 'AXIS_MUX_CONTROL' (pulsed when the register is written from the bus}
        axis_mux_control_resetn : std_logic_vector(0 downto 0); -- Value of register 'AXIS_MUX_CONTROL', field 'resetn'
        axis_mux_control_select : std_logic_vector(0 downto 0); -- Value of register 'AXIS_MUX_CONTROL', field 'select'
    end record;

    -- Revision number of the 'AXIS_MUX' register map
    constant AXIS_MUX_REVISION : natural := 3;

    -- Default base address of the 'AXIS_MUX' register map
    constant AXIS_MUX_DEFAULT_BASEADDR : unsigned(31 downto 0) := unsigned'(x"00000000");

    -- Register 'AXIS_MUX_CONTROL'
    constant AXIS_MUX_CONTROL_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000000"); -- address offset of the 'AXIS_MUX_CONTROL' register
    -- Field 'AXIS_MUX_CONTROL.resetn'
    constant AXIS_MUX_CONTROL_RESETN_BIT_OFFSET : natural := 0; -- bit offset of the 'resetn' field
    constant AXIS_MUX_CONTROL_RESETN_BIT_WIDTH : natural := 1; -- bit width of the 'resetn' field
    constant AXIS_MUX_CONTROL_RESETN_RESET : std_logic_vector(0 downto 0) := std_logic_vector'("0"); -- reset value of the 'resetn' field
    -- Field 'AXIS_MUX_CONTROL.select'
    constant AXIS_MUX_CONTROL_SELECT_BIT_OFFSET : natural := 1; -- bit offset of the 'select' field
    constant AXIS_MUX_CONTROL_SELECT_BIT_WIDTH : natural := 1; -- bit width of the 'select' field
    constant AXIS_MUX_CONTROL_SELECT_RESET : std_logic_vector(1 downto 1) := std_logic_vector'("0"); -- reset value of the 'select' field

    component AXIS_MUX_regs is
      generic (
        AXI_ADDR_WIDTH : integer := 32
      );
      port (
        axi_aclk      : in  std_logic;
        axi_aresetn   : in  std_logic;
        s_axi_awaddr  : in  std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
        s_axi_awprot  : in  std_logic_vector(2 downto 0);
        s_axi_awvalid : in  std_logic;
        s_axi_awready : out std_logic;
        s_axi_wdata   : in  std_logic_vector(31 downto 0);
        s_axi_wstrb   : in  std_logic_vector(3 downto 0);
        s_axi_wvalid  : in  std_logic;
        s_axi_wready  : out std_logic;
        s_axi_araddr  : in  std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
        s_axi_arprot  : in  std_logic_vector(2 downto 0);
        s_axi_arvalid : in  std_logic;
        s_axi_arready : out std_logic;
        s_axi_rdata   : out std_logic_vector(31 downto 0);
        s_axi_rresp   : out std_logic_vector(1 downto 0);
        s_axi_rvalid  : out std_logic;
        s_axi_rready  : in  std_logic;
        s_axi_bresp   : out std_logic_vector(1 downto 0);
        s_axi_bvalid  : out std_logic;
        s_axi_bready  : in  std_logic;
        user2regs     : in  user2regs_t;
        regs2user     : out regs2user_t
      );
    end component;

end AXIS_MUX_regs_pkg;
