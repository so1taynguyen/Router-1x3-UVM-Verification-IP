class router_env_config extends uvm_object;
    `uvm_object_utils(router_env_config)
    
    bit has_agt;
    bit has_scoreboard;
    uvm_active_passive_enum is_active;

    int src_sent_pkt = 0;
    int mon_rcv_pkt = 0;

    virtual router_if vif;

    function new(string name = "router_env_config");
        begin
            super.new(name);
        end
    endfunction
endclass