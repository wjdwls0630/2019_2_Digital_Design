module univ_shift_reg_jin(
   output reg [3:0] Q, //output reg
   input [3:0] Pin, //parallel input
   input [1:0] s, // input select bit
   input Ltin, Rtin, Clk ,Clr // serial input, clock and reset
   );
   always@(posedge Clk, negedge Clr)
	  if(~Clr) Q<=4'b0000;
	  else
		 case(s)
			2'b00: Q<=Q; //no change
			2'b01: Q<={Rtin, Q[3:1]}; //shift right
			2'b10: Q<={Q[2:0], Ltin}; //shift left
			2'b11: Q<=Pin; //parallel load
		 endcase
   endmodule






   
	  
