module program_counter (
    input logic clk,
    input logic reset,
    input logic load,
    input logic [7:0] next_pc,

    output logic [7:0] pc
);
    always_ff @( posedge clk ) begin
        if (reset) begin
            pc <= 8'd0;
        end
        else if (load) begin
            pc <= next_pc;      //jump (eg branch)
        end
        else begin
            pc <= pc + 1;
        end
    end


endmodule