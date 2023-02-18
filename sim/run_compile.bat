if exist ..\inst_mem.mif (
    copy /Y ..\inst_mem.mif .
)

if exist work rmdir /S /Q work

vlib work
vlog -nolock ../tb/*.v
REM if exist ../*.v (
REM	vlog -nolock ../*.v
REM )
if exist ../*.sv (
REM	vlog -sv -nolock ../*.sv
	vlog -sv -nolock ../bcd2hex.sv ../counter.sv ../counterDn.sv  ../poly.sv ../simonStmach.sv ../lab3.sv ../lab3_tb_support.sv ../lab3_tb.sv
)
REM if exist ../*.vhd (
REM	vcom -nolock ../*.vhd
REM )

