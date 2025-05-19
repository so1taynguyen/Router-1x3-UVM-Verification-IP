`uvm_analysis_imp_decl(_src)
`uvm_analysis_imp_decl(_des0)
`uvm_analysis_imp_decl(_des1)
`uvm_analysis_imp_decl(_des2)

class router_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(router_scoreboard)

    logic [7:0] src_data[$:66];
    logic [7:0] des_data[3][$:66];
    logic [7:0] cov_data;
    bit [1:0] cov_port;
    int port;

    logic [7:0] tmp1, tmp2, h, cov_h;
    int i;

    int flag_des0 = 0;
    int flag_des1 = 0;
    int flag_des2 = 0;

    int no_src_rcv = 0;
    int no_des0_rcv = 0;
    int no_des1_rcv = 0;
    int no_des2_rcv = 0;
    int pkt_matched = 0;
    int pkt_compared = 0;
    int pkt_dismatched_port = 0;
    int pkt_dismatched_data = 0;

    uvm_analysis_imp_src #(logic [7:0], router_scoreboard) src_port;
    uvm_analysis_imp_des0 #(logic [7:0], router_scoreboard) des0_port;
    uvm_analysis_imp_des1 #(logic [7:0], router_scoreboard) des1_port;
    uvm_analysis_imp_des2 #(logic [7:0], router_scoreboard) des2_port;
    
    covergroup router_coverage;
        option.per_instance = 1;
        DATA: coverpoint cov_data {
            bins LOW = {[0:84]};
            bins MEDIUM = {[85:169]};
            bins HIGH = {[170:255]};
        }
        DEST: coverpoint cov_port {
            bins DES_0 = {0};
            bins DES_1 = {1};
            bins DES_2 = {2};
        }
        NO_OF_PAYLOAD: coverpoint cov_h {
            bins LOW = {[1:21]};
            bins MEDIUM = {[22:42]};
            bins HIGH = {[43:63]};
        }
        //DATAxDESxPAYLOAD: cross DATA, DEST, NO_OF_PAYLOAD;
    endgroup

    function new(string name = "router_scoreboard", uvm_component parent);
        begin
            super.new(name, parent);
            src_port = new("src_port", this);
            des0_port = new("des0_port", this);
            des1_port = new("des1_port", this);
            des2_port = new("des2_port", this);
            router_coverage = new;
        end
    endfunction

    task run_phase(uvm_phase phase);
        begin
            forever 
                begin
                    wait (flag_des0 == 1 || flag_des1 == 1 || flag_des2 == 1)
                    begin
                        h = src_data[0];
                        $cast(port, h[1:0]);
                        i = 0;
                        while ((des_data[port].size() != 0) && (src_data.size() != 0))
                            begin
                                pkt_compared++;
                                tmp1 = src_data.pop_front();
                                tmp2 = des_data[port].pop_front();
                                if (tmp1 == tmp2)
                                    begin
                                        `uvm_info("SB:", $sformatf("data no.%0d matched", i), UVM_LOW)
                                        i++;
                                        pkt_matched++;
                                    end
                                else
                                    begin
                                        `uvm_info("SB", $sformatf("data no.%0d dismatched", i), UVM_LOW)
                                        i++;
                                        pkt_dismatched_data++;
                                    end
                            end
                        flag_des0 = 0;
                        flag_des1 = 0;
                        flag_des2 = 0;
                    end
                end
        end 
    endtask

    
    virtual function void write_src (logic [7:0] trans);
        begin
            logic [7:0] temp;
            $cast(temp, trans);
            src_data.push_back(temp);
            no_src_rcv++;
            cov_data = temp;
            cov_h = src_data[0];
            cov_port = cov_h[1:0];
            cov_h = {2'b00, cov_h[7:2]};
            router_coverage.sample();
        end
    endfunction

    virtual function void write_des0 (logic [7:0] trans);
        begin
            logic [7:0] temp, header;
            int no_data;
            bit [1:0] channel;
            $cast(temp, trans);
            header = src_data[0];
            channel = header[1:0];
            $cast(no_data, header[7:2]);
            if (channel == 2'd0)
                begin
                    des_data[0].push_back(temp);
                    if (des_data[0].size() == no_data + 2)
                        begin
                            flag_des0 = 1;
                        end
                    no_des0_rcv++;    
                end
            else 
                begin
                    $display("SB: Port dismatched!");
                    pkt_dismatched_port++;
                end
        end
    endfunction

    virtual function void write_des1 (logic [7:0] trans);
        begin
            logic [7:0] temp, header;
            int no_data;
            bit [1:0] channel;
            $cast(temp, trans);
            header = src_data[0];
            channel = header[1:0];
            $cast(no_data, header[7:2]);
            if (channel == 2'd1)
                begin
                    des_data[1].push_back(temp);
                    if (des_data[1].size() == no_data + 2)
                        begin
                            flag_des1 = 1;
                        end
                    no_des1_rcv++;
                end
            else 
                begin
                    $display("SB: Port dismatched!");
                    pkt_dismatched_port++;
                end
        end
    endfunction

    virtual function void write_des2 (logic [7:0] trans);
        begin
            logic [7:0] temp, header;
            int no_data;
            bit [1:0] channel;
            $cast(temp, trans);
            header = src_data[0];
            channel = header[1:0];
            $cast(no_data, header[7:2]);
            if (channel == 2'd2)
                begin
                    des_data[2].push_back(temp);
                    if (des_data[2].size() == no_data + 2)
                        begin
                            flag_des2 = 1;
                        end
                    no_des2_rcv++;
                end
            else 
                begin
                    $display("SB: Port dismatched!");
                    pkt_dismatched_port++;
                end
        end
    endfunction

    function void report_phase(uvm_phase phase);
        $display("==========SCOREBOARD REPORT==========");
        $display("Number of data from source: %0d", no_src_rcv);
        $display("Number of data from client 0: %0d", no_des0_rcv);
        $display("Number of data from client 1: %0d", no_des1_rcv);
        $display("Number of data from client 2: %0d", no_des2_rcv);
        $display("Number of compared data: %0d", pkt_compared);
        $display("Number of matched data: %0d", pkt_matched);
        $display("Number of dismatched port packet: %0d", pkt_dismatched_port);
        $display("Number of dismatched data packet: %0d", pkt_dismatched_data);
        $display("=====================================");
    endfunction
    
endclass