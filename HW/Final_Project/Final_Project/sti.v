`timescale 1ns/1ns
module sti;

   reg CLK, Clrn;
   reg [12:0] I_set;
   wire [12:0] I_out;
   reg SW_ON, LD_ON;
   
   //set end time
   initial begin
	  #40E6 $finish;
   end


   initial
   begin
	  CLK <= 1'b0;
	  Clrn <= 1'b0;
	  SW_ON <= 1'b1;
	  LD_ON <= 1'b1;
	  I_set <= 13'd1024;
	  #20 Clrn <= 1'b1; // reset two clock edge
	  #5E6 I_set <= 13'd2048;
	  #2E6 I_set <= 13'd1024;
	  #4E6 I_set <= 13'd2048;
	  #8E6 I_set <= 13'd1024;
	  #6E6 LD_ON <= 1'b0; //start decreasing
	  #3E6 I_set <= 13'd2048;
	  #2E6 I_set <= 13'd1024;
	  #2E6 LD_ON <= 1'b1; //again start increasing
	  #2E6 SW_ON <= 1'b0; //turn off the switch
	  #1E6 SW_ON <= 1'b1; //again swithch on 
   end

   always #5 CLK <= ~CLK; //clock generator

   top t1 (
	  .I_out(I_out),
	  .I_set(I_set), 
	  .SW_ON(SW_ON), 
	  .LD_ON(LD_ON), 
	  .CLK(CLK), 
	  .Clrn(Clrn));

   always @(I_out) begin
	  $monitor("I_out = %d, time = %0d", I_out, $time);
   end
endmodule
