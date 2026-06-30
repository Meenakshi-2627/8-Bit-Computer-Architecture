`timescale 1ns/1ps

module output_display(
    input clk,                  // Connect to your master board clock (e.g., 100MHz)
    input rst,                // Connect to your reset button
    input [7:0] binary_in,   // Your 8-bit output value from the computer (0-255)
    output reg [7:0] an,     // Active-low anode vector
    output reg [7:0] seg    // Active-low cathode/segment vector
);

    // 1. Refresh Counter (20-bit register handles clock division perfectly)
    reg [19:0] refresh_counter;
    always @(posedge clk or posedge rst) begin
        if (rst)
            refresh_counter <= 20'd0;
        else
            refresh_counter <= refresh_counter + 1'b1;
    end

    // Use the 3 MSBs to smoothly cycle between the 8 digits (~760 Hz refresh rate)
    wire [2:0] digit_select = refresh_counter[19:17];

    // 2. Separate the 8-bit binary value into 3 BCD digits (Hundreds, Tens, Ones)
    wire [3:0] hundreds = binary_in / 100;
    wire [3:0] tens     = (binary_in / 10) % 10;
    wire [3:0] ones     = binary_in % 10;

    // 3. Digit Multiplexer Logic
    reg [3:0] current_digit_val;
    reg is_blank;

    always @(*) begin
        // Defaults to avoid latches
        an = 8'b11111111; 
        current_digit_val = 4'd0;
        is_blank = 1'b0;

        case(digit_select)
            // First 5 digits (0 to 4) are configured as blank spaces
            3'b000: begin an = 8'b11111110; is_blank = 1'b1; end // Digit 0
            3'b001: begin an = 8'b11111101; is_blank = 1'b1; end // Digit 1
            3'b010: begin an = 8'b11111011; is_blank = 1'b1; end // Digit 2
            3'b011: begin an = 8'b11110111; is_blank = 1'b1; end // Digit 3
            3'b100: begin an = 8'b11101111; is_blank = 1'b1; end // Digit 4
            
            // Last 3 digits (5 to 7) display your computer's values
            3'b101: begin an = 8'b11011111; current_digit_val = hundreds; is_blank = 1'b0; end // Digit 5
            3'b110: begin an = 8'b10111111; current_digit_val = tens;     is_blank = 1'b0; end // Digit 6
            3'b111: begin an = 8'b01111111; current_digit_val = ones;     is_blank = 1'b0; end // Digit 7
        endcase
    end

    // 4. 7-Segment Decoder (Assuming pin layout: [cg, cf, ce, cd, cc, cb, ca, dp])
    always @(*) begin
        if (is_blank) begin
            seg = 8'b11111111; // ALL ONES = Turns ALL segments OFF (Blank space!)
        end else begin
            case(current_digit_val)
                4'd0: seg = 8'b10000001; // Display 0 (cg off, others on, dp off)
                4'd1: seg = 8'b11111001; // Display 1
                4'd2: seg = 8'b01001001; // Display 2
                4'd3: seg = 8'b01100001; // Display 3
                4'd4: seg = 8'b00110001; // Display 4
                4'd5: seg = 8'b00100101; // Display 5
                4'd6: seg = 8'b00000101; // Display 6
                4'd7: seg = 8'b11111001; // Display 7
                4'd8: seg = 8'b00000001; // Display 8
                4'd9: seg = 8'b00100001; // Display 9
                default: seg = 8'b11111111; // Fallback to blank space
            endcase
        end
    end

endmodule
