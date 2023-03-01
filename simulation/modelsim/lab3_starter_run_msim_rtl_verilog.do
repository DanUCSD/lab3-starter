transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/alcka/OneDrive/Desktop/UCSD\ Work\ Folder/CSE140L/lab3-starter {C:/Users/alcka/OneDrive/Desktop/UCSD Work Folder/CSE140L/lab3-starter/simonStmach.sv}
vlog -sv -work work +incdir+C:/Users/alcka/OneDrive/Desktop/UCSD\ Work\ Folder/CSE140L/lab3-starter {C:/Users/alcka/OneDrive/Desktop/UCSD Work Folder/CSE140L/lab3-starter/poly.sv}
vlog -sv -work work +incdir+C:/Users/alcka/OneDrive/Desktop/UCSD\ Work\ Folder/CSE140L/lab3-starter {C:/Users/alcka/OneDrive/Desktop/UCSD Work Folder/CSE140L/lab3-starter/lab3.sv}
vlog -sv -work work +incdir+C:/Users/alcka/OneDrive/Desktop/UCSD\ Work\ Folder/CSE140L/lab3-starter {C:/Users/alcka/OneDrive/Desktop/UCSD Work Folder/CSE140L/lab3-starter/counterDn.sv}
vlog -sv -work work +incdir+C:/Users/alcka/OneDrive/Desktop/UCSD\ Work\ Folder/CSE140L/lab3-starter {C:/Users/alcka/OneDrive/Desktop/UCSD Work Folder/CSE140L/lab3-starter/counter.sv}
vlog -sv -work work +incdir+C:/Users/alcka/OneDrive/Desktop/UCSD\ Work\ Folder/CSE140L/lab3-starter {C:/Users/alcka/OneDrive/Desktop/UCSD Work Folder/CSE140L/lab3-starter/bcd2hex.sv}

