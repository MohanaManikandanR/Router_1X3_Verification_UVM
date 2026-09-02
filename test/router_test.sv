class router_test extends uvm_test;

        `uvm_component_utils(router_test)

        router_env_config m_cfg;
        router_wr_agt_config w_cfg[];
        router_rd_agt_config r_cfg[];

        int no_of_write_agent = 1;
        int no_of_read_agent = 3;

        bit has_virtual_sequencer = 1;
        bit has_scoreboard = 1;

        router_env env_h;

        extern function new(string name = "router_test", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void end_of_elaboration_phase(uvm_phase phase);

endclass

function router_test::new(string name = "router_test", uvm_component parent);
        super.new(name, parent);
endfunction

function void router_test::build_phase(uvm_phase phase);

        r_cfg = new[no_of_read_agent];
        w_cfg = new[no_of_write_agent];
        m_cfg = router_env_config::type_id::create("m_cfg");
        m_cfg.r_cfg = new[no_of_read_agent];
        m_cfg.w_cfg = new[no_of_write_agent];
        foreach(w_cfg[i]) begin
                w_cfg[i] = router_wr_agt_config::type_id::create($sformatf("w_cfg[%0d]", i));
                if(!uvm_config_db #(virtual router_if)::get(this, "","vif", w_cfg[i].vif))
                        `uvm_fatal("TEST", "cannot get config data")
                w_cfg[i].is_active = UVM_ACTIVE;
                m_cfg.w_cfg[i] = w_cfg[i];
        end
        foreach(r_cfg[i]) begin
                r_cfg[i] = router_rd_agt_config::type_id::create($sformatf("r_cfg[%0d]", i));
                if(!uvm_config_db #(virtual router_if)::get(this, "", $sformatf("vif[%0d]",i), r_cfg[i].vif))
                        `uvm_fatal("TEST", "cannot get config data")
                r_cfg[i].is_active = UVM_ACTIVE;
                m_cfg.r_cfg[i] = r_cfg[i];
        end
        m_cfg.no_of_write_agent = no_of_write_agent;
        m_cfg.no_of_read_agent = no_of_read_agent;
        m_cfg.has_scoreboard = has_scoreboard;
        m_cfg.has_virtual_sequencer = has_virtual_sequencer;
        uvm_config_db #(router_env_config)::set(this, "*", "router_env_config", m_cfg);
        super.build_phase(phase);
        env_h = router_env::type_id::create("env_h", this);
endfunction

function void router_test::end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
endfunction


//////////////////small_packet//////////////////

class small_test extends router_test;

        `uvm_component_utils(small_test)

        bit[1:0] addr=1;
        nsmall_vseqs seq_h;
        //sftsmall_vseqs seq_h;


        function new(string name="small_test",uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);

                repeat(8) begin
                        seq_h = nsmall_vseqs::type_id::create("seq_h");
                        //seq_h = sftsmall_vseqs::type_id::create("seq_h");
                        addr={$random}%3;
                        uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
                        seq_h.start(env_h.vseqr_h);
                end
                #100;
                phase.drop_objection(this);

        endtask

endclass



////////////medium_packet/////////////////

class medium_test extends router_test;

        `uvm_component_utils(medium_test)

        bit[1:0] addr;

        nmedium_vseqs seq_h;
        //sftmedium_vseqs seq_h;

        function new(string name="medium_test",uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);

                repeat(8) begin
                        seq_h=nmedium_vseqs::type_id::create("seq_h");
                        //seq_h=sftmedium_vseqs::type_id::create("seq_h");
                        addr={$random}%3;
                        uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
                        seq_h.start(env_h.vseqr_h);
                end
                #100;
                phase.drop_objection(this);
        endtask

endclass


//////////////////large_packet////////////////////////

class large_test extends router_test;

        `uvm_component_utils(large_test)

        nlarge_vseqs seq_h;
        //sftlarge_vseqs seq_h;

        bit[1:0] addr;

        function new(string name="large_test",uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);

                repeat(8) begin
                        seq_h=nlarge_vseqs::type_id::create("seq_h");
                        //seq_h=sftlarge_vseqs::type_id::create("seq_h");
                        addr={$random}%3;
                        uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
                        seq_h.start(env_h.vseqr_h);

                end
                #100;

                phase.drop_objection(this);

        endtask

endclass


//////////////small_bad_packet//////////////////

class small_bad_test extends router_test;

        `uvm_component_utils(small_bad_test)

        n_sbad_vseqs seq_h;
        //sft_sbad_vseqs seq_h;

        bit[1:0] addr;


        function new(string name="small_bad_test",uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);

                repeat(8) begin
                        seq_h = n_sbad_vseqs::type_id::create("seq_h");
                        //seq_h=sft_sbad_vseqs::type_id::create("seq_h");
                        addr={$random}%3;
                        uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
                        seq_h.start(env_h.vseqr_h);

                end
                #100;

                phase.drop_objection(this);

        endtask

endclass


//////////////medium_bad_packet//////////////////

class medium_bad_test extends router_test;

        `uvm_component_utils(medium_bad_test)

        n_mbad_vseqs seq_h;
        //sft_mbad_vseqs seq_h;

        bit[1:0] addr;


        function new(string name="medium_bad_test",uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);

                repeat(8) begin
                        seq_h=n_mbad_vseqs::type_id::create("seq_h");
                        //seq_h=sft_mbad_vseqs::type_id::create("seq_h");
                        addr={$random}%3;
                        uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
                        seq_h.start(env_h.vseqr_h);

                end
                #100;

                phase.drop_objection(this);

        endtask

endclass


//////////////large_bad_packet//////////////////

class large_bad_test extends router_test;

        `uvm_component_utils(large_bad_test)

        n_lbad_vseqs seq_h;
        //sft_lbad_vseqs seq_h;

        bit[1:0] addr;


        function new(string name="large_bad_test",uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);

                repeat(8) begin
                        seq_h = n_lbad_vseqs::type_id::create("seq_h");
                        //seq_h = sft_lbad_vseqs::type_id::create("seq_h");
                        addr={$random}%3;
                        uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
                        seq_h.start(env_h.vseqr_h);

                end
                #100;

                phase.drop_objection(this);

        endtask

endclass
