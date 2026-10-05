module register_file (
    input logic clk,
    input logic write_enable,
    input logic [1:0] read_addr_a,
    input logic [1:0] read_addr_b,
    input logic [1:0] write_addr,
    input logic [7:0] write_data,

    output logic [7:0] read_data_a,
    output logic [7:0] read_data_b

);
    logic [7:0] registers [0:3];

    always_ff @( posedge clk ) begin
        if (write_enable) begin
            registers[write_addr] <= write_data;
        end     
    end

    always_comb begin
        read_data_a = registers[read_addr_a];
        read_data_b = registers[read_addr_b];
    end
endmodule