class router_rd_monitor extends uvm_monitor;

        `uvm_component_utils(router_rd_monitor)

        virtual router_if.RMON_MP vif;
        router_rd_agt_config r_cfg;
        uvm_analysis_port #(read_xtn) monitor_port;
        read_xtn data_h;

        extern function new(string name = "router_rd_monitor", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task collect_data();

endclass

function router_rd_monitor::new(string name = "router_rd_monitor", uvm_component parent);
        super.new(name, parent);
        monitor_port = new("monitor_port", this);
endfunction

function void router_rd_monitor::build_phase(uvm_phase phase);
        if(!uvm_config_db #(router_rd_agt_config)::get(this, "", "router_rd_agt_config", r_cfg))
                `uvm_fatal("RD_MON", "cannot get config data");
        super.build_phase(phase);
endfunction

function void router_rd_monitor::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = r_cfg.vif;
endfunction

task router_rd_monitor::run_phase(uvm_phase phase);
        forever
         collect_data();
endtask

task router_rd_monitor::collect_data();

        data_h = read_xtn::type_id::create("data_h");

        while(vif.rmon_cb.read_enb!==1)
        @(vif.rmon_cb);
        @(vif.rmon_cb);
        data_h.header = vif.rmon_cb.data_out;
        data_h.payload = new[data_h.header[7:2]];
        @(vif.rmon_cb);

        foreach(data_h.payload[i]) begin
                data_h.payload[i]=vif.rmon_cb.data_out;
                @(vif.rmon_cb);
        end

        data_h.parity=vif.rmon_cb.data_out;
        repeat(2)
        @(vif.rmon_cb);

        monitor_port.write(data_h);
        `uvm_info("ROUTER_RD_MONITOR","Data from rd_monitor",UVM_LOW);
        data_h.print;

endtask
