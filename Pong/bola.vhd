LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
LIBRARY lpm;
USE lpm.lpm_components.ALL;

ENTITY bola IS
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
END bola;

ARCHITECTURE funcional OF bola IS
  -- Constantes de la pantalla
  CONSTANT PANTALLA_ANCHO : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(640, 10);
  CONSTANT PANTALLA_ALTO  : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(480, 10);

  -- Constantes y variables de movimiento
  CONSTANT SIZE      : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(8, 10);
  CONSTANT VELO_POSI : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(2, 10);
  CONSTANT VELO_NEGA : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(-2, 10);

  SIGNAL velo_x : STD_LOGIC_VECTOR(9 DOWNTO 0) := VELO_POSI;
  SIGNAL velo_y : STD_LOGIC_VECTOR(9 DOWNTO 0) := VELO_NEGA;
  SIGNAL pos_x  : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(320, 10);
  SIGNAL pos_y  : STD_LOGIC_VECTOR(9 DOWNTO 0);

  SIGNAL red_data   : STD_LOGIC;
  SIGNAL green_data : STD_LOGIC;
  SIGNAL blue_data  : STD_LOGIC;
  SIGNAL estado1    : STD_LOGIC := '0';
  SIGNAL estado2    : STD_LOGIC := '0';

  BEGIN
    Red		<= red_data;
    Green	<= green_data;
    Blue	<= blue_data;
    
    bola_x <= pos_x;
    bola_y <= pos_y;
    bola_size_x <= Size;
    bola_size_y <= Size;
    
    gol1 <= estado1;
    gol2 <= estado2;

    --------------------------------
    -- Proceso para determinar si --
    -- se ha de pintar la pelota. --
    --------------------------------
    PintaBola: PROCESS (pos_X, pos_Y, pixel_column, pixel_row)
      BEGIN
        -- Comprueba que el pixel a pintar es de la pelota
        IF (pixel_column + SIZE >= pos_x) AND (pixel_column <= pos_x + SIZE) AND
           (pixel_row    + SIZE >= pos_y) AND (pixel_row    <= pos_y + SIZE) THEN
          red_data   <= '1';
          green_data <= '1';
          blue_data  <= '1';
        ELSE
          red_data   <= '0';
          green_data <= '0';
          blue_data  <= '0';
        END IF;
      END process PintaBola;

    --------------------------------
    -- Proceso para mover la      --
    -- pelota.                    --
    --------------------------------
    MueveBola: PROCESS (vert_sync)
      BEGIN
      -- Mover la bola cada vert_sync
      IF VERT_SYNC'EVENT AND vert_sync = '1' THEN
        -- Detectar los bordes superior e inferior de la pantalla
        IF pos_y <= SIZE or pos_y >= CONV_STD_LOGIC_VECTOR(1000, 10) THEN
          velo_y <= VELO_POSI;
        ELSIF pos_y >= CONV_STD_LOGIC_VECTOR(480, 10) - SIZE THEN
          velo_y <= VELO_NEGA;
        END IF;
        
        -- Detectar los bordes laterales
        IF pos_x <= SIZE + CONV_STD_LOGIC_VECTOR(5, 10) or pos_x >= CONV_STD_LOGIC_VECTOR(1000, 10) THEN
          estado1 <= '1';
        ELSIF rebote_xDer = '1' THEN
          velo_x <= VELO_POSI;
        ELSIF rebote_xIzq = '1' THEN
		  velo_x <= VELO_NEGA;
        ELSIF pos_x >= CONV_STD_LOGIC_VECTOR(640, 10) - SIZE - CONV_STD_LOGIC_VECTOR(5, 10) THEN
          estado2 <= '1';
        --ELSIF rebote_y = '1' THEN
        --  velo_x <= VELO_NEGA;
        ELSE
		      estado1 <= '0';
		      estado2 <= '0';
        END IF;
        
        -- Calcular la siguiente posicion de la bola
        IF estado1 = '0' and estado2 = '0' THEN
          pos_y <= pos_y + velo_y;
          pos_x <= pos_x + velo_x;
        ELSE
          pos_x <= CONV_STD_LOGIC_VECTOR(320, 10);
        END IF;
    END IF;
  END process MueveBola;
END funcional;
