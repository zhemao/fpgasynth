onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fpadd_tb/result
add wave -noupdate /fpadd_tb/clk
add wave -noupdate /fpadd_tb/reset
add wave -noupdate /fpadd_tb/done
add wave -noupdate /fpadd_tb/ind
add wave -noupdate /fpadd_tb/add/expx
add wave -noupdate /fpadd_tb/add/expy
add wave -noupdate /fpadd_tb/add/mantx
add wave -noupdate /fpadd_tb/add/manty
add wave -noupdate /fpadd_tb/add/expsum
add wave -noupdate /fpadd_tb/add/mantsum
add wave -noupdate /fpadd_tb/add/expsumu
add wave -noupdate /fpadd_tb/add/mantsumu
add wave -noupdate /fpadd_tb/add/shiftin
add wave -noupdate /fpadd_tb/add/shiftby
add wave -noupdate /fpadd_tb/add/shiftout
add wave -noupdate /fpadd_tb/add/encin
add wave -noupdate /fpadd_tb/add/encout
add wave -noupdate /fpadd_tb/add/step
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

run 1200 ns
