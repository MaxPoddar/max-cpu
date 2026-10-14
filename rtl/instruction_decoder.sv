module instruction_decoder (
    input logic [15:0] instruction,

    output logic [3:0] opcode,
    output logic [2:0] rD,
    output logic [2:0] rA,
    output logic [2:0] rB,
    output logic [7:0] imm8
);

        assign opcode = instruction[15:12];
        assign rD = instruction[11:9];
        assign rA = instruction[8:6];
        assign rB = instruction[5:3];
        assign imm8 = instruction[7:0];

endmodule