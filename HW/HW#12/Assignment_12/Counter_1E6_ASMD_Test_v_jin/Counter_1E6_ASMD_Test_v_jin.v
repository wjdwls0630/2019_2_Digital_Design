module Counter_1E6_ASMD_Test_v_jin(
   output reg C_out,
   input Start,
   input CLK, Clrn
);

   reg [19:0] A; //Counter_1E6
   reg [1:0] pstate, nstate; // state
   reg clr_A, incr_A, clr_C_out, set_C_out;
   //S0 : initial state, S1 : count
   parameter S0 = 2'b00, S1=2'b11;
   
   //state transition for control logic
   always @(posedge CLK, negedge Clrn) begin
	  if(~Clrn) begin
		 C_out <= 1'b0;
		 A <= 20'b0;
		 pstate <= S0;
	  end
	  else begin
		 pstate <= nstate; //clocked operation
		 if(clr_A) A <= 20'b0;
		 if(incr_A) A <= A + 1'b1;
		 if(clr_C_out) C_out <= 1'b0;
		 if(set_C_out) C_out <= 1'b1;
	  end
   end

   // decide next state
   always@(pstate, Start) begin
	  case(pstate)
		 S0:
		 begin
			if(Start)  nstate <= S1;
			else nstate <= S0;
		 end
		 S1:
		 begin
			if(Start) nstate <= S1;
			else nstate <= S0;
		 end
	  endcase
   end
   
   //decide control  
   always @(pstate, A, Start) begin
	  //default assignmet (recommend)
	  clr_A <= 1'b0;
	  incr_A <= 1'b0;
	  clr_C_out <= 1'b0;
	  set_C_out <= 1'b0;

	  //Register transfer operation
	  case(pstate)
		 S0:
		 begin
			if(Start) begin
			   clr_A <= 1'b1;
			   clr_C_out <= 1'b1;
			
			end
		 end

		 S1:
		 begin
			if(Start) begin
			   if(A==20'd999999) begin
				  clr_A <= 1'b1;
				  set_C_out <= 1'b1;
			   end
			   else begin 
				  incr_A <= 1'b1;
				  clr_C_out <= 1'b1;
			   end
			end
		 end
	  endcase
   end
endmodule
