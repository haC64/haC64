-------------------------------------------------
--  File:          alu.vhd
--
--  Entity:        alu
--  Architecture:  Structural
--  Author:        Paul Kelly
--  Created:       02/16/19
--  Modified:
--  VHDL'93
--  Description:   10 function arithmetic
--                 logic unit utilizing
--                 various 8-bit binary
--                 components
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    PORT (
        op1, op2    : in std_logic_vector(7 downto 0); -- arithmetic operands
        clk         : in std_logic;
        c_in        : in std_logic; -- carry in
        op_code     : in std_logic_vector(3 downto 0); -- code to determine op
        rts         : out std_logic_vector(7 downto 0);
        n_out       : out std_logic; -- negative flag out
        v_out       : out std_logic; -- overflow flag out
        z_out       : out std_logic; -- zero flag out
        c_out       : out std_logic  -- carry flag out
    );
end entity alu;

architecture Structural of alu is
    -- exclusive or component
    Component eor is
        PORT (
            in1 : in std_logic_vector(7 downto 0);
            in2 : in std_logic_vector(7 downto 0);
            o   : out std_logic_vector(7 downto 0);
            n, z : out std_logic
        );
    end Component;

    -- increment component
    Component inc is
        PORT (
            i : in std_logic_vector(7 downto 0);
            o   : out std_logic_vector(7 downto 0);
            n, z : out std_logic
        );
    end Component;

    -- logical shift right component
    Component lsr is
        PORT (
            i : in std_logic_vector(7 downto 0);
            o   : out std_logic_vector(7 downto 0);
            c, n, z : out std_logic
        );
    end Component;

    -- or component
    Component ora is
        PORT (
            in1 : in std_logic_vector(7 downto 0);
            in2 : in std_logic_vector(7 downto 0);
            o   : out std_logic_vector(7 downto 0);
            n, z : out std_logic
        );
    end Component;

    -- rotate left component
    Component rotl is
        PORT (
            i       : in std_logic_vector(7 downto 0);
            c_in    : in std_logic;
            o       : out std_logic_vector(7 downto 0);
            c_out   : out std_logic;
            n, z    : out std_logic
        );
    end Component;

    -- rotate right component
    Component rotr is
        PORT (
            i       : in std_logic_vector(7 downto 0);
            c_in    : in std_logic;
            o       : out std_logic_vector(7 downto 0);
            c_out   : out std_logic;
            n, z    : out std_logic
        );
    end Component;

    -- signals to attach to results of non-included components
    signal adc_res  : std_logic_vector(7 downto 0);
    signal and_res  : std_logic_vector(7 downto 0);
    signal asl_res  : std_logic_vector(7 downto 0);
    signal sub_res  : std_logic_vector(7 downto 0);
    signal dec_res  : std_logic_vector(7 downto 0);

    -- implemented components
    signal eor_res  : std_logic_vector(7 downto 0);
    signal inc_res  : std_logic_vector(7 downto 0);
    signal lsr_res  : std_logic_vector(7 downto 0);
    signal ora_res  : std_logic_vector(7 downto 0);
    signal rol_res  : std_logic_vector(7 downto 0);
    signal ror_res  : std_logic_vector(7 downto 0);

    signal nvzc_vec: std_logic_vector(3 downto 0);
begin
    -- exclusive or
    eor_comp : eor
        port map (in1 => op1, in2 => op2, o => eor_res, n => nvzc_vec(3), z =>
                 nvzc_vec(1));

    -- increment
    inc_comp : inc
        port map (i => op1, o => inc_res, n => nvzc_vec(3), z =>
                 nvzc_vec(1));

    -- logical shift right
    lsr_comp : lsr
        port map (i => op1, o => lsr_res, n => nvzc_vec(3), z =>
                 nvzc_vec(1), c => nvzc_vec(0));

    -- or component
    ora_comp : ora
        port map (in1 => op1, in2 => op2, o => ora_res, n => nvzc_vec(3), z =>
                 nvzc_vec(1));

    -- rotate left
    rotr_comp : rotl
        port map (i => op1, c_in => c_in, o => rol_res,
                  c_out => nvzc_vec(0), n => nvzc_vec(3), z => nvzc_vec(1));

    -- rotate right
    rotl_comp : rotr
        port map (i => op1, c_in => c_in, o => ror_res,
                  c_out => nvzc_vec(0), n => nvzc_vec(3), z => nvzc_vec(1));

    -- implement other components here

    -- issues: flags are set asynchronously
    process(clk) is
    begin
        if rising_edge(clk) then
            n_out <= nvzc_vec(3);
            v_out <= nvzc_vec(2);
            z_out <= nvzc_vec(1);
            c_out <= nvzc_vec(0);

            case op_code is
                when "0000" => rts <= adc_res;
                when "0001" => rts <= and_res;
                when "0010" => rts <= asl_res;
                when "0011" => rts <= sub_res;
                when "0100" => rts <= dec_res;
                when "0101" => rts <= eor_res;
                when "0110" => rts <= inc_res;
                when "0111" => rts <= lsr_res;
                when "1000" => rts <= ora_res;
                when "1001" => rts <= rol_res;
                when others => rts <= ror_res;
            end case;
        end if;
    end process;
end Structural;
