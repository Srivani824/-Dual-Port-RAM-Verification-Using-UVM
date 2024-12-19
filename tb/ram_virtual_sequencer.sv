/************************************************************************
  
Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
  
www.maven-silicon.com 
  
All Rights Reserved. 
This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd. 
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.
  
Filename:       ram_virtual_sequencer.sv
  
Author Name:    Putta Satish

Support e-mail: For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

Version:	1.0

************************************************************************/
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------


   
   // Extend ram_virtual_sequencer from uvm_sequencer
	class ram_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item) ;
   
      // Factory Registration
	`uvm_component_utils(ram_virtual_sequencer)

   // Declare handles for ram_wr_sequencer and ram_rd_sequencer

	ram_wr_sequencer wr_seqr;
	ram_rd_sequencer rd_seqr;

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "ram_virtual_sequencer",uvm_component parent);
	endclass

   // Define Constructor new() function
	function ram_virtual_sequencer::new(string name="ram_virtual_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction


