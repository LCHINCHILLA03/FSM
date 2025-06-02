//`timescale 100ns / 1ps

module FSM(
    input  logic clk, reset,
    input  logic [1:0] G1, G2, A, P,
    output logic [3:0] R1, R2, 
    output logic [1:0] E
);

    // Señales internas para FSM_Niveles
    logic [1:0] NP, O;

    // Instancia de la FSM de niveles de agua
    FSM_Niveles Nivel_Agua(
        .clk(clk), .reset(reset),
        .A(A), .P(P),
        .C(O), .Pout(NP)
    );

    // Definición de estados
    typedef enum logic [2:0] {S0, S1, S2, S3, S4, S5} statetype;
    statetype state, nextstate;

    // Tipos para salidas de control
    typedef enum logic [1:0] {Stop = 2'b00, Agua = 2'b01} outtype;
    outtype salida_1_1, salida_1_2;
    outtype salida_2_1, salida_2_2;

    // Tipos para errores
    typedef enum logic [1:0] {Error, NE} errortype;
    errortype error;

    // Registro de estado
    always_ff @(posedge clk or posedge reset)
        if (reset) state <= S0;
        else       state <= nextstate;

    // Lógica de transición de estado
    always_comb begin
        nextstate = S0;
        case (state)
            S0: if ((O != 2'b00) && (NP == 2'b00)) begin
                    if (G1 == 2'b00 && G2 == 2'b00)                           nextstate = S0;
                    else if ((G1 == 2'b01 || G1 == 2'b10) && G2 == 2'b00)     nextstate = S1;
                    else if (G1 == 2'b11 || G2 == 2'b11)                      nextstate = S2;
                    else if ((G2 == 2'b01 || G2 == 2'b10) && G1 == 2'b00)     nextstate = S3;
                    else if ((G1 == 2'b01 || G1 == 2'b10) && 
                             (G2 == 2'b01 || G2 == 2'b10))                   nextstate = S4;
                    else                                                     nextstate = S0;
                end else if (NP == 2'b01 || NP == 2'b10)                     nextstate = S5;

            S1: if ((O != 2'b00) && (NP == 2'b00)) begin
                    if (G1 == 2'b00 && G2 == 2'b00)                          nextstate = S0;
                    else if ((G1 == 2'b01 || G1 == 2'b10) && G2 == 2'b00)    nextstate = S1;
                    else if (G1 == 2'b11 || G2 == 2'b11)                     nextstate = S2;
                    else if ((G2 == 2'b01 || G2 == 2'b10) && G1 == 2'b00)    nextstate = S3;
                    else if ((G1 == 2'b01 || G1 == 2'b10) && 
                             (G2 == 2'b01 || G2 == 2'b10))                   nextstate = S4;
                    else                                                     nextstate = S0;
                end else if (NP == 2'b01 || NP == 2'b10)                    nextstate = S5;

            S2: if ((O != 2'b00) && (NP == 2'b00)) begin
                    if (G1 == 2'b00 && G2 == 2'b00)                          nextstate = S0;
                    else if ((G1 == 2'b01 || G1 == 2'b10) && G2 == 2'b00)    nextstate = S1;
                    else if (G1 == 2'b11 || G2 == 2'b11)                     nextstate = S2;
                    else if ((G2 == 2'b01 || G2 == 2'b10) && G1 == 2'b00)    nextstate = S3;
                    else if ((G1 == 2'b01 || G1 == 2'b10) && 
                             (G2 == 2'b01 || G2 == 2'b10))                   nextstate = S4;
                    else                                                     nextstate = S0;
                end else if (NP == 2'b01 || NP == 2'b10)                    nextstate = S5;

            S3: if ((O != 2'b00) && (NP == 2'b00)) begin
                    if (G1 == 2'b00 && G2 == 2'b00)                          nextstate = S0;
                    else if ((G1 == 2'b01 || G1 == 2'b10) && G2 == 2'b00)    nextstate = S1;
                    else if (G1 == 2'b11 || G2 == 2'b11)                     nextstate = S2;
                    else if ((G2 == 2'b01 || G2 == 2'b10) && G1 == 2'b00)    nextstate = S3;
                    else if ((G1 == 2'b01 || G1 == 2'b10) && 
                             (G2 == 2'b01 || G2 == 2'b10))                   nextstate = S4;
                    else                                                     nextstate = S0;
                end else if (NP == 2'b01 || NP == 2'b10)                    nextstate = S5;

            S4: if ((O != 2'b00) && (NP == 2'b00)) begin
                    if (G1 == 2'b00 && G2 == 2'b00)                          nextstate = S0;
                    else if ((G1 == 2'b01 || G1 == 2'b10) && G2 == 2'b00)    nextstate = S1;
                    else if (G1 == 2'b11 || G2 == 2'b11)                     nextstate = S2;
                    else if ((G2 == 2'b01 || G2 == 2'b10) && G1 == 2'b00)    nextstate = S3;
                    else if ((G1 == 2'b01 || G1 == 2'b10) && 
                             (G2 == 2'b01 || G2 == 2'b10))                   nextstate = S4;
                    else                                                     nextstate = S0;
                end else if (NP == 2'b01 || NP == 2'b10)                    nextstate = S5;

            S5: if ((O != 2'b00) && (NP == 2'b00)) begin
                    if (G1 == 2'b00 && G2 == 2'b00)                          nextstate = S0;
                    else if ((G1 == 2'b01 || G1 == 2'b10) && G2 == 2'b00)    nextstate = S1;
                    else if (G1 == 2'b11 || G2 == 2'b11)                     nextstate = S2;
                    else if ((G2 == 2'b01 || G2 == 2'b10) && G1 == 2'b00)    nextstate = S3;
                    else if ((G1 == 2'b01 || G1 == 2'b10) && 
                             (G2 == 2'b01 || G2 == 2'b10))                   nextstate = S4;
                    else                                                     nextstate = S0;
                end else if (NP == 2'b01 || NP == 2'b10)                    nextstate = S5;

            default: nextstate = S0;
        endcase
    end

    // Lógica de salida según estado
    always_comb begin
        salida_1_1 = Stop;
        salida_1_2 = Stop;
        salida_2_1 = Stop;
        salida_2_2 = Stop;
        error      = NE;

        case (state)
            S0: begin
                // Todos Stop, error NE (ya está seteado arriba)
            end
            S1: begin
                if (G1 == 2'b01) begin
                    salida_1_1 = Agua;
                end else if (G1 == 2'b10) begin
                    salida_1_2 = Agua;
                end
            end
            S2: begin
                salida_1_1 = Agua;
                salida_1_2 = Agua;
                salida_2_1 = Agua;
                salida_2_2 = Agua;
            end
            S3: begin
                if (G2 == 2'b01) begin
                    salida_2_1 = Agua;
                end else if (G2 == 2'b10) begin
                    salida_2_2 = Agua;
                end
            end
            S4: begin
                if (G1 == 2'b01 || G2 == 2'b01) begin
                    salida_1_1 = Agua;
                    salida_2_1 = Agua;
                end else if (G1 == 2'b10 || G2 == 2'b10) begin
                    salida_1_2 = Agua;
                    salida_2_2 = Agua;
                end
            end
            S5: begin
                error = Error;
            end
            default: begin
                salida_1_1 = Stop;
                salida_1_2 = Stop;
                salida_2_1 = Stop;
                salida_2_2 = Stop;
                error = NE;
            end
        endcase
    end

    // Asignaciones finales a puertos de salida
    assign R1 = {salida_1_1, salida_1_2};
    assign R2 = {salida_2_1, salida_2_2};
    assign E  = error;

endmodule
