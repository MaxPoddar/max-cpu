module register_file_tb;

    logic clk;
    logic write_enable;
    logic [1:0] read_addr_a;
    logic [1:0] read_addr_b;
    logic [1:0] write_addr;
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
        read_addr_a = 2'b00;
        read_addr_b = 2'b00;
        write_addr = 2'b00;
        write_data = 8'd0;

        // Write 5 into R1
        write_enable = 1;
        write_addr = 2'b01;
        write_data = 8'd5;

        #10;

        // Read R1
        read_addr_a = 2'b01;
        #1;

        $display("R1 = %0d", read_data_a);


        // Write 42 into R2
        write_addr = 2'b10;
        write_data = 8'd42;

        #10;

        // Read R2
        read_addr_a = 2'b10;
        #1;

        $display("R2 = %0d", read_data_a);

        // Read R1 and R2 together
        read_addr_a = 2'b01;
        read_addr_b = 2'b10;

        #1;

        $display(
            "R1 = %0d, R2 = %0d",
            read_data_a,
            read_data_b
        );


        // Check write_enable = 0
        write_enable = 0;
        write_addr = 2'b01;
        write_data = 8'd99;

        #10;

        read_addr_a = 2'b01;
        #1;

        $display(
            "R1 after disabled write = %0d",
            read_data_a
        );

        $finish;
    end


endmodule