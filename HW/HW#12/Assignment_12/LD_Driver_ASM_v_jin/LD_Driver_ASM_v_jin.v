module LD_Driver_ASM_v_jin(
   output reg [11:0] I_out,
   input SW_ON, LD_ON, C_out,
   input CLK, Clrn
);
   reg LD_ON_reg;
   reg [1:0] pstate, nstate;

   //Encode the states
   parameter S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;

   //state transition
   always @(posedge CLK, negedge Clrn) begin
	  if(~Clrn) begin
		 pstate <= S0;
		 I_out <= 12'b0;
	  end
	  else begin
		 pstate <= nstate; //clocked operation
		 case(pstate)
			S0:
			begin
			   LD_ON_reg <= LD_ON;
			   if(SW_ON) begin
				  I_out <= 12'b0;
			   end
			end

			S1:
			begin
			   if(SW_ON) begin
				  LD_ON_reg <= LD_ON;
				  if(LD_ON_reg) begin
					 if(I_out < 12'd2000) begin
						if(C_out == 1'b1) begin
						   I_out <= I_out+2'b10;
						end
					 end
				  end
			   end
			   else LD_ON_reg <= 1'b0;
			end

			S2:
			begin
			   if(SW_ON) begin
				  LD_ON_reg <= LD_ON;
				  if(!LD_ON_reg) begin
					 if(I_out > 1'b1) begin
						if(C_out == 1'b1) begin
						   I_out <= I_out-3'b100;
						end
					 end
				  end
			   end
			   else begin
				  LD_ON_reg <= 1'b0;
				  if(I_out > 1'b1) begin
					 if(C_out == 1'b1) begin
						I_out <= I_out-3'b100;
					 end
				  end
			   end	   
			end

			S3:
			begin
			   if(SW_ON) begin
				  LD_ON_reg <= LD_ON;
			   end
			end
		 endcase
	  end
   end

   always @(SW_ON, LD_ON_reg, pstate, I_out) begin
	  case(pstate)
		 S0: 
		 begin 
			if(SW_ON & LD_ON_reg) nstate <= S1;
			else nstate <= S0;
		 end

		 S1:
		 begin
			if(I_out >= 12'd2000) nstate <= S3;
			else begin 
			   if(SW_ON & LD_ON_reg) nstate <= S1;
			   else nstate <= S2;
			end
		 end

		 S2:
		 begin
			if(SW_ON) begin
	  		   if(LD_ON_reg) nstate <= S1;
			   else nstate <= S2;
			end
			else
			   if(I_out <= 1'd1) nstate <= S0;
			   else nstate <= S2;
		 end
		
		 S3:
		 begin 
			if(SW_ON & LD_ON_reg) nstate <= S3;
			else nstate <= S2;
		 end
	  endcase
   end
endmodule


