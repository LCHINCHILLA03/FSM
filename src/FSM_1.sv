`timescale 100ns / 1ps

module FSM_1(input logic clk, reset,
           input logic [1:0]G1, G2, A, P,
           output logic [1:0] R1, R2, E);
        logic NP, O;
        // FSM Moore
        FSM_Niveles Nivel_Agua(.clk(clk), .reset(reset), .A(A), .P(P), .C(O), .Pout(NP));
        // Coding states
        typedef enum logic [2:0] {S0, S1, S2, S3, S4, S5} statetype;
        statetype state, nextstate;
        // coding outs
        typedef enum logic [1:0] {Stop, Agua} outtype;
        outtype salida_1, salida_2;
        //coding erros
        typedef enum logic [1:0]{Error, NE} errortype;
        errortype error;
        // Registry
        always_ff @(posedge clk, posedge reset)
            if (reset) state <= S0;
            else state <= nextstate;
        // next state logic
        always_comb
            case (state)
                S0: if (O && NP == 1'b0) begin
                       if (G1 == 2'b00 && G2 == 2'b00) begin
                            nextstate = S0;
                       end 
                       else if ((G1 == 2'b01 || G1== 2'b10) && G2 == 2'b00) begin
                            nextstate = S1;
                       end 
                       else if ((G1 == 2'b11) || (G2 == 2'b11)) begin
                            nextstate = S2;
                       end
                       else if ((G2 == 2'b01 || G2 == 2'b10) && G1 == 2'b00) begin
                            nextstate = S3;
                       end 
                       else if((G1 == 2'b01 || G1== 2'b10) && (G2 == 2'b01 || G2== 2'b10)) begin
                            nextstate = S4;
                       end
                    else
                        nextstate = S5;
                    end
                
            endcase
            // pre-stage output logic
            always_comb
                case (state)
                    S0: begin salida_1 = Stop; salida_2 = Stop; error = NE; end
                    S1: begin
                            if (G1 == 2'b01) begin
                                salida_1[0] = Agua; salida_1[1] = Stop; salida_2[0] = Stop; salida_2[1] = Stop; error = NE;
                            end
                            else if (G1 == 2'b10) begin
                                salida_1[0] = Stop; salida_1[1] = Agua; salida_2[0] = Stop; salida_2[1] = Stop; error = NE;
                            end
                        end
                    S2: begin salida_1[0] = Agua; salida_1[1] = Agua; salida_2[0] = Agua; salida_2[1] = Agua; error = NE; end
                    S3: begin
                            if (G2 == 2'b01) begin
                                salida_1[0] = Stop; salida_1[1] = Stop; salida_2[0] = Agua; salida_2[1] = Stop; error = NE;
                            end
                            else if (G2 == 2'b10) begin
                                salida_1[0] = Stop; salida_1[1] = Stop; salida_2[0] = Stop; salida_2[1] = Agua; error = NE;
                            end
                        end
                    S4: begin 
                            if(G1 == 2'b01 || G2 == 2'b01) begin
                                salida_1[0] = Agua; salida_1[1] = Stop; salida_2[0] = Agua; salida_2[1] = Stop; error = NE;
                            end
                            else if(G1 == 2'b01 || G2 == 2'b10) begin
                                salida_1[0] = Agua; salida_1[1] = Stop; salida_2[0] = Stop; salida_2[1] = Agua; error = NE;
                            end
                            else if(G1 == 2'b01 || G2 == 2'b11) begin
                                salida_1[0] = Agua; salida_1[1] = Stop; salida_2[0] = Agua; salida_2[1] = Agua; error = NE;
                            end
                            if(G1 == 2'b10 || G2 == 2'b01) begin
                                salida_1[0] = Stop; salida_1[1] = Agua; salida_2[0] = Agua; salida_2[1] = Stop; error = NE;
                            end
                            else if(G1 == 2'b10 || G2 == 2'b10) begin
                                salida_1[0] = Stop; salida_1[1] = Agua; salida_2[0] = Stop; salida_2[1] = Agua; error = NE;
                            end
                            else if(G1 == 2'b10 || G2 == 2'b11) begin
                                salida_1[0] = Stop; salida_1[1] = Agua; salida_2[0] = Agua; salida_2[1] = Agua; error = NE;
                            end
                        end
                    S5: begin salida_1[0] = Stop; salida_1[1] = Stop; salida_2[0] = Stop; salida_2[1] = Stop; error = Error; end
                endcase
            assign R1 = salida_1;
            assign R2 = salida_2;
            assign E = error;
endmodule