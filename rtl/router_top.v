`include "router_fifo.v"
`include "router_fsm.v"
`include "router_reg.v"
`include "router_sync.v"

module router_top 	(input [7:0] data_in,
							input pkt_valid, clock, resetn,read_enb_0,read_enb_1,read_enb_2,
							output  [7:0] data_out_0,data_out_1,data_out_2,
							output vld_out_0,vld_out_1, vld_out_2, err,busy);
							wire [7:0] din;
wire [2:0] write_enb;
wire [2:0]soft_reset_,empty_,read_enb_,full_;

wire [7:0]data_out_temp[2:0];
wire lfd_state;

assign data_out_0=data_out_temp[0]; assign data_out_1=data_out_temp[1]; assign data_out_2=data_out_temp[2];
assign read_enb_[0]=read_enb_0;		assign read_enb_[1]=read_enb_1;	   assign read_enb_[2]=read_enb_2;


genvar i;
generate for (i=0;i<3;i=i+1)
begin : fifo
router_fifo FIFO1 (din,clock,soft_reset_[i],resetn,lfd_state,write_enb[i],
                   read_enb_[i],full_[i],empty_[i],data_out_temp[i]);
end
endgenerate

router_fsm FSM(clock, resetn, pkt_valid, fifo_full,empty_[0],empty_[1],empty_[2],
		  parity_done,low_pkt_valid,soft_reset_[0],soft_reset_[1],soft_reset_[2],data_in[1:0],write_enb_reg,
		  detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy);

router_sync SYN(clock,resetn,detect_add,full_[0],full_[1],full_[2],empty_[0],empty_[1],
		empty_[2],write_enb_reg,read_enb_0,read_enb_1,read_enb_2,
		data_in[1:0],write_enb,fifo_full,vld_out_0,vld_out_1,vld_out_2,
		soft_reset_[0],soft_reset_[1],soft_reset_[2]);
		
router_reg REG(clock,resetn,pkt_valid,fifo_full,detect_add,ld_state,
		laf_state,full_state,lfd_state,rst_int_reg,data_in,
		err,parity_done,low_pkt_valid,din);

endmodule

