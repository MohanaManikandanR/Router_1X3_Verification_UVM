class router_wr_driver extends uvm_driver #(write_xtn);

        `uvm_component_utils(router_wr_driver)

        virtual router_if.WDR_MP vif;
        router_wr_agt_config w_cfg;

        extern function new(string name = "router_wr_driver", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task send_to_dut(write_xtn xtn);

endclass

function router_wr_driver::new(string name = "router_wr_driver", uvm_component parent);
        super.new(name, parent);
endfunction

function void router_wr_driver::build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(router_wr_agt_config)::get(this, "", "router_wr_agt_config", w_cfg))
                `uvm_fatal("DRV", "cannot get config data")
endfunction

function void router_wr_driver::connect_phase(uvm_phase phase);
        vif = w_cfg.vif;
        super.connect_phase(phase);
endfunction

task router_wr_driver::run_phase(uvm_phase phase);


        @(vif.wdr_cb)
                vif.wdr_cb.rst<=0;
        @(vif.wdr_cb)
                vif.wdr_cb.rst<=1;


        forever begin
                seq_item_port.get_next_item(req);
                send_to_dut(req);
                seq_item_port.item_done();
        end
endtask


task router_wr_driver::send_to_dut(write_xtn xtn);
        while(vif.wdr_cb.busy!==0)
        @(vif.wdr_cb);

        vif.wdr_cb.pkt_valid<=1'b1;
        vif.wdr_cb.data_in <= xtn.header;
        @(vif.wdr_cb);

        foreach(xtn.payload[i]) begin
                while(vif.wdr_cb.busy!==0)
                @(vif.wdr_cb);
                vif.wdr_cb.data_in <= xtn.payload[i];
                @(vif.wdr_cb);
        end

        vif.wdr_cb.pkt_valid <= 1'b0;
        vif.wdr_cb.data_in <= xtn.parity;

        `uvm_info("ROUTER_WR_DRIVER","Data from wr_driver",UVM_LOW);
        xtn.print;
endtask
