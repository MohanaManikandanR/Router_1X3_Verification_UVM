class router_rd_driver extends uvm_driver #(read_xtn);

        `uvm_component_utils(router_rd_driver)

        virtual router_if.RDR_MP vif;
        router_rd_agt_config r_cfg;

        extern function new(string name = "router_rd_driver", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task send_to_dut(read_xtn xtn);

endclass

function router_rd_driver::new(string name = "router_rd_driver", uvm_component parent);
        super.new(name, parent);
endfunction

function void router_rd_driver::build_phase(uvm_phase phase);
        if(!uvm_config_db #(router_rd_agt_config)::get(this, "", "router_rd_agt_config", r_cfg))
                `uvm_fatal("DRV", "cannot get config data");
        super.build_phase(phase);
endfunction

function void router_rd_driver::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = r_cfg.vif;
endfunction

task router_rd_driver::run_phase(uvm_phase phase);

        forever begin
                seq_item_port.get_next_item(req);
                send_to_dut(req);
                seq_item_port.item_done();
        end
endtask

task router_rd_driver::send_to_dut(read_xtn xtn);

        while(vif.rdr_cb.valid_out!==1)
        @(vif.rdr_cb);

        repeat(xtn.delay)
        @(vif.rdr_cb);
        `uvm_info("ROUTER_RD_DRIVER","Data from rd_driver",UVM_LOW);
        req.print;

        vif.rdr_cb.read_enb <= 1'b1;

        @(vif.rdr_cb);

        while(vif.rdr_cb.valid_out!==0)
        @(vif.rdr_cb);

        @(vif.rdr_cb);

        vif.rdr_cb.read_enb <= 1'b0;
endtask
