-------------------------------------------------
--  File:          adder.vhd
--
--  Entity:        adder
--  Architecture:  BEHAVIORAL
--  Author:        Seth Gower
--  Created:       02/16/19
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                 Adder unit for ADC instruction
--                 for ALU for haC64
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder is
    generic( bit_width : integer := 8 );
    port(
        a       : in    std_logic_vector(bit_width-1 downto 0);
        b       : in    std_logic_vector(bit_width-1 downto 0);
        carry   : in    std_logic;

        output  : out   std_logic_vector(bit_width-1 downto 0);
        n,v,z,c : out   std_logic
    );
end entity adder;
architecture Behavioral of adder is
    signal s_carry     : std_logic_vector(bit_width downto 0);
    signal s_output    : std_logic_vector(bit_width-1 downto 0);
begin
    output      <= s_output;
    s_carry(0)  <= carry;
    n           <= s_output(bit_width-1);
    c           <= s_carry(bit_width);
    v           <= s_carry(bit_width) xor s_carry(bit_width-1);

    adders:for i in 0 to bit_width-1 generate
        s_output(i) <= a(i) xor b(i);
        s_carry(i+1)<= (a(i) and b(i)) or (a(i) and s_carry(i)) or (b(i) and
                       s_carry(i));
    end generate;

    psr_proc:process(s_output)
    begin

    end process;
end Behavioral;
