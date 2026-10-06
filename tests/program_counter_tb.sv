module program_counter_tb;

    logic clk;
    logic reset;
    logic load;
    logic [7:0] next_pc;
    logic [7:0] pc;

    program_counter dut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .next_pc(next_pc),
        .pc(pc)
    );

    always #5 clk = ~clk;

    initial begin

        // Initial values
        clk = 0;
        reset = 0;
        load = 0;
        next_pc = 8'b00000000;

        // Reset
        reset = 1;
        @(posedge clk);
        #1;
        if (pc !== 8'd0)
            $error("Reset: FAIL -- expected 0, got %0d", pc);
        else
            $display("Reset: PASS");

        // Normal increment
        reset = 0;
        @(posedge clk);
        #1;
        if (pc !== 8'd1)
            $error("Increment: FAIL -- expected 1, got %0d", pc);
        else
            $display("Increment: PASS");

        // Load
        load = 1;
        next_pc = 8'd43;
        @(posedge clk);
        #1;
        if (pc !== 8'd43)
            $error("Load: FAIL -- expected 43, got %0d", pc);
        else
            $display("Load: PASS");

        // Normal increment after load
        load = 0;
        @(posedge clk);
        #1;
        if (pc !== 8'd44)
            $error("Increment after load: FAIL -- expected 44, got %0d", pc);
        else
            $display("Increment after load: PASS");

        // Check reset overwrites load = 1
        reset = 1;
        load = 1;
        @(posedge clk);
        #1;
        if (pc !== 8'd0)
            $error("Reset vs Load: FAIL -- expected 0, got %0d", pc);
        else
            $display("Reset vs Load: PASS");

        $finish;
    end

endmodule





