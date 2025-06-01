//`timescale 100ns / 1ps

module FSM(
    input logic clk, reset,
    input logic [1:0] G1, G2, A, P,
    output logic [1:0] R1, R2,
    output logic [1:0] E
);
    logic [1:0] NP, O;

    // Definir valores simbólicos
    localparam [1:0] Stop = 2'b00;
    localparam [1:0] Agua = 2'b11;

    // FSM Moore
    FSM_Niveles Nivel_Agua(.clk(clk), .reset(reset), .A(A), .P(P), .C(O), .Pout(NP));

    typedef enum logic [2:0] {S0, S1, S2, S3, S4, S5} statetype;
    statetype state, nextstate;

    logic [1:0] salida_1, salida_2;

    typedef enum logic [1:0]{Error=2'b11, NE=2'b00} errortype;
    errortype error;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) 
            state <= S0;
        else 
            state <= nextstate;
    end

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
                    nextstate = S0;
                end
            end
            default: nextstate = S0;
        endcase
    end

    always_comb begin
        salida_1 = Stop;
        salida_2 = Stop;
        error = NE;

        case (state)
            S0: begin
                salida_1 = Stop;
                salida_2 = Stop;
                error = NE;
            end
            S1: begin
                if (G1 == 2'b01) begin
                    salida_1 = {Stop[1], Agua[0]};  // o simplemente salida_1 = {Stop[1], Agua[0]}; si tiene sentido para ti
                    salida_2 = Stop;
                end else if (G1 == 2'b10) begin
                    salida_1 = {Agua[1], Stop[0]};
                    salida_2 = Stop;
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
                    salida_1 = Stop;
                    salida_2 = {Stop[1], Agua[0]};
                end else if (G2 == 2'b10) begin
                    salida_1 = Stop;
                    salida_2 = {Agua[1], Stop[0]};
                end
                error = NE;
            end
            S4: begin
                if (G1 == 2'b01 || G2 == 2'b01) begin
                    salida_1 = {Stop[1], Agua[0]};
                    salida_2 = {Stop[1], Agua[0]};
                end else if (G1 == 2'b10 || G2 == 2'b10) begin
                    salida_1 = {Agua[1], Stop[0]};
                    salida_2 = {Agua[1], Stop[0]};
                end else if (G1 == 2'b11 || G2 == 2'b11) begin
                    salida_1 = {Agua, Agua};
                    salida_2 = {Agua, Agua};
                end
                error = NE;
            end
            S5: begin
                salida_1 = Stop;
                salida_2 = Stop;
                error = Error;
            end
            default: begin
                salida_1 = Stop;
                salida_2 = Stop;
                error = NE;
            end
        endcase
    end

    assign R1 = salida_1;
    assign R2 = salida_2;
    assign E = error;

endmodule
