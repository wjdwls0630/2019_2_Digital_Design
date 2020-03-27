module Counter_1E6_ASM_Test_v_jin(
   output reg C_out,
   input Start,
   input CLK, Clrn
);

   reg [19:0] A; //Counter_1E6
   reg [1:0] pstate, nstate; // state
   //S0 : initial state, S1 : count
   parameter S0 = 2'b00, S1=2'b11;
   
   //state transition for control logic
   always @(posedge CLK, negedge Clrn) begin
	  if(~Clrn) begin
		 C_out <= 1'b0;
		 A <= 20'b0;
		 pstate <= S0;
	  end
	  else pstate <= nstate; //clocked operation
   end
   
   // decide next state
   always@(pstate, Start) begin
	  case(pstate)
		 S0:
		 begin
			if(Start) nstate <= S1;
			else nstate <= S0;
		 end
		 S1:
		 begin
			if(Start) nstate <= S1;
			else nstate <= S0;
		 end
	  endcase
   end

   //Reigster Transfer operations
   always @(posedge CLK) begin
	  case(pstate) 
		 S0:
		 begin
			if(Start) begin
			   A <= 20'b0;
			   C_out <= 1'b0;
			end
		 end

		 S1:
		 begin
			if(Start) begin
			   if(A==20'd999999) begin
				  A <= 20'b0;
				  C_out <= 1'b1;
			   end
			   else begin
				  A <= A + 1'b1'
				  C_out <= 1'b0;
			   end
			end
		 end
	  endcase
   end
endmodule
