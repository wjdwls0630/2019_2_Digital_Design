onerror {exit -code 1}
vlib work
vlog -work work univ_shift_reg_jin.vo
vlog -work work univ_shift_reg_jin.vwf.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.univ_shift_reg_jin_vlg_vec_tst -voptargs="+acc"
vcd file -direction univ_shift_reg_jin.msim.vcd
vcd add -internal univ_shift_reg_jin_vlg_vec_tst/*
vcd add -internal univ_shift_reg_jin_vlg_vec_tst/i1/*
run -all
quit -f
