onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sin_tb/clk
add wave -noupdate /sin_tb/reset
add wave -noupdate /sin_tb/result
add wave -noupdate /sin_tb/done
add wave -noupdate /sin_tb/sinunit/theta
add wave -noupdate /sin_tb/sinunit/prec
add wave -noupdate /sin_tb/sinunit/state
add wave -noupdate /sin_tb/sinunit/coeffind
add wave -noupdate /sin_tb/sinunit/lastind
add wave -noupdate /sin_tb/sinunit/square
add wave -noupdate /sin_tb/sinunit/last_power
add wave -noupdate /sin_tb/sinunit/term_power
add wave -noupdate /sin_tb/sinunit/accum
add wave -noupdate /sin_tb/sinunit/coeff
add wave -noupdate /sin_tb/sinunit/accum_next
add wave -noupdate /sin_tb/sinunit/power_res
add wave -noupdate /sin_tb/sinunit/term_res
add wave -noupdate /sin_tb/sinunit/add_res
add wave -noupdate /sin_tb/sinunit/alldone
add wave -noupdate /sin_tb/sinunit/power_mult_rst
add wave -noupdate /sin_tb/sinunit/term_mult_rst
add wave -noupdate /sin_tb/sinunit/add_rst
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

run 10 us
