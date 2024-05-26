// cache memory/register file
module reg_file(
    input clk,
    input mode,
    input lea,
    input [2:0] reg_dest,
    input [2:0] reg_src,   
    input [2:0] reg_write, 
    input [7:0] data_in,
    input [7:0] immediate, 
    input write_enable, regToReg, 
    output [7:0] data_out1,
    output [7:0] data_out2 );

	logic[7:0] registers[7:0];
	logic[7:0] ENTRY = 'b00000000;

	// combinational reading
	assign data_out1 = registers[reg_dest];  
	assign data_out2 = mode ? immediate : registers[reg_src];

	// sequential writing
	always_ff @(posedge clk) begin
		if (write_enable) begin
			if (regToReg) begin
				registers[reg_write] <= registers[reg_src];    //MOV reg to reg			
			end
			else if (lea) begin
				registers[reg_write] <= ENTRY;        //LEA
				
			end
			else 
				registers[reg_write] <= data_in;     //MOV mem to reg or ALUOut
		end
	end

endmodule
