`timescale 1ns/1ns
module Counter_1E6_ASMD_Test_v_tb_jin;

wire C_out;
reg Start;
reg CLK, Clrn;



initial begin
   #50E6 $finish;
end


initial
begin
   CLK <= 1'b0;
   Clrn <= 1'b0;
   Start <= 1'b1;
   #20 Clrn <= 1'b1; // reset two clock edge
   #35E6 Start <= 1'b0; //start decreasing
   #2E6 Start <= 1'b1; //again start increasing
end

always #5 CLK <= ~CLK; //clock generator
Counter_1E6_ASMD_Test_v_jin ct1(
   .C_out(C_out),
   .Start(Start),
   .CLK(CLK),
   .Clrn(Clrn));

always @(C_out) begin
   $monitor("C_out = %d, time = %0d", C_out, $time);
end


endmodule
