module top(
   output [11:0] I_out,
   input SW_ON, LD_ON,
   input CLK, Clrn
);

   wire C_out;

   Counter_1E6_ASM_v_jin C1 (
	  .C_out(C_out), 
	  .CLK(CLK),
	  .Clrn(Clrn));

   LD_Driver_ASM_v_jin LD1 (
	  .I_out(I_out),
	  .SW_ON(SW_ON),
	  .LD_ON(LD_ON), 
	  .C_out(C_out), 
	  .CLK(CLK),
	  .Clrn(Clrn));
endmodule
