class ram_read_mon;

   // Instantiate virtual interface instance rd_mon_if of type ram_if with RD_MON_MP modport
   virtual ram_if.RD_MON_MP rd_mon_if;

   // Declare three handles 'rddata', 'data2rm' and 'data2sb' of class type ram_trans
   ram_trans rddata;
   ram_trans data2rm;
   ram_trans data2sb;

   // Declare two mailboxes 'mon2rm' and 'mon2sb' parameterized by type ram_trans
   mailbox #(ram_trans) mon2rm;
   mailbox #(ram_trans) mon2sb;

   // In constructor
   // Pass the following as the input arguments: virtual interface and mailbox handles 'mon2rm' and 'mon2sb' 
   function new(virtual ram_if.RD_MON_MP rd_mon_if, mailbox #(ram_trans) mon2rm, mailbox #(ram_trans) mon2sb);
      this.rd_mon_if = rd_mon_if;
      this.mon2rm = mon2rm;
      this.mon2sb = mon2sb;

      // Allocate memory for 'rddata'
      rddata = new();
   endfunction







   // Task to monitor the read signals from the interface
   virtual task monitor();
      // Wait for the read signal to be asserted on the interface
      @(rd_mon_if.rd_mon_cb);
      wait (rd_mon_if.rd_mon_cb.read == 1);
      
      // Sample the read transaction data from the interface
      @(rd_mon_if.rd_mon_cb);
      begin
         rddata.read       = rd_mon_if.rd_mon_cb.read;
         rddata.rd_address = rd_mon_if.rd_mon_cb.rd_address;
         rddata.data_out   = rd_mon_if.rd_mon_cb.data_out;
         
         // Call the display method of the ram_trans to display the monitor data
         rddata.display("DATA FROM READ MONITOR");
      end
   endtask: monitor

   // Task to start the monitoring process
   virtual task start();
      fork
         // Continuous monitoring in a forever loop
         forever begin
            // Call the monitor task
            monitor();
            
            // Shallow copy rddata to data2sb
            data2sb = rddata;

            // Shallow copy rddata to data2rm
            data2rm = rddata;
            
            // Put the transaction item into two mailboxes mon2rm and mon2sb
            mon2rm.put(data2rm);
            mon2sb.put(data2sb);
         end
      join_none
   endtask: start

endclass: ram_read_mon

