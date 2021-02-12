timescale 1ns / 1ps
`default_nettype none


(*blackbox*)
module pll_spi(

		inout VGND,
		inout VPWR,
		
    		//input CSB,
    		input RST,
    		input SCK,
    		//input SDI,
    		//nput trap,
    
    		//output SDO,
    		//output irq,
    		//output mask_rev[3:0],
    		//output mfgr_id[11:0],
    		output pll_bias_ena,
    		//output pll_bypass,
    		output pll_cp_ena,
    		output pll_trim[3:0],
    		output pll_vco_ena,
    		//output xtal_ena,
    		//output prod_id[7:0],
    		//output reg_ena,
    		//output reset,
    		//output sdo_enb	
    		
    		);

endmodule

