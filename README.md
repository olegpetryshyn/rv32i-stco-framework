# rv321i Memory implementation
This project is based on the base of the single core implementation used in: rv32i-singlecycle-core.
integrating asymmetric non-volatile memory latency and physical scaling models.

There will be 2 implementation used and confronted to the base model in terms of power and efficiency:
- STT-MRAM
- Josephson Junction (temperature = 4 K) 

## STT-MRAM
This type of memory is based on magnetic random access memory, a new emerging type of fast memory wich uses magnetic junction to achieve high speed and good endurance (see more at: https://www.ramxeed.com/tech-column/mram-in-memory-computing/). 

This type of memory has a very **fast read time**, but a **slower write time** (**4 clk cycles**), so the implementation has to account for an additional variable (called '''mem_ready''' in this case) wich signals if the memory is ready to recieve the new information. In case the variable is 0, the PC has to stop (stalling time) to      






David A. Patterson, John L. Hennessy — "Computer Organization and Design RISC-V Edition: The Hardware Software  Interface"
Sarah L. Harris, David Harris — "Digital Design and Computer Architecture: RISC-V Edition" (Morgan Kaufmann) 
[specifiche di Bus Standard per SoC (Wishbone B4 & ARM AMBA APB/AXI)](https://github.com/pbing/ibex_wb)
