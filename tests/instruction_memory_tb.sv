module instruction_memory_tb;

    logic [7:0] addr;
    logic [15:0] instruction;

    instruction_memory dut (
        .addr(addr),
        .instruction(instruction)
    );

    initial begin

        // Testing if $readmemh correctly loaded values into instruction memory
        addr = 8'd0;
        #1;
        if (instruction !== 16'h6205)
            $error("Addr0 check: FAIL -- expected 0x6205, got %h", instruction);
        else
            $display("Addr0 check: PASS");

        addr = 8'd1;
        #1;
        if (instruction !== 16'h6403)
            $error("Addr1 check: FAIL -- expected 0x6403, got %h", instruction);
        else
            $display("Addr1 check: PASS");

        addr = 8'd2;
        #1;
        if (instruction !== 16'h0650)
            $error("Addr2 check: FAIL -- expected 0x0650, got %h", instruction);
        else
            $display("Addr2 check: PASS");

        addr = 8'd3;
        #1;
        if (instruction !== 16'hB000)
            $error("Addr3 check: FAIL -- expected 0xB000, got %h", instruction);
        else
            $display("Addr3 check: PASS");
        
        $finish;
    
    end
endmodule