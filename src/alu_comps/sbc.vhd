-------------------------------------------------
--  File:          sbc.vhd
--
--  Entity:        sbc
--  Architecture:  BEHAVIORAL
--  Author:        Seth Gower
--  Created:       02/17/19
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                 subtracting unit for
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sbc is
    generic(bit_width : integer := 8);
    port(
        a,b     : in    std_logic_vector(bit_width-1 downto 0);
        output  : out   std_logic_vector(bit_width-1 downto 0);
        borrow  : in    std_logic;
        n,v,z,c : out   std_logic
    );
end entity sbc;
architecture Behavioral of sbc is
    signal s_output     : std_logic_vector(bit_width downto 0);

begin
    s_output <= std_logic_vector(signed(borrow & a) - signed('0' & b));
    output <= s_output(bit_width-1 downto 0);
    n <= s_output(bit_width-2);
    c <= s_output(bit_width);
    z <= '1' when s_output = x"00" else '0';
    v <= not (a(bit_width-1) xor b(bit_width-1) xor s_output(bit_width));
end Behavioral;
