class router_sequencer extends uvm_sequencer #(router_trans);
    `uvm_component_utils(router_sequencer)

    function new(string name = "router_sequencer", uvm_component parent);
        begin
            super.new(name, parent);
        end
    endfunction 
endclass 