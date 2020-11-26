Library ieee;
	 use ieee.std_Logic_1164.all;
	  USE IEEE.NUMERIC_STD.ALL;
	
	 use work.f_x.all;

entity humm_amin is
  port(  plaintext     : in  std_logic_vector(127  downto 0); 
			--IV     : in  std_logic_vector(63  downto 0);
			key:				 in std_logic_vector(127 downto 0) ;
			c     : 			 out std_logic_vector(127  downto 0)  
);
  end;
  
  
	architecture behave of humm_amin is
		constant IV: std_logic_vector(63 downto 0):=X"0000000000000000";
		begin
		
		process(plaintext,key)
		
		variable R_cat,R_init,R_1,R_2,R_3,R_4,R_5,R_6,R_7,R_8: std_logic_vector(127 downto 0);
		variable intermediate: std_logic_vector(143 downto 0);
		variable enc0,enc1,enc2,enc3,enc4,enc5,enc6,enc7: std_logic_vector(15 downto 0);
		begin
			R_cat:= IV & IV;

			R_init:=initial(key,R_cat);
			
			intermediate:= enc(plaintext(15 downto 0),R_init,key);
			enc0:=intermediate(15 downto 0);
			R_1:=intermediate(143 downto 16);
			
			intermediate:= enc(plaintext(31 downto 16),R_1,key);
			enc1:=intermediate(15 downto 0);
			R_2:= intermediate(143 downto 16);
			
			intermediate:= enc(plaintext(47 downto 32),R_2,key);
			enc2:=intermediate(15 downto 0);
			R_3:= intermediate(143 downto 16);
			
			intermediate:= enc(plaintext(63 downto 48),R_3,key);
			enc3:=intermediate(15 downto 0);
			R_4:= intermediate(143 downto 16);
			
			intermediate:= enc(plaintext(79 downto 64),R_4,key);
			enc4:=intermediate(15 downto 0);
			R_5:= intermediate(143 downto 16);
			
			intermediate:= enc(plaintext(95 downto 80),R_5,key);
			enc5:=intermediate(15 downto 0);
			R_6:= intermediate(143 downto 16);
			
			intermediate:= enc(plaintext(111 downto 96),R_6,key);
			enc6:=intermediate(15 downto 0);
			R_7:= intermediate(143 downto 16);
			
			intermediate:= enc(plaintext(127 downto 112),R_7,key);
			enc7:=intermediate(15 downto 0);
			R_8:= intermediate(143 downto 16);
			
			
			
			c<=enc7 & enc6 & enc5 & enc4 & enc3 & enc2 & enc1 & enc0;
			
			
			
			
							
			
		end process;
		
	
	
	
	
	end architecture;
  
  
