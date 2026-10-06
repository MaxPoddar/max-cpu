module register_file_tb;

    logic clk;
    logic write_enable;
    logic [2:0] read_addr_a;
    logic [2:0] read_addr_b;
    logic [2:0] write_addr;
    logic [7:0] write_data;
    logic [7:0] read_data_a;
    logic [7:0] read_data_b; 

    register_file dut (
        .clk(clk),
        .write_enable(write_enable),
        .read_addr_a(read_addr_a),
        .read_addr_b(read_addr_b),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_data_a(read_data_a),
        .read_data_b(read_data_b)
    );

    always #5 clk = ~clk;
    
    initial begin

        // Initial values
        clk = 0;
        write_enable = 0;
        read_addr_a = 3'b000;
        read_addr_b = 3'b000;
        write_addr = 3'b000;
        write_data = 8'd0;

        // Write 5 into R1
        write_enable = 1;
        write_addr = 3'b001;
        write_data = 8'd5;

        @(posedge clk);

        // Read R1
        read_addr_a = 3'b001;
        #1;
        if (read_data_a !== 8'd5)
            $error("Read and Write R1: FAIL -- expected 5, got %0d", read_data_a);
        else
            $display("Read and Write R1: PASS");

        // Write 42 into R2
        write_addr = 3'b010;
        write_data = 8'd42;

        @(posedge clk);

        // Read R2
        read_addr_a = 3'b010;
        #1;
        if (read_data_a !== 8'd42)
            $error("Read and Write R2: FAIL -- expected 42, got %0d", read_data_a);
        else
            $display("Read and Write R2: PASS");

        // Read R1 and R2 together
        read_addr_a = 3'b001;
        read_addr_b = 3'b010;

        #1;
        if (read_data_a !== 8'd5 || read_data_b !== 8'd42)
            $error("Dual Read: FAIL -- expected R1 = 5 and R2 = 42, got R1 = %0d and R2 = %0d", read_data_a, read_data_b);
        else
            $display("Dual Read: PASS");

        // Write and Read R7
        write_addr = 3'b111;
        write_data = 8'd47;
        
        @(posedge clk);

        read_addr_a = 3'b111;
        #1;
        if (read_data_a !== 8'd47)
            $error("Read and Write R7: FAIL -- expected 47, got %0d", read_data_a);
        else
            $display("Read and Write R7: PASS");


        // Check write_enable = 0
        write_enable = 0;
        write_addr = 3'b001;
        write_data = 8'd99;

        @(posedge clk);

        read_addr_a = 3'b001;
        #1;

        if (read_data_a !== 8'd5)
            $error("Disabled write enable: FAIL -- expected 5, got %0d", read_data_a);
        else
            $display("Disabled write enable: PASS");


        $finish;
    end


endmodule