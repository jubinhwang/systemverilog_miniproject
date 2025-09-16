`timescale 1ns / 1ps
module ram #(    
    parameter AWIDTH =3
)(
    input  logic       clk,
    input  logic       w_en,
    input  logic [7:0] wdata,
    input  logic [AWIDTH-1:0] waddress,
    input  logic [AWIDTH-1:0] raddress,
    output logic [7:0] rdata
);

    logic [7:0] ram[0:2**AWIDTH-1];

    assign rdata = ram[raddress];

    always_ff @(posedge clk) begin
        if (w_en) begin
            ram[waddress] <= wdata;
        end
    end

endmodule
