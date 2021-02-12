
#Project : SoC Implementation of PLL
This project aims to integrate the PLL, SPI, level shifter, IO pads and POR at the top level.
The physical design flow is then run to integrate all the blocks. This project basically builds on the project done by a previous intern.

##Week 2 Progress
#SPI
Before all the blocks can be integrated, the SPI block needs to be synthesized and the LEF file must be obtained. As such, the Verilog files, namely spi_slave.v and raven_spi.v was obtained from the raven project in the link below:-

https://github.com/efabless/raven-picorv32/tree/master/verilog

The following commands were run in the interactive mode:-

run_synthesis

For the synthesis run, the clock was set to 12.5MHz and the standard cell used for synthesis is sky130_fd_sc_hvl since the block is operating at 3.3V. The rest of the commands are run in successsion.

run_floorplan
run_placement
run_routing

After routing is done, the lef is extracted by using the command below:-
magic -T sky130A.tech lef read merged.lef def read &
lef write raven_spi.lef

[[images/spi.png]]


#LVLSHIFTER
The level shifter does not need to be designed from scratch since it is provided in the PDK. 
The LEF file can be obtained in the skywater-pdk in the cells folder of the sky130_fd_sc_hvl directory. The level shifter chosen was sky130_fd_sc_hvl__lsbufhv2lv_simple.


#OTHER IPS
The rest of the IPs, namely AVSDPLL and POR, config settings can be obtained from the following repos respectively:-


AVSDPLL
github https://github.com/lakshmi-sathi/avsdpll_1v8

POR and Config Settings
https://github.com/rsnkhatri3/vsdPLLSoC


The IOPAD can be obtained in the skywater-pdk directory. The top level Verilog for the pin connections have been edited to include the SPI and level shifter blocks. These can be found in the RTL directory.


#Future Work
-Solve timing issues for SPI block.
-Run the physical design flow at the top level with the integrated SPI and level shifter blocks.

