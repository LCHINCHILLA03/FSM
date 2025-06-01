//`timescale 100ns / 1ps

module FSM(
    input  logic clk, reset,
    input  logic [1:0] G1, G2, A, P,
    output logic [1:0] R1, R2, E
);

    logic [1:0] NP, O;

    // Instancia del FSM de niveles de agua
    FSM_Niveles Nivel_Agua(.clk(clk), .reset(reset), .A(A), .P(P), .C(O), .Pout(NP));

    typedef enum logic [2:0] {S0, S1, S2, S3, S4, S5} statetype;
    statetype state, nextstate;

    typedef enum logic [1:0] {Stop = 2'b00, Agua = 2'b11} outtype;
    typedef enum logic [1:0] {Error = 2'b11, NE = 2'b00} errortype;

    logic [1:0] salida_1, salida_2;
    logic [1:0] error;

    // Registro de estado
    always_ff @(posedge clk or posedge reset) begin
        if (reset) state <= S0;
        else state <= nextstate;
    end

    // Lógica de transición de estados
    always_comb begin
        nextstate = S0;  // valor por defecto
        if (O != 2'b00 || NP != 2'b00) begin
            nextstate = S5;
        end else begin
            unique case (state)
                S0, S1, S2, S3, S4, S5: begin
                    if (G1 == 2'b00 && G2 == 2'b00)
                        nextstate = S0;
                    else if ((G1 == 2'b01 || G1 == 2'b10) && G2 == 2'b00)
                        nextstate = S1;
                    else if (G1 == 2'b11 || G2 == 2'b11)
                        nextstate = S2;
                    else if ((G2 == 2'b01 || G2 == 2'b10) && G1 == 2'b00)
                        nextstate = S3;
                    else if ((G1 != 2'b00) && (G2 != 2'b00))
                        nextstate = S4;
                end
                default: nextstate = S0;
            endcase
        end
    end

    // Lógica de salida
    always_comb begin
        salida_1 = Stop;
        salida_2 = Stop;
        error = NE;

        unique case (state)
            S1: begin
                if (G1 == 2'b01)
                    salida_1 = 2'b01;
                else if (G1 == 2'b10)
                    salida_1 = 2'b10;
            end
            S2: begin
                salida_1 = Agua;
                salida_2 = Agua;
            end
            S3: begin
                if (G2 == 2'b01)
                    salida_2 = 2'b01;
                else if (G2 == 2'b10)
                    salida_2 = 2'b10;
            end
            S4: begin
                case ({G1, G2})
                    {2'b01, 2'b01}: begin salida_1 = 2'b01; salida_2 = 2'b01; end
                    {2'b01, 2'b10}: begin salida_1 = 2'b01; salida_2 = 2'b10; end
                    {2'b01, 2'b11}: begin salida_1 = 2'b01; salida_2 = Agua; end
                    {2'b10, 2'b01}: begin salida_1 = 2'b10; salida_2 = 2'b01; end
                    {2'b10, 2'b10}: begin salida_1 = 2'b10; salida_2 = 2'b10; end
                    {2'b10, 2'b11}: begin salida_1 = 2'b10; salida_2 = Agua; end
                    default: begin salida_1 = Stop; salida_2 = Stop; end
                endcase
            end
            S5: begin
                salida_1 = Stop;
                salida_2 = Stop;
                error = Error;
            end
        endcase
    end

    assign R1 = salida_1;
    assign R2 = salida_2;
    assign E = error;

endmodule

