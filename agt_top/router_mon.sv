class router_mon extends uvm_monitor;
    `uvm_component_utils(router_mon)

    virtual router_if.MON_MP vif;

    router_env_config m_cfg;

    uvm_analysis_port #(logic [7:0]) src2sb_port;
    uvm_analysis_port #(logic [7:0]) des0tosb_port;
    uvm_analysis_port #(logic [7:0]) des1tosb_port;
    uvm_analysis_port #(logic [7:0]) des2tosb_port;

    router_trans src2sb;
    router_trans des0tosb, des1tosb, des2tosb;
    
    function new(string name = "router_mon", uvm_component parent);
        begin
            super.new(name, parent);
            src2sb_port = new ("src2sb", this);
            des0tosb_port = new ("des0tosb_port", this);
            des1tosb_port = new ("des1tosb_port", this);
            des2tosb_port = new ("des2tosb_port", this);
        end
    endfunction

    function void build_phase(uvm_phase phase);
        begin
            super.build_phase(phase);
            if (!(uvm_config_db#(router_env_config)::get(this, "", "router_env_config", m_cfg)))
                `uvm_fatal("CONFIG", "cannot get() m_cfg from uvm_config_db. Have you set() it?")
        end
    endfunction
    
    function void connect_phase(uvm_phase phase);
        begin
            vif = m_cfg.vif;
        end
    endfunction
    
    task run_phase(uvm_phase phase);
        begin
            fork
                begin
                    forever
                        collect_src_data();
                end

                begin
                    forever
                        begin
                            @(posedge vif.mon_cb.read_enb0)
                                collect_des0_data();  
                        end
                end

                begin
                    forever
                        begin
                            @(posedge vif.mon_cb.read_enb1)
                                collect_des1_data();  
                        end
                end

                begin
                    forever
                        begin
                            @(posedge vif.mon_cb.read_enb2)
                                collect_des2_data();  
                        end
                end
            join
        end
    endtask

    task collect_src_data;
        begin
            wait (vif.mon_cb.resetn && vif.mon_cb.pkt_valid)
            src2sb = router_trans::type_id::create("src2sb");
            src2sb.full_pkt[0] = vif.mon_cb.data_in;
            $cast(src2sb.payload_count, src2sb.full_pkt[0][7:2]);   
            wait (!(vif.mon_cb.busy))
                begin
                    @(vif.mon_cb);
                    for (int i = 1; i <= src2sb.payload_count + 1; i++)
                    begin
                        @(vif.mon_cb);
                        begin
                            src2sb.full_pkt[i] = vif.mon_cb.data_in;
                        end
                    end       
                end
            for (int i = 0; i <= src2sb.payload_count + 1; i++)
                src2sb_port.write(src2sb.full_pkt[i]);
            m_cfg.mon_rcv_pkt++;
            `uvm_info("SOURCE_MONITOR", $sformatf("printing from monitor \n%s", src2sb.sprint()), UVM_LOW)
        end
    endtask

    task collect_des0_data;
        begin
            @(vif.mon_cb);
            des0tosb = router_trans::type_id::create("des0tosb");
            des0tosb.full_pkt[0] = vif.mon_cb.data_out_0;
            $cast(des0tosb.payload_count, des0tosb.full_pkt[0][7:2]);
            for (int i = 1; i <= des0tosb.payload_count + 1; i++)
                begin
                    @(vif.mon_cb)
                    des0tosb.full_pkt[i] = vif.mon_cb.data_out_0;
                end
            foreach (des0tosb.full_pkt[i])
                des0tosb_port.write(des0tosb.full_pkt[i]);
            `uvm_info("CLIENT 0 MONITOR", $sformatf("printing from monitor \n%s", des0tosb.sprint()), UVM_LOW)
        end
    endtask

    task collect_des1_data;
        begin
            @(vif.mon_cb);
            des1tosb = router_trans::type_id::create("des1tosb");
            des1tosb.full_pkt[0] = vif.mon_cb.data_out_1;
            $cast(des1tosb.payload_count, des1tosb.full_pkt[0][7:2]);
            for (int i = 1; i <= des1tosb.payload_count + 1; i++)
                begin
                    @(vif.mon_cb)
                    des1tosb.full_pkt[i] = vif.mon_cb.data_out_1;
                end
            foreach (des1tosb.full_pkt[i])
                des1tosb_port.write(des1tosb.full_pkt[i]);
            `uvm_info("CLIENT 1 MONITOR", $sformatf("printing from monitor \n%s", des1tosb.sprint()), UVM_LOW)
        end
    endtask

    task collect_des2_data;
        begin
            @(vif.mon_cb);
            des2tosb = router_trans::type_id::create("des2tosb");
            des2tosb.full_pkt[0] = vif.mon_cb.data_out_2;
            $cast(des2tosb.payload_count, des2tosb.full_pkt[0][7:2]);
            for (int i = 1; i <= des2tosb.payload_count + 1; i++)
                begin
                    @(vif.mon_cb)
                    des2tosb.full_pkt[i] = vif.mon_cb.data_out_2;
                end
            foreach (des2tosb.full_pkt[i])
                des2tosb_port.write(des2tosb.full_pkt[i]);
            `uvm_info("CLIENT 2 MONITOR", $sformatf("printing from monitor \n%s", des2tosb.sprint()), UVM_LOW)
        end
    endtask
    
    function void report_phase(uvm_phase phase);
        begin
            `uvm_info(get_type_name(), $sformatf("Report: Source monitor received %0d packets", m_cfg.mon_rcv_pkt), UVM_LOW)
        end
    endfunction
endclass