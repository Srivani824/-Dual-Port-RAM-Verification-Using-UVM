class ram_read_drv;

   // Instantiate virtual interface instance rd_drv_if of type ram_if with RD_DRV_MP modport
   virtual ram_if.RD_DRV_MP rd_drv_if;

   // Declare a handle for ram_trans as 'data2duv'
   ram_trans data2duv;

   // Declare a mailbox 'gen2rd' parameterized with ram_trans
   mailbox #(ram_trans) gen2rd;

   // In constructor 
   // pass the following as the input arguments: 
   // virtual interface and mailbox handle 'gen2rd' parameterized by ram_trans 
   function new(virtual ram_if.RD_DRV_MP rd_drv_if, mailbox #(ram_trans) gen2rd);
      this.rd_drv_if = rd_drv_if;
      this.gen2rd = gen2rd;
   endfunction

   // Task to drive signals to the interface
   virtual task drive();
      // Wait for valid data in the mailbox
      @(rd_drv_if.rd_drv_cb);

      // Apply inputs
      rd_drv_if.rd_drv_cb.rd_address <= data2duv.rd_address;
      rd_drv_if.rd_drv_cb.read       <= data2duv.read;	 

      // Wait for two clock cycles after applying all the inputs
      // If read is high, at least one clock cycle will be required to read the data
      repeat(2) 
         @(rd_drv_if.rd_drv_cb);

      // Disable the read signal after reading
      rd_drv_if.rd_drv_cb.read <= '0;
   endtask: drive
	
   // Task to start the read driver
   virtual task start();
      fork
         forever begin
            // Get the data from the mailbox 'gen2rd'
            gen2rd.get(data2duv);

            // Call the drive task to apply the signals
            drive();
         end
      join_none
   endtask: start

endclass: ram_read_drv

