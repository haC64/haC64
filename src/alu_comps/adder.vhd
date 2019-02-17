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
        input   : in    std_logic_vector(bit_width-1 downto 0);
        carry   : in    std_logic;
        output  : out   std_logic_vector(bit_width-1 downto 0);
        psr     : out   std_logic_vector(3 downto 0)
    );
end entity adder;
architecture Behavioral of adder is

begin
end Behavioral;
