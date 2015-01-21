LIBRARY IEEE;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY marcador IS
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
END marcador;

ARCHITECTURE funcional OF marcador IS 
  BEGIN
    PROCESS (numero)
      BEGIN
        CASE numero IS
          WHEN x"0" =>
            hex0 <= '0';
            hex1 <= '0';
            hex2 <= '0';
            hex3 <= '0';
            hex4 <= '0';
            hex5 <= '0';
            hex6 <= '1';
            
          WHEN x"1" =>
            hex0 <= '1';
            hex1 <= '0';
            hex2 <= '0';
            hex3 <= '1';
            hex4 <= '1';
            hex5 <= '1';
            hex6 <= '1';
            
          WHEN x"2" =>
            hex0 <= '0';
            hex1 <= '0';
            hex2 <= '1';
            hex3 <= '0';
            hex4 <= '0';
            hex5 <= '1';
            hex6 <= '0';
            
          WHEN x"3" =>
            hex0 <= '0';
            hex1 <= '0';
            hex2 <= '0';
            hex3 <= '0';
            hex4 <= '1';
            hex5 <= '1';
            hex6 <= '0';
            
          WHEN x"4" =>
            hex0 <= '0';
            hex1 <= '1';
            hex2 <= '0';
            hex3 <= '1';
            hex4 <= '1';
            hex5 <= '0';
            hex6 <= '0';
            
          WHEN x"5" =>
            hex0 <= '0';
            hex1 <= '1';
            hex2 <= '0';
            hex3 <= '0';
            hex4 <= '1';
            hex5 <= '0';
            hex6 <= '0';
            
          WHEN x"6" =>
            hex0 <= '0';
            hex1 <= '1';
            hex2 <= '0';
            hex3 <= '0';
            hex4 <= '0';
            hex5 <= '0';
            hex6 <= '0';
            
          WHEN x"7" =>
            hex0 <= '0';
            hex1 <= '0';
            hex2 <= '0';
            hex3 <= '1';
            hex4 <= '1';
            hex5 <= '0';
            hex6 <= '1';
            
          WHEN x"8" =>
            hex0 <= '0';
            hex1 <= '0';
            hex2 <= '0';
            hex3 <= '0';
            hex4 <= '0';
            hex5 <= '0';
            hex6 <= '0';
            
          WHEN x"9" =>
            hex0 <= '0';
            hex1 <= '0';
            hex2 <= '0';
            hex3 <= '1';
            hex4 <= '1';
            hex5 <= '0';
            hex6 <= '0';
            
          WHEN OTHERS =>
            hex0 <= '0';
            hex1 <= '0';
            hex2 <= '0';
            hex3 <= '0';
            hex4 <= '0';
            hex5 <= '0';
            hex6 <= '0';
        END CASE;
    END process;
END funcional;