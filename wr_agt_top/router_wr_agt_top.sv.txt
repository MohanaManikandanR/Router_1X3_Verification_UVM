class router_wr_agt_top extends uvm_env;

        `uvm_component_utils(router_wr_agt_top)

        router_env_config m_cfg;
        router_wr_agt_config w_cfg;
        router_wr_agent agt_h[];

        extern function new(string name = "router_wr_agt_top", uvm_component parent);
        extern function void build_phase(uvm_phase phase);

endclass

function router_wr_agt_top::new(string name = "router_wr_agt_top", uvm_component parent);
        super.new(name, parent);
endfunction

function void router_wr_agt_top::build_phase(uvm_phase phase);
        if(!uvm_config_db #(router_env_config)::get(this, "", "router_env_config", m_cfg))
                `uvm_fatal("WAGT_TOP", "cannot get config data");
        super.build_phase(phase);
        agt_h = new[m_cfg.no_of_write_agent];
        foreach(agt_h[i]) begin
                uvm_config_db #(router_wr_agt_config)::set(this, $sformatf("agt_h[%0d]*",i), "router_wr_agt_config", m_cfg.w_cfg[i]);
                agt_h[i] = router_wr_agent::type_id::create($sformatf("agt_h[%0d]",i), this);
        end
endfunction
