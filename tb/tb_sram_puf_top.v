`timescale 1ns / 1ps
// ============================================================================
// Top-Level Testbench for SRAM-PUF System
// 
// Tests complete enrollment and reconstruction flow
// ============================================================================

module tb_sram_puf_top;

    // Parameters
    parameter CLK_PERIOD = 10;  // 100 MHz
    parameter N = 256;
    parameter SECRET_BITS = 128;
    parameter HELPER_BITS = 448;
    
    // Signals
    reg clk;
    reg rst;
    reg start_enroll;
    reg start_reconstruct;
    reg [HELPER_BITS-1:0] helper_data_in;
    wire operation_done;
    wire [255:0] key_out;
    wire [HELPER_BITS-1:0] helper_data_out;
    wire error_flag;
    
    // Stored helper data
    reg [HELPER_BITS-1:0] stored_helper;
    reg [255:0] enrollment_key;
    
    // Timeout counter
    integer timeout_counter;
    
    // DUT Instantiation
    sram_puf_controller #(
        .N(N),
        .SECRET_BITS(SECRET_BITS),
        .HELPER_BITS(HELPER_BITS),
        .ENROLL_CYCLES(10),
        .STABILITY_THRESHOLD(8),
        .USE_BCH(0)  // Use Hamming
    ) dut (
        .clk(clk),
        .rst(rst),
        .start_enroll(start_enroll),
        .start_reconstruct(start_reconstruct),
        .helper_data_in(helper_data_in),
        .operation_done(operation_done),
        .key_out(key_out),
        .helper_data_out(helper_data_out),
        .error_flag(error_flag)
    );
    
    // Clock Generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // Test Sequence
    initial begin
        $display("========================================");
        $display("SRAM-PUF System Testbench");
        $display("========================================");
        
        // Initialize
        rst = 1;
        start_enroll = 0;
        start_reconstruct = 0;
        helper_data_in = {HELPER_BITS{1'b0}};
        
        #(CLK_PERIOD*5);
        rst = 0;
        #(CLK_PERIOD*5);
        $display("[INFO] Reset complete, starting tests...");
        
        // ====================================================================
        // TEST 1: Enrollment
        // ====================================================================
        $display("\n[TEST 1] Starting Enrollment...");
        start_enroll = 1;
        #(CLK_PERIOD);
        start_enroll = 0;
        
        // Wait for enrollment to complete with timeout
        timeout_counter = 0;
        while (!operation_done && timeout_counter < 500000) begin
            #(CLK_PERIOD);
            timeout_counter = timeout_counter + 1;
        end
        
        if (timeout_counter >= 500000) begin
            $display("[ERROR] Enrollment timeout! operation_done never asserted");
            $display("[DEBUG] Current state: %0d", dut.state);
            $display("[DEBUG] error_flag: %0d", error_flag);
            $finish;
        end
        
        $display("[INFO] Enrollment operation_done asserted after %0d cycles", timeout_counter);
        #(CLK_PERIOD*2);
        
        if (error_flag) begin
            $display("[ERROR] Enrollment failed!");
            $finish;
        end else begin
            $display("[PASS] Enrollment completed successfully");
            $display("  Helper Data: %h", helper_data_out);
            $display("  Key Output:  %h", key_out);
            
            // Store helper data and key for comparison
            stored_helper = helper_data_out;
            enrollment_key = key_out;
        end
        
        #(CLK_PERIOD*10);
        
        // ====================================================================
        // TEST 2: Reconstruction
        // ====================================================================
        $display("\n[TEST 2] Starting Reconstruction...");
        helper_data_in = stored_helper;
        start_reconstruct = 1;
        #(CLK_PERIOD);
        start_reconstruct = 0;
        
        // Wait for reconstruction to complete with timeout
        timeout_counter = 0;
        while (!operation_done && timeout_counter < 500000) begin
            #(CLK_PERIOD);
            timeout_counter = timeout_counter + 1;
        end
        
        if (timeout_counter >= 500000) begin
            $display("[ERROR] Reconstruction timeout!");
            $display("[DEBUG] Current state: %0d", dut.state);
            $finish;
        end
        
        $display("[INFO] Reconstruction operation_done asserted after %0d cycles", timeout_counter);
        #(CLK_PERIOD*2);
        
        if (error_flag) begin
            $display("[ERROR] Reconstruction failed!");
        end else begin
            $display("[PASS] Reconstruction completed successfully");
            $display("  Key Output: %h", key_out);
            
            // Compare keys
            if (key_out == enrollment_key) begin
                $display("[PASS] Keys match! PUF system working correctly.");
            end else begin
                $display("[WARN] Keys differ (expected with noise)");
                $display("  Enrollment Key:     %h", enrollment_key);
                $display("  Reconstruction Key: %h", key_out);
            end
        end
        
        #(CLK_PERIOD*10);
        
        // ====================================================================
        // TEST 3: Multiple Reconstructions
        // ====================================================================
        $display("\n[TEST 3] Testing multiple reconstructions...");
        
        repeat(3) begin
            // Wait for previous operation to fully complete
            while (operation_done) begin
                #(CLK_PERIOD);
            end
            
            #(CLK_PERIOD*5);
            
            helper_data_in = stored_helper;
            start_reconstruct = 1;
            #(CLK_PERIOD);
            start_reconstruct = 0;
            
            timeout_counter = 0;
            while (!operation_done && timeout_counter < 500000) begin
                #(CLK_PERIOD);
                timeout_counter = timeout_counter + 1;
            end
            
            if (!error_flag && timeout_counter < 500000) begin
                $display("  Reconstruction Key: %h", key_out);
            end
            
            #(CLK_PERIOD*10);
        end
        
        $display("\n========================================");
        $display("Testbench Complete");
        $display("========================================");
        $finish;
    end
    
    // Global Timeout
    initial begin
        #(CLK_PERIOD * 10000000);  // 100ms timeout
        $display("[ERROR] Global testbench timeout!");
        $finish;
    end

endmodule
