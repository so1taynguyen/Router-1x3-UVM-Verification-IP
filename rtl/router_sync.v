module router_sync(input clock,resetn,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,
                   input [1:0]data_in,
                   output reg [2:0]write_enb,
                   output reg fifo_full,vld_out_0,vld_out_1,vld_out_2,soft_reset_0,soft_reset_1,soft_reset_2 );
reg [1:0] temp;
reg [4:0]count_0,count_1,count_2;

always@(posedge clock)
begin
	if(detect_add)
		temp=data_in;
end

always@(*)
begin
		  fifo_full=0;		
    	  case(temp)
	     2'b00: fifo_full=full_0;
		  2'b01: fifo_full=full_1;
		  2'b10: fifo_full=full_2;
	
		endcase
end

always@(*)
begin
	vld_out_0=~empty_0;
	vld_out_1=~empty_1;
	vld_out_2=~empty_2;
end

always@(*)
begin
		if(write_enb_reg)
		begin
	          write_enb=3'b000;
		  case(temp)
	 	  	      2'b00: write_enb=3'b001;
	    	   	2'b01: write_enb=3'b010;
	    	   	2'b10: write_enb=3'b100;
    	  endcase
		end	
		else
					write_enb=0;
		
end
		
always@(posedge clock)
begin
	if(~resetn)
		count_0<=0;
	else
		begin
		if(~read_enb_0)	
			begin
			if (vld_out_0)
					begin	
					if(count_0==29)
							begin
							soft_reset_0<=1'b1;
							count_0<=0;
							end
					else
							begin
							count_0<=count_0+1;
							soft_reset_0<=1'b0;
							end
					end
			end
		else
			count_0<=0;
		end
end

always@(posedge clock)
begin
	if(~resetn)
		count_1<=0;
	else
		begin
		if(~read_enb_1)	
			begin
			if (vld_out_1)
					begin	
					if(count_1==29)
							begin
							soft_reset_1<=1'b1;
							count_1<=0;
							end
					else
							begin
							count_1<=count_1+1;
							soft_reset_1<=1'b0;
							end
					end
			end
		else
			count_1<=0;
		end
end


always@(posedge clock)
begin
	if(~resetn)
		count_2<=0;
	else
		begin
		if(~read_enb_2)	
			begin
			if (vld_out_2)
					begin	
					if(count_2==29)
							begin
							soft_reset_2<=1'b1;
							count_2<=0;
							end
					else
							begin
							count_2<=count_2+1;
							soft_reset_2<=1'b0;
							end
					end
			end
		else
			count_2<=0;
		end
end

endmodule
