# ============================================================================
# Vivado Project Creation Script for SRAM-PUF System
# ============================================================================

# Set project name and directory
set project_name "sram_puf_project"
set project_dir "./vivado_project"

# Create project
create_project $project_name $project_dir -part xc7a35tcpg236-1 -force

# Set project properties
set_property target_language Verilog [current_project]
set_property simulator_language Mixed [current_project]

# Get the directory where this script is located
set script_dir [file dirname [file normalize [info script]]]
set project_root [file dirname $script_dir]

# Add RTL source files
add_files -norecurse [list \
    [file join $project_root rtl sram_puf_params.vh] \
    [file join $project_root rtl sram_puf_core.v] \
    [file join $project_root rtl hamming_codec.v] \
    [file join $project_root rtl bch_codec.v] \
    [file join $project_root rtl sha256_core.v] \
    [file join $project_root rtl key_gen.v] \
    [file join $project_root rtl fuzzy_extractor.v] \
    [file join $project_root rtl sram_puf_controller.v] \
]

# Add testbench files
add_files -fileset sim_1 -norecurse [list \
    [file join $project_root tb tb_sram_puf_top.v] \
]

# Add constraints file
add_files -fileset constrs_1 -norecurse [list \
    [file join $script_dir constraints.xdc] \
]

# Set top module for synthesis
set_property top sram_puf_controller [current_fileset]

# Update compile order for sources
update_compile_order -fileset sources_1

# Set manual compile order mode for simulation
set_property source_mgmt_mode None [current_project]

# Set simulation top
set_property top tb_sram_puf_top [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# Update compile order for simulation
update_compile_order -fileset sim_1

puts "========================================="
puts "Project created successfully!"
puts "Project: $project_name"
puts "Location: $project_dir"
puts "========================================="
puts ""
puts "Next steps:"
puts "1. Run simulation: launch_simulation"
puts "2. Run synthesis: launch_runs synth_1"
puts "3. Run implementation: launch_runs impl_1"
puts "========================================="
