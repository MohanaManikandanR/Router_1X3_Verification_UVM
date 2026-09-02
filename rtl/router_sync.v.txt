module router_sync(input detect_add,
                   input [1:0] data_in,
                   input write_enb_reg,
                   input clk,
                   input resetn,
                   input read_enb_0,
                   input read_enb_1,
                   input read_enb_2,
                   input empty_0,
                   input empty_1,
                   input empty_2,
                   input full_0,
                   input full_1,
                   input full_2,
                   output vld_out_0,
                   output vld_out_1,
                   output vld_out_2,
                   output reg soft_reset_0,
                   output reg soft_reset_1,
                   output reg soft_reset_2,
                   output reg [2:0] write_enb,
                   output reg fifo_full
                   );

    reg [1:0] temp;

    reg [4:0] count_0, count_1, count_2;

    assign vld_out_0 = ~empty_0;
    assign vld_out_1 = ~empty_1;
    assign vld_out_2 = ~empty_2;

    always @(posedge clk) begin
        if(!resetn) begin
            temp <= 2'b11;
        end
        else begin
            if(detect_add) begin
                temp <= data_in;
            end
        end
    end

    always @(*) begin
        case (temp)
            2'b00: fifo_full = full_0;
            2'b01: fifo_full = full_1;
            2'b10: fifo_full = full_2;
            default: fifo_full = 1'b0;
        endcase
    end

    always @(*) begin
        if(write_enb_reg) begin
            case(temp)
                2'b00: write_enb = 3'b001;
                2'b01: write_enb = 3'b010;
                2'b10: write_enb = 3'b100;
                default: write_enb = 3'b000;
            endcase
        end
        else begin
            write_enb = 3'b000;
        end
    end

    always @(posedge clk) begin
        if(!resetn) begin
            count_0 <= 5'b0;
            soft_reset_0 <= 0;
        end
        else if (vld_out_0) begin
            if(!read_enb_0) begin
                if(count_0 == 29) begin
                    soft_reset_0 <= 1'b1;
                    count_0 <= 5'b0;
                end
                else begin
                    count_0 <= count_0 + 1;
                end
            end
            else begin
                count_0 <= 5'b0;
            end
        end
        else begin
            count_0 <= 5'b0;
        end
    end

    always @(posedge clk) begin
        if(!resetn) begin
            count_1 <= 5'b0;
            soft_reset_1 <= 0;
        end
        else if (vld_out_1) begin
            if(!read_enb_1)begin
                if(count_1 == 29) begin
                    soft_reset_1 <= 1'b1;
                    count_1 <= 5'b0;
                end
                else begin
                    count_1 <= count_1 + 1;
                end
            end
            else begin
                count_1 <= 5'b0;
            end
        end
        else begin
            count_1 <= 5'b0;
        end
    end

    always @(posedge clk) begin
        if(!resetn) begin
            count_2 <= 5'b0;
            soft_reset_2 <= 0;
        end
        else if (vld_out_2) begin
            if(!read_enb_2) begin
                if(count_2 == 29) begin
                    soft_reset_2 <= 1'b1;
                    count_2 <= 5'b0;
                end
                else begin
                    count_2 <= count_2 + 1;
                end
            end
            else begin
                count_2 <= 5'b0;
            end
        end
        else begin
            count_2 <= 5'b0;
        end
    end

endmodule
