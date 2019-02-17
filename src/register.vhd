-------------------------------------------------
--  File:          register.vhd
--
--  Entity:        reg
--  Architecture:  Behavioral
--  Author:        Seth Gower and Paul Kelly
--  Created:       02/16/19
--  Modified:      
--  VHDL'93
--  Description:   General 8 bit register 
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg is
    PORT (
        i   : IN    std_logic_vector( 7 downto 0); -- 8 bit input
        clk : IN    std_logic;		
        we  : IN    std_logic;		-- write enable
        rst : IN    std_logic;		-- asychro reset
        O   : OUT   std_logic_vector( 7 downto 0); -- 8 bit output
    );
end entity reg;

architecture Behavioral of reg is
    -- register storage 
    signal data : std_logic_vector( 7 downto 0) := (others => '0');
begin
    process(clk, rst)
    begin
        -- asynchro rst
        if rst = '1' then
            data <= (others => '0');
        elsif rising_edge(clk) then
            -- if write enable on rising edge of clk, set data to I
            if we = '1' then
                data <= I;
            end if;
        end if;
    end process;
    -- provide parallel output
    O <= data;
end Behavioral;
