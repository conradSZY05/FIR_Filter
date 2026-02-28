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
        s_axis_fir_tlast, s_axis_fir_tvalid, m_axis_fir_tready : in std_logic;
        m_axis_fir_tvalid, s_axis_fir_tready, m_axis_fir_tlast : out std_logic;
        m_axis_fir_tkeep : out unsigned(3 downto 0);
        m_axis_fir_tdata : out signed(31 downto 0)
    );
end FIR_filter;

architecture rtl of FIR_filter is
    signal enable_fir, enable_buff : std_logic;
    signal buff_cnt : unsigned(3 downto 0);
    signal input_sample : signed(15 downto 0);
    
    -- tap coefficients, buffer, accumulator
    type coeff_array_t is array (0 to 14) of signed(15 downto 0);
    constant TAPS : coeff_array_t := (
        0 => to_signed(385, 16),
        1 => to_signed(20, 16),
        2 => to_signed(-1528, 16),
        3 => to_signed(-3156, 16),
        4 => to_signed(-2089, 16),
        5 => to_signed(3079, 16),
        6 => to_signed(9729, 16),
        7 => to_signed(12809, 16),
        8 => to_signed(9729, 16),
        9 => to_signed(3079, 16),
        10 => to_signed(-2089, 16),
        11 => to_signed(-3156, 16),
        12 => to_signed(-1528, 16),
        13 => to_signed(20, 16),
        14 => to_signed(385, 16)
    );
    
    type sample_array_t is array (0 to 14) of signed(15 downto 0); 
    signal buff : sample_array_t;
    
    type acc_array_t is array (0 to 14) of signed(31 downto 0);
    signal acc : acc_array_t;
    
begin
    -- initialise tkeep, tlast
    process(clk)
    begin
        if rising_edge(clk) then
            m_axis_fir_tkeep <= x"F";
        end if;
    end process;
    process(clk)
    begin
        if rising_edge(clk) then
            if (s_axis_fir_tlast = '1') then
                m_axis_fir_tlast <= '1';
            else
                m_axis_fir_tlast <= '0';
            end if;
        end if;
    end process;
    
    
    -- after reset, set output tvalid high once circular buffer has been filled with input samples for the first time
    process (clk, reset)
        variable buf_var : unsigned(3 downto 0);
    begin
        if (reset = '1') then
            buff_cnt <= (others => '0');
            enable_fir <= '0';
            input_sample <= (others => '0');
        elsif rising_edge(clk) then
            if (m_axis_fir_tready = '0') OR (s_axis_fir_tvalid = '0') then
                buff_cnt <= to_unsigned(15, 4);
                enable_fir <= '0';

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
    
    -- reset buff
    process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') OR (m_axis_fir_tready = '0') OR (s_axis_fir_tvalid = '0') then
                s_axis_fir_tready <= '0';
                m_axis_fir_tvalid <= '0';
                enable_buff <= '0';
            else 
                s_axis_fir_tready <= '1';
                m_axis_fir_tvalid <= '1';
                enable_buff <= '1';
            end if; 
        end if;
    end process;
    
    -- get input sample stream from circular buffer and create 15 inputs for 15 taps of filter
    process(clk)
    begin
        if rising_edge(clk) then
            if (enable_buff = '1') then
                buff(0) <= input_sample;
                buff(1) <= buff(0);
                buff(2) <= buff(1);
                buff(3) <= buff(2);
                buff(4) <= buff(3);
                buff(5) <= buff(4);
                buff(6) <= buff(5);
                buff(7) <= buff(6);
                buff(8) <= buff(7);
                buff(9) <= buff(8);
                buff(10) <= buff(9);
                buff(11) <= buff(10);
                buff(12) <= buff(11);
                buff(13) <= buff(12);
                buff(14) <= buff(13);
            end if;
        end if;
    end process;
    
    -- multiply using taps
    process(clk)
    begin
        if rising_edge(clk) then
            if (enable_fir = '1') then 
                for i in 0 to 14 loop
                    acc(i) <= TAPS(i) * buff(i);
                end loop;
            end if;
        end if;
    end process;
    
    -- accumulate
    process(clk)
        variable sum : signed(31 downto 0);
    begin
        if rising_edge(clk) then
            sum := (others => '0');
            if (enable_fir = '1') then
                for n in acc'range loop
                    sum := sum + acc(n);
                end loop;
            end if;
            m_axis_fir_tdata  <= sum;
        end if;
    end process;

end rtl;