module alu_tb;

    logic [7:0] a;
    logic [7:0] b;
    logic [2:0] op;
    logic [7:0] result;
    logic zero;

    //Device Under Test (connect to a port)
    alu dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero)
    );

    initial begin

        // Initial values
        a = 8'd10;
        b = 8'd6;

        // ADD
        op = 3'b000;
        #1;
        if (result !== 8'd16)
            $error("ADD: FAIL -- expected 16, got %0d", result);
        else
            $display("ADD: PASS");

        // SUB
        op = 3'b001;
        #1;
        if (result !== 8'd4)
            $error("SUB: FAIL -- expected 4, got %0d", result);
        else
            $display("SUB: PASS");

        // AND
        op = 3'b010;
        #1;
        if (result !== 8'b00000010)
            $error("AND: FAIL -- expected 00000010, got %b", result);
        else
            $display("AND: PASS");

        // OR
        op = 3'b011;
        #1;
        if (result !== 8'b00001110)
            $error("OR: FAIL -- expected 00001110, got %b", result);
        else
            $display("OR: PASS");

        // XOR
        op = 3'b100;
        #1;
        if (result !== 8'b00001100)
            $error("XOR: FAIL -- expected 00001100, got %b", result);
        else
            $display("XOR: PASS");

        // Test if result = 0 -> zero flag = 1
        a = 8'd5;
        b = 8'd5;
        op = 3'b001;
        #1;
        if (zero !== 1'b1)
            $error("Zero: FAIL -- expected 1, got %b", zero);
        else
            $display("Zero: PASS");
        
        // Test if result != 0 -> zero flag = 0
        op = 3'b000;
        #1;
        if (zero !== 1'b0)
            $error("Non zero: FAIL -- expected 0, got %b", zero);
        else
            $display("Non zero: PASS");

        // Invalid op code
        op = 3'b111;
        #1;
        if (result !== 8'd0)
            $error("Invalid op: FAIL -- expected 0, got %0d", result);
        else
            $display("Invalid op: PASS");

        $finish;
    end

endmodule   