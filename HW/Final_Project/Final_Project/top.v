module top(
   output [12:0] I_out,
   input [12:0] I_set,
   input SW_ON, LD_ON,
   input CLK, Clrn
);
   wire Start_C, Clr_C, C_out;

   Counter_1E6_ASM_v_jin C1 (
	  .C_out(C_out),
	  .Start_C(Start_C),
	  .Clr_C(Clr_C),
	  .CLK(CLK),
	  .Clrn(Clrn));

   LD_Driver_ASM_v_jin LD1 (
	  .I_out(I_out),
	  .Start_C(Start_C),
	  .Clr_C(Clr_C),
	  .I_set(I_set),
	  .SW_ON(SW_ON),
	  .LD_ON(LD_ON), 
	  .C_out(C_out), 
	  .CLK(CLK),
	  .Clrn(Clrn));
endmodule
