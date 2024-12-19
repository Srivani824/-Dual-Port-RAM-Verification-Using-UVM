class ram_gen;

   // Declare a handle 'gen_trans' of class type ram_trans which has to be randomized
   ram_trans gen_trans;

   // Declare a handle 'data2send' of class type ram_trans which has to be put into the mailboxes
   ram_trans data2send;

   // Declare two mailboxes gen2rd, gen2wr parameterized by ram_trans
   mailbox #(ram_trans) gen2rd;
   mailbox #(ram_trans) gen2wr;
   
   // In constructor
   // Add mailboxes parameterized by transaction class as an argument and make the assignment
   // and create the object for the handle to be randomized
   function new(mailbox#(ram_trans) gen2rd, mailbox#(ram_trans) gen2wr);
      this.gen2rd = gen2rd;
      this.gen2wr = gen2wr;
      gen_trans = new(); // Create the object for the handle to be randomized
   endfunction : new

   // In virtual task start
   virtual task start();
      // Inside fork join_none
      fork
         repeat (ram_pkg::number_of_transactions) begin
            // Generate random transactions equal to number_of_transactions (defined in package)
					
            // Randomize using transaction handle using 'if' or 'assert'
            if (!gen_trans.randomize()) begin
               // If randomization fails, display message "DATA NOT RANDOMIZED" and stop the simulation
               $display("ERROR: DATA NOT RANDOMIZED");
               $finish;
            end
            
            // Shallow copy gen_trans to data2send
            data2send = gen_trans;

            // Put the handle into both the mailboxes
            gen2rd.put(data2send);
            gen2wr.put(data2send);
         end
      join_none
   endtask: start

endclass: ram_gen

