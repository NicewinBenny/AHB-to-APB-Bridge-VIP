
class dst_monitor extends uvm_monitor;

	`uvm_component_utils(dst_monitor)

	virtual bridge_interface.SVMON vif;
	
	dst_config dst_cfg;
	dst_trans xtn;

	uvm_analysis_port #(dst_trans) monitor_port;

	extern function new(string name = "dst_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();

endclass

function dst_monitor::new(string name = "dst_monitor", uvm_component parent);
	super.new(name, parent);
	monitor_port = new("monitor_port",this);
endfunction

function void dst_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db#(dst_config)::get(this,"","dst_config",dst_cfg))
		`uvm_fatal("cfg","cannot get the cfg");
endfunction

function void dst_monitor::connect_phase(uvm_phase phase);
	vif=dst_cfg.vif;
endfunction

task dst_monitor::run_phase(uvm_phase phase);
	super.run_phase(phase);

forever
	begin
		collect_data();

	end
endtask

task dst_monitor::collect_data();

	xtn = dst_trans::type_id::create("xtn");

	while(vif.svmon_cb.Penable !== 1)
		@(vif.svmon_cb);
		xtn.Paddr = vif.svmon_cb.Paddr;
		xtn.Pselx = vif.svmon_cb.Pselx;
		xtn.Penable = vif.svmon_cb.Penable;
		xtn.Pwrite = vif.svmon_cb.Pwrite;

	while(vif.svmon_cb.Penable !== 1)
		@(vif.svmon_cb);

	if(vif.svmon_cb.Pwrite)
		xtn.Pwdata = vif.svmon_cb.Pwdata;
	else
		xtn.Prdata = vif.svmon_cb.Prdata;
	xtn.print();

monitor_port.write(xtn);
	
	@(vif.svmon_cb);
	
endtask
