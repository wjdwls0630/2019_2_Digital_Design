transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/parallels/Digital_Design/Final_Project {/home/parallels/Digital_Design/Final_Project/top.v}
vlog -vlog01compat -work work +incdir+/home/parallels/Digital_Design/Final_Project {/home/parallels/Digital_Design/Final_Project/LD_Driver_ASM_v_jin.v}
vlog -vlog01compat -work work +incdir+/home/parallels/Digital_Design/Final_Project {/home/parallels/Digital_Design/Final_Project/Counter_1E6_ASM_v_jin.v}

vlog -vlog01compat -work work +incdir+/home/parallels/Digital_Design/Final_Project {/home/parallels/Digital_Design/Final_Project/sti.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  sti

add wave *
view structure
view signals
run -all
