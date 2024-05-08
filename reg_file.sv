// cache memory/register file
module register_file(
    input clk,
	input [1:0] reg_dest1,
    input [2:0] reg_dest2,  
    input [1:0] reg_src1,   
    input [2:0] reg_src2, 
    input [7:0] data_in, 
	input read_enable,
    input write_enable, 
    output [7:0] data_out1,
    output [7:0] data_out2 );

	reg [7:0] registers[7:0];

	// combinational reading
	always @(*) begin
		if (read_enable) begin
			data_out1 <= registers[reg_src1];  
			data_out2 <= registers[reg_src2];  
		end else begin
			data_out1 = 8'bZ; 
            data_out2 = 8'bZ; 
        end
	end

	// sequential writing
	always_ff @(posedge clk) begin
		if (write_enable) begin
			registers[reg_dest1] <= data_in;
			registers[reg_dest2] <= data_in;
		end
	end

endmodule
