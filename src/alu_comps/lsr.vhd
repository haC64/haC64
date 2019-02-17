-------------------------------------------------
--  File:          lsr.vhd
--
--  Entity:        lsr
--  Architecture:  Behavioral
--  Author:        Paul Kelly
--  Created:       02/17/19
--  Modified:      
--  VHDL'93
--  Description:   logical shift right of 
--                 input value
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lsr is
    PORT (
        i  : IN std_logic_vector( 7 downto 0);    -- input data
        o    : OUT std_logic_vector( 7 downto 0);   -- data output 
        c, n, z : OUT std_logic   -- C, N, Z flags set
    );
end entity lsr;

architecture Behavioral of lsr is
    -- provide data for sensitivity to update flags
    signal data : std_logic_vector(7 downto 0) := (others => '0');
begin
    process(i) is
    begin
        c <= i(0);
        data <= '0' & i(7 downto 1);
    end process;
    z <= '1' when data = x"00" else '0';
    n <= data(7);
    o <= data;
end Behavioral;
