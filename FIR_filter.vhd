library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
  
entity FIR_filter is
    generic (
        NUM_TAPS : integer := 53;
        COEF_WIDTH : integer := 16;
        INPUT_WIDTH : integer := 16;
        OUTPUT_WIDTH : integer := 38 -- 16 bit samples multiplied with 16 bit coefficients, summed 53 (53 taps) times is 38 bits for no overflow
    );
    port (
        clk, reset, enable : in std_logic;
        data_i : in std_logic_vector(INPUT_WIDTH-1 downto 0);
        data_o : out std_logic_vector(OUTPUT_WIDTH-1 downto 0)
    );
end FIR_filter;
  
architecture rtl of FIR_filter is
    -- f_s = 500 Hz, f_c = 40 Hz, stopband 50 Hz LPF generated 53 tap coefficients
    type t_tap_array is array (0 to NUM_TAPS-1) of signed(COEF_WIDTH-1 downto 0);
    constant TAPS : t_tap_array := (
        x"FFE7", x"FE99", x"FE3A", x"FD73", x"FCDB", x"FC98", x"FCD0", x"FD8F",
        x"FEC2", x"0035", x"0199", x"0296", x"02E0", x"0250", x"00F3", x"FF0D",
        x"FD17", x"FBA5", x"FB45", x"FC5F", x"FF17", x"033C", x"084A", x"0D84",
        x"120F", x"1526", x"163E", x"1526", x"120F", x"0D84", x"084A", x"033C",
        x"FF17", x"FC5F", x"FB45", x"FBA5", x"FD17", x"FF0D", x"00F3", x"0250",
        x"02E0", x"0296", x"0199", x"0035", x"FEC2", x"FD8F", x"FCD0", x"FC98",
        x"FCDB", x"FD73", x"FE3A", x"FE99", x"FFE7"
    );
    
    constant MULT_WIDTH : integer := INPUT_WIDTH+COEF_WIDTH;
   
    -- input buffer
    type in_registers is array (0 to NUM_TAPS-1) of signed(INPUT_WIDTH-1 downto 0);
    signal ireg_s : in_registers := (others => (others => '0'));
    
    -- multiplier
    type mult_registers is array (0 to NUM_TAPS-1) of signed(MULT_WIDTH-1 downto 0);
    signal mreg_s : mult_registers := (others => (others => '0'));
    
    -- accumulator
    type acc_registers is array (0 to NUM_TAPS-1) of signed(MULT_WIDTH-1 downto 0);
    signal areg_s : acc_registers := (others => (others => '0'));
    
begin

    process(clk)
    begin
        if rising_edge(clk) then
            
            
            if (reset = '1') then
                for i in 0 to NUM_TAPS-1 loop
                    ireg_s(i) <= (others => '0');
                    mreg_s(i) <= (others => '0');
                    areg_s(i) <= (others => '0');
                end loop;
            else
                -- start shift
                ireg_s(0) <= signed(data_i);
                
                for i in 1 to NUM_TAPS-1 loop
                    ireg_s(i) <= ireg_s(i-1);
                    
                    
                    
                end loop;
            end if;
        end if; 
    end process;
  
end rtl;