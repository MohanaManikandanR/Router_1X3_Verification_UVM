interface router_if(input bit clock);

        logic [7:0] data_in;
        logic [7:0] data_out;
        logic rst;
        logic error;
        logic busy;
        bit read_enb;
        logic valid_out;
        bit pkt_valid;

        clocking wdr_cb @(posedge clock);
                default input #1 output #1;
                output data_in;
                output pkt_valid;
                output rst;
                input error;
                input busy;
        endclocking

        clocking rdr_cb @(posedge clock);
                default input #1 output #1;
                output read_enb;
                input valid_out;
        endclocking

        clocking wmon_cb @(posedge clock);
                default input #1 output #1;
                input data_in;
                input pkt_valid;
                input error;
                input busy;
                input rst;
        endclocking

        clocking rmon_cb @(posedge clock);
                default input #1 output #1;
                input data_out;
                input read_enb;
        endclocking

        modport WDR_MP (clocking wdr_cb);
        modport RDR_MP (clocking rdr_cb);
        modport WMON_MP (clocking wmon_cb);
        modport RMON_MP (clocking rmon_cb);

endinterface
