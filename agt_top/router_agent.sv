class router_agent extends uvm_agent;
    `uvm_component_utils(router_agent)
    
    router_env_config m_cfg;
    router_sequencer seqcer;
    router_drv drv;
    router_mon mon;

    function new (string name = "router_agent", uvm_component parent = null);
        begin
            super.new(name, parent);
        end
    endfunction

    function void build_phase(uvm_phase phase);
        begin
            super.build_phase(phase);
            if (!(uvm_config_db#(router_env_config)::get(this, "", "router_env_config", m_cfg)))
                `uvm_fatal("CONFIG", "cannot get() m_cfg from uvm_config_db. Have you set() it?")
            mon = router_mon::type_id::create("mon", this);
            if (m_cfg.is_active == UVM_ACTIVE)
                begin
                    seqcer = router_sequencer::type_id::create("seqcer", this);
                    drv = router_drv::type_id::create("drv", this);
                end
        end
    endfunction
    
    function void connect_phase(uvm_phase phase);
        begin
            if (m_cfg.is_active == UVM_ACTIVE)
                drv.seq_item_port.connect(seqcer.seq_item_export);
        end
    endfunction
endclass