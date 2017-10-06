onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_testbench/reset
add wave -noupdate /DE1_SoC_testbench/clk
add wave -noupdate -expand -group red_drivers {/DE1_SoC_testbench/GPIO_0[23]}
add wave -noupdate -expand -group red_drivers {/DE1_SoC_testbench/GPIO_0[20]}
add wave -noupdate -expand -group red_drivers {/DE1_SoC_testbench/GPIO_0[17]}
add wave -noupdate -expand -group red_drivers {/DE1_SoC_testbench/GPIO_0[14]}
add wave -noupdate -expand -group red_drivers {/DE1_SoC_testbench/GPIO_0[2]}
add wave -noupdate -expand -group red_drivers {/DE1_SoC_testbench/GPIO_0[5]}
add wave -noupdate -expand -group red_drivers {/DE1_SoC_testbench/GPIO_0[8]}
add wave -noupdate -expand -group red_drivers {/DE1_SoC_testbench/GPIO_0[11]}
add wave -noupdate -expand -group green_array {/DE1_SoC_testbench/GPIO_0[24]}
add wave -noupdate -expand -group green_array {/DE1_SoC_testbench/GPIO_0[21]}
add wave -noupdate -expand -group green_array {/DE1_SoC_testbench/GPIO_0[18]}
add wave -noupdate -expand -group green_array {/DE1_SoC_testbench/GPIO_0[15]}
add wave -noupdate -expand -group green_array {/DE1_SoC_testbench/GPIO_0[1]}
add wave -noupdate -expand -group green_array {/DE1_SoC_testbench/GPIO_0[4]}
add wave -noupdate -expand -group green_array {/DE1_SoC_testbench/GPIO_0[7]}
add wave -noupdate -expand -group green_array {/DE1_SoC_testbench/GPIO_0[10]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 50
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
