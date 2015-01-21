LIBRARY IEEE;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
--USE IEEE.NUMERIC_STD.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY escenario IS
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
END escenario;

ARCHITECTURE funcional OF escenario IS
  -- Pelota de juego
  COMPONENT bola 
    PORT(
      -- Variables de dibujado
      vert_sync    : IN  STD_LOGIC;
      pixel_row    : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
      pixel_column : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
      Red          : OUT STD_LOGIC;
      Green        : OUT STD_LOGIC;
      Blue         : OUT STD_LOGIC;
      
      -- Control de bola
      bola_x       : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      bola_y       : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      bola_size_x  : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      bola_size_y  : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      rebote_xIzq  : IN  STD_LOGIC;
      rebote_xDer  : IN  STD_LOGIC;
      rebote_y     : IN  STD_LOGIC;
      
      gol1         : OUT STD_LOGIC;
      gol2         : OUT STD_LOGIC
		);
  END COMPONENT;

  -- Pala de juego
  COMPONENT pala
    GENERIC (
      DEFAULT_POS_X : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(0, 10)
    );
  
    PORT (
      -- Puertos para dibujado
      vert_sync    : IN  STD_LOGIC;
      pixel_row    : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
      pixel_column : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
      Red          : OUT STD_LOGIC;
      Green        : OUT STD_LOGIC;
      Blue         : OUT STD_LOGIC;
      
      -- Botones de control
      btn_up       : IN  STD_LOGIC;
      btn_down     : IN  STD_LOGIC;
      
      -- Control de rebotes de bola
      bola_x       : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
      bola_y       : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
      bola_size_x  : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
      bola_size_y  : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
      rebote       : OUT STD_LOGIC
    );
  END COMPONENT;

  -- Marcador
  COMPONENT marcador
    PORT (
      numero : IN  UNSIGNED(3 DOWNTO 0);
    
      hex0   : OUT STD_LOGIC;
      hex1   : OUT STD_LOGIC;
      hex2   : OUT STD_LOGIC;
      hex3   : OUT STD_LOGIC;
      hex4   : OUT STD_LOGIC;
      hex5   : OUT STD_LOGIC;
      hex6   : OUT STD_LOGIC
    );
  END COMPONENT;

  -- Constantes de la pantalla
  CONSTANT PANTALLA_ANCHO : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(640, 10);
  CONSTANT PANTALLA_ALTO  : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(480, 10);

  -- Variables
  SIGNAL red_bola,   red_palaIzq,   red_palaDer   : STD_LOGIC;
  SIGNAL green_bola, green_palaIzq, green_palaDer : STD_LOGIC;
  SIGNAL blue_bola,  blue_palaIzq,  blue_palaDer  : STD_LOGIC;
  
  SIGNAL bola_x, bola_y, bola_size_x, bola_size_y : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL rebote_palaIzq, rebote_palaDer           : STD_LOGIC;
  
  SIGNAL contador1 : UNSIGNED(3 DOWNTO 0);
  SIGNAL contador2 : UNSIGNED(3 DOWNTO 0);
  SIGNAL gol1      : STD_LOGIC;
  SIGNAL gol2      : STD_LOGIC;

  BEGIN
    Red   <= red_bola   or red_palaIzq   or red_palaDer;
    Green <= green_bola or green_palaIzq or green_palaDer;
    Blue  <= blue_bola  or blue_palaIzq  or blue_palaDer;
  
	PROCESS (vert_sync)
		BEGIN
			IF (vert_sync'event AND vert_sync = '1') THEN
				-- FIX: Arreglar fallo de doble detección de borde
				contador1 <= contador1 + gol1;
				contador2 <= contador2 + gol2;
			END IF;
	END PROCESS;
  
    PELOTA: bola
    PORT MAP (
      vert_sync    => vert_sync,
      pixel_row    => pixel_row,
      pixel_column => pixel_column,
      Red          => red_bola,
      Green        => green_bola,
      Blue         => blue_bola,
      
      bola_x       => bola_x,
      bola_y       => bola_y,
      bola_size_x  => bola_size_x,
      bola_size_y  => bola_size_y,
      rebote_xIzq  => rebote_palaDer,
      rebote_xDer  => rebote_palaIzq,
      rebote_y     => '0',
      gol1         => gol1,
      gol2         => gol2
    );
    
    PALA_IZQ: pala 
    GENERIC MAP (
      DEFAULT_POS_X => CONV_STD_LOGIC_VECTOR(10, 10)
    )
    PORT MAP (
      vert_sync    => vert_sync,
      pixel_row    => pixel_row,
      pixel_column => pixel_column,
      Red          => red_palaIzq,
      Green        => green_palaIzq,
      Blue         => blue_palaIzq,
      
      btn_up       => btn_up1,
      btn_down     => btn_down1,
      
      bola_x       => bola_x,
      bola_y       => bola_y,
      bola_size_x  => bola_size_x,
      bola_size_y  => bola_size_y,
      rebote       => rebote_palaIzq
    );
    
    PALA_DER: pala
    GENERIC MAP (
      DEFAULT_POS_X => PANTALLA_ANCHO - CONV_STD_LOGIC_VECTOR(10, 10)
    )
    PORT MAP (
      vert_sync    => vert_sync,
      pixel_row    => pixel_row,
      pixel_column => pixel_column,
      Red          => red_palaDer,
      Green        => green_palaDer,
      Blue         => blue_palaDer,
      
      btn_up       => btn_up2,
      btn_down     => btn_down2,
      
      bola_x       => bola_x,
      bola_y       => bola_y,
      bola_size_x  => bola_size_x,
      bola_size_y  => bola_size_y,
      rebote       => rebote_palaDer
    );
    
    MARCADOR1: marcador
    PORT MAP (
      numero => contador1,
      hex0   => hex00,
      hex1   => hex01,
      hex2   => hex02,
      hex3   => hex03,
      hex4   => hex04,
      hex5   => hex05,
      hex6   => hex06
    );
    
    MARCADOR2: marcador
    PORT MAP (
      numero => contador2,
      hex0   => hex20,
      hex1   => hex21,
      hex2   => hex22,
      hex3   => hex23,
      hex4   => hex24,
      hex5   => hex25,
      hex6   => hex26
    );
    
END funcional;