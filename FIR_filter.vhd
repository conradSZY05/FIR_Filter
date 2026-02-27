----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.02.2026 19:57:30
-- Design Name: 
-- Module Name: FIR_filter - rtl
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIR_filter is
    port(
        clk, reset : in std_logic;
        s_axis_fir_tdata  : in signed(15 downto 0);
        s_axis_fir_tkeep : in signed(3 downto 0);
        s_axis_fir_tlast, s_axis_fir_tvalid, m_axis_fir_tready : in std_logic;
        m_axis_fir_tvalid, s_axis_fir_tready, m_axis_fir_tlast : out std_logic;
        m_axis_fir_tkeep : out unsigned(3 downto 0);
        m_axis_fir_tdata : out signed(31 downto 0)
    );
end FIR_filter;

architecture rtl of FIR_filter is
    signal enable_fir, enable_buf : std_logic;
    signal buff_cnt : unsigned(3 downto 0);
    signal input_sample : signed(15 downto 0);
    signal buff0, buff1, buff2, buff3, buff4, buff5, buff6, buff7, buff8, buff9, buff10, buff11, buff12, buff13, buff14 : signed(15 downto 0);
    signal tap0, tap1, tap2, tap3, tap4, tap5, tap6, tap7, tap8, tap9, tap10, tap11, tap12, tap13, tap14 : signed(15 downto 0);
    signal acc0, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10, acc11, acc12, acc13, acc14 : signed(31 downto 0);
begin
    -- assign tap coefficients
    tap0 <= to_signed(385, 16);
    tap1 <= to_signed(20, 16);
    tap2 <= to_signed(-1528, 16);
    tap3 <= to_signed(-3156, 16);
    tap4 <= to_signed(-2089, 16);
    tap5 <= to_signed(3079, 16);
    tap6 <= to_signed(9729, 16);
    tap7 <= to_signed(12809, 16);
    tap8 <= to_signed(9729, 16);
    tap9 <= to_signed(3079, 16);
    tap10 <= to_signed(-2089, 16);
    tap11 <= to_signed(-3156, 16);
    tap12 <= to_signed(-1528, 16);
    tap13 <= to_signed(20, 16);
    tap14 <= to_signed(385, 16);
    
    -- after reset, set output tvalid high once circular buffer has been filled with input samples for the first time
    process (clk, reset)
    begin
        if rising_edge(clk) OR falling_edge(reset) then
            if (reset = '1') then
                buff_cnt <= (others => '0');
                enable_fir <= '0';
                input_sample <= (others => '0');
            elsif (m_axis_fir_tready = '0') OR (s_axis_fir_tvalid = '0') then
                buff_cnt <= to_unsigned(15, 4);
                enable_fir <= '0';
                input_sample <= input_sample;
            elsif (buff_cnt = to_unsigned(15, 4)) then
                buff_cnt <= (others => '0');
                enable_fir <= '1';
                input_sample <= s_axis_fir_tdata;
            else 
                buff_cnt <= buff_cnt + 1;
                input_sample <= s_axis_fir_tdata;
            end if;
        end if;
    end process;
    
    --
    
    

end rtl;
