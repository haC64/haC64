-------------------------------------------------
--  File:          eor.vhd
--
--  Entity:        eor
--  Architecture:  Behavioral
--  Author:        Seth Gower and Paul Kelly
--  Created:       02/16/19
--  Modified:      
--  VHDL'93
--  Description:   8 bit two input xor for use
--                 in 6510 ALU
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity eor is
    PORT (
        in1  : IN std_logic_vector( 7 downto 0);    -- input data
        in2  : IN std_logic_vector( 7 downto 0);    -- xor applicand
        o    : OUT std_logic_vector( 7 downto 0);   -- data output 
        n, v : OUT std_logic   -- N, V flags set
    );
end entity eor;

architecture Behavioral of eor is
    -- provide data for sensitivity to update flags
    signal data : std_logic_vector(7 downto 0) := (others => '0');
begin
    process(data) is
    begin
        if data = "00000000" then
            z <= '1';
        else 
            z <= '0';
        end if;
        if data(7) = '1' then 
            n <= '1';
        else 
            n <= '0';
        end if;
    end process;
    data <= in1 xor in2;
end Behavioral;
