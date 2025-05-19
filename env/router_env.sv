class router_env extends uvm_env;
    `uvm_component_utils(router_env)
    
    router_scoreboard sb;
    router_agent agt;
    router_env_config m_cfg;

    function new (string name = "router_env", uvm_component parent = null);
        begin
            super.new(name, parent);
        end
    endfunction

    function void build_phase(uvm_phase phase);
        begin
            super.build_phase(phase);
            if (!(uvm_config_db#(router_env_config)::get(this, "", "router_env_config", m_cfg)))
                `uvm_fatal("CONFIG", "cannot get() m_cfg from uvm_config_db. Have you set() it?")
            if (m_cfg.has_agt)
                agt = router_agent::type_id::create("agt", this);
            if (m_cfg.has_scoreboard)
                sb = router_scoreboard::type_id::create("sb", this);
        end
    endfunction
    
    function void connect_phase(uvm_phase phase);
        begin
            if (m_cfg.has_agt == 1 && m_cfg.has_scoreboard == 1)
                begin
                    agt.mon.src2sb_port.connect(sb.src_port);
                    agt.mon.des0tosb_port.connect(sb.des0_port);
                    agt.mon.des1tosb_port.connect(sb.des1_port);
                    agt.mon.des2tosb_port.connect(sb.des2_port);
                end
        end
    endfunction
endclass    