module LD_Driver_ASM_v_jin(
   output reg [12:0] I_out,
   output reg Start_C,
   output reg Clr_C,
   input [12:0] I_set,
   input SW_ON, LD_ON, C_out,
   input CLK, Clrn
);
   reg LD_ON_reg; // store LD_ON
   reg [12:0] I_set_reg; //store i_set value
   reg [12:0] I_incr; // setting incremental 
   reg [2:0] pstate, nstate;

   //Encode the states
   parameter S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=3'b101;

   //state transition
   always @(posedge CLK, negedge Clrn) begin
	  if(~Clrn) begin
		 pstate <= S0;
		 I_out <= 13'b0;
		 Start_C <= 1'b0;
		 Clr_C <= 1'b0;
		 LD_ON_reg <= 1'b0;
		 I_set_reg <= 13'b0;
		 I_incr <= 13'b0;
	  end
	  else begin
		 pstate <= nstate; //clocked operation
		 // if SW_ON == 0, set LD_ON_reg 1'b0
		 if(SW_ON) LD_ON_reg <= LD_ON;
		 else LD_ON_reg <= 1'b0;
		 // store i_set
		 I_set_reg <= I_set;
		 // make incr
		 I_incr <= (I_set >> 10); // divide by 1024(approx 1000)
		 
		 //Register Transter operation
		 case(pstate)
			S0:
			begin
			   I_out <= 13'b0;
			   if(SW_ON) begin
				  Start_C <= 1'b1;
				  Clr_C <= 1'b0;
			   end 
			   else Start_C <= 1'b0;
			
			end
			S1:
			begin
			   if(SW_ON) begin
				  if(LD_ON_reg) begin
					 Clr_C <= 1'b0;
					 if(I_out < I_set_reg) begin
						if(C_out == 1'b1) begin
						   I_out <= I_out+I_incr;
						end
					 end
				  end 
				  else Clr_C <= 1'b1;
			   end 
			   else Clr_C <= 1'b1;
			end

			S2:
			begin
			   if(SW_ON) begin
				  if(!LD_ON_reg) begin
					 Clr_C <= 1'b0;
					 if(I_out >= 4'b1010) begin
						if(C_out == 1'b1) begin 
						   //multiple by 2 
						   I_out <= I_out-(I_incr << 1); 
						end
					 end 
				  end
				  else Clr_C <= 1'b1;
			   end
			   else begin
				  if(I_out >= 4'b1010) begin
					 Clr_C <= 1'b0;
					 if(C_out == 1'b1) begin
						I_out <= I_out-(I_incr << 1);
					 end
				  end 
				  else Clr_C <= 1'b1;
			   end
			end
			S3:
			begin 
			   Clr_C <= 1'b1;
			end

			S4:
			begin
			   if(SW_ON) begin
				  if(LD_ON_reg) begin
					 Clr_C <= 1'b0;
					 if(I_out < I_set_reg) begin
						if(C_out == 1'b1) begin
						   I_out <= I_out+I_incr;
						end
					 end
				  end 
				  else Clr_C <= 1'b1;
			   end 
			   else Clr_C <= 1'b1;
			end

			S5:
			begin
			   if(SW_ON) begin
				  if(LD_ON_reg) begin
					 Clr_C <= 1'b0;
					 if(I_out > I_set_reg) begin
						if(C_out == 1'b1) begin
						   I_out <= I_out-(I_incr<<1);
						end
					 end
				  end 
				  else Clr_C <= 1'b1;
			   end 
			   else Clr_C <= 1'b1;
			end

		 endcase
	  end
   end

   always @(SW_ON, LD_ON_reg, pstate, I_out, I_set_reg) begin
	  case(pstate)
		 S0: 
		 begin 
			if(SW_ON & LD_ON_reg) nstate <= S1;
			else nstate <= S0;
		 end

		 S1:
		 begin
			if(SW_ON & LD_ON_reg) begin
				  if(I_out >= I_set_reg) nstate <= S3;
				  else nstate <= S1;
			end
			else nstate <= S2;
		 end

		 S2:
		 begin
			if(SW_ON) begin

	  		   if(LD_ON_reg) nstate <= S1;
			   else nstate <= S2;
			end
			else
			   if(I_out <= 4'b1010) nstate <= S0;
			   else nstate <= S2;
		 end
		
		 default: 
		 begin 
			if(SW_ON & LD_ON_reg) begin
			   if (I_out != I_set_reg) begin
				  if(I_out < I_set_reg) nstate <= S4; //i_set incr 
				  else nstate <= S5;
			   end
			   else nstate <= S3;
			end
			else nstate <= S2;
		 end
	  endcase
   end
endmodule


