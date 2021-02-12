
`include "chip_io.v"
`include "avsdpll_1v8.v"
`include "simple_por.v"
`include "lvl_shifter.v"
`include "pll_spi.v"


module vsdPLLSoC ( input  ref_clk,
                 output b_cp,
                 output b_vco,
                 input  vco_in,
                 input  en_cp,
                 input  en_vco,
                 input  VCCD,           
                 input  VSSD,
                 input  VDDIO,
                 input  VSSIO,           
                 input  VDDA,           
                 input  VSSA,
                 input gpio_3,
                 input gpio_2,
                 input gpio_1,
                 input gpio_0,
                 output  clk

);




//wire gpio_0;
//wire gpio_1;
//wire gpio_2;
//wire gpio_3;

wire b_1_pll;
wire b_2_pll;
wire b_3_pll;
wire b_0_pll;

//wire  ref_clk;
wire  ref_clk_pll;

//wire  clk;
wire  clk_pll;

//wire   vco_in;
wire   vco_in_pll;

//wire en_cp;
wire en_cp_pll;

//wire en_vco;
wire en_vco_pll;

//wire b_cp;
//wire b_cp_pll;

//wire b_vco;
//wire b_vco_pll;


wire porb;

wire en_cp_pll_spi;
wire en_vco_pll_spi;
wire b_1_pll_spi;
wire b_2_pll_spi;
wire b_3_pll_spi;
wire b_0_pll_spi;


simple_por   POR  (

          `ifdef USE_POWER_PINS       
                   .vdd3v3(VDDIO),
                   .vdd1v8(VCCD),
                   .vss(VSSIO),
          `endif         
                   .porb_h(porb)
               //  .porb_l(),
               //  .por_l()
                 );

lvl_shifter   LVLSHIFT1  (

          `ifdef USE_POWER_PINS       
                   .VPWR(VDDIO), //3.3V
                   .LVPWR(VCCD), //1.8V
                   .VGND(VSSIO), //0V
          `endif         
              
              	    .A(en_cp_pll_spi) //from spi
              	    .X(en_cp_pll) //shifted to 1.8V and fed to PLL
                
		//.VNB(),
		//.VPB(),
                 );

lvl_shifter   LVLSHIFT2  (

          `ifdef USE_POWER_PINS       
                   .VPWR(VDDIO), //3.3V
                   .LVPWR(VCCD), //1.8V
                   .VGND(VSSIO), //0V
          `endif         
               
        	 .A(en_vco_pll_spi) //from spi
              	 .X(en_vco_pll) //shifted to 1.8V and fed to PLL
		//.VNB(),
		//.VPB(),
                 );
        
lvl_shifter   LVLSHIFT3  (

          `ifdef USE_POWER_PINS       
                   .VPWR(VDDIO),
                   .LVPWR(VCCD),
                   .VGND(VSSIO),
          `endif         
               
            
		//.VNB(),
		//.VPB(),
		
		 .A(B_0_pll_spi) //from spi
              	 .X(B_0_pll) //shifted to 1.8V and fed to PLL
                 );                 
                 
lvl_shifter   LVLSHIFT4  (

          `ifdef USE_POWER_PINS       
                   .VPWR(VDDIO),
                   .LVPWR(VCCD),
                   .VGND(VSSIO),
          `endif         
               
            
		//.VNB(),
		//.VPB(),
		
		 .A(B_1_pll_spi) //from spi
              	 .X(B_1_pll) //shifted to 1.8V and fed to PLL
                 );

lvl_shifter   LVLSHIFT5  (

          `ifdef USE_POWER_PINS       
                   .VPWR(VDDIO),
                   .LVPWR(VCCD),
                   .VGND(VSSIO),
          `endif         
               
            
		//.VNB(),
		//.VPB(),
		
		.A(B_2_pll_spi) //from spi
              	 .X(B_2_pll) //shifted to 1.8V and fed to PLL
                 );

lvl_shifter   LVLSHIFT6  (

          `ifdef USE_POWER_PINS       
                   .VPWR(VDDIO),
                   .LVPWR(VCCD),
                   .VGND(VSSIO),
          `endif         
               
            
		//.VNB(),
		//.VPB(),
    		 .A(B_3_pll_spi) //from spi
              	 .X(B_3_pll) //shifted to 1.8V and fed to PLL
                 );

pll_spi   SPI (//

          `ifdef USE_POWER_PINS       
                   .VPWR(VDDIO),
                   .VGND(VSSIO),
          `endif         
               
		.RST(porb),	//hooked up with POR
		.SCK(ref_clk), //hooked up with refclk
		.pll_cp_ena(en_cp_pll_spi),
		.pll_vco_ena(en_vco_pll_spi),
		.pll_trim({B_3_pll_spi,B_2_pll_spi,B_1_pll_spi,B_0_pll_spi})
		//.pll_bypass(), 
    		//.pll_bias_ena(), 
   
    		//.CSB(), 
    		//.SDI(), 
    		
    		//.trap(),
    		//.SDO(),
    		//.irq(),
    		//.mask_rev(),
    		//.mfgr_id(),
    		//.prod_id(),
    		//.reg_ena(),
    		//.reset(),
    		//.sdo_enb(),	
                //.xtal_ena(),
                 
                 );




avsdpll_1v8    PLL               (


                    `ifdef USE_POWER_PINS
                                   .VDD3(VDDA),
                                   .GND2(VSSA),
                                   .VDD2(VDDIO),
                                   .GND(VSSIO),
				    .VDD(VDDA),
                    `endif

                                   .REF(ref_clk_pll),
                            //     .B_VCO(B_VCO_pll),
                            //     .B_CP(B_CP_pll),
                                   .ENb_VCO(en_vco_pll),
                                   .ENb_CP(en_cp_pll),
                                   .B({B_3_pll,B_2_pll,B_1_pll,B_0_pll}),
                                   .CLK(clk_pll),
                                   .VCO_IN(vco_in_pll)
                                  
                                   ); 





chip_io   PADFRAME     (

                          
           `ifdef USE_POWER_PINS                
                          .vccd(VCCD),
		          .vssd(VSSD),
		          .vddio(VDDIO),
		          .vssio(VSSIO),
		          .vdda(VDDA),
		          .vssa(VSSA),                        
            `endif


                         .GPIO_0(gpio_0),
                         .GPIO_1(gpio_1),
	                 .GPIO_2(gpio_2),
	                 .GPIO_3(gpio_3), 
		         .B_0_pll(),
	                 .B_1_pll(), 
		         .B_2_pll(), 
		         .B_3_pll(),
		         
		         .REF_CLK(ref_clk), 
		         .REF_CLK_pll(ref_clk_pll),		 
		         
		         .CLK(clk), 
	              	 .CLK_pll(clk_pll),		 
		         
		         .VCO_IN(vco_in), 
		         .VCO_IN_pll(vco_in_pll),		 
		         
		         .EN_CP(en_cp), 
		         .EN_CP_pll(en_cp_pll),		 
		         
		         .EN_VCO(en_vco), 
		         .EN_VCO_pll(en_vco_pll),		 
		         
		         .B_CP(b_cp), 
		         .B_CP_pll(),		 
		         
		         .B_VCO(b_vco), 
		         .B_VCO_pll(), 		
		
		      	.PORB(porb)
		);
		





endmodule
