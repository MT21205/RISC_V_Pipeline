`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2021 20:36:34
// Design Name: 
// Module Name: IF_ID_EX_MA_RW_Test_tb
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


module IF_ID_EX_MA_RW_Test_tb;

    reg clk;
    //wire[31:0] in_Addr;
    //reg isBranchTaken;
    
    wire[31:0] IF_Inst_Out;
    wire[31:0] IF_DE_Inst_out;
        
    wire[4:0] IF_DE_RS1_Addr_out;
    wire[4:0] IF_DE_RS2_Addr_out;
    wire[4:0] IF_DE_RD_Addr_out;
    
    //Inputs and nets for Register
    //reg Reg_Write_flag_In;
    //reg[31:0] RD_Data_In;
    
    wire[31:0] ID_RS1_Data_Out;
    wire[31:0] ID_RS2_Data_Out;
    
    //Inputs and nets for ID stage
    wire[31:0] ID_Imm_out;
    wire[31:0] ID_Inst_out;
    wire[4:0] ID_Inst_Type_out;
    wire[4:0] ID_RD_Addr_Out;
    
    //Inputs and nets for ID_EX Register
    wire[31:0] ID_EX_Inst_out;
    wire[31:0] ID_EX_A_out;
    wire[31:0] ID_EX_B_out;
    wire[31:0] ID_EX_Imm_Out;
    wire[4:0] ID_EX_Inst_Type_Out;
    wire[4:0] ID_EX_RD_Addr_Out;
    
    //Inputs and nets for EX Stage
    wire EX_isBranchTaken_Out;
    wire[31:0] EX_Result_Out;
    //wire[31:0] EX_Inst_Out;
    wire[31:0] EX_Operand_B_Out;
    wire[4:0] EX_Inst_Type_Out;
    wire[4:0] EX_RD_Addr_Out;
    
    //Inputs and nets for EX_MA Register
    wire[31:0] EX_MA_Result_Out;
    //wire[31:0] EX_MA_Inst_Out;
    wire[31:0] EX_MA_Operand_B_Out;
    wire[4:0] EX_MA_Inst_Type_Out;
    wire[4:0] EX_MA_RD_Addr_Out;
    
    //Inputs and nets for MA Stage
    wire[31:0] MA_Register_Data_Out;
    //wire[31:0] MA_Inst_Out;
    wire[4:0] MA_RD_Addr_Out;
    wire[4:0] MA_Inst_Type_Out;
    
    //Inputs and nets for MA_RW Register
    wire[31:0] MA_RW_Data_Out;
    //wire[31:0] MA_RW_Inst_Out;
    wire[4:0] MA_RW_Inst_Type_Out;
    wire[4:0] MA_RW_RD_Addr_Out;
    
    //Inputs and nets for RW Stage
    wire[31:0] RW_Data_Out;
    wire RW_Reg_Write_flag_Out;
    wire[4:0] RW_Dest_Reg_Addr_Out;
    
    IF Instruction_Fetch (
                            //Inputs
                            .in_Addr(EX_Result_Out), // Result from execte stage can have the branch address if the branch is taken.
                            .isBranchTaken(EX_isBranchTaken_Out), 
                            .clk(clk),
                            //Output 
                            .Inst_Out(IF_Inst_Out)
                            );
                            
    IF_DE_REG IF_DE_Register (
                               //Inputs
                                .clk(clk), 
                                .Inst_In(IF_Inst_Out),
                                .branch_kill_flag_In(EX_isBranchTaken_Out), 
                                //Outputs
                                .Inst_Out(IF_DE_Inst_out),
                                .RS1_Addr_out(IF_DE_RS1_Addr_out),
                                .RS2_Addr_out(IF_DE_RS2_Addr_out),
                                .RD_Addr_out(IF_DE_RD_Addr_out)
                                );
    Register_File Reg_File(
                            //Inputs
                            .Inst_In(IF_DE_Inst_out),
                            .Reg_Write_flag_In(RW_Reg_Write_flag_Out),
                            .RS1_Addr_In(IF_DE_RS1_Addr_out),
                            .RS2_Addr_In(IF_DE_RS2_Addr_out),
                            .RD_Addr_In(RW_Dest_Reg_Addr_Out),
                            .RD_Data_In(RW_Data_Out),
                            //Outputs
                            .RS1_Data_Out(ID_RS1_Data_Out),
                            .RS2_Data_Out(ID_RS2_Data_Out)
                            );
    ID Instruction_Decode(
                            //Inputs
                            .Inst_In(IF_DE_Inst_out),
                            .RD_Addr_In(IF_DE_RD_Addr_out),
                            //Outputs
                            .Imm_Data_Out(ID_Imm_out),
                            .Inst_Out(ID_Inst_out),
                            .Inst_Type_Out(ID_Inst_Type_out),
                            .RD_Addr_Out(ID_RD_Addr_Out)
                            );
    ID_EX_reg ID_EX_Register(
                            //inputs
                            .clk(clk),
                            .Inst_In(ID_Inst_out),
                            .Operand_A_val_In(ID_RS1_Data_Out),
                            .Operand_B_val_In(ID_RS2_Data_Out),
                            .Immx_Data_In(ID_Imm_out),
                            .Inst_Type_In(ID_Inst_Type_out),
                            .branch_kill_flag_In(EX_isBranchTaken_Out),
                            .RD_Addr_In(ID_RD_Addr_Out),
                            //outputs
                            .Inst_Out(ID_EX_Inst_out),
                            .Operand_A_val_Out(ID_EX_A_out),
                            .Operand_B_val_Out(ID_EX_B_out),
                            .Immx_Data_Out(ID_EX_Imm_Out),
                            .Inst_Type_Out(ID_EX_Inst_Type_Out),
                            .RD_Addr_Out(ID_EX_RD_Addr_Out)
                            );
                            
    EX Execute(
                //Inputs
                .Inst_In(ID_EX_Inst_out),
                .Operand_A_val_In(ID_EX_A_out),
                .Operand_B_val_In(ID_EX_B_out),
                .Immx_Data_In(ID_EX_Imm_Out),
                .Inst_Type_In(ID_EX_Inst_Type_Out),
                .RD_Addr_In(ID_EX_RD_Addr_Out),
                //Outputs
                .isBranchTaken_Out(EX_isBranchTaken_Out),
                .Result_Out(EX_Result_Out),
                //.Inst_Out(EX_Inst_Out),
                .Operand_B_Out(EX_Operand_B_Out),
                .Inst_Type_Out(EX_Inst_Type_Out),
                .RD_Addr_Out(EX_RD_Addr_Out)
                );
    
    EX_MA_reg EX_MA_Register(
                //Inputs
                //.isBranchTaken_Out(),
                .clk(clk),
                .Result_In(EX_Result_Out),
                //.Inst_In(EX_Inst_Out),
                .Inst_Type_In(EX_Inst_Type_Out),
                .Operand_B_In(EX_Operand_B_Out),
                .RD_Addr_In(EX_RD_Addr_Out),
                //Outputs
                .Result_Out(EX_MA_Result_Out),
                //.Inst_Out(EX_MA_Inst_Out),
                .Operand_B_Out(EX_MA_Operand_B_Out),
                .Inst_Type_Out(EX_MA_Inst_Type_Out),
                .RD_Addr_Out(EX_MA_RD_Addr_Out)
    );
    
    Data_Memory MA_Stage(
                    // Inputs
                    //.Inst_In(EX_MA_Inst_Out),
                    .Inst_Type_In(EX_MA_Inst_Type_Out),
                    .Store_Operand_B_Data_In(EX_MA_Operand_B_Out),
                    .Ld_Str_Addr_Reg_Result_In(EX_MA_Result_Out),
                    .RD_Addr_In(EX_MA_RD_Addr_Out),
                    //Outputs
                    .Register_Data_Out(MA_Register_Data_Out),
                    //.Inst_Out(MA_Inst_Out),
                    .RD_Addr_Out(MA_RD_Addr_Out),
                    .Inst_Type_Out(MA_Inst_Type_Out)
                    );
                    
    MA_RW_reg MA_RW_Register(
                //Inputs
                .clk(clk),
                .Data_In(MA_Register_Data_Out),
                //.Inst_In(MA_Inst_Out),
                .Inst_Type_In(EX_MA_Inst_Type_Out),
                .RD_Addr_In(MA_RD_Addr_Out),
                //Outputs
                .Data_Out(MA_RW_Data_Out),
                //.Inst_Out(MA_RW_Inst_Out),
                .Inst_Type_Out(MA_RW_Inst_Type_Out),
                .RD_Addr_Out(MA_RW_RD_Addr_Out)
                ); 
                
    RW Register_Writeback(
            //Inputs
            .Data_In(MA_RW_Data_Out),
            //.Inst_In(MA_RW_Inst_Out),
            .Inst_Type_In(MA_RW_Inst_Type_Out),
            .RD_Addr_In(MA_RW_RD_Addr_Out),
            //Outputs
            .Data_Out(RW_Data_Out),
            .Reg_Write_flag_Out(RW_Reg_Write_flag_Out),
            .Dest_Reg_Addr_Out(RW_Dest_Reg_Addr_Out)
            );
                    
    initial
    begin
        clk <= 1'd0;
    end
    
    always
        #5 clk <= ~clk;
        
    initial
    begin
        #2
        #160
                        
        $finish;
    end

endmodule
