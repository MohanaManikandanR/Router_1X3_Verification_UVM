class router_rbase_seqs extends uvm_sequence #(read_xtn);

        `uvm_object_utils(router_rbase_seqs)

        function new(string name = "router_rbase_seqs");
                super.new(name);
        endfunction

endclass

//////////////////normal_seq///////////////////

class normal_seqs extends router_rbase_seqs;

        `uvm_object_utils(normal_seqs)

        function new(string name="normal_seqs");
                super.new(name);
        endfunction

        task body();
                req = read_xtn::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {delay<30;});
                finish_item(req);
        endtask

endclass


///////////////sft_rst_seq/////////////////////

class sftrst_seqs extends router_rbase_seqs;

        `uvm_object_utils(sftrst_seqs)

        function new(string name="sftrst_seqs");
                super.new(name);
        endfunction

        task body();
                req = read_xtn::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {delay>30;});
                finish_item(req);
        endtask

endclass
