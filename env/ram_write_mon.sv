class ram_write_mon;

   // Instantiate virtual interface instance 'wr_mon_if' of type ram_if with WR_MON_MP modport
   virtual ram_if.WR_MON_MP wr_mon_if;

   // Declare two handles 'wrdata' and 'data2rm' of class type ram_trans
   ram_trans wrdata;
   ram_trans data2rm;

   // Declare a mailbox 'mon2rm' parameterized by type ram_trans
   mailbox #(ram_trans) mon2rm;

   // In constructor
   function new(virtual ram_if.WR_MON_MP wr_mon_if, mailbox #(ram_trans) mon2rm);
      // Pass the virtual interface and mailbox handle 'mon2rm' as input arguments
      this.wr_mon_if = wr_mon_if;
      this.mon2rm = mon2rm;

      // Allocate memory for 'wrdata' transaction handle
      wrdata = new();
   endfunction: new

   // Task to monitor write transactions
   virtual task monitor();
      // Wait for a trigger from the write monitor callback (wr_mon_cb) of the interface
      @(wr_mon_if.wr_mon_cb);

      // Wait for the write signal to be asserted
      wait (wr_mon_if.wr_mon_cb.write == 1);

      // Wait for the next write callback
      @(wr_mon_if.wr_mon_cb);
      
      // Capture the write transaction data from the interface into the 'wrdata' transaction object
      wrdata.write      = wr_mon_if.wr_mon_cb.write;
      wrdata.wr_address = wr_mon_if.wr_mon_cb.wr_address;
      wrdata.data       = wr_mon_if.wr_mon_cb.data_in;

      // Call the display function of the ram_trans class to display the monitored write data
      wrdata.display("DATA FROM WRITE MONITOR");
   endtask: monitor

   // Task to continuously monitor transactions and send them to the scoreboard
   virtual task start();
      fork
         // Begin a forever loop to continuously monitor write transactions
         forever begin
            // Call the monitor task to sample interface signals and convert to transaction items
            monitor();

            // Shallow copy the captured data from 'wrdata' to 'data2rm' for sending to the scoreboard
            data2rm = wrdata;

            // Put the captured transaction item into the mailbox 'mon2rm' for further processing
            mon2rm.put(data2rm);
         end
      join_none
   endtask: start

endclass: ram_write_mon

