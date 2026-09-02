class write_xtn extends uvm_sequence_item;

        `uvm_object_utils(write_xtn);

        rand bit [7:0] header;
        rand bit [7:0] payload [];
        bit [7:0] parity;
        bit pkt_valid;
        bit busy,error;

        constraint a1 {
                header[1:0]!=2'b11;
                header[7:2]!=0;
        }

        constraint a2 {
                payload.size == header[7:2];
        }

        extern function new(string name = "write_xtn");
        extern function void do_print(uvm_printer printer);
        extern function void post_randomize();

endclass

function write_xtn::new(string name = "write_xtn");
        super.new(name);
endfunction

function void write_xtn::do_print(uvm_printer printer);
        printer.print_field("header",this.header,8,UVM_DEC);
        foreach(payload[i])
           printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);
        printer.print_field("parity",this.parity,8,UVM_DEC);
        printer.print_field("busy",this.busy,1,UVM_DEC);
        printer.print_field("error",this.error,1,UVM_DEC);
endfunction

function void write_xtn::post_randomize();
        parity = parity^header;
         foreach(payload[i])
                parity = parity^payload[i];
endfunction
