`timescale 1ns / 1ps
// ============================================================================
// SRAM PUF Controller - Top Level Module
// 
// Coordinates enrollment and reconstruction phases
// Integrates all submodules: PUF core, fuzzy extractor, key generator
//
// Feature: advanced-sram-puf
// ============================================================================

`include "sram_puf_params.vh"

module sram_puf_controller #(
    parameter N = `DEFAULT_PUF_SIZE,
    parameter SECRET_BITS = 128,
    parameter HELPER_BITS = 448,
    parameter ENROLL_CYCLES = `DEFAULT_ENROLL_CYCLES,
    parameter STABILITY_THRESHOLD = `DEFAULT_STABILITY_THRESH,
    parameter USE_BCH = 0
)(
    input  wire clk,
    input  wire rst,
    input  wire start_enroll,
    input  wire start_reconstruct,
    input  wire [HELPER_BITS-1:0] helper_data_in,
    output reg  operation_done,
    output reg  [255:0] key_out,
    output reg  [HELPER_BITS-1:0] helper_data_out,
    output reg  error_flag
);

    // ========================================================================
    // FSM States
    // ========================================================================
    
    reg [3:0] state;
    
    // ========================================================================
    // Internal Signals
    // ========================================================================
    
    // PUF Core signals
    reg puf_rst;
    reg puf_read_enable;
    wire puf_read_done;
    wire [N-1:0] puf_response;
    wire [N-1:0] meta_flags;
    wire puf_bit;
    
    // Fuzzy Extractor signals
    reg fuzzy_start;
    reg fuzzy_mode;  // 0=enroll, 1=reconstruct
    wire fuzzy_done;
    wire fuzzy_error;
    wire [SECRET_BITS-1:0] fuzzy_secret;
    wire [HELPER_BITS-1:0] fuzzy_helper;
    reg [SECRET_BITS-1:0] latched_secret;  // Latched secret for key generation
    
    // Key Generator signals
    reg keygen_start;
    wire keygen_done;
    wire [255:0] keygen_key;
    
    // LFSR signals
    reg [N-1:0] lfsr_seed;
    reg lfsr_load;
    reg lfsr_enable;
    wire [N-1:0] lfsr_out;
    wire lfsr_bit;
    reg [8:0] lfsr_cycle_count;  // Count LFSR shift cycles
    reg [N-1:0] masked_puf;     // PUF response after LFSR masking
    
    // Enrollment tracking
    reg [3:0] powerup_count;
    reg [3:0] stability_count [0:N-1];
    reg [N-1:0] majority_value;
    reg [N-1:0] stable_mask;
    reg [N-1:0] powerup_history [0:ENROLL_CYCLES-1];
    reg [9:0] stable_count_temp;
    reg [3:0] ones_count;
    
    integer i, j;
    
    // ========================================================================
    // Module Instantiations
    // ========================================================================
    
    // SRAM PUF Core
    sram_puf_core #(
        .N(N)
    ) puf_core_inst (
        .clk(clk),
        .rst(puf_rst),
        .enable_noise(1'b1),
        .temp_factor(8'd128),      // Nominal
        .voltage_factor(8'd128),   // Nominal
        .read_enable(puf_read_enable),
        .read_done(puf_read_done),
        .puf_response(puf_response),
        .puf_bit(puf_bit),
        .meta_flags(meta_flags)
    );
    
    // Fuzzy Extractor
    fuzzy_extractor #(
        .PUF_BITS(N),
        .SECRET_BITS(SECRET_BITS),
        .USE_BCH(USE_BCH),
        .HELPER_BITS(HELPER_BITS)
    ) fuzzy_inst (
        .clk(clk),
        .rst(rst),
        .mode(fuzzy_mode),
        .start(fuzzy_start),
        .puf_in(puf_response),
        .meta_mask(meta_flags),
        .helper_in(helper_data_in),
        .secret_out(fuzzy_secret),
        .helper_out(fuzzy_helper),
        .error_flag(fuzzy_error),
        .done(fuzzy_done)
    );
    
    // LFSR for PUF response masking
    lfsr_256 #(
        .WIDTH(N)
    ) lfsr_inst (
        .clk(clk),
        .rst(rst),
        .seed(lfsr_seed),
        .load(lfsr_load),
        .enable(lfsr_enable),
        .lfsr_out(lfsr_out),
        .lfsr_bit(lfsr_bit)
    );
    
    // Key Generator
    key_gen #(
        .SECRET_BITS(SECRET_BITS)
    ) keygen_inst (
        .clk(clk),
        .rst(rst),
        .start(keygen_start),
        .secret_in(latched_secret),
        .key_out(keygen_key),
        .done(keygen_done)
    );
    
    // ========================================================================
    // Main FSM
    // ========================================================================
    
    always @(posedge clk) begin
        if (rst) begin
            state <= `STATE_IDLE;
            operation_done <= 1'b0;
            error_flag <= 1'b0;
            puf_rst <= 1'b0;
            puf_read_enable <= 1'b0;
            fuzzy_start <= 1'b0;
            keygen_start <= 1'b0;
            lfsr_load <= 1'b0;
            lfsr_enable <= 1'b0;
            lfsr_cycle_count <= 0;
            powerup_count <= 0;
            key_out <= 256'b0;
            helper_data_out <= {HELPER_BITS{1'b0}};
            latched_secret <= {SECRET_BITS{1'b0}};
            masked_puf <= {N{1'b0}};
        end
        else begin
            case (state)
                `STATE_IDLE: begin
                    operation_done <= 1'b0;
                    error_flag <= 1'b0;
                    
                    if (start_enroll) begin
                        powerup_count <= 0;
                        // Initialize stability tracking
                        for (i = 0; i < N; i = i + 1) begin
                            stability_count[i] <= 0;
                        end
                        state <= `STATE_ENROLL_POWERUP;
                    end
                    else if (start_reconstruct) begin
                        state <= `STATE_RECONSTRUCT_POWERUP;
                    end
                end
                
                // ============================================================
                // ENROLLMENT PHASE
                // ============================================================
                
                `STATE_ENROLL_POWERUP: begin
                    if (powerup_count < ENROLL_CYCLES) begin
                        // Trigger power-up and start read
                        puf_rst <= 1'b1;
                        puf_read_enable <= 1'b1;
                        state <= `STATE_ENROLL_WAIT_READ;
                    end
                    else begin
                        state <= `STATE_ENROLL_ANALYZE;
                    end
                end
                
                `STATE_ENROLL_WAIT_READ: begin
                    // Wait for PUF read to complete
                    puf_rst <= 1'b0;  // Release reset after one cycle
                    
                    if (puf_read_done) begin
                        // Store this power-up result
                        powerup_history[powerup_count] <= puf_response;
                        powerup_count <= powerup_count + 1;
                        puf_read_enable <= 1'b0;
                        state <= `STATE_ENROLL_POWERUP;
                    end
                end
                
                `STATE_ENROLL_ANALYZE: begin
                    // Analyze stability across all power-ups
                    for (i = 0; i < N; i = i + 1) begin
                        // Count how many times each cell was '1'
                        ones_count = 0;
                        
                        for (j = 0; j < ENROLL_CYCLES; j = j + 1) begin
                            if (powerup_history[j][i]) begin
                                ones_count = ones_count + 1;
                            end
                        end
                        
                        // Determine majority value
                        if (ones_count > (ENROLL_CYCLES / 2)) begin
                            majority_value[i] = 1'b1;
                        end else begin
                            majority_value[i] = 1'b0;
                        end
                        
                        // Count consistency with majority
                        stability_count[i] = 0;
                        for (j = 0; j < ENROLL_CYCLES; j = j + 1) begin
                            if (powerup_history[j][i] == majority_value[i]) begin
                                stability_count[i] = stability_count[i] + 1;
                            end
                        end
                    end
                    
                    state <= `STATE_ENROLL_SELECT;
                end
                
                `STATE_ENROLL_SELECT: begin
                    // Select stable cells
                    for (i = 0; i < N; i = i + 1) begin
                        if (stability_count[i] >= STABILITY_THRESHOLD && !meta_flags[i]) begin
                            stable_mask[i] = 1'b1;
                        end else begin
                            stable_mask[i] = 1'b0;
                        end
                    end
                    
                    // Check if we have enough stable cells
                    stable_count_temp = 0;
                    for (i = 0; i < N; i = i + 1) begin
                        if (stable_mask[i]) begin
                            stable_count_temp = stable_count_temp + 1;
                        end
                    end
                    
                    if (stable_count_temp < SECRET_BITS) begin
                        error_flag <= 1'b1;
                        state <= `STATE_ERROR;
                    end else begin
                        state <= `STATE_ENROLL_EXTRACT;
                    end
                end
                
                `STATE_ENROLL_EXTRACT: begin
                    // Generate helper data using fuzzy extractor
                    fuzzy_mode <= 1'b0;  // Enrollment mode
                    
                    if (!fuzzy_done) begin
                        fuzzy_start <= 1'b1;
                    end else begin
                        fuzzy_start <= 1'b0;
                        if (fuzzy_error) begin
                            error_flag <= 1'b1;
                            state <= `STATE_ERROR;
                        end else begin
                            helper_data_out <= fuzzy_helper;
                            latched_secret <= fuzzy_secret;  // Latch the secret
                            state <= `STATE_KEYGEN;
                        end
                    end
                end
                
                // ============================================================
                // RECONSTRUCTION PHASE
                // ============================================================
                
                `STATE_RECONSTRUCT_POWERUP: begin
                    // Single power-up for reconstruction
                    puf_rst <= 1'b1;
                    puf_read_enable <= 1'b1;
                    state <= `STATE_RECONSTRUCT_READ;
                end
                
                `STATE_RECONSTRUCT_READ: begin
                    // Wait for PUF read to complete
                    puf_rst <= 1'b0;  // Release reset after one cycle
                    
                    if (puf_read_done) begin
                        puf_read_enable <= 1'b0;
                        // Seed LFSR with XOR of PUF response and diversification constant
                        lfsr_seed <= puf_response ^ {{(N-32){1'b0}}, 32'hDEADBEEF};
                        lfsr_load <= 1'b1;
                        lfsr_cycle_count <= 0;
                        state <= `STATE_LFSR;
                    end
                end
                
                `STATE_LFSR: begin
                    // Run LFSR for N cycles to generate masking sequence
                    lfsr_load <= 1'b0;
                    
                    if (lfsr_cycle_count < N) begin
                        lfsr_enable <= 1'b1;
                        lfsr_cycle_count <= lfsr_cycle_count + 1;
                    end
                    else begin
                        lfsr_enable <= 1'b0;
                        // XOR LFSR output with PUF response for dispersion
                        masked_puf <= puf_response ^ lfsr_out;
                        state <= `STATE_RECONSTRUCT_DECODE;
                    end
                end
                
                `STATE_RECONSTRUCT_DECODE: begin
                    // Decode using helper data
                    fuzzy_mode <= 1'b1;  // Reconstruction mode
                    
                    if (!fuzzy_done) begin
                        fuzzy_start <= 1'b1;
                    end else begin
                        fuzzy_start <= 1'b0;
                        if (fuzzy_error) begin
                            error_flag <= 1'b1;
                            state <= `STATE_ERROR;
                        end else begin
                            latched_secret <= fuzzy_secret;  // Latch the secret
                            state <= `STATE_KEYGEN;
                        end
                    end
                end
                
                // ============================================================
                // KEY GENERATION (common to both phases)
                // ============================================================
                
                `STATE_KEYGEN: begin
                    if (!keygen_done) begin
                        keygen_start <= 1'b1;
                    end else begin
                        keygen_start <= 1'b0;
                        key_out <= keygen_key;
                        state <= `STATE_DONE;
                    end
                end
                
                // ============================================================
                // COMPLETION STATES
                // ============================================================
                
                `STATE_DONE: begin
                    operation_done <= 1'b1;
                    if (!start_enroll && !start_reconstruct) begin
                        state <= `STATE_IDLE;
                    end
                end
                
                `STATE_ERROR: begin
                    operation_done <= 1'b1;
                    error_flag <= 1'b1;
                    if (!start_enroll && !start_reconstruct) begin
                        state <= `STATE_IDLE;
                    end
                end
                
                default: begin
                    state <= `STATE_IDLE;
                end
            endcase
        end
    end

endmodule
