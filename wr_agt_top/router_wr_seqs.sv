class router_wbase_seqs extends uvm_sequence #(write_xtn);

     `uvm_object_utils(router_wbase_seqs)

function new(string name="router_wbase_seq");
        super.new(name);
endfunction

endclass

////////// small_packet/////////

class small_seqs extends router_wbase_seqs;
        `uvm_object_utils(small_seqs)

        bit[1:0] addr;

        function new(string name="small_seqs");
                super.new(name);
        endfunction

        task body();
                //$display("small seq started");
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                        `uvm_fatal(get_type_name(),"getting address is failed")
                //$display("addr=%0d",addr);
                req = write_xtn::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {header[7:2] inside {[1:20]};header[1:0]==addr;})
                finish_item(req);
        endtask

endclass


////////////////medium_packet///////////

class medium_seqs extends router_wbase_seqs;
        `uvm_object_utils(medium_seqs)

        bit[1:0] addr;

        function new(string name="medium_seqs");
                super.new(name);
        endfunction

        task body();
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                        `uvm_fatal(get_type_name(),"getting adress is failed")
                req=write_xtn::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {header[7:2] inside {[21:40]};header[1:0]==addr;})
                finish_item(req);
        endtask

endclass

/////////////////////large_packet//////////////

class large_seqs extends router_wbase_seqs;
        `uvm_object_utils(large_seqs)

        bit[1:0] addr;

        function new(string name="large_seqs");
                super.new(name);
        endfunction

        task body();
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal(get_type_name(),"getting adress is failed")
                req=write_xtn::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {header[7:2] inside {[41:63]};header[1:0]==addr;})
                finish_item(req);
        endtask

endclass


//////////////////small_bad_packet//////////////

class small_bad_seqs extends router_wbase_seqs;
        `uvm_object_utils(small_bad_seqs)

        bit[1:0] addr;

        function new(string name="small_bad_seqs");
                super.new(name);
        endfunction

        task body();
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                        `uvm_fatal(get_type_name(),"getting adress is failed")
                req=write_xtn::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {header[7:2] inside {[1:20]};header[1:0]==addr;})
                req.parity=8'd10;
                finish_item(req);
        endtask

endclass


//////////////////medium_bad_packet//////////////

class medium_bad_seqs extends router_wbase_seqs;
        `uvm_object_utils(medium_bad_seqs)

        bit[1:0] addr;

        function new(string name="medium_bad_seqs");
                super.new(name);
        endfunction

        task body();
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                        `uvm_fatal(get_type_name(),"getting adress is failed")
                req=write_xtn::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {header[7:2] inside {[21:40]};header[1:0]==addr;})
                req.parity=8'd10;
                finish_item(req);
        endtask

endclass


//////////////////large_bad_packet//////////////

class large_bad_seqs extends router_wbase_seqs;
        `uvm_object_utils(large_bad_seqs)

        bit[1:0] addr;

        function new(string name="large_bad_seqs");
                super.new(name);
        endfunction

        task body();
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                        `uvm_fatal(get_type_name(),"getting adress is failed")
                req=write_xtn::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {header[7:2] inside {[41:63]};header[1:0]==addr;})
                req.parity=8'd10;
                finish_item(req);
        endtask

endclass
