onerror {exit -code 1}
vlib work
vlog -work work RTL_Ex_8_2_v_jin.vo
vlog -work work RTL_Ex_8_2_v_jin.vwf.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.RTL_Ex_8_2_v_jin_vlg_vec_tst -voptargs="+acc"
vcd file -direction RTL_Ex_8_2_v_jin.msim.vcd
vcd add -internal RTL_Ex_8_2_v_jin_vlg_vec_tst/*
vcd add -internal RTL_Ex_8_2_v_jin_vlg_vec_tst/i1/*
run -all
quit -f
