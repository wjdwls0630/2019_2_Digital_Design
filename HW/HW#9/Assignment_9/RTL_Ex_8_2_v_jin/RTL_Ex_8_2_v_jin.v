module RTL_Ex_8_2_v_jin(
   output reg E, F,
   output reg[3:0] A,
   input S, CLK, Clrn
   );
   //specify system registers
   reg [1:0] pstate, nstate; //control register
   //Encode the states
   parameter T0 = 2'b00, T1 = 2'b01, T2 = 2'b10;
   //state transition for control 
   always @(posedge CLK, negedge Clrn) begin
	  if(~Clrn) pstate <= T0; //initial state
	  else begin
		 pstate <= nstate; //clocked operations
	  end
   end
   
   //decision box -> decide next state
   always @(S, A, pstate) begin
	  case(pstate)
		 T0:
		 begin
			if(S) nstate = T1;
			else nstate = T0;
		 end
		 T1:
		 begin
			if(A[2]&A[3]) nstate = T2;
			else nstate = T1;
		 end
		 T2:
		 begin
			nstate = T0;
		 end
	  endcase
   end
   
   always @(posedge CLK) begin
	  case(pstate)
		 T0:
		 begin
			if(S) begin
			   A <= 4'b0000;
			   F <= 1'b0;
			end
		 end
		 T1:
		 begin
			A <= A+4'b0001;
			if(A[2]) begin
			   E <= 1'b1;
			end
			else begin 
			   E <= 1'b0;
			end
		 end
		 T2:
			F <= 1'b1;
	  endcase
   end
endmodule




  

			





   

