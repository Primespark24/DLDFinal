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
    sw   : in std_logic_vector (15 downto 0); -- 16 switch inputs
    LED  : out std_logic_vector (15 downto 0); -- 16 leds above switches
    an   : out std_logic_vector (3 downto 0); -- Controls four 7-seg displays
    seg  : out std_logic_vector(6 downto 0); -- 6 leds per display
    dp   : out std_logic -- 1 decimal point per display
  );
end font_test_top;

architecture font_test_top of font_test_top is
  signal clk, reset           : std_logic;
  signal pixel_x, pixel_y     : std_logic_vector(9 downto 0);
  signal video_on, pixel_tick : std_logic;
  signal rgb_reg, rgb_text    : std_logic_vector(2 downto 0);
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

  -- instantiate font ROM control character to look up 
  -- by the switches
  font_gen_unit : entity work.font_test_gen
    port map(
      clk => clk, video_on => video_on,
      char_num => sw(6 downto 0),
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

end font_test_top;
