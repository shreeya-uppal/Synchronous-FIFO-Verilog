module input_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = 4
)(
    input clk,
    input reset,
    input write_en,
    input read_en,
    input  [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output full,
    output empty
);

reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

reg [ADDR_WIDTH-1:0] write_ptr;
reg [ADDR_WIDTH-1:0] read_ptr;

reg [ADDR_WIDTH:0] count;

// WRITE OPERATION
always @(posedge clk or posedge reset)
begin
    if(reset)
        write_ptr <= 0;
    else if(write_en && !full)
    begin
        mem[write_ptr] <= data_in;
        write_ptr <= write_ptr + 1;
    end
end

// READ OPERATION
always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        read_ptr <= 0;
        data_out <= 0;
    end
    else if(read_en && !empty)
    begin
        data_out <= mem[read_ptr];
        read_ptr <= read_ptr + 1;
    end
end

// COUNTER
always @(posedge clk or posedge reset)
begin
    if(reset)
        count <= 0;
    else
    begin
        case({write_en && !full, read_en && !empty})
            2'b10: count <= count + 1;
            2'b01: count <= count - 1;
            default: count <= count;
        endcase
    end
end

assign full  = (count == DEPTH);
assign empty = (count == 0);

endmodule
