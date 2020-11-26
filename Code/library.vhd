LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

----------------------------------------------------------------------------------------	 
    PACKAGE f_x IS
	 
        FUNCTION f  (x: std_logic_vector(15 downto 0)) RETURN std_logic_vector;
		  FUNCTION CSL(x: std_logic_vector (15 downto 0); S: integer range 0 to 15) RETURN std_logic_vector;
		  FUNCTION CSR(x: std_logic_vector (15 downto 0); S: integer range 0 to 15) RETURN std_logic_vector;
		  FUNCTION add(a: std_logic_vector (15 downto 0); b: std_logic_vector (15 downto 0)) RETURN std_logic_vector;
		  FUNCTION initial ( key: std_logic_vector(127 downto 0);R: std_logic_vector(127 downto 0)) RETURN std_logic_vector;
		  FUNCTION enc ( plaintext: std_logic_vector(15 downto 0);R: std_logic_vector(127 downto 0);KEY: std_logic_vector(127 downto 0)) RETURN std_logic_vector;
	 END PACKAGE;
----------------------------------------------------------------------------------------
	 
    PACKAGE BODY f_x IS
		
		FUNCTION add(a: std_logic_vector (15 downto 0); b: std_logic_vector (15 downto 0)) RETURN std_logic_vector is
			variable result: std_logic_vector(15 downto 0);
			variable int : integer range 0 to 65535;
			BEGIN
		
			int:= to_integer(unsigned(a)+unsigned(b)) mod 65536 ;
			return std_logic_vector(to_unsigned(int, result'length));
		END add;
		
	 
	 
	 
		FUNCTION CSL(x: std_logic_vector (15 downto 0); S: integer range 0 to 15) RETURN std_logic_vector is
			Variable result1 : std_logic_vector (15 downto 0);
			Variable result2 : std_logic_vector (15 downto 0);
			Variable result : std_logic_vector (15 downto 0);
			BEGIN
--		
--				result1:= std_logic_vector(shift_left(unsigned(X),S));
--				result2:= std_logic_vector(shift_right(unsigned(X),16-s));
--				result:= result1  or result2;
				result:= std_logic_vector(unsigned(x) rol s);

		
			RETURN result;
		END CSL;
		
		
		FUNCTION CSR(x: std_logic_vector (15 downto 0); S: integer range 0 to 15) RETURN std_logic_vector is
		Variable result1 : std_logic_vector (15 downto 0);
		Variable result2 : std_logic_vector (15 downto 0);
		Variable result : std_logic_vector (15 downto 0);
		BEGIN
		
--			result1:= std_logic_vector(shift_right(unsigned(X),S));
--			result2:= std_logic_vector(shift_left(unsigned(X),16-s));
			result:= std_logic_vector(unsigned(x) ror s);
		
			RETURN result;
		END CSR;
		
		
		
		 FUNCTION f ( x: std_logic_vector(15 downto 0)) RETURN std_logic_vector IS
			type SBOX_type is array( 0 to 15) of integer range 0 to 15;
			VARIABLE x0,x1,x2,x3     :  std_logic_vector(3  downto 0); 
--		 	VARIABLE xx,xx6,xx10     :  std_logic_vector(15 downto 0); 
			variable XX,S0_shifted,S1_shifted,S2_shifted,S3_shifted: std_logic_vector (15 downto 0);
			variable XX_vector: std_logic_vector(15 downto 0);
			variable X0_integer,X1_integer,X2_integer,X3_integer: integer range 0 to 15; 
			variable S0_int,S1_int,S2_int,S3_int: integer range 0 to 15;
			variable S0_unsigned,S1_unsigned,S2_unsigned,S3_unsigned: unsigned (15 downto 0);
			constant S0:SBOX_type:= (7, 12, 14, 9, 2, 1, 5, 15, 11, 6, 13, 0, 4, 8, 10, 3);
			constant s1:SBOX_type:= (4, 10, 1, 6, 8, 15, 7, 12, 3, 0, 14, 13, 5, 9, 11, 2);
			constant s2:SBOX_type:= (2, 15, 12, 1, 5, 6, 10, 13, 14, 8, 3, 4, 0, 11, 9, 7);
			constant s3:SBOX_type:= (15, 4, 5, 8, 9, 7, 2, 1, 10, 3, 0, 14, 6, 12, 13, 11);
			
			BEGIN
				x0:= x(15 downto 12);
				x1:= x(11 downto 8);
				x2:= x(7 downto 4) ;
				x3:= x(3 downto 0) ;
				
				X0_integer:= to_integer(unsigned(x0));
				X1_integer:= to_integer(unsigned(x1));
				X2_integer:= to_integer(unsigned(x2));
				X3_integer:= to_integer(unsigned(x3));
				
				S0_int:=S0(X0_integer);
				S1_int:=S1(X1_integer);
				S2_int:=S2(X2_integer);
				S3_int:=S3(X3_integer);
				
				S0_unsigned:=to_unsigned(S0_int, xx'length);
				S1_unsigned:=to_unsigned(S1_int, xx'length);
				S2_unsigned:=to_unsigned(S2_int, xx'length);
				S3_unsigned:=to_unsigned(S3_int, xx'length);
				
				S0_shifted:=std_logic_vector(shift_left(S0_unsigned,12));
				S1_shifted:=std_logic_vector(shift_left(S1_unsigned,8));
				S2_shifted:=std_logic_vector(shift_left(S2_unsigned,4));
				S3_shifted:=std_logic_vector(shift_left(S3_unsigned,0));
				
				XX_vector:= S0_shifted or S1_shifted or S2_shifted or S3_shifted;
				XX:= XX_vector xor CSL(XX_vector,6) xor CSL(XX_vector,10);
				
							
			RETURN XX;
		END f;
       
		 
		 FUNCTION initial ( key: std_logic_vector(127 downto 0);R: std_logic_vector(127 downto 0)) RETURN std_logic_vector IS
		
--			
			variable t0,t1,t2,t3: std_logic_vector(15 downto 0);
			variable temp: std_logic_vector(15 downto 0);
			variable R0_var:std_logic_vector(15 downto 0):=R(15 downto 0);
			variable R1_var:std_logic_vector(15 downto 0):=R(31 downto 16);
			variable R2_var:std_logic_vector(15 downto 0):=R(47 downto 32);
			variable R3_var:std_logic_vector(15 downto 0):=R(63 downto 48);
			variable R4_var:std_logic_vector(15 downto 0):=R(79 downto 64);
			variable R5_var:std_logic_vector(15 downto 0):=R(95 downto 80);
			variable R6_var:std_logic_vector(15 downto 0):=R(111 downto 96);
			variable R7_var:std_logic_vector(15 downto 0):=R(127 downto 112);
			variable result: std_logic_vector(127 downto 0);
			BEGIN
				for i in 0 to 3 loop
					temp:= std_logic_vector(to_unsigned(i,temp'length));
					t0:=	f(f(f(f(add(R0_var, temp) xor key(15 downto 0)) xor key(31 downto 16)) xor key(47 downto 32)) xor key(63 downto 48)); 
					t1:=	f(f(f(f(add(R1_var,t0) xor key(79 downto 64))  xor key(95 downto 80)) xor key(111 downto 96)) xor key(127 downto 112)); 
					t2:=	f(f(f(f(add(R2_var,t1) xor key(15 downto 0))   xor key(31 downto 16)) xor key(47 downto 32)) xor key(63 downto 48)); 
					t3:=	f(f(f(f(add(R3_var,t2) xor key(79 downto 64))  xor key(95 downto 80)) xor key(111 downto 96)) xor key(127 downto 112)); 
					R0_var:= CSL(add(R0_var, t3),3);
					R1_var:= CSR(add(R1_var, t0),1);
					R2_var:= CSL(add(R2_var, t1),8);
					R3_var:= CSL(add(R3_var, t2),1);
					R4_var:= R4_var xor R0_var;
					R5_var:= R5_var xor R1_var;
					R6_var:= R6_var xor R2_var;
					R7_var:= R7_var xor R3_var;

										
				end loop;
				
				result:= R7_var & R6_var & R5_var & R4_var & R3_var & R2_var & R1_var & R0_var;
							
			RETURN result;
				
       END initial;
		 
		 FUNCTION enc ( plaintext: std_logic_vector(15 downto 0);R: std_logic_vector(127 downto 0);KEY: std_logic_vector(127 downto 0)) RETURN std_logic_vector IS
					
			variable t0,t1,t2,c: std_logic_vector(15 downto 0);
			variable temp,R0_var,R1_var,R2_var,R3_var,R4_var,R5_var,R6_var,R7_var: std_logic_vector(15 downto 0);
			variable result: std_logic_vector(143 downto 0);
			BEGIN
				
				
				t0:=	f(f(f(f(add(R(15 downto 0), plaintext)   xor key(15 downto 0)) xor key(31 downto 16)) xor key(47 downto 32)) xor key(63 downto 48)); 
				t1:=	f(f(f(f(add(R(31 downto 16),t0       )   xor key(79 downto 64) xor R(79 downto 64)) xor key(95 downto 80) xor R(95 downto 80)) xor key(111 downto 96) xor R(111 downto 96)) xor key(127 downto 112) xor R(127 downto 112)); 
				t2:=	f(f(f(f(add(R(47 downto 32),t1       )   xor key(15 downto 0)  xor R(79 downto 64)) xor key(31 downto 16) xor R(95 downto 80)) xor key(47 downto 32)  xor R(111 downto 96)) xor key(63 downto 48)   xor R(127 downto 112)); 
				
				c:=	f(f(f(f(add(R(63 downto 48), t2)  xor key(79 downto 64)) xor key(95 downto 80)) xor key(111 downto 96)) xor key(127 downto 112)); 
				c:= add(c, R(15 downto 0));
				
				
				
				R4_var:=  add(R(15 downto 0),t2) xor R(79 downto 64) ;
				R5_var:=  add(R(31 downto 16),t0) xor R(95 downto 80) ;
				R6_var:=  add(R(47 downto 32) ,t1) xor R(111 downto 96) ;
				R7_var:=  add(add(add(R(63 downto 48),R(15 downto 0)),t2),t0) xor R(127 downto 112);
				
				R3_var:= add(add(add(R(63 downto 48),R(15 downto 0)),t2),t0);
				R0_var:= add(R(15 downto 0),t2)  ;
				R1_var:= add(R(31 downto 16),t0)  ;
				R2_var:= add(R(47 downto 32) ,t1) ;
				
				result:= R7_var & R6_var & R5_var & R4_var & R3_var & R2_var & R1_var & R0_var & c;
							
			RETURN result;
				
       END enc;
		 
		 
		 
    
	 END PACKAGE BODY;
