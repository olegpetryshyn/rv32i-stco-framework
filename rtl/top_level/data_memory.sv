//==========================================================================================
// name: data_memory
// function: describes the behaviour of the memory containing data.
// It is divided in 2 parts:
// 1) Asynchronous reading (data memory is read combinationally)
// 2) Synchronous writing with a 4-clock-cycle STT-MRAM switching latency
//==========================================================================================

module data_memory import isa_pkg::*;
(
    input  logic             clk,
    input  logic             rset_n,         // active-low synchronous reset
    input  logic             we,             // write enable (dmem_we)
    input  logic [XLEN-1:0]  address,        // memory address (dmem_address)
    input  logic [XLEN-1:0]  wdata,          // data to write (dmem_wdata)
    output logic [XLEN-1:0]  rdata,          // data read (dmem_rdata)
    output logic             mem_ready       // handshake stall signal to core (0 = stall, 1 = ready)
);  

    logic [1:0]      lock_counter;           // counts 4 clock cycles (0 to 3)
    logic            busy;                   // flag indicating write transaction in progress
    logic [XLEN-1:0] memory_data [0: MEM_DEPTH-1];

    // synchronous writing logic (active on clock edge)
    always_ff @(posedge clk or negedge rset_n) begin
        if (!rset_n) begin          // idle state on reset
            lock_counter <= 2'b00;
            busy         <= 1'b0;
        end
        else begin
            if (we && !busy) 
            begin  // start new write transaction (cycle 1)
                busy         <= 1'b1;
                lock_counter <= 2'b01;
            end

            else if (busy) begin
                if (lock_counter == 2'b11) begin
                    // 4th cycle: MTJ switching complete, commit write and return to idle
                    lock_counter <= 2'b00;
                    busy         <= 1'b0;
                    memory_data[address >> 2] <= wdata; // word-aligned addressing (ignore 2 LSBs)
                end
                else begin 
                    // increment wait cycle counter
                    lock_counter <= lock_counter + 2'b01;
                end
            end
        end
    end

    // combinational ready generation to prevent 1-cycle delay on PC stall
    always_comb begin
        if (!busy)
            mem_ready = !we;
        else
            mem_ready = (lock_counter == 2'b11);
    end

    // asynchronous reading
    always_comb begin
        rdata = memory_data[address >> 2];
    end

endmodule
