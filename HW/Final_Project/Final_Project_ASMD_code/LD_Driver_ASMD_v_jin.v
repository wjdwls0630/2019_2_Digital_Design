module LD_Driver_ASMD_v_jin(
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
   reg set_I_reg, set_I_incr, rst_LD, set_LD, clr_I_out, rst_Start_C, set_Start_C,
   rst_Clr_C, set_Clr_C, incr_I, decr_I;
   //Encode the states
   parameter S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=3'b101;

   //state transition
   always @(posedge CLK, negedge Clrn) begin
      if(~Clrn) pstate <= S0;
      else pstate <= nstate; //clocked operation
   end

   // code next state logic
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

   always @(SW_ON, LD_ON_reg, pstate, I_out, I_set_reg) begin

      // default assignment
      rst_LD <= 1'b0;
      set_LD <= 1'b0;
      clr_I_out <= 1'b0;
      rst_Start_C <= 1'b0;
      set_Start_C <= 1'b0;
      rst_Clr_C <= 1'b0;
      set_Clr_C <= 1'b0;
      incr_I <= 1'b0;
      decr_I <= 1'b0;

      // if SW_ON == 0, set LD_ON_reg 1'b0
      if (SW_ON) set_LD <= 1'b1;
      else rst_LD <= 1'b1;
      set_I_reg <= 1'b1; // store i_set
      set_I_incr <= 1'b1; // divide by 1024(approx 1000)

      case (pstate)
         S0:
         begin
            clr_I_out <= 1'b1;
            if(SW_ON) begin
               set_Start_C <= 1'b1;
               rst_Clr_C <= 1'b1;
            end
            else rst_Start_C <= 1'b1;
         end

         S1:
         begin
            if(SW_ON) begin
               if(LD_ON_reg) begin
                  rst_Clr_C <= 1'b1;
                  if(I_out < I_set_reg) begin
                     if(C_out == 1'b1) begin
                        incr_I <= 1'b1;
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
                   rst_Clr_C <= 1'b1;
                   if(I_out >= 4'b1010) begin
                      if(C_out == 1'b1) begin
                         //multiple by 2
                         decr_I <= 1'b1;
                      end
                   end
                end
                else Clr_C <= 1'b1;
             end
             else begin
                if(I_out >= 4'b1010) begin
                   rst_Clr_C <= 1'b1;
                   if(C_out == 1'b1) begin
                      decr_I <= 1'b1;
                   end
                end
                else Clr_C <= 1'b1;
             end
          end

          S3:
             set_Clr_C <= 1'b1;

          S4:
          begin
             if(SW_ON) begin
                if(LD_ON_reg) begin
                   rst_Clr_C <= 1'b1;
                   if(I_out < I_set_reg) begin
                      if(C_out == 1'b1) begin
                         incr_I <= 1'b1;
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
                   rst_Clr_C <= 1'b1;
                   if(I_out > I_set_reg) begin
                      if(C_out == 1'b1) begin
                         decr_I <= 1'b1;
                      end
                   end
                end
                else Clr_C <= 1'b1;
             end
             else Clr_C <= 1'b1;
          end
      endcase
   end

   //Register Transfer operation
   always @ ( posedge CLK, negedge Clrn ) begin
      if(~Clrn) begin
         I_out <= 13'b0;
         LD_ON_reg <= 1'b0;
         I_set_reg <= 13'b0;
         I_incr <= 13'b0;
      end
      else begin
         if(set_I_reg) I_set_reg <= I_set; //store i value
         if(set_I_incr) I_incr <= (I_set >> 10);  // make incr
         if(rst_LD) LD_ON_reg <= 1'b0;
         if(set_LD) LD_ON_reg <= LD_ON;
         if(clr_I_out) I_out <= 13'b0;
         if(rst_Start_C) Start_C <= 1'b0;
         if(set_Start_C) Start_C <= 1'b1;
         if(rst_Clr_C) Clr_C <= 1'b0;
         if(set_Clr_C) Clr_C <= 1'b1;
         if(incr_I) I_out <= I_out + I_incr;
         if(decr_I) I_out <= I_out - (I_incr << 1);
      end
   end
endmodule
