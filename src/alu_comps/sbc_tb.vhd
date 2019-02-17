-------------------------------------------------
--  File:          sbc_tb.vhd
--
--  Entity:        sbc_tb
--  Architecture:  BEHAVIORAL
--  Author:        Seth Gower
--  Created:       02/17/19
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                 I need a really long default
--                 here so I don't have to type so
--                 much !
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sbc_tb is
    generic(bit_width : integer := 8);
end entity sbc_tb;
architecture Behavioral of sbc_tb is
    constant clk_period : time := 200 ns;
    type test_vector is record
        a       : std_logic_vector(bit_width-1 downto 0);
        b       : std_logic_vector(bit_width-1 downto 0);
        borrow  : std_logic;
        n,v,z,c : std_logic;
        output  : std_logic_vector(bit_width-1 downto 0);
    end record;

    type vector_array is array (natural range<>) of test_vector;

    constant test_vectors : vector_array := (
        -- a    b    cin  n   v   z   c   out
        (x"00",x"FF",'0','1','0','0','0',x"01"),
        (x"00",x"FF",'1','0','1','1','1',x"00"),
        (x"55",x"aa",'0','1','0','0','0',x"ab"),
        (x"55",x"aa",'1','0','1','1','1',x"aa"),
        (x"00",x"00",'0','0','0','1','0',x"00"),
        (x"00",x"00",'1','0','0','0','0',x"ff"),
        (x"ff",x"ff",'0','1','0','0','1',x"00"),
        (x"ff",x"ff",'1','1','0','0','1',x"ff")
    );
    component sbc is
        generic(bit_width : integer := 8);
        port(
            a,b     : in    std_logic_vector(bit_width-1 downto 0);
            output  : out   std_logic_vector(bit_width-1 downto 0);
            borrow  : in    std_logic;
            n,v,z,c : out   std_logic
        );
    end component sbc;

    signal s_clk,s_borrow,s_n,s_v,s_z,s_c   : std_logic;
    signal s_a,s_b,s_output     : std_logic_vector(bit_width-1 downto 0);
begin
    sbc_0 : sbc
        port map (
            a => s_a,
            b => s_b,
            output   => s_output,
            borrow   => s_borrow,
            n => s_n,
            v => s_v,
            z => s_z,
            c => s_c
        );

    clk_process:process
    begin
        s_clk <= '0';
        wait for clk_period/2;
        s_clk <= '1';
        wait for clk_period/2;
    end process;

    stim:process
        variable curr_vec : test_vector;
    begin
        for i in test_vectors'range loop
            wait until falling_edge(s_clk);
            curr_vec := test_vectors(i);

            s_a <= curr_vec.a;
            s_b <= curr_vec.b;
            s_borrow <= curr_vec.borrow;

            wait for clk_period*2;
            assert s_output = curr_vec.output report "Output for test case "
            & integer'image(i) & " incorrect" severity error;
            assert s_n = curr_vec.n report integer'image(i)&":n flag wrong"
                severity error;
            assert s_v = curr_vec.v report integer'image(i)&":v flag wrong"
                severity error;
            assert s_z = curr_vec.z report integer'image(i)&":z flag wrong"
                severity error;
            assert s_c = curr_vec.c report integer'image(i)&":c flag wrong"
                severity error;
            wait for clk_period;
        end loop;

        report "Simulation Finished" severity failure;
    end process;
end Behavioral;
