class router_rd_agt_top extends uvm_env;

        `uvm_component_utils(router_rd_agt_top)

        router_env_config m_cfg;
        router_rd_agt_config r_cfg[];
        router_rd_agent agt_h[];

        extern function new(string name = "router_rd_agt_top", uvm_component parent);
        extern function void build_phase(uvm_phase phase);

endclass

function router_rd_agt_top::new(string name = "router_rd_agt_top", uvm_component parent);
        super.new(name, parent);
endfunction

function void router_rd_agt_top::build_phase(uvm_phase phase);
        if(!uvm_config_db #(router_env_config)::get(this, "", "router_env_config", m_cfg))
                `uvm_fatal("RAGT_TOP", "cannot get config data");
        super.build_phase(phase);
        agt_h = new[m_cfg.no_of_read_agent];
        foreach(agt_h[i]) begin
                uvm_config_db #(router_rd_agt_config)::set(this, $sformatf("agt_h[%0d]*",i), "router_rd_agt_config", m_cfg.r_cfg[i]);
                agt_h[i] = router_rd_agent::type_id::create($sformatf("agt_h[%0d]",i), this);
        end
endfunction
