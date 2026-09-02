class router_wr_monitor extends uvm_monitor;

        `uvm_component_utils(router_wr_monitor)

        virtual router_if.WMON_MP vif;
        router_wr_agt_config w_cfg;
        uvm_analysis_port #(write_xtn) monitor_port;

        extern function new(string name = "router_wr_monitor", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task collect_data();

endclass

function router_wr_monitor::new(string name = "router_wr_monitor", uvm_component parent);
        super.new(name, parent);
        monitor_port = new("monitor_port", this);
endfunction

function void router_wr_monitor::build_phase(uvm_phase phase);
        if(!uvm_config_db #(router_wr_agt_config)::get(this, "", "router_wr_agt_config", w_cfg))
                `uvm_fatal("WR_MON", "cannot get config data")
        super.build_phase(phase);
endfunction

function void router_wr_monitor::connect_phase(uvm_phase phase);
        vif = w_cfg.vif;
        super.connect_phase(phase);
endfunction

task router_wr_monitor::run_phase(uvm_phase phase);
        forever begin
                collect_data();
        end
endtask

task router_wr_monitor::collect_data();

        write_xtn data_h;
        data_h = write_xtn::type_id::create("data_h");

        while(vif.wmon_cb.pkt_valid!==1)
        @(vif.wmon_cb);

        while(vif.wmon_cb.busy!==0)
        @(vif.wmon_cb);

        data_h.header = vif.wmon_cb.data_in;
        data_h.payload = new[data_h.header[7:2]];
        @(vif.wmon_cb);

        foreach(data_h.payload[i]) begin
                while(vif.wmon_cb.busy!==0)
                @(vif.wmon_cb);
                data_h.payload[i]=vif.wmon_cb.data_in;
                @(vif.wmon_cb);

        end

        while(vif.wmon_cb.pkt_valid!==0)
        @(vif.wmon_cb);

        data_h.parity=vif.wmon_cb.data_in;

        repeat(2)
        @(vif.wmon_cb);
        data_h.error=vif.wmon_cb.error;

        monitor_port.write(data_h);
        `uvm_info("ROUTER_WR_MONITOR","Data from wr_monitor",UVM_LOW);
        data_h.print;

endtask
