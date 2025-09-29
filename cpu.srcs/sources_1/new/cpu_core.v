`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2025 05:17:25 PM
// Design Name: 
// Module Name: cpu_core
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

////////
//if ALU - 
//      [4:0] OPCODE
//      [10:5] RESERVED
//      [13:11] DEST REG (R1...R7)
//      [15:14] RESERVED
//      [18:16] ALU OP2
//      [20:19] RESERVED
//      [23:21] ALU OP1
//      [25:24] RESERVED
//      [26] IMM op1 ?
//      [27] THROW op2 ?
//      [31:28] DEST REG2 (R1...R7)



//if LOAD - R -> R
//      [4:0] OPCODE
//      [10:5] RESERVED
//      [13:11] DEST REG
//      [15:14] RESERVED
//      [18:16] SOURCE REG
//      [20:19] RESERVED

// if MEM->R or R-> MEM
//      [4:0] OPCODE
//      [10:5] RESERVED
//      [13:11] DEST/SRC REG
//      [15:14] RESERVED

//if val ->IMM
//      [4:0] OPCODE
//      [10:5] RESERVED
//      [26:11] val


module cpu_core( //will add more outputs for debug led feature
    input sys_clk,
    input reset,
    output result
    );
    
    
    //first part of this module is just declaring the different alu components, as well as 
    //instantiating ip cores for ROM and RAM
    
    reg alu_op1;
     reg alu_op2;
     reg alu_start;    
     reg alu_ack;        
     reg [4:0] alu_opcode;
     
     wire [31:0] alu_out1;
     wire [31:0] alu_out2;
     wire [3:0] alu_flags;
     wire alu_div_by_zero;
     wire alu_done;
     
     
     alu cpu_alu(
        .clk(sys_clk),
        .reset(reset),
        .start(alu_start),
        .ack(alu_ack),
        .opcode(alu_opcode),
        .op1(alu_op1),
        .op2(alu_op2),
        .fout1(alu_out1),
        .fout2(alu_out2),
        .fflags(alu_flags),
        .div_by_zero(alu_div_by_zero),
        .done(alu_done)
        
     );
     
     
     
     reg ram_rst;
     reg ram_en;
     reg [31:0] ram_addr;
     reg [3:0] ram_we;
     reg [31:0] ram_din;
     wire [31:0] dout;
     wire ram_rst_busy;
     
     
     blk_mem_gen_0 cpu_ram(
        .clka(sys_clk), 
        .rsta(ram_rst), 
        .ena(ram_en),
        .wea(ram_wea),
        .addra(ram_addr),
        .dina(ram_din),
        .douta(ram_dout),
        .rsta_busy(ram_rst_busy)
     
     );
     
     
     
     reg rom_en;
     reg [9:0] rom_addr;
     wire [31:0] rom_dout;
     cpu_rom cpu_rom(
        .clka(sys_clk),
        .ena(rom_en),
        .addra(rom_addr),
        .douta(roun_dout)  
     
     );
     
     
     //registers
     reg [31:0] regs [0:15];
     
     
     //general purpose
     parameter R1 = 4'd0;
     parameter R2 = 4'd2;
     parameter R3 = 4'd3;
     parameter R4 = 4'd4;
     parameter R5 = 4'd5;
     parameter R6 = 4'd6;
     parameter R7 = 4'd7;
     
     //special, cant write to directly, needs to be loaded from
     //other register
     parameter BP = 4'd8;
     parameter SI = 4'd9;
     parameter SP = 4'd10;
     parameter IMM = 4'd11;
         
     
     //will only be available in intermediate representation, only used for
     //in between steps. The assembly language will not have access to these
     parameter ADDR = 4'd12;
     parameter THROW = 4'd13;
     parameter EX1 = 4'd14;
     parameter EX2 = 4'd15;
     
     reg [31:0] inst_reg;
     
     
     //opcodes
     //opcodes less than 20 are for the alu
     parameter LIL = 5'd20; //load imm lower
     parameter LIU = 5'd21;
     parameter RTM = 5'd22; // reg to mem
     parameter MTR = 5'd23;//mem to register
     parameter RTR = 5'd24;//register to register
     parameter LAL = 5'd25; // load addr lower
     parameter LAU = 5'd26;
     parameter JMP  = 5'd27;//jump instructions
     parameter JNE = 5'd28;
     parameter JE  = 5'd29;
     parameter JGT = 5'd30;
     parameter JLT = 5'd31;
              
              
    //sattes         
    reg [1:0] state;
    
    parameter START = 2'b00;
    parameter WAITING = 2'b01;
    parameter ONE_DELAY = 2'b10;
    
    
    //since rom access takes one cycle, we do not want to wait an extra cycle every time,
    //so as long as the current instruction is not a jump one, we can just get the next one ready
    //in the mean time
    //however this means that the starting logic should be fixed so that we wait one cycle
    
    
    
    //NOTE TO SELF
    //if cur= jump instr and flag is set, check in this block?
    // work out timing to verify
    
    //ALSO - make first instruction (ROM entry) 32'b0, so and in main FSM, check if inst_reg == 0,
    //this way no need for first instruction logic due to first delay, very simple 
    //and only lose one clock cycle
    //it is also important to note here we are only updating the address, not changing the
    //inst_reg
    always @(posedge sys_clk or posedge reset) begin
        if (reset) rom_addr <=0;
        
        else if ((state == START) && (inst_reg < 27)) begin //if not a jump instr
            rom_addr <= rom_addr + 1;
        end
        //here, put the code handling jump instructions, it should be straightforward since
        //we get the jump instruction, and then when we go to check, ww fail the inst_reg < 27
        // then we check flags (which will have been set from prev op), and then
        //update accordingly
        
    end
    
    always @(posedge sys_clk or posedge reset) begin
    
        if (reset) begin
            state <= START; //reset rom address, and therefore instruction register as well
            
        end
        else begin
            
        end
        
            if(state == START) begin
                alu_ack <= 0;
                
                
                //set ram write enable to zero, unless we are going to write
                if(inst_reg[4:0] != RTM) ram_we = 4'b0;

                                
                if (inst_reg[4:0] < 20) begin
                //alu operation, give opcode and start instruction
                    alu_opcode <= inst_reg[4:0];
                    alu_start <= 1;
                    state <= WAITING;
                end
                //other cases
                case (inst_reg[4:0])
                    LIL: begin
                        //load lower bits of register with cooresponding value
                        regs[IMM][15:0] <= inst_reg[26:11];
                        inst_reg <= rom_dout;
                        //rom_addr <= rom_addr +1; //increment instruction pointer
                    end
                    
                    //same as above but for upper bits
                    LIU: begin
                        regs[IMM][31:16] <= inst_reg[26:11];
                        inst_reg <= rom_dout;
                        //rom_addr <= rom_addr +1; 
                    end
                    //register to memory
                    RTM: begin
                        //write enable all 4 bytes, 
                        //next version will have specific byte write enabled
                        ram_we <=4'b1111;
                        ram_en <= 1'b1;
                        //uses address register for where to write
                        ram_addr <= regs[ADDR];
                        
                        //data fed by registed designated by instructino
                        ram_din <= regs[inst_reg[13:11]];
                        inst_reg <= rom_dout;
                    end
                    MTR: begin
                    //write enable is 0 for read only
                        ram_we <= 4'b0;
                        ram_en <= 1'b1;
                        ram_addr <= regs[ADDR];
                        //we do not assign here since the data is not ready yet
                        state <= ONE_DELAY; //ram access takes one delay
                    end
                    
                    //
                    RTR: begin
                        regs[inst_reg[13:11]] <= regs[inst_reg[18:16]];
                        inst_reg <= rom_dout;
                    end
                    
                    //reset is a work in progress
                    LAL: begin
                        regs[ADDR][15:0] <= inst_reg[26:11];
                        inst_reg <= rom_dout;
                        
                    end
                    LAU: begin
                        regs[ADDR][31:16] <= inst_reg[26:11];
                        inst_reg <= rom_dout;

                    end
                    
//                    JNE: begin
//                    end
//                    JE : begin
//                    end
//                    JGT: begin
//                    end
//                    JLT: begin
//                    end
                
                endcase
                
            end
            
            else if (state == WAITING) begin
                alu_start <= 1'b0;
                if (alu_done) begin
                    regs[inst_reg[13:11]] <= alu_out1;
                    regs[inst_reg[31:28]] <= alu_out2;
                    inst_reg <= rom_dout;
                    state <= START;
                    
                                       
                end
                else begin
                    state <= WAITING;
                    regs[inst_reg[13:11]] <= ram_dout;
                    inst_reg <= rom_dout;
                end
                
            end
            else if (state == ONE_DELAY) begin
                
                    
            
            end
        
        
    end
        
    
    
          
     
     
     
     
     
     
     
     
     
     
  
    
endmodule







