/************************************************************************
  
Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
  
www.maven-silicon.com 
  
All Rights Reserved. 
This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd. 
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.
  
Filename		:   ram_rd_monitor.sv

Description 	:	Read Monitor class for Dual Port RAM TB
  
Author Name		:   Putta Satish

Support e-mail	: 	For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

Version			:	1.0

************************************************************************/
/*//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

// Extend ram_rd_monitor from uvm_monitor
class ram_rd_monitor extends uvm_monitor;

	// Factory Registration
	`uvm_component_utils(ram_rd_monitor)

	// Declare virtual interface handle with RMON_MP as modport
   	virtual ram_if.RMON_MP vif;

	// Declare the ram_rd_agent_config handle as "m_cfg"
    ram_rd_agent_config m_cfg;

	// Analysis TLM port to connect the monitor to the scoreboard 


	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "ram_rd_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);


endclass 

//-----------------  constructor new method  -------------------//
 
function ram_rd_monitor::new (string name = "ram_rd_monitor", uvm_component parent);
	super.new(name, parent);
	// create object for handle monitor_port using new
   
endfunction : new

//-----------------  build() phase method  -------------------//
 
 function void ram_rd_monitor::build_phase(uvm_phase phase);
	// call super.build_phase(phase);
    super.build_phase(phase);
	// get the config object using uvm_config_db 
	if(!uvm_config_db #(ram_rd_agent_config)::get(this,"","ram_rd_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction

//-----------------  connect() phase method  -------------------//
// in connect phase assign the configuration object's virtual interface
// to the monitor's virtual interface instance(handle --> "vif")
function void ram_rd_monitor::connect_phase(uvm_phase phase);
    vif = m_cfg.vif;
endfunction


//-----------------  run() phase method  -------------------//
	

// In forever loop
// Call task collect_data
task ram_rd_monitor::run_phase(uvm_phase phase);
    forever
		// Call collect data task
		collect_data();     
endtask


//Collect Reference Data from DUV IF 
task ram_rd_monitor::collect_data();

    read_xtn data_sent;
	// Create an instance data_sent
    data_sent= read_xtn::type_id::create("data_sent");

    @(posedge vif.rmon_cb.read);
    data_sent.read = vif.rmon_cb.read;
    data_sent.address = vif.rmon_cb.rd_address;
    data_sent.xtn_type = (data_sent.address == 'd1904) ? BAD_XTN : GOOD_XTN ;
    repeat(2)
    @(vif.rmon_cb);
    data_sent.data = vif.rmon_cb.data_out;
    //Debug Print - Set Verbosity level UVM_HIGH only to debug
    `uvm_info("RAM_RD_MONITOR",$sformatf("printing from monitor \n %s", data_sent.sprint()),UVM_LOW) 
	// LAB : Call write method of analysis port after collecting the data
  
    //increment mon_rcvd_xtn_cnt
    m_cfg.mon_rcvd_xtn_cnt++;
endtask 

// UVM report_phase
function void ram_rd_monitor::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: RAM Read Monitor Collected %0d Transactions", m_cfg.mon_rcvd_xtn_cnt), UVM_LOW)
endfunction   */



//************************************************************************//
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------
// Extend ram_rd_monitor from uvm_monitor
class ram_rd_monitor extends uvm_monitor;

    // Factory Registration
    `uvm_component_utils(ram_rd_monitor)

    // Declare virtual interface handle with RMON_MP as modport
    // The monitor will interact with the DUT's interface via this virtual interface
    virtual ram_if.RMON_MP vif;

    // Declare the ram_rd_agent_config handle as "m_cfg"
    ram_rd_agent_config m_cfg;

    // Analysis TLM port to connect the monitor to the scoreboard
    // This port will be used to send collected data to the scoreboard for verification
    uvm_analysis_port #(read_xtn) monitor_port;
	int mon_rcvd_xtn_cnt;

    //------------------------------------------
    // METHODS
    //------------------------------------------

    // Standard UVM Methods:
    extern function new(string name = "ram_rd_monitor", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task collect_data();
    extern function void report_phase(uvm_phase phase);

endclass 

//-----------------  constructor new method  -------------------//

// Define the constructor for ram_rd_monitor
function ram_rd_monitor::new(string name = "ram_rd_monitor", uvm_component parent);
    super.new(name, parent);
    // Create object for handle monitor_port using new
    monitor_port = new("monitor_port", this);
endfunction : new

//-----------------  build() phase method  -------------------//

// The build_phase method is used for building and configuring the monitor.
function void ram_rd_monitor::build_phase(uvm_phase phase);
    // Call the base class build_phase
    super.build_phase(phase);

    // Get the configuration object using uvm_config_db
    if(!uvm_config_db#(ram_rd_agent_config)::get(this, "", "ram_rd_agent_config", m_cfg))
        `uvm_fatal("CONFIG", "cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction

//-----------------  connect() phase method  -------------------//

// The connect_phase method is used for connecting the virtual interface to the monitor.
function void ram_rd_monitor::connect_phase(uvm_phase phase);
    // Assign the configuration object's virtual interface to the monitor's virtual interface instance (vif)
    vif = m_cfg.vif;
endfunction

//-----------------  run() phase method  -------------------//

// The run_phase method is responsible for continuously collecting data.
task ram_rd_monitor::run_phase(uvm_phase phase);
    // In forever loop, continuously call task collect_data to collect reference data
    forever begin
        collect_data();  // Call collect_data task to capture data from the interface
    end
endtask

//-----------------  collect_data() task  -------------------//

// The collect_data task is used to collect data from the DUT interface and store it.
task ram_rd_monitor::collect_data();
    read_xtn data_sent;
    
    // Create an instance of data_sent to store the collected transaction
    data_sent = read_xtn::type_id::create("data_sent");

    // Wait for a read signal on the virtual interface and collect the relevant data
    @(posedge vif.rmon_cb.read);  // Wait for the read signal
    data_sent.read = vif.rmon_cb.read;  // Capture the read signal
  data_sent.address = vif.rmon_cb.rd_address;  // Capture the read address

    // Check if the address is a bad transaction (e.g., address 1904) or a good transaction
    data_sent.xtn_type = (data_sent.address == 'd1904) ? BAD_XTN : GOOD_XTN;

    // Wait for the next two clock cycles to collect the data
    repeat(2)
        @(vif.rmon_cb);  // Wait for two clock cycles

    // Capture the data output after the address
    data_sent.data = vif.rmon_cb.data_out;

    // Debug Print - Set Verbosity level UVM_HIGH only to debug
    `uvm_info("RAM_RD_MONITOR", $sformatf("Printing from monitor:\n%s", data_sent.sprint()), UVM_LOW);

    // Write the collected transaction to the analysis port to send it to the scoreboard
    monitor_port.write(data_sent);  // Send data to the scoreboard

    // Increment the transaction count in the configuration object
    //m_cfg.mon_rcvd_xtn_cnt++;  // Update the received transaction count
	//mon_rcvd_xtn_cnt = mon_rcvd_xtn_cnt + 1;
	mon_rcvd_xtn_cnt++;
endtask 

//-----------------  report_phase() method  -------------------//

// The report_phase method is responsible for reporting the number of transactions collected.
function void ram_rd_monitor::report_phase(uvm_phase phase);
    // Report the number of transactions collected by the monitor
    `uvm_info(get_type_name(), $sformatf("Report: RAM Read Monitor Collected %0d Transactions", mon_rcvd_xtn_cnt), UVM_LOW);
endfunction
      
     
    


