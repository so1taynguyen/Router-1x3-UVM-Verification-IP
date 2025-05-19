class router_drv extends uvm_driver #(router_trans);
    `uvm_component_utils(router_drv)
    
    virtual router_if.DRV_MP vif;

    router_env_config m_cfg;
    
    function new(string name = "router_drv", uvm_component parent);
        begin
            super.new(name, parent);
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
            forever 
                begin
                    seq_item_port.get_next_item(req);
                    wait (vif.drv_cb.resetn)
                    send_to_dut(req);
                    seq_item_port.item_done();
                end
        end
    endtask

    task send_to_dut(router_trans xtn);
        begin
            `uvm_info("ROUTER_DRIVER", $sformatf("printing from driver \n%s", xtn.sprint()), UVM_LOW)
            fork
                begin: source
                    @(vif.drv_cb);
                    vif.drv_cb.data_in <= xtn.full_pkt[0];
                    vif.drv_cb.pkt_valid <= 1'b1;
                    wait (vif.drv_cb.busy != 1'b1)
                        begin
                            @(vif.drv_cb);
                            for (int i = 1; i <= xtn.payload_count + 1; i++)
                                begin
                                    @(vif.drv_cb);
                                    vif.drv_cb.data_in <= xtn.full_pkt[i];                     
                                end
                                vif.drv_cb.pkt_valid <= 1'b0;
                        end
                    m_cfg.src_sent_pkt++;
                end: source

                begin: clients
                    wait (vif.drv_cb.vld_out_0 || vif.drv_cb.vld_out_1 || vif.drv_cb.vld_out_2)
                        if (vif.drv_cb.vld_out_0 == 1'b1)
                            begin
                                repeat (2) @(vif.drv_cb);
                                vif.drv_cb.read_enb0 <= 1'b1;
                                wait (vif.drv_cb.vld_out_0 == 1'b0)
                                vif.drv_cb.read_enb0 <= 1'b0;
                            end
                        else if (vif.drv_cb.vld_out_1 == 1'b1)
                            begin
                                repeat (2) @(vif.drv_cb);
                                vif.drv_cb.read_enb1 <= 1'b1;
                                wait (vif.drv_cb.vld_out_1 == 1'b0)
                                vif.drv_cb.read_enb1 <= 1'b0;
                            end
                        else if (vif.drv_cb.vld_out_2 == 1'b1)
                            begin
                                repeat (2) @(vif.drv_cb);
                                vif.drv_cb.read_enb2 <= 1'b1;
                                wait (vif.drv_cb.vld_out_2 == 1'b0)
                                vif.drv_cb.read_enb2 <= 1'b0;
                            end
                end: clients
            join
        end
    endtask
    
    function void report_phase(uvm_phase phase);
        begin
            `uvm_info(get_type_name(), $sformatf("Report: Source sent %0d packets", m_cfg.src_sent_pkt), UVM_LOW)
        end
    endfunction
    
endclass 