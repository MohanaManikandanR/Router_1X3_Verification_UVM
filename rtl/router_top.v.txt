module router_top(input clock,
                  input resetn,
                  input read_enb_0,
                  input read_enb_1,
                  input read_enb_2,
                  input[7:0] data_in,
                  input pkt_valid,
                  output[7:0] data_out_0,
                  output[7:0] data_out_1,
                  output[7:0] data_out_2,
                  output valid_out_0,
                  output valid_out_1,
                  output valid_out_2,
                  output error,
                  output busy
                  );

    wire[2:0] write_enb;
    wire soft_reset_0;
    wire soft_reset_1;
    wire soft_reset_2;
    wire lfd_state;
    wire empty_0;
    wire empty_1;
    wire empty_2;
    wire full_0;
    wire full_1;
    wire full_2;
    wire detect_add;
    wire write_enb_reg;
    wire fifo_full;
    wire parity_done;
    wire low_pkt_valid;
    wire ld_state;
    wire laf_state;
    wire full_state;
    wire rst_int_reg;
    wire[7:0] dout;

    router_fsm FSM(.clock(clock),
                   .resetn(resetn),
                   .pkt_valid(pkt_valid),
                   .busy(busy),
                   .parity_done(parity_done),
                   .data_in(data_in[1:0]),
                   .soft_reset_0(soft_reset_0),
                   .soft_reset_1(soft_reset_1),
                   .soft_reset_2(soft_reset_2),
                   .fifo_full(fifo_full),
                   .low_pkt_valid(low_pkt_valid),
                   .fifo_empty_0(empty_0),
                   .fifo_empty_1(empty_1),
                   .fifo_empty_2(empty_2),
                   .detect_add(detect_add),
                   .ld_state(ld_state),
                   .laf_state(laf_state),
                   .full_state(full_state),
                   .write_enb_reg(write_enb_reg),
                   .rst_int_reg(rst_int_reg),
                   .lfd_state(lfd_state)
                   );

    router_sync Synchronizer(.detect_add(detect_add),
                             .clk(clock),
                             .resetn(resetn),
                             .data_in(data_in[1:0]),
                             .vld_out_0(valid_out_0),
                             .vld_out_1(valid_out_1),
                             .vld_out_2(valid_out_2),
                             .read_enb_0(read_enb_0),
                             .read_enb_1(read_enb_1),
                             .read_enb_2(read_enb_2),
                             .write_enb(write_enb),
                             .fifo_full(fifo_full),
                             .empty_0(empty_0),
                             .empty_1(empty_1),
                             .empty_2(empty_2),
                             .soft_reset_0(soft_reset_0),
                             .soft_reset_1(soft_reset_1),
                             .soft_reset_2(soft_reset_2),
                             .full_0(full_0),
                             .full_1(full_1),
                             .full_2(full_2),
                             .write_enb_reg(write_enb_reg)
                             );
    router_reg Register(.clock(clock),
                        .resetn(resetn),
                        .pkt_valid(pkt_valid),
                        .data_in(data_in),
                        .fifo_full(fifo_full),
                        .detect_add(detect_add),
                        .ld_state(ld_state),
                        .laf_state(laf_state),
                        .full_state(full_state),
                        .rst_int_reg(rst_int_reg),
                        .lfd_state(lfd_state),
                        .parity_done(parity_done),
                        .low_pkt_valid(low_pkt_valid),
                        .err(error),
                        .dout(dout)
                        );

    router_fifo FIFO_0(.clock(clock),
                       .resetn(resetn),
                       .write_enb(write_enb[0]),
                       .soft_reset(soft_reset_0),
                       .read_enb(read_enb_0),
                       .data_in(dout),
                       .lfd_state(lfd_state),
                       .empty(empty_0),
                       .data_out(data_out_0),
                       .full(full_0)
                       );

    router_fifo FIFO_1(.clock(clock),
                       .resetn(resetn),
                       .write_enb(write_enb[1]),
                       .soft_reset(soft_reset_1),
                       .read_enb(read_enb_1),
                       .data_in(dout),
                       .lfd_state(lfd_state),
                       .empty(empty_1),
                       .data_out(data_out_1),
                       .full(full_1)
                       );

    router_fifo FIFO_2(.clock(clock),
                       .resetn(resetn),
                       .write_enb(write_enb[2]),
                       .soft_reset(soft_reset_2),
                       .read_enb(read_enb_2),
                       .data_in(dout),
                       .lfd_state(lfd_state),
                       .empty(empty_2),
                       .data_out(data_out_2),
                       .full(full_2)
                       );

endmodule
