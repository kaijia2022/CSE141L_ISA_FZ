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
    input write_enable, 
    output [7:0] data_out1,
    output [7:0] data_out2 );

	reg [7:0] registers[7:0];
	reg [7:0] ENTRY;
        logic [7:0] data_out2_intermediate;

	// combinational reading

	assign data_out1 = registers[reg_dest];  
	assign data_out2_intermediate = lea ? ENTRY : registers[reg_src];  
	assign data_out2 = mode ? immediate : data_out2_intermediate;

	// sequential writing
	always_ff @(posedge clk) begin
		if (write_enable) begin
			registers[reg_write] <= data_in;
		end
	end

endmodule
