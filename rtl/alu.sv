module alu (
    input logic [7:0] a,
    input logic [7:0] b,
    input logic [2:0] op,
    output logic [7:0] result,
    output logic zero
);

    always_comb begin
        case (op)
            3'b000: result = a + b;
            3'b001: result = a - b;
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            default: result = 8'b00000000;
        endcase

        zero = (result == 8'b00000000);
    end

endmodule
