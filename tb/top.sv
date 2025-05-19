`include "router_if.sv"
import uvm_pkg::*;
import router_pkg::*;
`include "router_top.v"

module top;
    parameter cycle = 10;
    reg clock, resetn;

    router_if in(clock, resetn);

    router_top DUT (.data_in(in.data_in), .pkt_valid(in.pkt_valid), 
                    .clock(clock), .resetn(resetn), 
                    .read_enb_0(in.read_enb0), .read_enb_1(in.read_enb1), .read_enb_2(in.read_enb2),
		            .data_out_0(in.data_out_0), .data_out_1(in.data_out_1), .data_out_2(in.data_out_2),
	                .vld_out_0(in.vld_out_0), .vld_out_1(in.vld_out_1), .vld_out_2(in.vld_out_2), 
                    .err(in.err), .busy(in.busy));

    initial 
        begin
            clock = 1'b0;
            forever 
                begin   
                    #(cycle/2) clock = ~clock;
                end
        end

    initial 
        begin
            uvm_config_db#(virtual router_if)::set(null, "*", "vif", in); 
        end

    initial 
        begin
            run_test("router_test"); 
        end

    initial 
        begin
            resetn = 0;
            #12 resetn = 1;
        end

    initial 
        begin
            $dumpfile("Router1x3.vcd");
            $dumpvars(0);
        end
endmodule