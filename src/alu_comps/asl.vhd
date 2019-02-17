-------------------------------------------------
--  File:          asl.vhd
--
--  Entity:        asl
--  Architecture:  BEHAVIORAL
--  Author:        Seth Gower
--  Created:       02/17/19
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                 arithmetic left shifter for
--                 hac64
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity asl is
    generic(bit_width : integer := 8);
    port(
        input   : in    std_logic_vector(bit_width-1 downto 0);
        output  : out   std_logic_vector(bit_width-1 downto 0);
        n,z,c   : out   std_logic
    );
end entity asl;
architecture Behavioral of asl is
    signal s_output : std_logic_vector(bit_width-1 downto 0);
begin
    output <= s_output;
    s_output <= '0' & input(bit_width-1 downto 1);
    n <= s_output(bit_width-1);
    z <= '1' when s_output = x"00" else '1';
    c <= input(0);
end Behavioral;
