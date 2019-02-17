----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2019 01:49:03 AM
-- Design Name: 
-- Module Name: comp_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comp_tb is
end comp_tb;

architecture Behavioral of comp_tb is
    Component inc is 
        PORT (
            i   : IN std_logic_vector(7 downto 0);
            o   : OUT std_logic_vector(7 downto 0);
            n, z: OUT std_logic
        );
    end Component;
    
    type test_record is record
        a   : std_logic_vector(7 downto 0);
        y   : std_logic_vector(7 downto 0);
        neg : std_logic;
        zer : std_logic;
    end record;
    
    type test_vectors is array(0 to 4) of test_record;
    constant test_vector_table : test_vectors := (
        ( a => x"55", y => x"56", neg => '0', zer => '0'),
        ( a => x"FF", y => x"00", neg => '0', zer => '1'),
        ( a => x"11", y => x"12", neg => '0', zer => '0'),
        ( a => x"00", y => x"01", neg => '0', zer => '0'),
        ( a => x"AA", y => x"AB", neg => '1', zer => '0')
    );
    
    constant delay : time := 10ns;
    signal A, Y : std_logic_vector(7 downto 0) := (others => '0');
    signal N, Z : std_logic := '0';
begin
    -- instantiate component
    inc_inst : inc PORT MAP (
        i   => A,
        o   => Y,
        n   => N,
        z   => Z
    );
    
    test_proc : process is begin
        for i in 0 to 4 loop
            A <= test_vector_table(i).a;
            wait for delay;
            assert Y = test_vector_table(i).y
                report "inc failed";
            assert N = test_vector_table(i).neg
                report "Incorrect N flag set";
            assert Z = test_vector_table(i).zer
                report "Incorrect Z flag set";
        end loop;
    end process;
end Behavioral;
