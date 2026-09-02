class router_env extends uvm_env;

        `uvm_component_utils(router_env)
        router_env_config m_cfg;
        router_wr_agt_top wagt_top;
        router_rd_agt_top ragt_top;
        router_sb sb_h;
        router_virtual_sequencer vseqr_h;

        extern function new(string name = "router_env", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);

endclass

function router_env::new(string name = "router_env", uvm_component parent);
        super.new(name, parent);
endfunction

function void router_env::build_phase(uvm_phase phase);
        if(!uvm_config_db #(router_env_config)::get(this, "", "router_env_config", m_cfg))
                `uvm_fatal("ENV", "cannot get config data");
        super.build_phase(phase);
        if(m_cfg.has_wagent == 1)
                wagt_top = router_wr_agt_top::type_id::create("wagt_top", this);
        if(m_cfg.has_ragent == 1)
                ragt_top = router_rd_agt_top::type_id::create("ragt_top", this);
        if(m_cfg.has_scoreboard == 1)
                sb_h = router_sb::type_id::create("sb_h", this);
        if(m_cfg.has_virtual_sequencer == 1)
                vseqr_h = router_virtual_sequencer::type_id::create("vseqr_h", this);
endfunction

function void router_env::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(m_cfg.has_virtual_sequencer) begin
                if(m_cfg.has_wagent == 1) begin
                        foreach(vseqr_h.wr_seqrh[i])
                                vseqr_h.wr_seqrh[i] = wagt_top.agt_h[i].seqr_h;
                end
                if(m_cfg.has_ragent == 1) begin
                        foreach(vseqr_h.rd_seqrh[i])
                                vseqr_h.rd_seqrh[i] = ragt_top.agt_h[i].seqr_h;
                end
        end
        if(m_cfg.has_scoreboard == 1) begin
                if(m_cfg.has_wagent == 1) begin
                        foreach(wagt_top.agt_h[i])
                                wagt_top.agt_h[i].mon_h.monitor_port.connect(sb_h.fifo_wrh[i].analysis_export);
                end
                if(m_cfg.has_ragent == 1) begin
                        foreach(ragt_top.agt_h[i])
                                ragt_top.agt_h[i].mon_h.monitor_port.connect(sb_h.fifo_rdh[i].analysis_export);
                end
        end
endfunction
