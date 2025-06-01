//`timescale 100ns / 1ps

module FSM(
    input logic clk, reset,
    input logic [1:0] G1, G2, A, P,
    output logic [1:0] R1, R2,
    output logic [1:0] E
);
    logic [1:0] NP, O;
    // FSM Moore
    FSM_Niveles Nivel_Agua(.clk(clk), .reset(reset), .A(A), .P(P), .C(O), .Pout(NP));

    // Coding states
    typedef enum logic [2:0] {S0, S1, S2, S3, S4, S5} statetype;
    statetype state, nextstate;

    // coding outs as logic vectors (2 bits)
    logic [1:0] salida_1, salida_2;

    // coding errors
    typedef enum logic [1:0]{Error=2'b11, NE=2'b00} errortype;
    errortype error;

    // Registry
    always_ff @(posedge clk or posedge reset) begin
        if (reset) 
            state <= S0;
        else 
            state <= nextstate;
    end

    // Next state logic
    always_comb begin
        case (state)
            S0, S1, S2, S3, S4, S5: begin
                if (O && NP == 2'b00) begin
                    if (G1 == 2'b00 && G2 == 2'b00) nextstate = S0;
                    else if ((G1 == 2'b01 || G1 == 2'b10) && G2 == 2'b00) nextstate = S1;
                    else if ((G1 == 2'b11) || (G2 == 2'b11)) nextstate = S2;
                    else if ((G2 == 2'b01 || G2 == 2'b10) && G1 == 2'b00) nextstate = S3;
                    else if ((G1 == 2'b01 || G1 == 2'b10) && (G2 == 2'b01 || G2 == 2'b10)) nextstate = S4;
                    else nextstate = S0;
                end else if (NP != 2'b00) begin
                    nextstate = S5;
                end else begin
                    nextstate = S0; // fallback
                end
            end
            default: nextstate = S0;
        endcase
    end

    // Output logic
    always_comb begin
        // Defaults
        salida_1 = 2'b00;  // Stop
        salida_2 = 2'b00;  // Stop
        error = NE;

        case (state)
            S0: begin
                salida_1 = 2'b00; // Stop
                salida_2 = 2'b00; // Stop
                error = NE;
            end
            S1: begin
                if (G1 == 2'b01) begin
                    salida_1 = {Stop, Agua};  // salida_1[1]=Agua, salida_1[0]=Stop
                    salida_2 = 2'b00;         // Stop
                end else if (G1 == 2'b10) begin
                    salida_1 = {Agua, Stop};  // salida_1[1]=Stop, salida_1[0]=Agua
                    salida_2 = 2'b00;         // Stop
                end
                error = NE;
            end
            S2: begin
                salida_1 = {Agua, Agua};
                salida_2 = {Agua, Agua};
                error = NE;
            end
            S3: begin
                if (G2 == 2'b01) begin
                    salida_1 = 2'b00;         // Stop
                    salida_2 = {Stop, Agua};
                end else if (G2 == 2'b10) begin
                    salida_1 = 2'b00;         // Stop
                    salida_2 = {Agua, Stop};
                end
                error = NE;
            end
            S4: begin
                // Corrección lógica según condiciones originales:
                if (G1 == 2'b01 || G2 == 2'b01) begin
                    salida_1 = {Stop, Agua};
                    salida_2 = {Stop, Agua};
                end else if (G1 == 2'b10 || G2 == 2'b10) begin
                    salida_1 = {Agua, Stop};
                    salida_2 = {Agua, Stop};
                end else if (G1 == 2'b11 || G2 == 2'b11) begin
                    salida_1 = {Agua, Agua};
                    salida_2 = {Agua, Agua};
                end
                error = NE;
            end
            S5: begin
                salida_1 = 2'b00; // Stop
                salida_2 = 2'b00; // Stop
                error = Error;
            end
            default: begin
                salida_1 = 2'b00;
                salida_2 = 2'b00;
                error = NE;
            end
        endcase
    end

    assign R1 = salida_1;
    assign R2 = salida_2;
    assign E = error;

endmodule
