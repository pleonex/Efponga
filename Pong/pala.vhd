LIBRARY IEEE;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY pala IS
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
END pala;

ARCHITECTURE funcional OF pala IS
  -- Constantes de la pantalla
  CONSTANT PANTALLA_ANCHO : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(640, 10);
  CONSTANT PANTALLA_ALTO  : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(480, 10);

  -- Constantes de tamaño y movimiento
  CONSTANT SIZE_X    : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(10, 10);
  CONSTANT SIZE_Y    : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50, 10);
  CONSTANT VELO_POSI : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(4, 10);
  CONSTANT VELO_NEGA : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(-4, 10);

  -- Variables de movimiento
  CONSTANT POS_X    : STD_LOGIC_VECTOR(9 DOWNTO 0) := DEFAULT_POS_X;
  SIGNAL pos_y      : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(240, 10);
  SIGNAL velo_y     : STD_LOGIC_VECTOR(9 DOWNTO 0);

  -- Variables de dibujo
  SIGNAL red_data   : STD_LOGIC;
  SIGNAL green_data : STD_LOGIC;
  SIGNAL blue_data  : STD_LOGIC;
  
  BEGIN
    Red   <= red_data;
    Green <= green_data;
    Blue  <= blue_data;

    --------------------------------
    -- Proceso para determinar si --
    -- se ha de pintar la pala.   --
    --------------------------------
    PintaPala: PROCESS (pos_y, pixel_column, pixel_row)
      BEGIN
        -- Comprueba que el pixel a pintar es de la pala
        IF (pixel_column + SIZE_X >= POS_X) AND (pixel_column <= POS_X + SIZE_X) AND
           (pixel_row    + SIZE_Y >= pos_y) AND (pixel_row    <= pos_y + SIZE_Y) THEN
          red_data   <= '1';
          green_data <= '0';
          blue_data  <= '0';
        ELSE
          red_data   <= '0';
          green_data <= '0';
          blue_data  <= '0';
        END IF;
    END process PintaPala;

    --------------------------------
    -- Proceso para mover la      --
    -- pala.                      --
    --------------------------------
    MuevePala: PROCESS (vert_sync)
      BEGIN
        -- Mover la pala cada vert_sync
        IF vert_sync'EVENT AND vert_sync = '1' THEN
          
          -- Detectar los bordes superior e inferior de la pantalla
          IF pos_y <= SIZE_Y and btn_up = '1' THEN
            velo_y <= CONV_STD_LOGIC_VECTOR(0, 10);
          ELSIF (pos_y >= PANTALLA_ALTO - SIZE_Y) and btn_down = '1' THEN
            velo_y <= CONV_STD_LOGIC_VECTOR(0, 10);
            
          -- Detecta si se ha pulsado una tecla
          ELSIF btn_up = '0' THEN
            velo_y <= VELO_POSI;
          ELSIF btn_down = '0' THEN
            velo_y <= VELO_NEGA;
          
          ELSE
            velo_y <= CONV_STD_LOGIC_VECTOR(0, 10);
          END IF;
          
          -- Calcular la siguiente posicion de la bola
          pos_y <= pos_y + velo_y;
        END IF;
    END PROCESS MuevePala;
    
    ReboteBola: PROCESS (bola_x, bola_y, bola_size_x, bola_size_y, pos_y)
      BEGIN
        IF (bola_x <= POS_X + SIZE_X + bola_size_x) and
           (bola_x + SIZE_X >= POS_X + bola_size_x) and
           (bola_y <= pos_y + SIZE_Y + bola_size_y) and
           (pos_y  <= bola_y + bola_size_y + SIZE_Y) THEN
          rebote <= '1';
        ELSIF (bola_x + bola_size_x + SIZE_X >= POS_X) and
              (bola_x + bola_size_x <= POS_X + SIZE_X) and
              (bola_y <= pos_y + SIZE_Y + bola_size_y) and
              (pos_y  <= bola_y + bola_size_y + SIZE_Y) THEN
          rebote <= '1';
        ELSE
          rebote <= '0';
        END IF;
    END PROCESS ReboteBola;
END funcional;