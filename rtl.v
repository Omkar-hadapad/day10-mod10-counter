//======================================================
// DAY 10 - MOD-10 (DECADE) COUNTER
// Synchronous and Asynchronous Reset
//======================================================


//======================================================
// 1. D FLIP-FLOP WITH SYNCHRONOUS RESET
//======================================================

module dff_sync_reset (
    input  clk,
    input reset,
    input d,
    output reg q
);

always @(posedge clk)
begin
    if (reset)
        q <= 1'b0;
    else
        q <= d;
end

endmodule


//======================================================
// 2. D FLIP-FLOP WITH ASYNCHRONOUS RESET
//======================================================

module dff_async_reset (
    input clk,
    input reset,
    input d,
    output reg q
);

always @(posedge clk or posedge reset)
begin
    if (reset)
        q <= 1'b0;
    else
        q <= d;
end

endmodule


//======================================================
// 3. MOD-10 NEXT-STATE LOGIC
//======================================================
// Current count 0 to 8 -> count + 1
// Current count 9     -> 0
//
// Invalid states 10-15 are also forced to 0.
//======================================================

module mod10_next_state (
    input  [3:0] count,
    output reg [3:0] next_count
);

always @(*)
begin
    if (count == 4'd9)
        next_count = 4'd0;

    else if (count >= 4'd10)
        next_count = 4'd0;

    else
        next_count = count + 4'd1;
end

endmodule


//======================================================
// 4. MOD-10 COUNTER WITH SYNCHRONOUS RESET
//======================================================

module mod10_counter_sync (
    input clk,
    input reset,
    output [3:0] count
);

wire [3:0] next_count;

mod10_next_state NEXT_LOGIC (
    .count(count),
    .next_count(next_count)
);


// Four D flip-flops form the 4-bit counter register

dff_sync_reset DFF0 (
    .clk(clk),
    .reset(reset),
    .d(next_count[0]),
    .q(count[0])
);

dff_sync_reset DFF1 (
    .clk(clk),
    .reset(reset),
    .d(next_count[1]),
    .q(count[1])
);

dff_sync_reset DFF2 (
    .clk(clk),
    .reset(reset),
    .d(next_count[2]),
    .q(count[2])
);

dff_sync_reset DFF3 (
    .clk(clk),
    .reset(reset),
    .d(next_count[3]),
    .q(count[3])
);

endmodule


//======================================================
// 5. MOD-10 COUNTER WITH ASYNCHRONOUS RESET
//======================================================

module mod10_counter_async (
    input clk,
    input reset,
    output [3:0] count
);

wire [3:0] next_count;

mod10_next_state NEXT_LOGIC (
    .count(count),
    .next_count(next_count)
);


// Four D flip-flops form the 4-bit counter register

dff_async_reset DFF0 (
    .clk(clk),
    .reset(reset),
    .d(next_count[0]),
    .q(count[0])
);

dff_async_reset DFF1 (
    .clk(clk),
    .reset(reset),
    .d(next_count[1]),
    .q(count[1])
);

dff_async_reset DFF2 (
    .clk(clk),
    .reset(reset),
    .d(next_count[2]),
    .q(count[2])
);

dff_async_reset DFF3 (
    .clk(clk),
    .reset(reset),
    .d(next_count[3]),
    .q(count[3])
);

endmodule


//======================================================
// 6. TOP MODULE
//======================================================

module mod10_counter_top (
    input clk,
    input reset_sync,
    input reset_async,

    output [3:0] count_sync,
    output [3:0] count_async
);

mod10_counter_sync SYNC_COUNTER (
    .clk(clk),
    .reset(reset_sync),
    .count(count_sync)
);

mod10_counter_async ASYNC_COUNTER (
    .clk(clk),
    .reset(reset_async),
    .count(count_async)
);

endmodule
