LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
LIBRARY lpm;
USE lpm.lpm_components.ALL;

ENTITY pong IS
  PORT(	
    clock     : IN  STD_LOGIC;
    
    -- Puertos VGA
    vga_red   : OUT STD_LOGIC;
    vga_green : OUT STD_LOGIC;
    vga_blue  : OUT STD_LOGIC;
    vga_blank : OUT STD_LOGIC;
    vga_hs    : OUT STD_LOGIC;
    vga_vs    : OUT STD_LOGIC;
    vga_clk   : OUT STD_LOGIC;
    
    -- Controles de juego
    btn_up1    : IN  STD_LOGIC;
    btn_down1  : IN  STD_LOGIC;
    btn_up2    : IN  STD_LOGIC;
    btn_down2  : IN  STD_LOGIC;
    
    -- Marcados de 7 segmentos
    hex00      : OUT STD_LOGIC;
    hex01      : OUT STD_LOGIC;
    hex02      : OUT STD_LOGIC;
    hex03      : OUT STD_LOGIC;
    hex04      : OUT STD_LOGIC;
    hex05      : OUT STD_LOGIC;
    hex06      : OUT STD_LOGIC;
     
    hex20      : OUT STD_LOGIC;
    hex21      : OUT STD_LOGIC;
    hex22      : OUT STD_LOGIC;
    hex23      : OUT STD_LOGIC;
    hex24      : OUT STD_LOGIC;
    hex25      : OUT STD_LOGIC;
    hex26      : OUT STD_LOGIC
  );
END pong;

ARCHITECTURE funcional OF pong IS
  -- Escenario
  COMPONENT escenario
    PORT (
      vert_sync    : IN  STD_LOGIC;
      pixel_row    : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
      pixel_column : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
      Red          : OUT STD_LOGIC;
      Green        : OUT STD_LOGIC;
      Blue         : OUT STD_LOGIC;
      
      -- Controles del juego
      btn_up1      : IN  STD_LOGIC;
      btn_down1    : IN  STD_LOGIC;
      btn_up2      : IN  STD_LOGIC;
      btn_down2    : IN  STD_LOGIC;
      
      -- Marcados de 7 segmentos
      hex00        : OUT STD_LOGIC;
      hex01        : OUT STD_LOGIC;
      hex02        : OUT STD_LOGIC;
      hex03        : OUT STD_LOGIC;
      hex04        : OUT STD_LOGIC;
      hex05        : OUT STD_LOGIC;
      hex06        : OUT STD_LOGIC;
       
      hex20        : OUT STD_LOGIC;
      hex21        : OUT STD_LOGIC;
      hex22        : OUT STD_LOGIC;
      hex23        : OUT STD_LOGIC;
      hex24        : OUT STD_LOGIC;
      hex25        : OUT STD_LOGIC;
      hex26        : OUT STD_LOGIC
    );
  END COMPONENT;
  
  -- PLL para adaptar reloj (50 MHz -> 25 MHz)
  COMPONENT vga_PLL
    PORT(
      inclk0  : IN  STD_LOGIC := '0';
      c0		  : OUT STD_LOGIC
    );
  END COMPONENT;
	
  -- Controlador de VGA
  COMPONENT vga_sync
    PORT(	
      clock_25Mhz   : IN  STD_LOGIC;
      red           : IN  STD_LOGIC;
      green         : IN  STD_LOGIC;
      blue	        : IN  STD_LOGIC;
      vga_red       : OUT STD_LOGIC;
      vga_green     : OUT STD_LOGIC;
      vga_blue      : OUT STD_LOGIC;
      vga_blank     : OUT STD_LOGIC;
      vga_hs        : OUT STD_LOGIC;
      vga_vs        : OUT STD_LOGIC;
      vga_clk       : OUT STD_LOGIC;
      pixel_row     : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      pixel_column  : OUT	STD_LOGIC_VECTOR(9 DOWNTO 0)
    );		
  END COMPONENT;

  -- Variables
  SIGNAL clock_25MHz : STD_LOGIC;
  SIGNAL Red_Data    : STD_LOGIC;
  SIGNAL Green_Data  : STD_LOGIC;
  SIGNAL Blue_Data   : STD_LOGIC;
  SIGNAL vert_sync   : STD_LOGIC;
  SIGNAL pixel_col   : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL pixel_row	 : STD_LOGIC_VECTOR(9 DOWNTO 0);

  BEGIN
    vga_vs <= vert_sync;

    -- Conexión de componentes
    PLL: vga_pll PORT MAP (
      inclk0 => clock,
      c0     => clock_25Mhz
    );
		
    SYNC: VGA_SYNC PORT MAP (	
      clock_25Mhz  => clock_25MHz,
      red          => red_data,
      green        => green_data,
      blue         => blue_data,	
      vga_red      => vga_red,
      vga_green    => vga_green,
      vga_blue     => vga_blue,
      vga_blank    => vga_blank,
      vga_hs       => vga_hs, 
      vga_vs       => vert_sync, 
      vga_clk      => vga_clk,
      pixel_row    => pixel_row, 
      pixel_column => pixel_col
    );			

    ESCE: escenario PORT MAP (
      Red          => red_data,
      Green        => green_data,
      Blue         => blue_data,
      vert_sync    => vert_sync,
      pixel_row    => pixel_row,
      pixel_column => pixel_col,
      
      btn_up1      => btn_up1,
      btn_down1    => btn_down1,
      btn_up2      => btn_up2,
      btn_down2    => btn_down2,
      
      hex00        => hex00,
      hex01        => hex01,
      hex02        => hex02,
      hex03        => hex03,
      hex04        => hex04,
      hex05        => hex05,
      hex06        => hex06,
      
      hex20        => hex20,
      hex21        => hex21,
      hex22        => hex22,
      hex23        => hex23,
      hex24        => hex24,
      hex25        => hex25,
      hex26        => hex26
    );
END funcional;