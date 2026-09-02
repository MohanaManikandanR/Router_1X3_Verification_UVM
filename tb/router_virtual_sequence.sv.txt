class router_vbase_seqs extends uvm_sequence #(uvm_sequence_item);

        `uvm_object_utils(router_vbase_seqs)

        bit [1:0]addr;

        small_seqs s_seqh;
        medium_seqs m_seqh;
        large_seqs l_seqh;
        small_bad_seqs s_bseqh;
        medium_bad_seqs m_bseqh;
        large_bad_seqs l_bseqh;

        normal_seqs n_seqh;
        sftrst_seqs sft_seqh;


        router_wr_sequencer wr_seqrh[];
        router_rd_sequencer rd_seqrh[];

        router_virtual_sequencer vsqrh;

        router_env_config m_cfg;

        function new(string name="router_vbase_seqs");
                super.new(name);
        endfunction


        virtual task body();
                if(!uvm_config_db#(router_env_config)::get(null,get_full_name(),"router_env_config",m_cfg))
                        `uvm_fatal(get_type_name(),"getting is failed");

                wr_seqrh = new[m_cfg.no_of_write_agent];
                rd_seqrh = new[m_cfg.no_of_read_agent];

                assert($cast(vsqrh,m_sequencer)) else begin
                `uvm_error("BODY", "Error in $cast of virtual sequencer")
                end

                foreach(wr_seqrh[i])
                        wr_seqrh[i]=vsqrh.wr_seqrh[i];
                foreach(rd_seqrh[i])
                        rd_seqrh[i]=vsqrh.rd_seqrh[i];

        endtask

endclass


////////////////////////////normal_small_seqs///////////////////////////////////////

class nsmall_vseqs extends router_vbase_seqs;

        `uvm_object_utils(nsmall_vseqs)

        function new(string name="nsmall_seqs");
                super.new(name);
        endfunction

        task body();
                super.body();
                //$display("Started small virtual seqs");
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                        `uvm_fatal(get_type_name(),"getting is failed")
                //$display("addr=%0d",addr);
                s_seqh = small_seqs::type_id::create("s_seqh");
                n_seqh = normal_seqs::type_id::create("n_seqh");

                fork
                        s_seqh.start(wr_seqrh[0]);
                        n_seqh.start(rd_seqrh[addr]);
                join

        endtask
endclass


////////////////////////////sftrst_small_seqs///////////////////////////////////////

class sftsmall_vseqs extends router_vbase_seqs;

        `uvm_object_utils(sftsmall_vseqs)

        function new(string name="sftsmall_seqs");
                super.new(name);
        endfunction

        task body();
                super.body();
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                        `uvm_fatal(get_type_name(),"getting is failed")

                s_seqh=small_seqs::type_id::create("s_seqh");
                sft_seqh=sftrst_seqs::type_id::create("sft_seqh");

                fork
                        s_seqh.start(wr_seqrh[0]);
                        sft_seqh.start(rd_seqrh[addr]);
                join

        endtask
endclass


////////////////////////////normal_medium_seqs///////////////////////////////////////

class nmedium_vseqs extends router_vbase_seqs;

        `uvm_object_utils(nmedium_vseqs)

        function new(string name="nmedium_seqs");
                super.new(name);
        endfunction

        task body();
                super.body();
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                        `uvm_fatal(get_type_name(),"getting is failed")

                m_seqh=medium_seqs::type_id::create("m_seqh");
                n_seqh=normal_seqs::type_id::create("n_seqh");

                fork
                        m_seqh.start(wr_seqrh[0]);
                        n_seqh.start(rd_seqrh[addr]);
                join

        endtask
endclass


///////////////////////////sftrst_medium_seqs///////////////////////////////////////

class sftmedium_vseqs extends router_vbase_seqs;

        `uvm_object_utils(sftmedium_vseqs)

        function new(string name="sftmedium_seqs");
                super.new(name);
        endfunction

        task body();
                super.body();
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                        `uvm_fatal(get_type_name(),"getting is failed")

                m_seqh=medium_seqs::type_id::create("m_seqh");
                sft_seqh=sftrst_seqs::type_id::create("sft_seqh");

                fork
                        m_seqh.start(wr_seqrh[0]);
                        sft_seqh.start(rd_seqrh[addr]);
                join

        endtask
endclass


////////////////////////////normal_large_seqs///////////////////////////////////////

class nlarge_vseqs extends router_vbase_seqs;

        `uvm_object_utils(nlarge_vseqs)

        function new(string name="nlarge_seqs");
                super.new(name);
        endfunction

        task body();
                super.body();
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                        `uvm_fatal(get_type_name(),"getting is failed")

                l_seqh=large_seqs::type_id::create("l_seqh");
                n_seqh=normal_seqs::type_id::create("n_seqh");

                fork
                        l_seqh.start(wr_seqrh[0]);
                        n_seqh.start(rd_seqrh[addr]);
                join

        endtask
endclass


///////////////////////////sftrst_large_seqs///////////////////////////////////////

class sftlarge_vseqs extends router_vbase_seqs;

        `uvm_object_utils(sftlarge_vseqs)

        function new(string name="sftlarge_seqs");
                super.new(name);
        endfunction

        task body();
                super.body();
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                        `uvm_fatal(get_type_name(),"getting is failed")

                l_seqh=large_seqs::type_id::create("l_seqh");
                sft_seqh=sftrst_seqs::type_id::create("sft_seqh");

                fork
                        l_seqh.start(wr_seqrh[0]);
                        sft_seqh.start(rd_seqrh[addr]);
                join

        endtask
endclass


////////////////////////////normal_small_bad_seqs///////////////////////////////////////

class n_sbad_vseqs extends router_vbase_seqs;

        `uvm_object_utils(n_sbad_vseqs)

        function new(string name="n_sbad_seqs");
                super.new(name);
        endfunction

        task body();
                super.body();
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                        `uvm_fatal(get_type_name(),"getting is failed")

                s_bseqh= small_bad_seqs::type_id::create("b_seqh");
                n_seqh=normal_seqs::type_id::create("n_seqh");

                fork
                        s_bseqh.start(wr_seqrh[0]);
                        n_seqh.start(rd_seqrh[addr]);
                join

        endtask
endclass


///////////////////////////sftrst_small_bad_seqs///////////////////////////////////////

class sft_sbad_vseqs extends router_vbase_seqs;

        `uvm_object_utils(sft_sbad_vseqs)

        function new(string name="sft_sbad_seqs");
                super.new(name);
        endfunction

        task body();
                super.body();
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                        `uvm_fatal(get_type_name(),"getting is failed")

                s_bseqh= small_bad_seqs::type_id::create("b_seqh");
                sft_seqh=sftrst_seqs::type_id::create("sft_seqh");

                fork
                        s_bseqh.start(wr_seqrh[0]);
                        sft_seqh.start(rd_seqrh[addr]);
                join

        endtask
endclass


////////////////////////////normal_medium_bad_seqs///////////////////////////////////////

class n_mbad_vseqs extends router_vbase_seqs;

        `uvm_object_utils(n_mbad_vseqs)

        function new(string name="n_mbad_seqs");
                super.new(name);
        endfunction

        task body();
                super.body();
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                        `uvm_fatal(get_type_name(),"getting is failed")

                m_bseqh= medium_bad_seqs::type_id::create("b_seqh");
                n_seqh=normal_seqs::type_id::create("n_seqh");

                fork
                        m_bseqh.start(wr_seqrh[0]);
                        n_seqh.start(rd_seqrh[addr]);
                join

        endtask
endclass


///////////////////////////sftrst_medium_bad_seqs///////////////////////////////////////

class sft_mbad_vseqs extends router_vbase_seqs;

        `uvm_object_utils(sft_mbad_vseqs)

        function new(string name="sft_mbad_seqs");
                super.new(name);
        endfunction

        task body();
                super.body();
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                        `uvm_fatal(get_type_name(),"getting is failed")

                m_bseqh = medium_bad_seqs::type_id::create("b_seqh");
                sft_seqh=sftrst_seqs::type_id::create("sft_seqh");

                fork
                        m_bseqh.start(wr_seqrh[0]);
                        sft_seqh.start(rd_seqrh[addr]);
                join

        endtask
endclass

////////////////////////////normal_large_bad_seqs///////////////////////////////////////

class n_lbad_vseqs extends router_vbase_seqs;

        `uvm_object_utils(n_lbad_vseqs)

        function new(string name="n_lbad_seqs");
                super.new(name);
        endfunction

        task body();
                super.body();
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                        `uvm_fatal(get_type_name(),"getting is failed")

                l_bseqh= large_bad_seqs::type_id::create("b_seqh");
                n_seqh=normal_seqs::type_id::create("n_seqh");

                fork
                        l_bseqh.start(wr_seqrh[0]);
                        n_seqh.start(rd_seqrh[addr]);
                join

        endtask
endclass


///////////////////////////sftrst_large_bad_seqs///////////////////////////////////////

class sft_lbad_vseqs extends router_vbase_seqs;

        `uvm_object_utils(sft_lbad_vseqs)

        function new(string name="sft_lbad_seqs");
                super.new(name);
        endfunction

        task body();
                super.body();
                if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                        `uvm_fatal(get_type_name(),"getting is failed")

                l_bseqh = large_bad_seqs::type_id::create("b_seqh");
                sft_seqh=sftrst_seqs::type_id::create("sft_seqh");

                fork
                        l_bseqh.start(wr_seqrh[0]);
                        sft_seqh.start(rd_seqrh[addr]);
                join

        endtask
endclass

