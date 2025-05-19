module router_reg(input clock,resetn,pkt_valid,fifo_full,detect_add,ld_state,
		laf_state,full_state,lfd_state,rst_int_reg,
		input [7:0]data_in,
		output reg err,parity_done,low_pkt_valid,
		output reg[7:0]dout);
reg [7:0] header,parity_reg,packet_parity,fifo_full_state;

//header
always@(posedge clock)
begin
if(detect_add & pkt_valid)
begin
	if(data_in[1:0]==2'b00|2'b01|2'b10)
	header<=data_in;
end
end

//parity calculation
always@(posedge clock)
begin
	if(lfd_state)
		begin
			parity_reg<=header;
		end
	else if(ld_state&~full_state&pkt_valid)
		begin
			parity_reg<=(parity_reg^data_in);
		end
end

//parity check err
always@(posedge clock)
begin
if(~resetn)
	err<=0;
else
begin
	if(parity_done)
		begin 
		packet_parity<=data_in;
		if(packet_parity!=parity_reg)
			err<=1;
		end
	else
		err<=0;		
end
end

//parity done
always@(posedge clock)
begin
if(~resetn)
	parity_done<=0;
else
begin
	if(detect_add)
		parity_done<=0;
	else if(laf_state&low_pkt_valid&~parity_done)
		parity_done<=1;	
	else if (ld_state&~fifo_full&~pkt_valid)
		parity_done<=1;
 end
end

//low pkt valid
always@(posedge clock)
begin
if(~resetn)
	low_pkt_valid<=0;
else
begin
	if(rst_int_reg)
		low_pkt_valid<=0;
	
	
	else if(ld_state&~pkt_valid)
		low_pkt_valid<=1;

end
end

//dout
always@(posedge clock)
begin
if(~resetn)
	dout<=0;
else
begin
	if(lfd_state)
		dout<=header;
	
	else if(ld_state&~fifo_full)
		dout<=data_in;

	else if(ld_state&fifo_full)
		fifo_full_state<=data_in;
	else if(laf_state )
			dout<=fifo_full_state;


end
end
endmodule
