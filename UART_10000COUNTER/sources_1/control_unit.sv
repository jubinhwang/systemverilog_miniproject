`timescale 1ns / 1ps

module control_unit #(
    parameter AWIDTH = 3
) (
    input  logic              clk,
    input  logic              rst,
    input  logic              rd,
    input  logic              wr,
    output logic [AWIDTH-1:0] waddr,
    output logic [AWIDTH-1:0] raddr,
    output logic              full,
    output logic              empty
);

    logic [AWIDTH-1:0] waddr_reg, waddr_next;
    logic [AWIDTH-1:0] raddr_reg, raddr_next;

    logic full_reg, full_next;
    logic empty_reg, empty_next;

    assign waddr = waddr_reg;
    assign raddr = raddr_reg;
    assign full  = full_reg;
    assign empty = empty_reg;

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            waddr_reg <= 0;
            raddr_reg <= 0;
            full_reg  <= 1'b0;
            empty_reg <= 1'b1;
        end else begin
            waddr_reg <= waddr_next;
            raddr_reg <= raddr_next;
            full_reg  <= full_next;
            empty_reg <= empty_next;
        end
    end

    always_comb begin
        waddr_next = waddr_reg;
        raddr_next = raddr_reg;
        full_next  = full_reg;
        empty_next = empty_reg;
        case ({
            wr, rd
        })
            2'b01: begin
                // pop
                if (!empty_reg) begin
                    raddr_next = raddr_reg + 1;
                    full_next  = 0;
                    if (waddr_reg == raddr_next) begin
                        empty_next = 1'b1;
                    end
                end
            end
            2'b10: begin
                // push
                if (!full_reg) begin
                    waddr_next = waddr_reg + 1;
                    empty_next = 0;
                    if (waddr_next == raddr_reg) begin
                        full_next = 1'b1;
                    end
                end
            end
            2'b11: begin
                // push, pop
                if (full_reg) begin
                    // pop
                    raddr_next = raddr_reg + 1;
                    full_next  = 1'b0;
                end else if (empty_reg) begin
                    // push
                    waddr_next = waddr_reg + 1;
                    empty_next = 1'b0;
                end else begin
                    waddr_next = waddr_reg + 1;
                    raddr_next = raddr_reg + 1;
                end
            end
            default: begin

            end
        endcase
    end

endmodule
