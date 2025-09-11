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


//if LOAD - R -> R
//      [4:0] OPCODE
//      [10:5] RESERVED
//      [13:11] DEST REG
//      [15:14] RESERVED
//      [18:16] SOURCE REG
//      [20:19] RESERVED




module cpu_core(
    input sys_clk,
    input reset,
    output result
    );
    
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
     wire [31:0] inst_reg;
     cpu_rom cpu_rom(
        .clka(sys_clk),
        .ena(rom_en),
        .addra(rom_addr),
        .douta(inst_reg)  
     
     );
     
     
     
     reg [31:0] regs [0:10];
     
     parameter R1 = 4'd0;
     parameter R2 = 4'd2;
     parameter R3 = 4'd3;
     parameter R4 = 4'd4;
     parameter R5 = 4'd5;
     parameter R6 = 4'd6;
     parameter R7 = 4'd7;
     
     parameter BP = 4'd8;
     parameter SI = 4'd9;
     parameter SP = 4'd10;
     parameter IM = 4'd11;
     
     parameter ADDR = 4'd12;
     parameter THROW = 4'd13;
     parameter EX1 = 4'd14;
     parameter EX2 = 4'd15;
     
     //opcodes
     parameter LIL = 5'd20; //load imm lower
     parameter LIU = 5'd21;
     parameter RTM = 5'd22; // reg to mem
     parameter MTR = 5'd23;
     parameter RTR = 5'd24;
     parameter LAL = 5'd25; // load addr lower
     parameter JAU = 5'd26;
     parameter JZ  = 5'd27;
     parameter JNE = 5'd28;
     parameter JE  = 5'd29;
     parameter JGT = 5'd30;
     parameter JLT = 5'd31;
               
    reg [1:0] state;
    
    parameter START = 2'b00;
    parameter WAITING = 2'b01;
    
    
    always @(posedge sys_clk or posedge reset) begin
    
        if (reset) begin
            rom_addr <= 0;
            
        end
        else begin
        
            if(state == START) begin
                if (inst_reg[4:0] < 20) begin
                    alu_start <= 1;
                    state <= WAITING;
                end
                case (inst_reg[4:0])
                    LIL: begin
                        
                    end
                    LIL: begin
                    end
                    LIU: begin
                    end
                    RTM: begin
                    end
                    MTR: begin
                    end
                    RTR: begin
                    end
                    LAL: begin
                    end
                    JAU: begin
                    end
                    JZ : begin
                    end
                    JNE: begin
                    end
                    JE : begin
                    end
                    JGT: begin
                    end
                    JLT: begin
                    end
                
                endcase
                
            end
            
            if (state == WAITING) begin
                alu_start <= 1'b0;
                if (alu_done) begin
                    regs[
                    
                end
                else begin
                    state <= WAITING;
                end
                
            end
        
        
        end
        
    
    end
          
     
     
     
     
     
     
     
     
     
     
  
    
endmodule







