-------------------------------------------------------------------------------
-- Listing 13.3
-- Code modified from https://academic.csuohio.edu/chu_p/rtl/fpga_vhdl.html
-- Updated 12/2/2020 by Kent Jones
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity font_test_top is
  port (
    -- System Clock  
    CLK100MHZ : in std_logic;

    -- vga inputs and outputs
    Hsync, Vsync : out std_logic; -- Horizontal and Vertical Synch
    vgaRed       : out std_logic_vector(3 downto 0); -- Red bits
    vgaGreen     : out std_logic_vector(3 downto 0); -- Green bits
    vgaBlue      : out std_logic_vector(3 downto 0); -- Blue bits   
    
    -- switches and LEDs     
    btnC : in std_logic;
    btnU : in std_logic;
    btnL : in std_logic;
    btnR : in std_logic;
    btnD : in std_logic;
    an   : out std_logic_vector(3 downto 0);
    sw   : in std_logic_vector (15 downto 0); -- 16 switch inputs
    LED  : out std_logic_vector (15 downto 0); -- 16 leds above switches
    seg  : out std_logic_vector(6 downto 0); -- 6 leds per display
    dp   : out std_logic -- 1 decimal point per display
  );
end font_test_top;

architecture font_test_top of font_test_top is
  signal clk, reset           : std_logic;
  signal pixel_x, pixel_y     : std_logic_vector(9 downto 0);
  signal video_on, pixel_tick : std_logic;
  signal rgb_reg, rgb_text    : std_logic_vector(2 downto 0);
  signal imageHolder : std_logic_vector(6 downto 0):= "0000000"; --made a register that hold the Rom address for the outputted image15 downto 0); -- 16 leds above switches
    -- declares the different states of our fsm
    type statetype is (S0, S1);
    signal state, nextstate : statetype;
    signal counter : integer range 0 to 3;
    signal a : std_logic;
begin
  -- wire up the clk, reset and LEDs
  -- the switches could be used to modify
  -- the rgb signal
  clk   <= CLK100MHZ; -- system clock
  reset <= btnC; -- reset signal for vga driver
  LED   <= sw; -- drive LED's from switches
  

  -- instantiate VGA sync circuit
  vga_sync_unit : entity work.vga_sync
    port map(
      clk => clk, reset => reset, hsync => Hsync,
      vsync => Vsync, video_on => video_on,
      pixel_x => pixel_x, pixel_y => pixel_y,
      p_tick => pixel_tick
    );

  font_gen_unit : entity work.font_test_gen
    port map(
      clk => clk, video_on => video_on,
      char_num => imageHolder,--changing this resulted in big errors
      pixel_x => pixel_x, pixel_y => pixel_y,
      rgb_text => rgb_text
    );

  -- rgb buffer
  process (clk)
  begin
    if rising_edge(clk) then
      if (pixel_tick = '1') then
        rgb_reg <= rgb_text;
      end if;
    end if;
  end process;

  -- build the RGB colors from the rgb_reg
  vgaRed <= rgb_reg(2) & rgb_reg(2) & rgb_reg(2) & rgb_reg(2);
  vgaGreen <= rgb_reg(1) & rgb_reg(1) & rgb_reg(1) & rgb_reg(1);
  vgaBlue <= rgb_reg(0) & rgb_reg(0) & rgb_reg(0) & rgb_reg(0);
 --
  sync : entity work.synchro port map( 
    clk => clk,
    d => btnD,
    q => a
  );
  --refernece from kent jones ic_25 ex_b Scynchroized moore
  -- next state combinational logic
  process (nextstate, a, state)
  begin
    case state is
      when S0 =>
        if a = '0' 
        then nextstate <= S0;
        else nextstate <= S1;
        end if;
      when S1 =>
        if a = '1' 
        then nextstate <= S1;
        else nextstate <= S0;
        end if;
      when others =>
        nextstate <= S0;
    end case;
  end process;


  process (clk, reset) begin  --kent jones's patternmoors.vhd
    if reset = '1' then
      state <= S0;
    elsif rising_edge(clk) then
      state <= nextstate;
    end if;
  end process;
  --only want to increment the counter when we are going to nextstate, otherwise keep its valeue
  counter <= counter + 1 when state = S0 and nextstate = S1 else counter;
  imageHolder(1 downto 0) <= std_logic_vector(to_unsigned(counter, 2));


    -- Turn off the 7-segment LEDs
    an  <= "1111"; -- wires supplying power to 4 7-seg displays
    seg <= "1111111"; -- wires connecting each of 7 * 4 segments to ground
    dp  <= '1'; -- wire connects decimal point to ground    
end font_test_top;
