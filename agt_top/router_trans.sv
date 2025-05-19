class router_trans extends uvm_sequence_item;
    `uvm_object_utils(router_trans)
    
    rand bit [`SIZE - 1:0] header;
    bit [`SIZE - 1:0] payload;
    bit [`SIZE - 1:0] parity;

    logic [`SIZE - 1:0] full_pkt[int];

    int payload_count;

    constraint VALID_HEADER {
        header[1:0] != 2'd3;
        header[`SIZE - 1:2] != 0;
    }

    function new(string name = "router_trans");
        begin
            super.new(name);
        end
    endfunction

    function void post_randomize;
        begin
            $cast(payload_count, header[`SIZE - 1:2]);
            full_pkt[0] = header;
            parity = header;
            for (int i = 1; i <= payload_count; i++)
                begin
                    payload = $random;
                    full_pkt[i] = payload;
                    parity = parity ^ full_pkt[i];
                end
            full_pkt[payload_count + 1] = parity;
        end
    endfunction

    function void do_copy(uvm_object rhs);
        begin
            router_trans rhs_;

            if (!($cast(rhs_, rhs)))
                `uvm_fatal ("do_copy", "cast of the rhs object failed")

            super.do_copy(rhs);
            
            foreach(full_pkt[i])
                full_pkt[i] = rhs_.full_pkt[i];
            payload_count = rhs_.payload_count;
        end
    endfunction

    function void do_print(uvm_printer printer);
        begin
            super.do_print(printer);

            printer.print_field("Header", this.full_pkt[0], 8, UVM_DEC);
            for (int i = 1; i <= payload_count; i++)
                printer.print_field("Data", this.full_pkt[i], 8, UVM_DEC);
            printer.print_field("Parity", this.full_pkt[payload_count + 1], 8, UVM_DEC);
        end
    endfunction
endclass