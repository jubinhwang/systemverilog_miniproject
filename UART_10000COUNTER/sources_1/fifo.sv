`timescale 1ns / 1ps

module fifo (
    input  logic       clk,
    input  logic       rst,
    input  logic       push,
    input  logic       pop,
    input  logic [7:0] wdata,
    output logic       empty,
    output logic       full,
    output logic [7:0] rdata
);

    logic [2:0] l_waddr, l_radder;

    control_unit U_CU_SRAM (
        .clk  (clk),
        .rst  (rst),
        .rd   (pop),
        .wr   (push),
        .waddr(l_waddr),
        .raddr(l_radder),
        .full (full),
        .empty(empty)
    );

    ram U_SRAM (
        .clk     (clk),
        .waddress(l_waddr),
        .raddress(l_radder),
        .w_en    (~full & push),
        .wdata   (wdata),
        .rdata   (rdata)
    );

endmodule
