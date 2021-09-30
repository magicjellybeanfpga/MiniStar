onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /tb_top_ult/uut/cnt/clk
add wave -noupdate -radix unsigned /tb_top_ult/uut/cnt/rstn
add wave -noupdate -radix unsigned /tb_top_ult/uut/cnt/echo
add wave -noupdate -radix unsigned /tb_top_ult/uut/cnt/trig
add wave -noupdate -radix unsigned /tb_top_ult/uut/cnt/count_one
add wave -noupdate -radix unsigned /tb_top_ult/uut/cnt/count_ten
add wave -noupdate -radix unsigned /tb_top_ult/uut/cnt/count_hundred
add wave -noupdate -radix unsigned /tb_top_ult/uut/cnt/count_thousand
add wave -noupdate -radix unsigned /tb_top_ult/uut/cnt/count_period
add wave -noupdate -radix unsigned /tb_top_ult/uut/cnt/count_echo
add wave -noupdate -radix unsigned /tb_top_ult/uut/clk
add wave -noupdate -radix unsigned /tb_top_ult/uut/echo
add wave -noupdate -radix unsigned /tb_top_ult/uut/rstn
add wave -noupdate -radix unsigned /tb_top_ult/uut/trig
add wave -noupdate -radix unsigned /tb_top_ult/uut/dig
add wave -noupdate -radix unsigned /tb_top_ult/uut/smg
add wave -noupdate -radix unsigned /tb_top_ult/uut/count_one
add wave -noupdate -radix unsigned /tb_top_ult/uut/count_ten
add wave -noupdate -radix unsigned /tb_top_ult/uut/count_hundred
add wave -noupdate -radix unsigned /tb_top_ult/uut/count_thousand
add wave -noupdate -radix unsigned /tb_top_ult/uut/clk_100khz
add wave -noupdate -radix unsigned /tb_top_ult/uut/sel
add wave -noupdate -radix unsigned /tb_top_ult/uut/dig0
add wave -noupdate -radix unsigned /tb_top_ult/uut/smg0
add wave -noupdate -radix unsigned /tb_top_ult/uut/dig1
add wave -noupdate -radix unsigned /tb_top_ult/uut/smg1
add wave -noupdate -radix unsigned /tb_top_ult/uut/dig2
add wave -noupdate -radix unsigned /tb_top_ult/uut/smg2
add wave -noupdate -radix unsigned /tb_top_ult/uut/dig3
add wave -noupdate -radix unsigned /tb_top_ult/uut/smg3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {22571000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 409
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {29026176 ps}
