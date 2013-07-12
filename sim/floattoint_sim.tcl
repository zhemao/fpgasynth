onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /floattoint_tb/clk
add wave -noupdate /floattoint_tb/reset
add wave -noupdate /floattoint_tb/floatin
add wave -noupdate /floattoint_tb/intout
add wave -noupdate /floattoint_tb/done
add wave -noupdate /floattoint_tb/converter/exp
add wave -noupdate /floattoint_tb/converter/mant_res
add wave -noupdate /floattoint_tb/converter/resultu
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {245000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 206
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {579744 ps}

run 600 ns
