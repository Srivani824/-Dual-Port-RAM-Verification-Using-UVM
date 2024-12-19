/************************************************************************
  
Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
  
www.maven-silicon.com 
  
All Rights Reserved. 
This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd. 
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.
  
Filename		:   top.sv

Description 	: 	Top Module
  
Author Name		:   Putta Satish

Support e-mail	: 	For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

Version			:	1.0

************************************************************************/

module top;

	// import ram_test_pkg
    	import ram_test_pkg::*;
	
	//import uvm_pkg.sv
	import uvm_pkg::*;
	
	//include uvm_macros.svh"
	`include "uvm_macros.svh"

    	//Generate clock signal
	bit clock;  
	always 
		#10 clock=!clock;     

   // Instantiate ram_if with clock as input
   ram_if in0(clock);
       
   // Instantiate rtl ram_chip and pass the interface instance as argument
   ram_chip ch(in0);

   // In initial block
    initial 
	begin
		
		`ifdef VCS
        	 $fsdbDumpvars(0, top);
        	`endif	

		//set the virtual interface using the uvm_config_db
		uvm_config_db #(virtual ram_if)::set(null,"*","vif",in0);
		// Call run_test
		run_test();
	end

endmodule

  
   
  
