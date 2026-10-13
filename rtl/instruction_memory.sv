module instruction_memory (
    input logic [7:0] addr,

    output logic [15:0] instruction
);
    logic [15:0] instr_mem [0:255];

    initial begin
        $readmemh("programs/test.hex", instr_mem);
    end

    always_comb begin
        instruction = instr_mem[addr];
    end

endmodule