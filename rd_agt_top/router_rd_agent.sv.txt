class router_rd_agent extends uvm_agent;

        `uvm_component_utils(router_rd_agent)

        router_rd_sequencer seqr_h;
        router_rd_driver drv_h;
        router_rd_monitor mon_h;
        router_rd_agt_config r_cfg;

        extern function new(string name = "router_rd_agent", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);

endclass

function router_rd_agent::new(string name = "router_rd_agent", uvm_component parent);
        super.new(name, parent);
endfunction

function void router_rd_agent::build_phase(uvm_phase phase);
        if(!uvm_config_db #(router_rd_agt_config)::get(this, "", "router_rd_agt_config", r_cfg))
                `uvm_fatal("RD_AGT", "cannot get config data");
        super.build_phase(phase);
        if(r_cfg.is_active == UVM_ACTIVE) begin
                seqr_h = router_rd_sequencer::type_id::create("seqr_h", this);
                drv_h = router_rd_driver::type_id::create("drv_h", this);
        end
        mon_h = router_rd_monitor::type_id::create("mon_h", this);
endfunction

function void router_rd_agent::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(r_cfg.is_active == UVM_ACTIVE)
                drv_h.seq_item_port.connect(seqr_h.seq_item_export);
endfunction
