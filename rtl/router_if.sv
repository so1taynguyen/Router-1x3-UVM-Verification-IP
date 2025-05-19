interface router_if (input bit clock, input bit resetn);
    //Input
    logic [7:0] data_in;
    bit pkt_valid;
    bit read_enb0, read_enb1, read_enb2;

    //Output
    logic [7:0] data_out_0, data_out_1, data_out_2;
    bit vld_out_0, vld_out_1, vld_out_2;
    bit err, busy;

    //Clocking blocks
    clocking drv_cb @(posedge clock);
        default input #1 output negedge;
        input busy, resetn;
        input vld_out_0, vld_out_1, vld_out_2;
        output data_in, pkt_valid;
        output read_enb0, read_enb1, read_enb2;
    endclocking

    clocking mon_cb @(posedge clock);
        default input #1 output negedge;
        input data_in, pkt_valid, busy, resetn;
        input read_enb0, read_enb1, read_enb2, data_out_0, data_out_1, data_out_2;
        input vld_out_0, vld_out_1, vld_out_2;
    endclocking

    //Modports
    modport DRV_MP(clocking drv_cb);
    modport MON_MP(clocking mon_cb);

    //Assertions
    property vld_out_assert;
        @(posedge clock)
        if (pkt_valid)
            pkt_valid ##[1:5] (vld_out_0 || vld_out_1 || vld_out_2);
    endproperty

    property read_enb0_assert;
        @(posedge clock)
        if (vld_out_0)
            vld_out_0 ##[1:30] read_enb0;
    endproperty

    property read_enb1_assert;
        @(posedge clock)
        if (vld_out_1)
            vld_out_1 ##[1:30] read_enb1;
    endproperty

    property read_enb2_assert;
        @(posedge clock)
        if (vld_out_2)
            vld_out_2 ##[1:30] read_enb2;
    endproperty

    property data_out_0_assert;
        @(posedge clock)
        if (read_enb0 && vld_out_0)
            read_enb0 |=> (data_out_0 !== {8{1'bz}});
    endproperty

    property data_out_1_assert;  
        @(posedge clock)
        if (read_enb1 && vld_out_1)
            read_enb1 |=> (data_out_1 !== {8{1'bz}});
    endproperty

    property data_out_2_assert;
        @(posedge clock)
        if (read_enb2 && vld_out_2)
            read_enb2 |=> (data_out_2 !== {8{1'bz}});
    endproperty

    assert property (vld_out_assert)
        else $error("Valid out signals don't rise!");

    assert property (read_enb0_assert)
        else $error("Read enable 0 doesn't rise!");

    assert property (read_enb1_assert)
        else $error("Read enable 1 doesn't rise!");

    assert property (read_enb2_assert)
        else $error("Read enable 2 doesn't rise!");

    assert property (data_out_0_assert)
        else $error("Data out 0 dropped!");

    assert property (data_out_1_assert)
        else $error("Data out 1 dropped!");

    assert property (data_out_2_assert)
        else $error("Data out 2 dropped!");
endinterface