-------------------------------------------------
--  File:          increment.vhd
--
--  Entity:        inc 
--  Architecture:  Behavioral
--  Author:        Paul Kelly
--  Created:       02/17/19
--  Modified:      
--  VHDL'93
--  Description:   Increment input by one
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity inc is
    PORT (
        i    :  IN  std_logic_vector(7 downto 0);
        o    :  OUT std_logic_vector(7 downto 0);
        n, z :  OUT std_logic
    );
end entity inc;

architecture Behavioral of inc is
    signal data : std_logic_vector( 7 downto 0) := (others => '0');
begin
    process(i) is
    begin
        data <= std_logic_vector( signed(i) + 1);
    end process;
    z <= '1' when data = x"00" else '0';
    n <= data(7);
    o <= data;
end Behavioral;
