library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_FIR_filter is
    generic (
        NUM_TAPS : integer := 53;
        COEF_WIDTH : integer := 16;
        INPUT_WIDTH : integer := 16;
        OUTPUT_WIDTH : integer := 38 -- 16 bit samples multiplied with 16 bit coefficients, summed 53 (53 taps) times is 38 bits for no overflow
    );
end tb_FIR_filter;
    
architecture sim of tb_FIR_filter is
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal data_i : std_logic_vector(INPUT_WIDTH-1 downto 0) := (others => '0');
    signal data_o : std_logic_vector(OUTPUT_WIDTH-1 downto 0) := (others => '0');
    
    constant CLK_PERIOD : time := 10 ns;
    

begin
    uut : entity work.FIR_filter(rtl)
    port map (
        clk => clk,
        reset => reset,
        data_i => data_i,
        data_o => data_o
    );
    
    clk <= not clk after CLK_PERIOD / 2;
    
    process
    begin
        
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        wait for CLK_PERIOD;
        
        data_i <= b"0000000000000001";
        wait for CLK_PERIOD;
        data_i <= b"0000000000000000";
        
        wait for 100 * CLK_PERIOD;
    end process;
end sim;