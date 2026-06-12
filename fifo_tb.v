module fifo_tb;

reg clk;
reg reset;
reg write_en;
reg read_en;
reg [7:0] data_in;

wire [7:0] data_out;
wire full;
wire empty;

/////////////////////////////////////////////////
// Instantiate FIFO
/////////////////////////////////////////////////

input_fifo uut (
    .clk(clk),
    .reset(reset),
    .write_en(write_en),
    .read_en(read_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);

/////////////////////////////////////////////////
// Clock generation (10 ns period)
/////////////////////////////////////////////////

always #5 clk = ~clk;

/////////////////////////////////////////////////
// Test sequence
/////////////////////////////////////////////////

integer i;

initial begin

clk = 0;
reset = 1;
write_en = 0;
read_en = 0;
data_in = 0;

#20
reset = 0;

write_en = 1;

for(i = 0; i < 16; i = i + 1)
begin
    #10 data_in = i + 8'h10;
end

#10
write_en = 0;

#20

read_en = 1;

for(i = 0; i < 8; i = i + 1)
begin
    #10;
end

#10
read_en = 0;

#50
$finish;

end

endmodule
