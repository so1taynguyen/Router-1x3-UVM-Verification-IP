class router_base_test extends uvm_test;
    `uvm_component_utils(router_base_test)
    
    router_env_config m_cfg;
    router_env env;

    function new(string name = "router_base_test", uvm_component parent = null);
        begin
            super.new(name, parent);
        end
    endfunction

    function void build_phase(uvm_phase phase);
        begin
            m_cfg = router_env_config::type_id::create("m_cfg");
            if (!(uvm_config_db#(virtual router_if)::get(this, "", "vif", m_cfg.vif)))
                `uvm_fatal("VIF CONFIG", "cannot get() m_cfg from uvm_config_db. Have you set() it?")

            m_cfg.has_agt = 1;
            m_cfg.has_scoreboard = 1;
            m_cfg.is_active = UVM_ACTIVE;

            uvm_config_db#(router_env_config)::set(this, "*", "router_env_config", m_cfg);
            env = router_env::type_id::create("env", this);
        end
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    
endclass 

class router_test extends router_base_test;
    `uvm_component_utils(router_test)
    
    router_seqs seqs;

    function new(string name = "router_test", uvm_component parent = null);
        begin
            super.new(name, parent);
        end
    endfunction

    function void build_phase(uvm_phase phase);
        begin
            super.build_phase(phase);
        end
    endfunction
    
    task run_phase(uvm_phase phase);
        begin
            phase.raise_objection(this);
            seqs = router_seqs::type_id::create("seqs");
            seqs.start(env.agt.seqcer);
            #50
            phase.drop_objection(this);  
        end
    endtask
    
endclass