
class src_driver extends uvm_driver #(src_trans);
	`uvm_component_utils(src_driver)

	virtual bridge_interface.MSDRV vif;
	
	src_config src_cfg;


	extern function new(string name = "src_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(src_trans req);

endclass

function src_driver::new(string name = "src_driver", uvm_component parent);
	super.new(name, parent);
endfunction

function void src_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db#(src_config)::get(this,"","src_config",src_cfg))
		`uvm_fatal("cfg","cannot get the cfg");
endfunction

function void src_driver::connect_phase(uvm_phase phase);
	vif=src_cfg.vif;
endfunction

task src_driver::run_phase(uvm_phase phase);
	super.run_phase(phase);

	@(vif.msdrv_cb);
	vif.msdrv_cb.Hresetn <= 1'b0;
	@(vif.msdrv_cb);
	vif.msdrv_cb.Hresetn <= 1'b1;

forever
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		req.print();
		seq_item_port.item_done();
	end
endtask

task src_driver::send_to_dut(src_trans req);
	
	while(vif.msdrv_cb.Hreadyout !== 1)
		@(vif.msdrv_cb);
	vif.msdrv_cb.Haddr <= req.Haddr;
	vif.msdrv_cb.Hsize <= req.Hsize;
	vif.msdrv_cb.Hwrite <= req.Hwrite;
	vif.msdrv_cb.Htrans <= req.Htrans;
	vif.msdrv_cb.Hreadyin <= 1'b1;
	@(vif.msdrv_cb);
	while(vif.msdrv_cb.Hreadyout !== 1)
		@(vif.msdrv_cb);
	vif.msdrv_cb.Hwdata <= req.Hwdata;


endtask
