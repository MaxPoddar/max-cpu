module instruction_decoder_tb;

    logic [15:0] instruction;
    logic [3:0] opcode;
    logic [2:0] rD;
    logic [2:0] rA;
    logic [2:0] rB;
    logic [7:0] imm8;

    instruction_decoder dut (
        .instruction(instruction),
        .opcode(opcode),
        .rD(rD),
        .rA(rA),
        .rB(rB),
        .imm8(imm8)
    );

    initial begin

        // instruction: ADD r3, r1, r2 (16'h0650)
        instruction = 16'h0650;
        #1;
        if (opcode !== 4'b0000 || rD !== 3'b011 || rA !== 3'b001 || rB !== 3'b010)
            $error("ADD: FAIL -- expected 0000 011 001 010, got %b %b %b %b", opcode, rD, rA, rB);
        else
            $display("ADD: PASS");

        // instruction: LOADI r3, 42
        instruction = 16'b0110011000101010;
        #1;
        if (opcode !== 4'b0110 || rD !== 3'b011 || imm8 !== 8'd42)
            $error("LOADI: FAIL -- expected 0110 011 00101010, got %b %b %b", opcode, rD, imm8);
        else
            $display("LOADI: PASS");

        // instruction: JMP 12
        instruction = 16'b1001000000001100;
        #1;
        if (opcode !== 4'b1001 || imm8 !== 8'd12)
            $error("JMP: FAIL -- expected 1001 00001100, got %b %b", opcode, imm8);
        else
            $display("JMP: PASS");

        $finish;
    end
endmodule