module router_fsm(input clock,
                  input resetn,
                  input pkt_valid,
                  input parity_done,
                  input[1:0] data_in,
                  input soft_reset_0,
                  input soft_reset_1,
                  input soft_reset_2,
                  input fifo_full,
                  input low_pkt_valid,
                  input fifo_empty_0,
                  input fifo_empty_1,
                  input fifo_empty_2,
                  output busy,
                  output detect_add,
                  output ld_state,
                  output laf_state,
                  output full_state,
                  output write_enb_reg,
                  output rst_int_reg,
                  output lfd_state
                  );

    reg[2:0] state, next_state;
    reg[1:0] addr;

    parameter DECODE_ADDRESS = 3'b000,
              LOAD_FIRST_DATA = 3'b001,
              WAIT_TILL_EMPTY = 3'b010,
              LOAD_DATA = 3'b011,
              FIFO_FULL_STATE = 3'b100,
              LOAD_AFTER_FULL = 3'b101,
              LOAD_PARITY = 3'b110,
              CHECK_PARITY_ERROR = 3'b111;

    always@(posedge clock) begin
        if(!resetn) begin
            addr <= 2'b00;
        end

        else begin
            addr <= data_in;
        end
    end

    always@(posedge clock) begin
        if((soft_reset_0 && data_in==2'b00) || (soft_reset_1 && data_in==2'b01) || (soft_reset_2 && data_in==2'b10)) begin
            state <= DECODE_ADDRESS;
        end

        else begin
            state <= next_state;
        end
    end

    always@(*) begin
        next_state = DECODE_ADDRESS;
        case(state)

            DECODE_ADDRESS : if((pkt_valid & (data_in[1:0] == 0) & fifo_empty_0) |
                                (pkt_valid & (data_in[1:0] == 1) & fifo_empty_1) |
                                (pkt_valid & (data_in[1:0] == 2) & fifo_empty_2))
                                next_state = LOAD_FIRST_DATA;
                             else if((pkt_valid & (data_in[1:0] == 0) & !fifo_empty_0) |
                                     (pkt_valid & (data_in[1:0] == 1) & !fifo_empty_1) |
                                     (pkt_valid & (data_in[1:0] == 2) & !fifo_empty_2))
                                next_state = WAIT_TILL_EMPTY;
                             else
                                next_state = DECODE_ADDRESS;

            LOAD_FIRST_DATA : next_state = LOAD_DATA;

            LOAD_DATA : if(!fifo_full && !pkt_valid)
                            next_state = LOAD_PARITY;
                        else if(fifo_full)
                            next_state = FIFO_FULL_STATE;
                        else
                            next_state = LOAD_DATA;

            FIFO_FULL_STATE : if(fifo_full)
                                  next_state = FIFO_FULL_STATE;
                              else
                                  next_state = LOAD_AFTER_FULL;

            LOAD_AFTER_FULL : if(!parity_done && !low_pkt_valid)
                                  next_state = LOAD_DATA;
                              else if(!parity_done && low_pkt_valid)
                                  next_state = LOAD_PARITY;
                              else
                                  next_state = DECODE_ADDRESS;

            WAIT_TILL_EMPTY : if((fifo_empty_0 && addr==0) | (fifo_empty_1 && addr==1) | (fifo_empty_2 && addr==2))
                                  next_state = LOAD_FIRST_DATA;
                              else
                                  next_state = WAIT_TILL_EMPTY;

            LOAD_PARITY : next_state = CHECK_PARITY_ERROR;

            CHECK_PARITY_ERROR : if(fifo_full)
                                     next_state = FIFO_FULL_STATE;
                                 else
                                    next_state = DECODE_ADDRESS;

        endcase
    end

      assign detect_add = (state == DECODE_ADDRESS) ? 1'b1 : 1'b0;
      assign lfd_state = (state == LOAD_FIRST_DATA) ? 1'b1 : 1'b0;
      assign busy = (state == LOAD_FIRST_DATA || state == LOAD_PARITY || state == FIFO_FULL_STATE || state == LOAD_AFTER_FULL || state == WAIT_TILL_EMPTY || state == CHECK_PARITY_ERROR) ? 1'b1 : 1'b0;
      assign ld_state = (state == LOAD_DATA) ? 1'b1 : 1'b0;
      assign write_enb_reg = (state == LOAD_DATA || state == LOAD_PARITY || state == LOAD_AFTER_FULL) ? 1'b1 : 1'b0;
      assign full_state = (state == FIFO_FULL_STATE) ? 1'b1 : 1'b0;
      assign laf_state = (state == LOAD_AFTER_FULL) ? 1'b1 : 1'b0;
      assign rst_int_reg = (state == CHECK_PARITY_ERROR);

endmodule
