//`timescale 1ns / 1ps

module tt_um_luis(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        ena,
    input  logic [7:0]  ui_in,
    input  logic [7:0]  uio_in,
    output logic [7:0]  uo_out,
    output logic [7:0]  uio_out,
    output logic [7:0]  uio_oe
);

    // Usar señales no utilizadas para evitar advertencias
    logic        unused_ena;
    logic [7:0]  unused_uio_in;

    assign unused_ena     = ena;
    assign unused_uio_in  = uio_in;

    // Módulo FSM conectado
    FSM FSM1(
        .clk(clk),
        .reset(rst_n),
        .G1(ui_in[1:0]),
        .G2(ui_in[3:2]),
        .A(ui_in[5:4]),
        .P(ui_in[7:6]),
        .E(uo_out[1:0]),
        .R1(uo_out[5:2]),
        .R2({uo_out[7:6],uio_out[1:0]})
    );

    // Asignar el resto de salidas que no se usan
    assign uio_out [7:2]    = 6'b0;
    assign uio_oe      = 8'b0;

endmodule
