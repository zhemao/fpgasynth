onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /wave_gen_tb/clk
add wave -noupdate /wave_gen_tb/reset
add wave -noupdate /wave_gen_tb/req_next
add wave -noupdate /wave_gen_tb/aud_data
add wave -noupdate /wave_gen_tb/aud_done
add wave -noupdate /wave_gen_tb/generator/theta
add wave -noupdate /wave_gen_tb/generator/sum_result
add wave -noupdate /wave_gen_tb/generator/sum_datab
add wave -noupdate /wave_gen_tb/generator/base_samp
add wave -noupdate /wave_gen_tb/generator/scaled_samp
add wave -noupdate /wave_gen_tb/generator/next_samp
add wave -noupdate /wave_gen_tb/generator/overshoot
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

run 3840 us
