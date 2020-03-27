transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/parallels/Digital_Design/Assignment_12/LD_Driver_ASM_v_jin {/home/parallels/Digital_Design/Assignment_12/LD_Driver_ASM_v_jin/top.v}
vlog -vlog01compat -work work +incdir+/home/parallels/Digital_Design/Assignment_12/LD_Driver_ASM_v_jin {/home/parallels/Digital_Design/Assignment_12/LD_Driver_ASM_v_jin/Counter_1E6_ASM_v_jin.v}
vlog -vlog01compat -work work +incdir+/home/parallels/Digital_Design/Assignment_12/LD_Driver_ASM_v_jin {/home/parallels/Digital_Design/Assignment_12/LD_Driver_ASM_v_jin/LD_Driver_ASM_v_jin.v}

vlog -vlog01compat -work work +incdir+/home/parallels/Digital_Design/Assignment_12/LD_Driver_ASM_v_jin {/home/parallels/Digital_Design/Assignment_12/LD_Driver_ASM_v_jin/sti.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  sti

add wave *
view structure
view signals
run -all
