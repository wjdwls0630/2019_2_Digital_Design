module Counter_1E6_ASMD_v_jin(
   output reg C_out,
   input CLK, Clrn
);

   reg [19:0] A; //Counter_1E6
   reg [1:0] pstate, nstate; // state
   reg clr_A, incr_A, rst_C_out, set_C_out;

   //S0 : initial state, S1 : count
   parameter S0 = 2'b00, S1=2'b11;

   // state transition for control logic
   always @(posedge CLK, negedge Clrn) begin
    if(~Clrn) pstate <= S0;
    else pstate <= nstate; //clocked operation
   end

   // code next state logic
   always@(pstate, A) begin
    case(pstate)
      S0:
        nstate <= S1;
      S1:
        if(A==20'd999999) nstate <= S0;
        else nstate <= S1;
    endcase
   end

   //code output logic
   always@(pstate, A) begin
    clr_A <= 1'b0;
    incr_A <= 1'b0;
    rst_C_out <= 1'b0;
    set_C_out <= 1'b0;
    case(pstate)
      S0:
        clr_A <= 1'b1;
        rst_C_out <= 1'b1;
      S1:
        if(A==20'd999999) begin
          clr_A <= 1'b1;
          set_C_out <= 1'b1;
        end
        else begin
          incr_A <=1'b1;
          rst_C_out <= 1'b1;
        end
    endcase
   end

   //Register operation
   always @ (posedge CLK, negedge Clrn ) begin
    if(~Clrn) begin
      A <= 20'b0;
      clr_A <= 1'b0;
      incr_A <= 1'b0;
      rst_C_out <= 1'b0;
      set_C_out <= 1'b0;
    end
    else begin
      if(clr_A) A <= 20'b0;
      if(incr_A) A <= A+1'b1;
      if(rst_C_out) C_out <= 1'b0;
      if(set_C_out) C_out <= 1'b1;
    end
   end
endmodule
