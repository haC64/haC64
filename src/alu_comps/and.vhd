-------------------------------------------------
--  File:          and.vhd
--
--  Entity:        and
--  Architecture:  BEHAVIORAL
--  Author:        Seth Gower
--  Created:       02/17/19
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                 And unit for ALU for c64
--                 Architecture for haC64
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity and_unit is
    generic(bit_width : integer := 8);
    port(
        a,b     : in    std_logic_vector(bit_width-1 downto 0);
        output  : out   std_logic_vector(bit_width-1 downto 0);
        n,z     : out   std_logic
    );
end entity and_unit;
architecture Behavioral of and_unit is
    signal s_output :std_logic_vector(bit_width-1 downto 0);
begin
    output <= s_output;
    s_output <= a and b;
    z <= '1' when s_output = x"00" else '0';
    n <= s_output(bit_width-1);
end Behavioral;
