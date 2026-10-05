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

        // Initial vals
        clk = 0;
        reset = 0;
        load = 0;
        next_pc = 8'b00000000;

        // Reset
        reset = 1;
        @(posedge clk);
        #1;
        $display("Reset PC: %0d", pc);

        // Normal increment
        reset = 0;
        @(posedge clk);
        #1;
        $display("Increment PC by 1: %0d", pc);

        // Load
        load = 1;
        next_pc = 8'd43;
        @(posedge clk);
        #1;
        $display("Load: %0d", pc);

        // Normal increment after load
        load = 0;
        @(posedge clk);
        #1;
        $display("Load incremented: %0d", pc);

        // Check reset overwrites load = 1
        reset = 1;
        load = 1;
        @(posedge clk);
        #1;
        $display("Reset vs Load: %0d", pc);

        $finish;
    end

endmodule





