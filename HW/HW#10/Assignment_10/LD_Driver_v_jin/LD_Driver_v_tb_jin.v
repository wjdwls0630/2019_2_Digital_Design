`timescale 1ns/1ns
module LD_Driver_v_tb_jin;


reg CLK, Clrn;
wire [11:0] I_out;
reg SW_ON, LD_ON;



initial begin
   #20E6 $finish;
end


initial
begin
   CLK <= 1'b0;
   Clrn <= 1'b0;
   SW_ON <= 1'b1;
   LD_ON <= 1'b1;
   #20 Clrn <= 1'b1; // reset two clock edge
   #11E6 LD_ON <= 1'b0; //start decreasing
   #2E6 LD_ON <= 1'b1; //again start increasing
   #1E6 SW_ON <= 1'b0; //turn off the switch
   #4E6 SW_ON <= 1'b1; //again swithch on 
end

always #5 CLK <= ~CLK; //clock generator

LD_Driver_v_jin M1 (.I_out(I_out), .SW_ON(SW_ON), .LD_ON(LD_ON), .CLK(CLK), .Clrn(Clrn));

always @(I_out) begin
   $monitor("I_out = %d, time = %0d", I_out, $time);
   

end


endmodule
