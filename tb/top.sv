module top;

        import router_test_pkg::*;
        import uvm_pkg::*;

        bit clock;
        always #5 clock = ~clock;

        router_if in(clock);
        router_if in0(clock);
        router_if in1(clock);
        router_if in2(clock);

        router_top DUV( .clock(clock),
                        .resetn(in.rst),
                        .read_enb_0(in0.read_enb),
                        .read_enb_1(in1.read_enb),
                        .read_enb_2(in2.read_enb),
                        .data_in(in.data_in),
                        .pkt_valid(in.pkt_valid),
                        .data_out_0(in0.data_out),
                        .data_out_1(in1.data_out),
                        .data_out_2(in2.data_out),
                        .valid_out_0(in0.valid_out),
                        .valid_out_1(in1.valid_out),
                        .valid_out_2(in2.valid_out),
                        .error(in.error),
                        .busy(in.busy));

        initial begin
                uvm_config_db #(virtual router_if)::set(null, "*", "vif", in);
                uvm_config_db #(virtual router_if)::set(null, "*", "vif[0]", in0);
                uvm_config_db #(virtual router_if)::set(null, "*", "vif[1]", in1);
                uvm_config_db #(virtual router_if)::set(null, "*", "vif[2]", in2);
                run_test("router_test");
        end


        property stable_data;
                @(posedge clock) in.busy |=>$stable(in.data_in);
        endproperty

        property busy_check;
                @(posedge clock) $rose(in.pkt_valid) |=>in.busy;
        endproperty

        property valid_signal;
                @(posedge clock) $rose(in.pkt_valid)|->##3(in0.valid_out|in1.valid_out|in2.valid_out);
        endproperty

        property rd_en0;
                @(posedge clock) in0.valid_out|->##[1:29]in0.read_enb;
        endproperty

        property rd_en1;
                @(posedge clock) in1.valid_out|->##[1:29]in1.read_enb;
        endproperty

        property rd_en2;
                @(posedge clock) in2.valid_out|->##[1:29]in2.read_enb;
        endproperty

        c1:assert property(stable_data)
                $display("assertions is done for stable data");
        else
                $display("assertions is not done for stable data");

        c2:assert property(busy_check)
                $display("assertions is done for busy check");
        else
                $display("assertions is not done for busy check");

        c3:assert property(valid_signal)
                $display("assertions is done for valid out");
        else
                $display("assertions is not done for valid out");

        c4:assert property(rd_en0)
                $display("assertions is done for read en 0");
        else
                $display("assertions is not done for read en 0");

        c5:assert property(rd_en1)
                $display("assertions is done for read en 1");
        else
                $display("assertions is not done for read en 1");

        c6:assert property(rd_en2)
                $display("assertions is done for read en 2");
        else
                $display("assertions is not done for read en 2");


        //STABLE_DATA : assert property (stable_data);
        //BUSY_CHECK : assert property (busy_check);
        //VALID_SIGNAL : assert property (valid_signal);
        //READ_ENABLE0 : assert property (rd_en1);
        //READ_ENABLE1 : assert property (rd_en2);
        //READ_ENABLE2 : assert property (rd_en3);

endmodule
