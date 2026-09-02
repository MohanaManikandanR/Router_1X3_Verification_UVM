class router_env_config extends uvm_object;

        bit has_wagent = 1;
        bit has_ragent = 1;
        int no_of_write_agent = 1;
        int no_of_read_agent = 3;
        bit has_virtual_sequencer = 1;
        bit has_scoreboard = 1;

        router_wr_agt_config w_cfg[];
        router_rd_agt_config r_cfg[];

        `uvm_object_utils(router_env_config)

        extern function new(string name = "router_env_config");

endclass

function router_env_config::new(string name = "router_env_config");
        super.new(name);
endfunction
