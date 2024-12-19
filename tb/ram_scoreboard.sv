/************************************************************************
  
Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
  
www.maven-silicon.com 
  
All Rights Reserved. 
This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd. 
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.
  
Filename		:   ram_scoreboard.sv

Description 	:	Scoreboard class for DUAL Port RAM
  
Author Name		:   Putta Satish

Support e-mail	:	For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

Version			:	1.0

************************************************************************/
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------


/*// Extend ram_scoreboard from uvm_scoreboard

class ram_scoreboard extends uvm_scoreboard;

    // Declare handles for uvm_tlm_analysis_fifos parameterized by read & write transactions as fifo_rdh & fifo_wrh respectively
	//    Hint:  uvm_tlm_analysis_fifo #(read_xtn) fifo_rdh;
	//           uvm_tlm_analysis_fifo #(write_xtn) fifo_wrh;
	
	



	// Add the following integers for Scoreboard Statistics
  	// wr_xtns_in : calculates number of write transactions 
 	// rd_xtns_in : calculates number of read transactions
    // xtns_compared : number of xtns compared
    // xtns_dropped : calculates number of xtns failed

       
	// Factory registration
	

	// Declare an Associative array as a reference model 
    // Type logic [63:0] and index type int

	// Declare handles of type write_xtn & read_xtn as wr_data & rd_data to store the tlm_analysis_fifo data 	
	

	//------------------------------------------
	// Methods
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name,uvm_component parent);
	extern function void mem_write(write_xtn wd);
	extern function bit mem_read(ref read_xtn rd);
	extern task run_phase(uvm_phase phase);
	extern function void check_data(read_xtn rd);
	extern function void report_phase(uvm_phase phase);

endclass

//-----------------  constructor new method  -------------------//

// Add Constructor function
// Create instances of uvm_tlm_analysis fifos inside the constructor
// using new("fifo_h", this)


        
//-----------------  mem_write() method  -------------------//

//Explore mem_write method 
//method to write write_xtn into ref model
	 
function void ram_scoreboard::mem_write(write_xtn wd);
    if(wd.write)
       
	    begin
			ref_data[wd.address] = wd.data;
			`uvm_info(get_type_name(), $sformatf("Write Transaction from Write agt_top \n %s",wd.sprint()), UVM_HIGH)
			wr_xtns_in ++;
     	end
endfunction : mem_write
	

//-----------------  mem_read() method  -------------------//

  	
//Explore mem_read method 
//method to read read_xtn from ref model
function bit ram_scoreboard::mem_read(ref read_xtn rd);
    if(rd.read)
		begin
      	`uvm_info(get_type_name(), $sformatf("Read Transaction from Read agt_top \n %s",rd.sprint()), UVM_HIGH)
        `uvm_info("MEM Function", $psprintf("Address = %h", rd.address), UVM_LOW)
        
      	if(ref_data.exists(rd.address))
			begin
				rd.data = ref_data[rd.address] ;
				rd_xtns_in ++;
				return(1);
			end
      	else
			begin
				xtns_dropped ++;
				return(0);
			end				      
        end
  	endfunction : mem_read  


//-----------------  run() phase  -------------------//

task ram_scoreboard::run_phase(uvm_phase phase);
    fork
	// In forever loop
	// get and print the write data using the tlm fifo
	// Call the method mem_write

		forever
			begin
				
			end
	// In forever loop
	// get and print the read data using the tlm fifo
	// Call the method check_data

        forever
			begin
				
			end
    join
endtask

      	
//Explore method check_data 
function void ram_scoreboard::check_data(read_xtn rd);
  	read_xtn ref_xtn;
  	// Copy of read XTN
	$cast( ref_xtn, rd.clone());
    // Update transaction handle to compared by calling read method of ref_data mem_read(ref_xtn);
   	`uvm_info(get_type_name(), $sformatf("Read Transaction from Memory_Model \n %s",ref_xtn.sprint()), UVM_HIGH)
    if(mem_read(ref_xtn))
		begin
       		//compare
			if(rd.compare(ref_xtn))
				begin
					`uvm_info(get_type_name(), $sformatf("Scoreboard - Data Match successful"), UVM_MEDIUM)
					xtns_compared++ ;
				end
        	else	
				`uvm_error(get_type_name(), $sformatf("\n Scoreboard Error [Data Mismatch]: \n Received Transaction:\n %s \n Expected Transaction: \n %s", 
                                  rd.sprint(), ref_xtn.sprint()))
  		end
       	else
			uvm_report_info(get_type_name(), $psprintf("No Data written in the address=%d \n %s",rd.address, rd.sprint()));

endfunction


function void ram_scoreboard::report_phase(uvm_phase phase);
   // Displays the final report of test using scoreboard statistic
   `uvm_info(get_type_name(), $sformatf("MSTB: Simulation Report from ScoreBoard \n Number of Read Transactions from Read agt_top : %0d \n Number of Write Transactions from write agt_top : %0d \n Number of Read Transactions Dropped : %0d \n Number of Read Transactions compared : %0d \n\n",rd_xtns_in, wr_xtns_in, xtns_dropped, xtns_compared), UVM_LOW)
endfunction */


//************************************************************************/
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------
//
// ram_scoreboard class extends uvm_scoreboard to implement a scoreboard
// that tracks read and write transactions in a RAM model. It uses TLM
// fifos for collecting and comparing read and write transactions, along
// with counters for scoreboard statistics such as the number of transactions,
// successful comparisons, and drops.
//
//************************************************************************

class ram_scoreboard extends uvm_scoreboard;

    // Declare handles for uvm_tlm_analysis_fifos parameterized by read & write transactions as fifo_rdh & fifo_wrh respectively
    uvm_tlm_analysis_fifo #(read_xtn) fifo_rdh;
    uvm_tlm_analysis_fifo #(write_xtn) fifo_wrh;

    // Declare counters for Scoreboard Statistics
    int wr_xtns_in = 0;     // Counts number of write transactions received
    int rd_xtns_in = 0;     // Counts number of read transactions received
    int xtns_compared = 0;  // Counts number of successful comparisons
    int xtns_dropped = 0;   // Counts number of dropped transactions due to data mismatch

    // Factory registration
    `uvm_component_utils(ram_scoreboard)

    // Declare an associative array as a reference model 
    // Type logic [63:0] and index type int
    logic [63:0] ref_data[int];

    // Declare handles of type write_xtn & read_xtn as wr_data & rd_data to store the tlm_analysis_fifo data
    write_xtn wr_data;
    read_xtn rd_data;

    //------------------------------------------
    // Methods
    //------------------------------------------

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        
        // Create instances of uvm_tlm_analysis_fifo with "fifo_h" as name and this component as parent
        fifo_rdh = new("fifo_rdh", this);
        fifo_wrh = new("fifo_wrh", this);
    endfunction : new

    //-----------------  mem_write() method  -------------------//
    // Method to write write_xtn into ref model
    function void mem_write(write_xtn wd);
        if(wd.write) begin
            // Write data to reference model at given address
            ref_data[wd.address] = wd.data;
            // Print write transaction details
            `uvm_info(get_type_name(), $sformatf("Write Transaction from Write agt_top \n %s", wd.sprint()), UVM_HIGH)
            // Increment write transaction counter
            wr_xtns_in++;
        end
    endfunction : mem_write

    //-----------------  mem_read() method  -------------------//
    // Method to read read_xtn from ref model
    function bit mem_read(ref read_xtn rd);
        if(rd.read) begin
            // Print read transaction details
            `uvm_info(get_type_name(), $sformatf("Read Transaction from Read agt_top \n %s", rd.sprint()), UVM_HIGH)
            `uvm_info("MEM Function", $psprintf("Address = %h", rd.address), UVM_LOW)
            
            // Check if data exists at the given address in ref_data
            if(ref_data.exists(rd.address)) begin
                // Retrieve data from reference model and assign to transaction
                rd.data = ref_data[rd.address];
                // Increment read transaction counter
                rd_xtns_in++;
                return(1); // Indicate successful read
            end else begin
                // Increment dropped transaction counter if data is not available
                xtns_dropped++;
                return(0); // Indicate unsuccessful read
            end
        end
    endfunction : mem_read  

    //-----------------  run_phase() method  -------------------//
    // Run phase method to manage write and read data in scoreboarding
    task run_phase(uvm_phase phase);
        fork
            // Forever loop for processing write data from the TLM fifo
            forever begin
                fifo_wrh.get(wr_data); // Get write data from TLM fifo
                `uvm_info(get_type_name(), $sformatf("Processing Write Data: %s", wr_data.sprint()), UVM_HIGH)
                mem_write(wr_data); // Call mem_write method
            end

            // Forever loop for processing read data from the TLM fifo
            forever begin
                fifo_rdh.get(rd_data); // Get read data from TLM fifo
                `uvm_info(get_type_name(), $sformatf("Processing Read Data: %s", rd_data.sprint()), UVM_HIGH)
                check_data(rd_data); // Call check_data method
            end
        join
    endtask : run_phase

    //-----------------  check_data() method  -------------------//
    // Method to check if the data in the read transaction matches
    function void check_data(read_xtn rd);
        read_xtn ref_xtn; // Declare a reference transaction to hold expected data
        // Clone read transaction to ref_xtn
        $cast(ref_xtn, rd.clone());
        
        // Update transaction handle for comparison using mem_read
        if(mem_read(ref_xtn)) begin
            // Compare received read transaction with expected data
            if(rd.compare(ref_xtn)) begin
                `uvm_info(get_type_name(), $sformatf("Scoreboard - Data Match successful"), UVM_MEDIUM)
                xtns_compared++; // Increment compared transaction counter if match is successful
            end else begin
                `uvm_error(get_type_name(), $sformatf("\n Scoreboard Error [Data Mismatch]: \n Received Transaction:\n %s \n Expected Transaction: \n %s", 
                                  rd.sprint(), ref_xtn.sprint()))
            end
        end else begin
            uvm_report_info(get_type_name(), $psprintf("No Data written in the address=%d \n %s", rd.address, rd.sprint()));
        end
    endfunction : check_data

    //-----------------  report_phase() method  -------------------//
    // Method to display the final report of test statistics from scoreboard
    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("MSTB: Simulation Report from ScoreBoard \n Number of Read Transactions from Read agt_top : %0d \n Number of Write Transactions from Write agt_top : %0d \n Number of Read Transactions Dropped : %0d \n Number of Read Transactions Compared : %0d \n\n",
                                              rd_xtns_in, wr_xtns_in, xtns_dropped, xtns_compared), UVM_LOW)
    endfunction : report_phase

endclass : ram_scoreboard








      

   
