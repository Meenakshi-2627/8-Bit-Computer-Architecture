`timescale 1ns / 1ps

module tb_top_mod_2;

    reg clk;
    reg rst;
    reg power_on;
    reg [3:0] addr_in;
    reg [7:0] data_in;

    wire [7:0] an;
    wire [7:0] seg;

    // DUT
    top_mod_2 DUT (
        .clk(clk),
        .rst(rst),
        .power_on(power_on),
        .addr_in(addr_in),
        .data_in(data_in),
        .an(an),
        .seg(seg)
    );

    // ---------------- CLOCK ----------------
    always #5 clk = ~clk;   // 100 MHz (simulated)

    // ---------------- TASK: WRITE RAM ----------------
    task preload_ram;
        input [3:0] addr;
        input [7:0] data;
        begin
            addr_in = addr;
            data_in = data;
            #10;
        end
    endtask

    // ---------------- TEST SEQUENCE ----------------
    initial begin
        // init
        clk = 0;
        rst = 1;
        power_on = 0;   // PRELOAD MODE
        addr_in = 0;
        data_in = 0;

        #20 rst = 0;

        // =====================================
        // DATA PRELOAD (RAM[12]-RAM[15])
        // =====================================
        preload_ram(4'd12, 8'd5);   // data = 5
        preload_ram(4'd13, 8'd3);   // data = 3
        preload_ram(4'd14, 8'd1);   // data = 1
        preload_ram(4'd15, 8'd8);   // data = 8

        // =====================================
        // PROGRAM PRELOAD
        // =====================================

        // 0: LDAIMM 5
        preload_ram(4'd0, 8'b0000_0000);

        preload_ram(4'd1, 8'b0001_0000);

        #20;

        // =====================================
        // START CPU
        // =====================================
        power_on = 1;
    data_in<=8'd15;
        // let CPU run
        #200;

        $finish;
    end

endmodule
