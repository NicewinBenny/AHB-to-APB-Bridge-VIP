
class dst_driver extends uvm_driver#(dst_trans);
	`uvm_component_utils(dst_driver)

	virtual bridge_interface.SVDRV vif;
	
	dst_config dst_cfg;


	extern function new(string name = "dst_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(dst_trans req);

endclass

function dst_driver::new(string name = "dst_driver", uvm_component parent);
	super.new(name, parent);
endfunction

function void dst_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db#(dst_config)::get(this,"","dst_config",dst_cfg))
		`uvm_fatal("cfg","cannot get the cfg");
endfunction

function void dst_driver::connect_phase(uvm_phase phase);
	vif=dst_cfg.vif;
endfunction

task dst_driver::run_phase(uvm_phase phase);
	super.run_phase(phase);

forever
	begin
		send_to_dut(req);
	end
endtask

task dst_driver::send_to_dut(dst_trans req);

	while(vif.svdrv_cb.Pselx !== (1 || 2 || 4 || 8))
		@(vif.svdrv_cb);

	while(vif.svdrv_cb.Pwrite == 0)
		vif.svdrv_cb.Prdata <= $random;

	@(vif.svdrv_cb);

endtask
