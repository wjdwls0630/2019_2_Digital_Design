module Counter_1E6_ASM_v_jin(
   output reg C_out,
   input Start_C, Clr_C,
   input CLK, Clrn
);

   reg [19:0] A; //Counter_1E6
   reg [1:0] pstate, nstate; // state
   //S0 : initial state, S1 : count
   parameter S0 = 2'b00, S1=2'b11;
   
   //state transition for control logic
   always @(posedge CLK, negedge Clrn) begin
	  if(~Clrn) begin
		 pstate <= S0;
		 A <= 20'b0;
		 C_out <= 1'b0;
	  end
	  else begin
		 pstate <= nstate; //clocked operation
		 //Register Transfer operation controlled by external input
		 case(pstate) 
			S0:
			begin
			   if(Start_C) begin
				  A <= 20'b0;
				  C_out <= 1'b0;
			   end
			end
			S1:
			begin
			   if(Start_C) begin
				  if(Clr_C) begin
					 A <= 20'b0;
					 C_out <= 1'b0;
				  end
				  else begin
					 if(A==20'd999999) begin
						A <= 20'b0;
						C_out <= 1'b1;
					 end
					 else begin
						A <= A + 1'b1;
						C_out <= 1'b0;
					 end
				  end
			   end
			end
		 endcase
	  end
   end
   
   // decide next state
   always@(pstate, Start_C) begin
	  case(pstate)
		 S0:
		 begin
			if(Start_C) nstate <= S1;
			else nstate <= S0;
		 end
		 S1:
		 begin
			if(Start_C) nstate <= S1;
			else nstate <= S0;
		 end
	  endcase
   end
endmodule
