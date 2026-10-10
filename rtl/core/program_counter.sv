// ===============================================================================================
// file name: program_counter ==> program counter
// function: points to the next instruction in a program. normally increases 
// by 4 (= 1 word), unless a jump is required.
// ===============================================================================================
  

module program_counter  import isa_pkg::*;(
    input logic                 clk,
    input logic                 rset_n,
    input logic                 mem_ready,
    input logic     [XLEN-1:0]  pc_next,
    output logic    [XLEN-1:0]  pc
);

    always_ff @ (posedge clk or negedge rset_n)
    begin
        if (!rset_n)
        pc <= 0;
        
        else if (mem_ready) // if the memory isn't ready, the PC is stalled
        pc <= pc_next;      // the next pc is decided by the Control Unit

        else;                // PC stall for 4 clk cycles
    end

endmodule





