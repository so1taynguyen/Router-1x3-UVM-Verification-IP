class router_seqs extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_utils(router_seqs)

    function new(string name = "router_seqs");
        begin
            super.new(name);
        end
    endfunction

    task body;
        begin
            repeat(30)
                begin
                    req = router_trans::type_id::create("req");
                    start_item(req);
                    assert(req.randomize());
                    finish_item(req);
                end
        end
    endtask
endclass