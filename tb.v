//======================================================
// DAY 10 TESTBENCH
// MOD-10 COUNTER
//======================================================


//======================================================
// 1. SYNCHRONOUS RESET TESTBENCH
//======================================================

module day10_sync_tb;

reg clk;
reg reset;

wire [3:0] count;


// DUT

mod10_counter_sync DUT (
    .clk(clk),
    .reset(reset),
    .count(count)
);


// Clock generation
// 10 ns clock period

initial
begin
    clk = 1'b0;

    forever #5 clk = ~clk;
end


// Waveform

initial
begin
    $dumpfile("day10_sync.vcd");
    $dumpvars(0, day10_sync_tb);
end


// Test

initial
begin

    $display("======================================");
    $display("DAY 10 - SYNCHRONOUS MOD-10 COUNTER");
    $display("======================================");

    reset = 1'b1;

    #12;

    // Release reset
    reset = 1'b0;

    // Allow counter to run
    #100;

    // Apply synchronous reset
    reset = 1'b1;

    #8;

    reset = 1'b0;

    #50;

    $finish;

end


// Display counter

initial
begin
    $monitor(
        "Time=%0t | CLK=%b | RESET=%b | COUNT=%d (%b)",
        $time,
        clk,
        reset,
        count,
        count
    );
end

endmodule



//======================================================
// 2. ASYNCHRONOUS RESET TESTBENCH
//======================================================

module day10_async_tb;

reg clk;
reg reset;

wire [3:0] count;


// DUT

mod10_counter_async DUT (
    .clk(clk),
    .reset(reset),
    .count(count)
);


// Clock generation

initial
begin
    clk = 1'b0;

    forever #5 clk = ~clk;
end


// Separate waveform

initial
begin
    $dumpfile("day10_async.vcd");
    $dumpvars(0, day10_async_tb);
end


// Test

initial
begin

    $display("======================================");
    $display("DAY 10 - ASYNCHRONOUS MOD-10 COUNTER");
    $display("======================================");

    reset = 1'b1;

    #12;

    // Release reset
    reset = 1'b0;

    // Allow counter to run
    #70;

    // Assert asynchronous reset
    // deliberately not aligned with clock

    #3;
    reset = 1'b1;

    #2;

    reset = 1'b0;

    #50;

    $finish;

end


// Display counter

initial
begin
    $monitor(
        "Time=%0t | CLK=%b | RESET=%b | COUNT=%d (%b)",
        $time,
        clk,
        reset,
        count,
        count
    );
end

endmodule
