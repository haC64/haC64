-------------------------------------------------
--  File:          rotl.vhd
--
--  Entity:        rotl
--  Architecture:  Behavioral
--  Author:        Paul Kelly
--  Created:       02/17/19
--  Modified:      
--  VHDL'93
--  Description:   Rotate input register 
--                 single bit to the left
--                 in bit gets carry 
--                 carry gets out bit
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rotl is
    PORT (
        i       : IN std_logic_vector( 7 downto 0);    -- input data
        c_in    : IN std_logic;                        -- carry shift in
        o       : OUT std_logic_vector( 7 downto 0);   -- data output 
        c_out   : OUT std_logic;                       -- carry shift out
        n, z    : OUT std_logic                        -- N, Z flags set
    );
end entity rotl;

architecture Behavioral of rotl is
    -- provide data for sensitivity to update flags
    signal data : std_logic_vector(7 downto 0) := (others => '0');
begin
    process(i) is
    begin
        c_out <= i(7);
        data  <= i(6 downto 0) & c_in;
    end process;
    z <= '1' when data = x"00" else '0';
    n <= data(7);
    o <= data;
end Behavioral;
