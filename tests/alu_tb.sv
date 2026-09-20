module alu_tb;

    logic [7:0] a;
    logic [7:0] b;
    logic [2:0] op;
    logic [7:0] result;
    logic zero;

    alu dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero)
    );

    initial begin
        a = 8'd10;
        b = 8'd3;

        op = 3'b000;
        #10;
        $display("ADD: %0d + %0d = %0d", a, b, result);

        op = 3'b001;
        #10;
        $display("SUB: %0d - %0d = %0d", a, b, result);

        op = 3'b010;
        #10;
        $display("AND: result = %b", result);

        op = 3'b011;
        #10;
        $display("OR: result = %b", result);

        op = 3'b100;
        #10;
        $display("XOR: result = %b", result);

        a = 3'd5;
        b = 3'd5;
        op = 3'b001;
        #10
        $display("ZERO TEST: result=%0d zero=%b", result, zero);

        $finish;
    end

endmodule   