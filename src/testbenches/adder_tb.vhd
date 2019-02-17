-------------------------------------------------
--  File:          adder_tb.vhd
--
--  Entity:        adder_tb
--  Architecture:  BEHAVIORAL
--  Author:        Seth Gower
--  Created:       02/17/19
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                 Testbench for the adder unit
--                 for the ALU
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder_tb is
    generic(bit_width : integer := 8);
end entity;

architecture behv of adder_tb is
    type test_vector is record
        a       : std_logic_vector(bit_width-1 downto 0);
        b       : std_logic_vector(bit_width-1 downto 0);
        carry   : std_logic;
        n,v,z,c : std_logic;
        output  : std_logic_vector(bit_width-1 downto 0);
    end record;

    type vector_array is array (natural range<>) of test_vector;

    constant test_vectors : vector_array := (
        -- a    b    cin  n   v   z   c   out
        (x"00",x"FF",'0','1','0','0','0',x"FF"),
        (x"00",x"FF",'1','0','1','1','1',x"00"),
        (x"55",x"aa",'0','1','0','0','0',x"FF"),
        (x"55",x"aa",'1','0','1','1','1',x"00"),
        (x"00",x"00",'0','0','0','1','0',x"00"),
        (x"00",x"00",'1','0','0','0','0',x"01"),
        (x"ff",x"ff",'0','1','0','0','1',x"fe"),
        (x"ff",x"ff",'1','1','0','0','1',x"ff")

    );
    constant clk_period : time := 100 ns;
    component adder is
        generic( bit_width : integer := 8 );
        port(
            a       : in    std_logic_vector(bit_width-1 downto 0);
            b       : in    std_logic_vector(bit_width-1 downto 0);
            carry   : in    std_logic;

            output  : out   std_logic_vector(bit_width-1 downto 0);
            n,v,z,c : out   std_logic
        );
    end component adder;

    signal s_clk,s_carry, s_n,s_v,s_z,s_c  : std_logic;
    signal s_a,s_b,s_output      : std_logic_vector(bit_width-1 downto 0);
begin

adder_0 : adder
    port map (
        a        => s_a,
        b        => s_b,
        carry    => s_carry,
        output   => s_output,
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
        variable curr_vector : test_vector;
    begin
        for i in test_vectors'range loop
            wait until falling_edge(s_clk);
            curr_vector := test_vectors(i);

            s_a <= curr_vector.a;
            s_b <= curr_vector.b;
            s_carry <= curr_vector.carry;

            wait for clk_period*2;
            assert s_output = curr_vector.output report "Output for test case "
            & integer'image(i) & " incorrect" severity error;
            assert s_n = curr_vector.n report integer'image(i)&":n flag wrong"
                severity error;
            assert s_v = curr_vector.v report integer'image(i)&":v flag wrong"
                severity error;
            assert s_z = curr_vector.z report integer'image(i)&":z flag wrong"
                severity error;
            assert s_c = curr_vector.c report integer'image(i)&":c flag wrong"
                severity error;
            wait for clk_period;
        end loop;
        report "Simulation finished" severity failure;
    end process;
end behv;
