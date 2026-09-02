class router_wr_agent extends uvm_agent;

        `uvm_component_utils(router_wr_agent)

        router_wr_sequencer seqr_h;
        router_wr_driver drv_h;
        router_wr_monitor mon_h;
        router_wr_agt_config w_cfg;

        extern function new(string name = "router_wr_agent", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);

endclass

function router_wr_agent::new(string name = "router_wr_agent", uvm_component parent);
        super.new(name, parent);
endfunction

function void router_wr_agent::build_phase(uvm_phase phase);
        if(!uvm_config_db #(router_wr_agt_config)::get(this, "", "router_wr_agt_config", w_cfg))
                `uvm_fatal("WR_AGT", "cannot get config data");
        super.build_phase(phase);
        if(w_cfg.is_active == UVM_ACTIVE) begin
                seqr_h = router_wr_sequencer::type_id::create("seqr_h", this);
                drv_h = router_wr_driver::type_id::create("drv_h", this);
        end
        mon_h = router_wr_monitor::type_id::create("mon_h", this);
endfunction

function void router_wr_agent::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(w_cfg.is_active == UVM_ACTIVE)
                drv_h.seq_item_port.connect(seqr_h.seq_item_export);
endfunction
