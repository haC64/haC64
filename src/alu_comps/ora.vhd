-------------------------------------------------
--  File:          ora.vhd
--
--  Entity:        ora
--  Architecture:  Behavioral
--  Author:        Paul Kelly
--  Created:       02/17/19
--  Modified:      
--  VHDL'93
--  Description:   8 bit two input or for use
--                 in 6510 ALU
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ora is
    PORT (
        in1  : IN std_logic_vector( 7 downto 0);    -- input data
        in2  : IN std_logic_vector( 7 downto 0);    -- or applicand
        o    : OUT std_logic_vector( 7 downto 0);   -- data output 
        n, z : OUT std_logic   -- N, Z flags set
    );
end entity ora;

architecture Behavioral of eor is
    -- provide data for sensitivity to update flags
    signal data : std_logic_vector(7 downto 0) := (others => '0');
begin
    process(in1, in2) is
    begin
        data <= in1 or in2;
    end process;
    z <= '1' when data = x"00" else '0';
    n <= data(7);
    o <= data;
end Behavioral;
