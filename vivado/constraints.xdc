# ============================================================================
# Timing Constraints for SRAM-PUF System
# ============================================================================

# Clock constraint - 100 MHz (10ns period)
create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_ports clk]

# Input delay constraints (relative to clock)
set_input_delay -clock clk -min 1.000 [get_ports {rst start_enroll start_reconstruct}]
set_input_delay -clock clk -max 3.000 [get_ports {rst start_enroll start_reconstruct}]
set_input_delay -clock clk -min 1.000 [get_ports helper_data_in*]
set_input_delay -clock clk -max 3.000 [get_ports helper_data_in*]

# Output delay constraints (relative to clock)
set_output_delay -clock clk -min 1.000 [get_ports {operation_done error_flag}]
set_output_delay -clock clk -max 4.000 [get_ports {operation_done error_flag}]
set_output_delay -clock clk -min 1.000 [get_ports key_out*]
set_output_delay -clock clk -max 4.000 [get_ports key_out*]
set_output_delay -clock clk -min 1.000 [get_ports helper_data_out*]
set_output_delay -clock clk -max 4.000 [get_ports helper_data_out*]

# ============================================================================
# Physical Constraints (Example for Artix-7 35T)
# Uncomment and modify for your specific board
# ============================================================================

# Clock pin
# set_property PACKAGE_PIN W5 [get_ports clk]
# set_property IOSTANDARD LVCMOS33 [get_ports clk]

# Reset pin
# set_property PACKAGE_PIN U18 [get_ports rst]
# set_property IOSTANDARD LVCMOS33 [get_ports rst]

# Control signals
# set_property PACKAGE_PIN T18 [get_ports start_enroll]
# set_property IOSTANDARD LVCMOS33 [get_ports start_enroll]
# set_property PACKAGE_PIN W19 [get_ports start_reconstruct]
# set_property IOSTANDARD LVCMOS33 [get_ports start_reconstruct]

# Status signals
# set_property PACKAGE_PIN U16 [get_ports operation_done]
# set_property IOSTANDARD LVCMOS33 [get_ports operation_done]
# set_property PACKAGE_PIN E19 [get_ports error_flag]
# set_property IOSTANDARD LVCMOS33 [get_ports error_flag]

# ============================================================================
# Optimization Directives
# ============================================================================

# Allow register duplication for timing closure
set_property ALLOW_COMBINATORIAL_LOOPS FALSE [get_nets]

# Optimize for speed
set_property OPTIMIZATION_MODE Performance [get_cells]

# ============================================================================
# False Path Constraints
# ============================================================================

# Asynchronous reset
set_false_path -from [get_ports rst]

# ============================================================================
# Multi-Cycle Path Constraints
# ============================================================================

# SHA-256 compression can take multiple cycles
# Uncomment if timing issues occur
# set_multicycle_path -setup 2 -from [get_cells -hier -filter {NAME =~ *sha256*}]
# set_multicycle_path -hold 1 -from [get_cells -hier -filter {NAME =~ *sha256*}]

# ============================================================================
# Notes
# ============================================================================
# 1. Adjust clock period based on your target frequency
# 2. Modify pin assignments for your specific FPGA board
# 3. Add more specific timing constraints if needed
# 4. Use report_timing to verify constraints are met
