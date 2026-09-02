module router_fifo(input clock,
                   input resetn,
                   input write_enb,
                   input soft_reset,
                   input read_enb,
                   input[7:0] data_in,
                   input lfd_state,
                   output empty,
                   output full,
                   output reg[7:0] data_out
                   );

    reg[8:0] fifo[15:0];
    reg[6:0] count;
    reg[4:0] wr_ptr;
    reg[4:0] rd_ptr;
    integer i;
    reg temp;

    always@(posedge clock) begin
        if(!resetn)
            temp <= 1'b0;
        else
            temp <= lfd_state;
    end

    always@(posedge clock) begin
        if(!resetn) begin
            for(i=0;i<16;i=i+1)
                fifo[i] <= 9'b0_0000_0000;
            wr_ptr <= 0;
        end

        else if(soft_reset) begin
            for(i=0;i<16;i=i+1)
                fifo[i] <= 9'b0_0000_0000;
            wr_ptr <= 0;
        end

        else if(write_enb && !full) begin
            fifo[wr_ptr[3:0]] <= {temp, data_in};
            wr_ptr <= wr_ptr + 1'b1;
        end
    end

    always@(posedge clock) begin
        if(!resetn) begin
            data_out <= 8'b0000_0000;
            rd_ptr <= 5'b0_0000;
        end
        else if(soft_reset)
            data_out <= 8'bz;
        else if(count==0)
            data_out <= 8'bz;
        else if(read_enb && !empty) begin
            data_out <= fifo[rd_ptr[3:0]][7:0];
            rd_ptr <= rd_ptr + 1'b1;
        end
        else
            data_out <= 8'bz;
    end

    always@(posedge clock) begin
        if(!resetn)
            count <= 7'b000_0000;
        else if(soft_reset)
            count <= 7'b000_0000;
        else if(fifo[rd_ptr[3:0]][8] == 1'b1)
            count <= fifo[rd_ptr[3:0]][7:2] + 1'b1;
        else if(read_enb && !empty)
            count <= count - 1'b1;
        else
            count <= count;
    end

    assign full = ((wr_ptr[4] != rd_ptr[4]) && (wr_ptr[3:0] == rd_ptr[3:0])) ? 1'b1 : 1'b0;
    assign empty = (wr_ptr == rd_ptr) ? 1'b1 : 1'b0;

endmodule
