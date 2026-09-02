class router_sb extends uvm_scoreboard;

        `uvm_component_utils(router_sb)

        uvm_tlm_analysis_fifo #(write_xtn) fifo_wrh[];
        uvm_tlm_analysis_fifo #(read_xtn) fifo_rdh[];

        router_env_config m_cfg;
        write_xtn w_xtn;
        read_xtn r_xtn;
        bit [1:0] addr;

        covergroup router_wr;
                option.per_instance=1;

                ADDR : coverpoint w_xtn.header[1:0]{
                        bins first = {2'b00};
                        bins second = {2'b01};
                        bins third = {2'b10};
                }
                PAY_LENG : coverpoint w_xtn.header[7:2]{
                        bins small_pkt = {[1:20]};
                        bins medium_pkt = {[21:40]};
                        bins large_pkt = {[41:63]};
                }
                ERROR : coverpoint w_xtn.error{
                        bins error0 = {0};
                        bins error1 = {1};
                }

                W_CROSS:cross ADDR,PAY_LENG,ERROR;

        endgroup


        covergroup router_rd;
                option.per_instance=1;

                ADDR : coverpoint r_xtn.header[1:0]{
                        bins first = {2'b00};
                        bins second = {2'b01};
                        bins third = {2'b10};
                }
                PAY_LENG : coverpoint r_xtn.header[7:2]{
                        bins small_pkt = {[1:20]};
                        bins medium_pkt = {[21:40]};
                        bins large_pkt = {[41:63]};
                }

                R_CROSS : cross ADDR,PAY_LENG;

        endgroup

        extern function new(string name = "router_sb", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task compare(write_xtn w_xtn, read_xtn r_xtn);

endclass

function router_sb::new(string name = "router_sb", uvm_component parent);
        super.new(name, parent);
        //fifo_wrh = new("fifo_wrh", this);
        //fifo_rdh = new("fifo_rdh", this);
        router_wr = new();
        router_rd = new();
endfunction

function void router_sb::build_phase(uvm_phase phase);
        if(!uvm_config_db #(router_env_config)::get(this, "", "router_env_config", m_cfg))
                `uvm_fatal("SB", "cannot get config data");
        fifo_rdh = new[m_cfg.no_of_read_agent];
        fifo_wrh = new[m_cfg.no_of_write_agent];
        foreach(fifo_rdh[i])
                fifo_rdh[i] = new($sformatf("fifo_rdh[%0d]",i), this);
        foreach(fifo_wrh[i])
                fifo_wrh[i] = new($sformatf("fifo_wrh[%0d]",i), this);
        super.build_phase(phase);
endfunction

task router_sb::run_phase(uvm_phase phase);

        forever begin
                fork
                        begin
                                fifo_wrh[0].get(w_xtn);
                                `uvm_info("ROUTER_WR_SCOREBOARD","Data from wr_scoreboard",UVM_LOW);
                                w_xtn.print();
                                router_wr.sample();
                        end

                        begin
                                if(!uvm_config_db#(bit[1:0])::get(this,"","bit[1:0]",addr))
                                        `uvm_fatal( get_type_name(),"getting is failed")

                                fifo_rdh[addr].get(r_xtn);
                                `uvm_info("ROUTER_RD_SCOREBOARD","Data from rd_scoreboard",UVM_LOW);
                                r_xtn.print();
                                router_rd.sample();
                        end
                join

        compare(w_xtn,r_xtn);

        end
endtask


task router_sb::compare(write_xtn w_xtn,read_xtn r_xtn);

        if(w_xtn.header == r_xtn.header)
                $display("header matched");
        else
                $display("header_not_matched");


        if(w_xtn.payload == r_xtn.payload)
                $display("payload matched");
        else
                $display("payload_not_matched");

        if(w_xtn.parity == r_xtn.parity)
                $display("parity matched");
        else
                $display("parity_not_matched");
        $display("---------------------------------------------------------------");

endtask
