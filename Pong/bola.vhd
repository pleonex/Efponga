LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
LIBRARY lpm;
USE lpm.lpm_components.ALL;

ENTITY bola IS
  PORT(
    vert_sync    : IN  STD_LOGIC;
    pixel_row    : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
    pixel_column : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
    up           : IN  STD_LOGIC;
    down         : IN  STD_LOGIC;
    up2          : IN  STD_LOGIC;
    down2        : IN  STD_LOGIC;
    Red          : OUT STD_LOGIC;
    Green        : OUT STD_LOGIC;
    Blue         : OUT STD_LOGIC
  );
END bola;

ARCHITECTURE funcional OF bola IS
  -- Constantes de la pantalla
  CONSTANT Pantalla_Ancho : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(640, 10);
  CONSTANT Pantalla_Alto  : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(480, 10);

  -- Constantes y variables para la pala
  CONSTANT Pala_Size_X    : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(10, 10);
  CONSTANT Pala_Size_Y    : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50, 10);
  CONSTANT Pala_Velo_Posi : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(4, 10);
  CONSTANT Pala_Velo_Nega : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(-4, 10);

  SIGNAL pala_on_r        : STD_LOGIC; -- Usado para indicar el color de la bola, si se ha de mostrar o no
  SIGNAL pala_on_g        : STD_LOGIC;
  SIGNAL pala_on_b        : STD_LOGIC;
  SIGNAL pala_velocidad_X : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL pala_velocidad_Y : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL pala_pos_X       : STD_LOGIC_VECTOR(9 DOWNTO 0) := Pala_Size_X;
  SIGNAL pala_pos_Y       : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(240, 10);

  -- Constantes y variables para la pala
  CONSTANT Pala2_Size_X    : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(10, 10);
  CONSTANT Pala2_Size_Y    : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50, 10);
  CONSTANT Pala2_Velo_Posi : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(4, 10);
  CONSTANT Pala2_Velo_Nega : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(-4, 10);

  SIGNAL pala2_on          : STD_LOGIC; -- Usado para indicar el color de la bola, si se ha de mostrar o no
  SIGNAL pala2_velocidad_X : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL pala2_velocidad_Y : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL pala2_pos_X       : STD_LOGIC_VECTOR(9 DOWNTO 0) := Pantalla_Ancho - Pala2_Size_X;
  SIGNAL pala2_pos_Y       : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(240, 10);

  -- Constantes y variables para la bola
  CONSTANT Size      : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(8, 10);
  CONSTANT Velo_Posi : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(6, 10);
  CONSTANT Velo_Nega : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(-6, 10);

  SIGNAL pelota_on   : STD_LOGIC; -- Usado para indicar el color de la bola, si se ha de mostrar o no
  SIGNAL velocidad_X : STD_LOGIC_VECTOR(9 DOWNTO 0) := Velo_Posi;
  SIGNAL velocidad_Y : STD_LOGIC_VECTOR(9 DOWNTO 0) := Velo_Posi;
  SIGNAL pos_X       : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(320, 10);
  SIGNAL pos_Y       : STD_LOGIC_VECTOR(9 DOWNTO 0);

  SIGNAL estado : STD_LOGIC := '0';

  BEGIN
    Red		<= pelota_on or pala_on_r or pala2_on;
    Green	<= pelota_on or pala_on_g or pala2_on;
    Blue	<= pelota_on or pala_on_b or pala2_on;

    --------------------------------
    -- Proceso para determinar si --
    -- se ha de pintar la pelota. --
    --------------------------------
    PintaBola: PROCESS (pos_X, pos_Y, pixel_column, pixel_row)
      BEGIN
        -- Comprueba que el pixel a pintar es de la pelota
        IF (pixel_column + Size >= pos_X) AND (pixel_column <= pos_X + Size) AND
           (pixel_row    + Size >= pos_Y) AND (pixel_row    <= pos_y + Size) THEN
          pelota_on <= '1';
        ELSE
          pelota_on <= '0';
        END IF;
      END process PintaBola;

    --------------------------------
    -- Proceso para determinar si --
    -- se ha de pintar la pala.   --
    --------------------------------
    PintaPala: PROCESS (pala_pos_X, pala_pos_Y, pixel_column, pixel_row)
      BEGIN
        -- Comprueba que el pixel a pintar es de la pala
        IF (pixel_column + Pala_Size_X >= pala_pos_X) AND (pixel_column <= pala_pos_X + Pala_Size_X) AND
           (pixel_row    + Pala_Size_Y >= pala_pos_Y) AND (pixel_row    <= pala_pos_y + Pala_Size_Y) THEN
          pala_on_r <= '1';
          pala_on_g <= '0';
          pala_on_b <= '0';
        ELSE
          pala_on_r <= '0';
          pala_on_g <= '0';
          pala_on_b <= '0';
        END IF;
      END process PintaPala;
      
    --------------------------------
    -- Proceso para determinar si --
    -- se ha de pintar la pala.   --
    --------------------------------
    PintaPala2: PROCESS (pala2_pos_X, pala2_pos_Y, pixel_column, pixel_row)
      BEGIN
        -- Comprueba que el pixel a pintar es de la pala
        IF (pixel_column + Pala2_Size_X >= pala2_pos_X) AND (pixel_column <= pala2_pos_X + Pala2_Size_X) AND
           (pixel_row    + Pala2_Size_Y >= pala2_pos_Y) AND (pixel_row    <= pala2_pos_y + Pala2_Size_Y) THEN
          pala2_on <= '1';
        ELSE
          pala2_on <= '0';
        END IF;
      END process PintaPala2;

    --------------------------------
    -- Proceso para mover la      --
    -- pelota.                    --
    --------------------------------
    MueveBola: PROCESS (vert_sync)
      BEGIN
      -- Mover la bola cada vert_sync
      IF VERT_SYNC'EVENT AND vert_sync = '1' THEN
        -- Detectar los bordes superior e inferior de la pantalla
        IF pos_Y <= Size or pos_Y >= CONV_STD_LOGIC_VECTOR(1000, 10) THEN
          velocidad_Y <= Velo_Posi;
        ELSIF pos_Y >= CONV_STD_LOGIC_VECTOR(480, 10) - Size THEN
          velocidad_Y <= Velo_Nega;
        END IF;
        
        -- Detectar los bordes laterales
        IF pos_X <= Size or pos_X >= CONV_STD_LOGIC_VECTOR(1000, 10) THEN
		  estado <= '1';
		ELSIF (pos_X <= pala_pos_X + Pala_Size_X + Size) and (pos_Y <= pala_pos_Y + Pala_Size_Y + Size and pos_Y + Size + Pala_Size_Y >= pala_pos_Y) THEN
	      velocidad_X <= Velo_Posi;
        ELSIF pos_X >= CONV_STD_LOGIC_VECTOR(640, 10) - Size THEN
          estado <= '1';
        ELSIF (pos_X + Size + Pala2_Size_X >= pala2_pos_X) and (pos_Y <= pala2_pos_Y + Pala2_Size_Y + Size and pos_Y + Size + Pala2_Size_Y >= pala2_pos_Y) THEN
          velocidad_X <= Velo_Nega;
        ELSE
		  estado <= '0';
        END IF;
        
        -- Calcular la siguiente posicion de la bola
        IF estado = '0' THEN
          pos_Y <= pos_Y + velocidad_Y;
          pos_X <= pos_X + velocidad_X;
        ELSE
          pos_X <= CONV_STD_LOGIC_VECTOR(320, 10);
        END IF;
    END IF;
  END process MueveBola;
  
    --------------------------------
    -- Proceso para mover la      --
    -- pala.                      --
    --------------------------------
    MuevePala: PROCESS (vert_sync)
      BEGIN
      -- Mover la pala cada vert_sync
      IF VERT_SYNC'EVENT AND vert_sync = '1' THEN
        -- Detecta si se ha pulsado una tecla
        IF up = '0' THEN
	      pala_velocidad_Y <= Pala_Velo_Posi;
	    ELSIF down = '0' THEN
          pala_velocidad_Y <= Pala_Velo_Nega;
        ELSE
          pala_velocidad_Y <= CONV_STD_LOGIC_VECTOR(0, 10);
        END IF;
    
        -- Detectar los bordes superior e inferior de la pantalla
        IF pala_pos_Y <= Pala_Size_Y and up = '1' THEN
          pala_velocidad_Y <= CONV_STD_LOGIC_VECTOR(0, 10);
        ELSIF (pala_pos_Y >= CONV_STD_LOGIC_VECTOR(480, 10) - Pala_Size_Y) and down = '1' THEN
          pala_velocidad_Y <= CONV_STD_LOGIC_VECTOR(0, 10);
        END IF;
        
        -- Detectar los bordes laterales
        --IF pala_pos_X <= Pala_Size_X or pala_pos_X >= CONV_STD_LOGIC_VECTOR(1000, 10) THEN
        --  pala_velocidad_X <= Velo_Posi;
        --ELSIF pala_pos_X >= CONV_STD_LOGIC_VECTOR(640, 10) - Pala_Size_X THEN
        --  pala_velocidad_X <= Velo_Nega;         
        --END IF;
        
        -- Calcular la siguiente posicion de la bola
        pala_pos_Y <= pala_pos_Y + pala_velocidad_Y;
        pala_pos_X <= pala_pos_X + pala_velocidad_X;
      END IF;
    END process MuevePala;
  
    --------------------------------
    -- Proceso para mover la      --
    -- pala.                      --
    --------------------------------
    MuevePala2: PROCESS (vert_sync)
      BEGIN
      -- Mover la pala cada vert_sync
      IF VERT_SYNC'EVENT AND vert_sync = '1' THEN
        -- Detecta si se ha pulsado una tecla
        IF up2 = '0' THEN
	        pala2_velocidad_Y <= Pala2_Velo_Posi;
	    ELSIF down2 = '0' THEN
          pala2_velocidad_Y <= Pala2_Velo_Nega;
        ELSE
          pala2_velocidad_Y <= CONV_STD_LOGIC_VECTOR(0, 10);
        END IF;
    
        -- Detectar los bordes superior e inferior de la pantalla
        IF (pala2_pos_Y <= Pala2_Size_Y or pala2_pos_Y >= CONV_STD_LOGIC_VECTOR(1000, 10)) and up2 = '1' THEN
          pala2_velocidad_Y <= CONV_STD_LOGIC_VECTOR(0, 10);
        ELSIF (pala2_pos_Y >= CONV_STD_LOGIC_VECTOR(480, 10) - Pala2_Size_Y) and down2 = '1' THEN
          pala2_velocidad_Y <= CONV_STD_LOGIC_VECTOR(0, 10);
        END IF;
        
        -- Detectar los bordes laterales
        --IF pala2_pos_X <= Pala2_Size_X or pala_pos_X >= CONV_STD_LOGIC_VECTOR(1000, 10) THEN
        --  pala_velocidad_X <= Velo_Posi;
        --ELSIF pala_pos_X >= CONV_STD_LOGIC_VECTOR(640, 10) - Pala_Size_X THEN
        --  pala_velocidad_X <= Velo_Nega;         
        --END IF;
        
        -- Calcular la siguiente posicion de la bola
        pala2_pos_Y <= pala2_pos_Y + pala2_velocidad_Y;
        pala2_pos_X <= pala2_pos_X + pala2_velocidad_X;
    END IF;
  END process MuevePala2;
END funcional;
