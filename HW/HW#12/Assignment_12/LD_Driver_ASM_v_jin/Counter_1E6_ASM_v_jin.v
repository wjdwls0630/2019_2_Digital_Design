module Counter_1E6_ASM_v_jin(
   output reg C_out, 
   input CLK, Clrn
);

   reg [19:0] A; //Counter_1E6
   reg [1:0] pstate, nstate; // state
   //S0 : initial state, S1 : count
   parameter S0 = 2'b00, S1=2'b11;
   
   always @(posedge CLK, negedge Clrn) begin
	  if(~Clrn) begin
		 C_out <= 1'b0;
		 A <= 20'b0;
		 pstate <= S0;
	  end
	  else begin
		 pstate <= nstate; //clocked operation

		 //Register transfer operation
		 case(pstate)
			S0:
			begin
			   A <= 20'b0;
			   C_out <= 1'b0;
			end

			S1:
			begin
			   if(A==20'd999999) begin
				  A <= 20'b0;
				  C_out <= 1'b1;
			   end
			   else begin 
				  A <= A + 1'b1;
				  C_out <= 1'b0;
			   end
			end
		 endcase
	  end
   end
   
   // state trnasition for control logic
   always@(pstate, A) begin
	  case(pstate)
		 S0:
			nstate <= S1;
		 S1:
			if(A==20'd999999) nstate <= S0;
			else nstate <= S1;
	  endcase
   end
endmodule
