class ram_write_drv;

   // Instantiate virtual interface instance wr_drv_if of type ram_if with WR_DRV_MP modport
   virtual ram_if.WR_DRV_MP wr_drv_if;

   // Declare a handle for ram_trans as 'data2duv' to store the transaction data for driving the DUV
   ram_trans data2duv;

   // Declare a mailbox 'gen2wr' parameterized with ram_trans to receive transactions from the generator
   mailbox #(ram_trans) gen2wr;

   // In constructor
   function new(virtual ram_if.WR_DRV_MP wr_drv_if, mailbox #(ram_trans) gen2wr);
      // Pass the virtual interface and mailbox handle 'gen2wr' as input arguments
      // Make connections between the constructor arguments and class members
      this.wr_drv_if = wr_drv_if;
      this.gen2wr = gen2wr;
   endfunction

   // Task to drive the write transaction into the design under verification (DUV)
   virtual task drive();
      // Wait for a trigger from the interface, i.e., wait for the write control block (wr_drv_cb)
      @(wr_drv_if.wr_drv_cb);
      
      // Drive the 'data_in' signal from the transaction object 'data2duv' to the interface
      wr_drv_if.wr_drv_cb.data_in    <= data2duv.data;
      
      // Drive the 'wr_address' signal from the transaction object 'data2duv' to the interface
      wr_drv_if.wr_drv_cb.wr_address <= data2duv.wr_address;
      
      // Set the 'write' signal high to initiate the write operation
      wr_drv_if.wr_drv_cb.write      <= data2duv.write;

      // Wait for two clock cycles after applying all the inputs
      // If 'write' is high, at least one clock cycle will be required to write the data
      repeat(2) 
         @(wr_drv_if.wr_drv_cb);

      // Disable the 'write' signal after the transaction is complete
      wr_drv_if.wr_drv_cb.write <= '0;
      
   endtask: drive

   // Task to continuously fetch and drive transactions
   virtual task start();
      fork
         // Begin a forever loop to continuously fetch data from the mailbox and drive it to the DUV
         forever begin
            // Get the transaction data from the mailbox 'gen2wr' 
            gen2wr.get(data2duv);

            // Call the drive task to apply the transaction to the DUV
            drive();
         end
      join_none
   endtask: start

endclass: ram_write_drv

