module router_fifo(input[7:0] data_in,input clock,soft_reset,resetn,lfd_state,write_enb,read_enb,
			output  full,empty,
			output reg [7:0]data_out );
reg [4:0]w_add,r_add;
reg[8:0]mem[15:0];
reg [6:0]count;
reg temp;
integer i;
always@(posedge clock)
begin	
		if (~resetn)
		w_add<=0;
		else if(write_enb&&~full)
		w_add<=w_add+1;
			
end
always@(posedge clock)
begin
	temp<=lfd_state;
end
	
always@(posedge clock)
begin
		if (~resetn)
		r_add<=0;
		if(read_enb&&~empty)
		r_add<=r_add+1;
end

always@(posedge clock)
begin
			if(~resetn)
				begin
				data_out<=0;
				for(i=0;i<16;i=i+1)
					mem[i]<=0;
				end
			else if (soft_reset)
				begin
				data_out<=8'bz;
					for(i=0;i<16;i=i+1)
					mem[i]<=0;
					r_add<=0;
					w_add<=0;
				end	
			else
				begin 
				if(write_enb&&~full)	
					mem[w_add[3:0]]<={temp,data_in};
				if(read_enb&&~empty)
					data_out<=mem[r_add[3:0]];
				if(count==0&&data_out!=0)
							 data_out<=8'bz;

			end
end			

always@(posedge clock)
begin     
			if(read_enb&&~empty)
			 begin
				if(mem[r_add[3:0]][8:8]==1'b1)
					count<= mem[r_add[3:0]][7:2]+1'b1;
				else 
					count<=count-1;
				end 
					
					
		
end					
				
assign empty=(r_add==w_add)?1:0;
assign full=({~w_add[4],w_add[3:0]}==r_add)?1:0;	
endmodule
