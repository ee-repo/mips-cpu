/*
 * Implementation of Data memory module
 */
module module_data_memory #(parameter WORD_SIZE=32, ADDRESS_BITS=32, MEMORY=1024)
                           (input clk, wr_en,
                            input [ADDRESS_BITS-1:0] addr,
                            input [WORD_SIZE-1:0] data_in,
                            output reg [WORD_SIZE-1:0] data_out);

    // Actual Memory declaration
    reg [WORD_SIZE-1:0] mem [MEMORY - 1 : 0];

    // Write to memory if WR_EN is TRUE
    always @(posedge clk) begin
      if (wr_en) data_out <= mem[addr];
      else mem[addr] <= data_in;
    end
endmodule

/*
 * Implementation of Instruction memory module
 */
module module_instruction_memory #(parameter ADDRESS_BITS=32, MEMORY=1024, WORD_SIZE=32)
                                  (input clk,
                                   input [ADDRESS_BITS-1:0] addr,
                                   input wr_en,
                                   input [WORD_SIZE-1:0] code,
                                   output reg [WORD_SIZE-1:0] instruction);

    // Create the memory
    reg [WORD_SIZE-1:0] instruction_memory [0:MEMORY-1];

    // Write the instruction to output or save an incoming port.
    always @(posedge clk) begin
        if (wr_en) instruction_memory[addr] <= code;
        else instruction <= instruction_memory[addr];
    end
endmodule

/*
 * Implementation of Register bank
 */
module module_register_bank #(parameter REGISTER_COUNT=32, REGISTER_WIDTH=32, ADDRESS_BITS=5)
                             (input clk,
                              input [ADDRESS_BITS-1:0] rd_addr_1, rd_addr_2, wr_addr,
                              input wr_en,
                              input [REGISTER_WIDTH-1:0] data_in,
                              output reg [REGISTER_WIDTH-1:0] d_out_1, d_out_2);

    // Create a Register Bank
    reg [REGISTER_WIDTH-1:0] reg_file [0:REGISTER_COUNT-1];

    always @(posedge clk) begin
        // Output the content of the selected registers
        d_out_1 <= reg_file[rd_addr_1];
        d_out_2 <= reg_file[rd_addr_2];

        // Last register is always Zero!
        reg_file[REGISTER_COUNT-1] <= 0;

        // Load in the appropriate register when wr_en is true
        if (wr_en) reg_file[wr_addr] <= data_in;
    end
endmodule