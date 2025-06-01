//`timescale 100ns / 1ps

module FSM_Niveles(input logic clk, reset,
                   input logic [1:0]A, P,
                   output logic [1:0]C, Pout);
        typedef enum logic [3:0] {S0, S1, S2, S3, S4, S5} statetype;     // Next state
        statetype state, nextstate;
        typedef enum logic [1:0] {No_Agua, Agua} outtype;      // output
        outtype [1:0]c;
        typedef enum logic [1:0] {Normal, Error} errortype;
        errortype [1:0]pout;
        // state register
        always_ff  @(posedge clk, posedge reset)
            if (reset) state <= S0;
            else state <= nextstate;
        // next state logic
        always_comb
            case (state)
                S0: if (A == 2'b00 && P == 2'b00) begin 
                        nextstate = S0;
                    end else if (A == 2'b01 && P == 2'b00) begin
                        nextstate = S1;
                    end else if (A == 2'b10 && P == 2'b00) begin
                        nextstate = S2;
                    end else if (A == 2'b11 && P == 2'b00) begin
                        nextstate = S5;
                    end else if (P == 2'b01) begin
                        nextstate = S3;
                    end else if (P == 2'b10) begin
                        nextstate = S4;
                    end
                    else
                        nextstate = S0;
                S1: if (A == 2'b00 && P == 2'b00) begin 
                        nextstate = S0;
                    end else if (A == 2'b01 && P == 2'b00) begin
                        nextstate = S1;
                    end else if (A == 2'b10 && P == 2'b00) begin
                        nextstate = S2;
                    end else if (A == 2'b11 && P == 2'b00) begin
                        nextstate = S5;
                    end else if (P == 2'b01) begin
                        nextstate = S3;
                    end else if (P == 2'b10) begin
                        nextstate = S4;
                    end
                    else
                        nextstate = S0;
                S2: if (A == 2'b00 && P == 2'b00) begin 
                        nextstate = S0;
                    end else if (A == 2'b01 && P == 2'b00) begin
                        nextstate = S1;
                    end else if (A == 2'b10 && P == 2'b00) begin
                        nextstate = S2;
                    end else if (A == 2'b11 && P == 2'b00) begin
                        nextstate = S5;
                    end else if (P == 2'b01) begin
                        nextstate = S3;
                    end else if (P == 2'b10) begin
                        nextstate = S4;
                    end
                    else
                        nextstate = S0;
                S3: if (A == 2'b00 && P == 2'b00) begin 
                        nextstate = S0;
                    end else if (A == 2'b01 && P == 2'b00) begin
                        nextstate = S1;
                    end else if (A == 2'b10 && P == 2'b00) begin
                        nextstate = S2;
                    end else if (A == 2'b11 && P == 2'b00) begin
                        nextstate = S5;
                    end else if (P == 2'b01) begin
                        nextstate = S3;
                    end else if (P == 2'b10) begin
                        nextstate = S4;
                    end
                    else
                        nextstate = S0;
                S4: if (A == 2'b00 && P == 2'b00) begin 
                        nextstate = S0;
                    end else if (A == 2'b01 && P == 2'b00) begin
                        nextstate = S1;
                    end else if (A == 2'b10 && P == 2'b00) begin
                        nextstate = S2;
                    end else if (A == 2'b11 && P == 2'b00) begin
                        nextstate = S5;
                    end else if (P == 2'b01) begin
                        nextstate = S3;
                    end else if (P == 2'b10) begin
                        nextstate = S4;
                    end
                    else
                        nextstate = S0;
                S5: if (A == 2'b00 && P == 2'b00) begin 
                        nextstate = S0;
                    end else if (A == 2'b01 && P == 2'b00) begin
                        nextstate = S1;
                    end else if (A == 2'b10 && P == 2'b00) begin
                        nextstate = S2;
                    end else if (A == 2'b11 && P == 2'b00) begin
                        nextstate = S5;
                    end else if (P == 2'b01) begin
                        nextstate = S3;
                    end else if (P == 2'b10) begin
                        nextstate = S4;
                    end
                    else
                        nextstate = S0;
                default: nextstate = S0;
            endcase
        // output logic pre-stage
        always_comb 
            case (state)
                S0: begin c[0] = No_Agua; c[1] = No_Agua; pout[0] = Normal; pout[1] = Normal; end
                S1: begin c[0] = Agua; c[1] = No_Agua; pout[0] = Normal; pout[1] = Normal; end
                S2: begin c[0] = No_Agua; c[1] = Agua; pout[0] = Normal; pout[1] = Normal; end
                S3: begin c[0] = No_Agua; c[1] = No_Agua; pout[0] = Error; pout[1] = Normal; end
                S4: begin c[0] = No_Agua; c[1] = No_Agua; pout[0] = Normal; pout[1] = Error; end
                S5: begin c[0] = Agua; c[1] = Agua; pout[0] = Normal; pout[1] = Error; end
            endcase
        // output logic
        assign C = c;
        assign Pout = pout;
endmodule
