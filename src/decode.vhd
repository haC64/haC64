-------------------------------------------------
--  File:          decode.vhd
--
--  Entity:        decode
--  Architecture:  BEHAVIORAL
--  Author:        Seth Gower
--  Created:       02/16/19
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                 Instruction decode stage for
--                 C64 hackathon project
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decode is
    generic(
        inst_size   : integer := 8
    );
    port(
        Instruction : in    std_logic_vector(inst_size-1 downto 0);
        Output      : out   std_logic_vector(inst_size-1 downto 0);
        PSROut      : out   std_logic_vector(inst_size-1 downto 0);
        Timing      : in    std_logic_vector(2 downto 0);
        Interrupt   : in    std_logic_vector(2 downto 0);
        MemWBEn     : out   std_logic
    );
end entity decode;
architecture Behavioral of decode is

    -- Add instructions
    constant op_adc_i   : std_logic_vector(inst_size-1 downto 0) := x"69";
    constant op_adc_z   : std_logic_vector(inst_size-1 downto 0) := x"65";
    constant op_adc_zx  : std_logic_vector(inst_size-1 downto 0) := x"75";
    constant op_adc_a   : std_logic_vector(inst_size-1 downto 0) := x"6d";
    constant op_adc_ax  : std_logic_vector(inst_size-1 downto 0) := x"7d";
    constant op_adc_ay  : std_logic_vector(inst_size-1 downto 0) := x"79";
    constant op_adc_indx: std_logic_vector(inst_size-1 downto 0) := x"61";
    constant op_adc_indy: std_logic_vector(inst_size-1 downto 0) := x"71";

    -- AND Instructions
    constant op_and_i   : std_logic_vector(inst_size-1 downto 0) := x"29";
    constant op_and_z   : std_logic_vector(inst_size-1 downto 0) := x"25";
    constant op_and_zx  : std_logic_vector(inst_size-1 downto 0) := x"35";
    constant op_and_a   : std_logic_vector(inst_size-1 downto 0) := x"2d";
    constant op_and_ax  : std_logic_vector(inst_size-1 downto 0) := x"3d";
    constant op_and_ay  : std_logic_vector(inst_size-1 downto 0) := x"39";
    constant op_and_indx: std_logic_vector(inst_size-1 downto 0) := x"21";
    constant op_and_indy: std_logic_vector(inst_size-1 downto 0) := x"31";

    -- Arithmetic Shift Left Instructions
    constant op_asl_acc : std_logic_vector(inst_size-1 downto 0) := x"0a";
    constant op_asl_z   : std_logic_vector(inst_size-1 downto 0) := x"06";
    constant op_asl_zx  : std_logic_vector(inst_size-1 downto 0) := x"16";
    constant op_asl_a   : std_logic_vector(inst_size-1 downto 0) := x"0e";
    constant op_asl_ax  : std_logic_vector(inst_size-1 downto 0) := x"1e";

    -- Logical Shift Right Instructions
    constant op_lsr_acc : std_logic_vector(inst_size-1 downto 0) := x"4a";
    constant op_lsr_z   : std_logic_vector(inst_size-1 downto 0) := x"46";
    constant op_lsr_zx  : std_logic_vector(inst_size-1 downto 0) := x"56";
    constant op_lsr_a   : std_logic_vector(inst_size-1 downto 0) := x"4e";
    constant op_lsr_ax  : std_logic_vector(inst_size-1 downto 0) := x"5e";

    -- Various Branch instructions
    constant op_bcc     : std_logic_vector(inst_size-1 downto 0) := x"90";
    constant op_bcs     : std_logic_vector(inst_size-1 downto 0) := x"B0";
    constant op_beq     : std_logic_vector(inst_size-1 downto 0) := x"F0";
    constant op_bmi     : std_logic_vector(inst_size-1 downto 0) := x"30";
    constant op_bne     : std_logic_vector(inst_size-1 downto 0) := x"D0";
    constant op_bpl     : std_logic_vector(inst_size-1 downto 0) := x"10";
    constant op_bvc     : std_logic_vector(inst_size-1 downto 0) := x"50";
    constant op_bvs     : std_logic_vector(inst_size-1 downto 0) := x"70";

    -- Misc Instructions
    constant op_brk     : std_logic_vector(inst_size-1 downto 0) := x"00";
    constant op_bit_z   : std_logic_vector(inst_size-1 downto 0) := x"24";
    constant op_bit_a   : std_logic_vector(inst_size-1 downto 0) := x"2c";

    -- Clear Flags
    constant op_clc     : std_logic_vector(inst_size-1 downto 0) := x"18";
    constant op_cld     : std_logic_vector(inst_size-1 downto 0) := x"D8";
    -- clear Interrupt disable
    constant op_cli     : std_logic_vector(inst_size-1 downto 0) := x"58";
    constant op_clv     : std_logic_vector(inst_size-1 downto 0) := x"B8";

    -- Set flags
    constant op_sec     : std_logic_vector(inst_size-1 downto 0) := x"38";
    constant op_sed     : std_logic_vector(inst_size-1 downto 0) := x"f8";
    -- set Interrupt disable
    constant op_sei     : std_logic_vector(inst_size-1 downto 0) := x"78";

    -- Compare Instructions
    constant op_cmp_i   : std_logic_vector(inst_size-1 downto 0) := x"c9";
    constant op_cmp_z   : std_logic_vector(inst_size-1 downto 0) := x"c5";
    constant op_cmp_zx  : std_logic_vector(inst_size-1 downto 0) := x"d5";
    constant op_cmp_a   : std_logic_vector(inst_size-1 downto 0) := x"cd";
    constant op_cmp_ax  : std_logic_vector(inst_size-1 downto 0) := x"dd";
    constant op_cmp_ay  : std_logic_vector(inst_size-1 downto 0) := x"d9";
    constant op_cmp_indx: std_logic_vector(inst_size-1 downto 0) := x"c1";
    constant op_cmp_indy: std_logic_vector(inst_size-1 downto 0) := x"d1";

    -- Compare Memory with Index Instructions
    constant op_cpx_i   : std_logic_vector(inst_size-1 downto 0) := x"e0";
    constant op_cpx_z   : std_logic_vector(inst_size-1 downto 0) := x"e4";
    constant op_cpx_a   : std_logic_vector(inst_size-1 downto 0) := x"ec";

    constant op_cpy_i   : std_logic_vector(inst_size-1 downto 0) := x"c0";
    constant op_cpy_z   : std_logic_vector(inst_size-1 downto 0) := x"c4";
    constant op_cpy_a   : std_logic_vector(inst_size-1 downto 0) := x"cc";

    -- Decrement memory value by 1
    constant op_dec_z   : std_logic_vector(inst_size-1 downto 0) := x"c6";
    constant op_dec_zx  : std_logic_vector(inst_size-1 downto 0) := x"d6";
    constant op_dec_a   : std_logic_vector(inst_size-1 downto 0) := x"ce";
    constant op_dec_ax  : std_logic_vector(inst_size-1 downto 0) := x"de";

    -- Decrement X or Y reg by 1
    constant op_dex     : std_logic_vector(inst_size-1 downto 0) := x"ca";
    constant op_dey     : std_logic_vector(inst_size-1 downto 0) := x"88";

    -- Incrememtn value in memory by 1
    constant op_inc_z   : std_logic_vector(inst_size-1 downto 0) := x"e6";
    constant op_inc_zx  : std_logic_vector(inst_size-1 downto 0) := x"f6";
    constant op_inc_a   : std_logic_vector(inst_size-1 downto 0) := x"ee";
    constant op_inc_ax  : std_logic_vector(inst_size-1 downto 0) := x"fe";

    -- incremement x or y reg by 1
    constant op_inx     : std_logic_vector(inst_size-1 downto 0) := x"e8";
    constant op_iny     : std_logic_vector(inst_size-1 downto 0) := x"c8";

    -- XOR
    constant op_eor_i   : std_logic_vector(inst_size-1 downto 0) := x"49";
    constant op_eor_z   : std_logic_vector(inst_size-1 downto 0) := x"45";
    constant op_eor_zx  : std_logic_vector(inst_size-1 downto 0) := x"55";
    constant op_eor_a   : std_logic_vector(inst_size-1 downto 0) := x"4d";
    constant op_eor_ax  : std_logic_vector(inst_size-1 downto 0) := x"59";
    constant op_eor_ay  : std_logic_vector(inst_size-1 downto 0) := x"59";
    constant op_eor_indx: std_logic_vector(inst_size-1 downto 0) := x"41";
    constant op_eor_indy: std_logic_vector(inst_size-1 downto 0) := x"51";

    -- various jump instructions
    constant op_jmp_a   : std_logic_vector(inst_size-1 downto 0) := x"4c";
    constant op_jmp_ind : std_logic_vector(inst_size-1 downto 0) := x"6c";
    constant op_jsr     : std_logic_vector(inst_size-1 downto 0) := x"20";

    -- load into the Accumulator
    constant op_lda_i   : std_logic_vector(inst_size-1 downto 0) := x"a9";
    constant op_lda_z   : std_logic_vector(inst_size-1 downto 0) := x"a5";
    constant op_lda_zx  : std_logic_vector(inst_size-1 downto 0) := x"b5";
    constant op_lda_a   : std_logic_vector(inst_size-1 downto 0) := x"ad";
    constant op_lda_ax  : std_logic_vector(inst_size-1 downto 0) := x"bd";
    constant op_lda_ay  : std_logic_vector(inst_size-1 downto 0) := x"b9";
    constant op_lda_indx: std_logic_vector(inst_size-1 downto 0) := x"a1";
    constant op_lda_indy: std_logic_vector(inst_size-1 downto 0) := x"b1";

    -- Load into the x reg
    constant op_ldx_i   : std_logic_vector(inst_size-1 downto 0) := x"a2";
    constant op_ldx_z   : std_logic_vector(inst_size-1 downto 0) := x"a6";
    constant op_ldx_zy  : std_logic_vector(inst_size-1 downto 0) := x"b6";
    constant op_ldx_a   : std_logic_vector(inst_size-1 downto 0) := x"ae";
    constant op_ldx_ay  : std_logic_vector(inst_size-1 downto 0) := x"be";

    -- load into the y reg
    constant op_ldy_i   : std_logic_vector(inst_size-1 downto 0) := x"a0";
    constant op_ldy_z   : std_logic_vector(inst_size-1 downto 0) := x"a4";
    constant op_ldy_zx  : std_logic_vector(inst_size-1 downto 0) := x"a4";
    constant op_ldy_a   : std_logic_vector(inst_size-1 downto 0) := x"ac";
    constant op_ldy_ax  : std_logic_vector(inst_size-1 downto 0) := x"ac";

    -- no operation
    constant op_nop     : std_logic_vector(inst_size-1 downto 0) := x"ea";

    -- ALU Or op
    constant op_ora_i   : std_logic_vector(inst_size-1 downto 0) := x"09";
    constant op_ora_z   : std_logic_vector(inst_size-1 downto 0) := x"05";
    constant op_ora_zx  : std_logic_vector(inst_size-1 downto 0) := x"15";
    constant op_ora_a   : std_logic_vector(inst_size-1 downto 0) := x"0d";
    constant op_ora_ax  : std_logic_vector(inst_size-1 downto 0) := x"1d";
    constant op_ora_ay  : std_logic_vector(inst_size-1 downto 0) := x"19";
    constant op_ora_indx: std_logic_vector(inst_size-1 downto 0) := x"01";
    constant op_ora_indy: std_logic_vector(inst_size-1 downto 0) := x"11";

    -- Push Accumulator and PSR onto the stack
    constant op_pha     : std_logic_vector(inst_size-1 downto 0) := x"48";
    constant op_php     : std_logic_vector(inst_size-1 downto 0) := x"08";

    -- Pull Accumulator and PSR onto the stack
    constant op_pla     : std_logic_vector(inst_size-1 downto 0) := x"68";
    constant op_plp     : std_logic_vector(inst_size-1 downto 0) := x"28";

    -- rotate left by 1 bit
    constant op_rol_acc : std_logic_vector(inst_size-1 downto 0) := x"2a";
    constant op_rol_z   : std_logic_vector(inst_size-1 downto 0) := x"26";
    constant op_rol_zx  : std_logic_vector(inst_size-1 downto 0) := x"36";
    constant op_rol_a   : std_logic_vector(inst_size-1 downto 0) := x"2e";
    constant op_rol_ax  : std_logic_vector(inst_size-1 downto 0) := x"3e";

    -- rotate right by 1 bit
    constant op_ror_acc : std_logic_vector(inst_size-1 downto 0) := x"2a";
    constant op_ror_z   : std_logic_vector(inst_size-1 downto 0) := x"26";
    constant op_ror_zx  : std_logic_vector(inst_size-1 downto 0) := x"36";
    constant op_ror_a   : std_logic_vector(inst_size-1 downto 0) := x"2e";
    constant op_ror_ax  : std_logic_vector(inst_size-1 downto 0) := x"3e";

    -- Return from Interrupt or Subroutine
    constant op_rti     : std_logic_vector(inst_size-1 downto 0) := x"40";
    constant op_rts     : std_logic_vector(inst_size-1 downto 0) := x"60";

    -- subtract with carry
    constant op_sbc_i   : std_logic_vector(inst_size-1 downto 0) := x"e9";
    constant op_sbc_z   : std_logic_vector(inst_size-1 downto 0) := x"e5";
    constant op_sbc_zx  : std_logic_vector(inst_size-1 downto 0) := x"f5";
    constant op_sbc_a   : std_logic_vector(inst_size-1 downto 0) := x"ed";
    constant op_sbc_ax  : std_logic_vector(inst_size-1 downto 0) := x"fd";
    constant op_sbc_ay  : std_logic_vector(inst_size-1 downto 0) := x"f9";
    constant op_sbc_indx: std_logic_vector(inst_size-1 downto 0) := x"e1";
    constant op_sbc_indy: std_logic_vector(inst_size-1 downto 0) := x"f1";

    -- store Accumulator in memory
    constant op_sta_z   : std_logic_vector(inst_size-1 downto 0) := x"85";
    constant op_sta_zx  : std_logic_vector(inst_size-1 downto 0) := x"95";
    constant op_sta_a   : std_logic_vector(inst_size-1 downto 0) := x"8d";
    constant op_sta_ax  : std_logic_vector(inst_size-1 downto 0) := x"9d";
    constant op_sta_ay  : std_logic_vector(inst_size-1 downto 0) := x"99";
    constant op_sta_indx: std_logic_vector(inst_size-1 downto 0) := x"81";
    constant op_sta_indy: std_logic_vector(inst_size-1 downto 0) := x"91";

    -- store index x in memory
    constant op_stx_z   : std_logic_vector(inst_size-1 downto 0) := x"86";
    constant op_stx_zy  : std_logic_vector(inst_size-1 downto 0) := x"96";
    constant op_stx_a   : std_logic_vector(inst_size-1 downto 0) := x"8e";

    constant op_sty_z   : std_logic_vector(inst_size-1 downto 0) := x"84";
    constant op_sty_zx  : std_logic_vector(inst_size-1 downto 0) := x"94";
    constant op_sty_a   : std_logic_vector(inst_size-1 downto 0) := x"8c";

    -- Transfer Accumulator to index x
    constant op_tax     : std_logic_vector(inst_size-1 downto 0) := x"aa";
    -- transfer Accumulator to index y
    constant op_tay     : std_logic_vector(inst_size-1 downto 0) := x"a8";
    -- transfer sp to index x
    constant op_tsx     : std_logic_vector(inst_size-1 downto 0) := x"ba";
    -- transfer x to Accumulator
    constant op_txa     : std_logic_vector(inst_size-1 downto 0) := x"8a";
    -- transfer index x to sp
    constant op_txs     : std_logic_vector(inst_size-1 downto 0) := x"9a";
    -- transfer index y to accum
    constant op_tya     : std_logic_vector(inst_size-1 downto 0) := x"98";
begin
end Behavioral;
