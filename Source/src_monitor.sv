
class src_monitor extends uvm_monitor;
	`uvm_component_utils(src_monitor)

	virtual bridge_interface.MSMON vif;

	src_config src_cfg;
	src_trans xtn;
	
	uvm_analysis_port #(src_trans) monitor_port;

	extern function new(string name = "src_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();

endclass

function src_monitor::new(string name = "src_monitor", uvm_component parent);
	super.new(name, parent);
	monitor_port = new("monitor_port",this);
endfunction

function void src_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db#(src_config)::get(this,"","src_config",src_cfg))
		`uvm_fatal("cfg","cannot get the cfg");
endfunction

function void src_monitor::connect_phase(uvm_phase phase);
	vif=src_cfg.vif;
endfunction

task src_monitor::run_phase(uvm_phase phase);
	super.run_phase(phase);

forever
	begin
		collect_data();
	end
endtask

task src_monitor::collect_data();
	
	xtn = src_trans::type_id::create("xtn");

	while(vif.msmon_cb.Htrans !== 2'b10 && vif.msmon_cb.Htrans !== 2'b11)
		@(vif.msmon_cb);

	while(vif.msmon_cb.Hreadyout !== 1)
		@(vif.msmon_cb);
	xtn.Haddr = vif.msmon_cb.Haddr;
	xtn.Hsize = vif.msmon_cb.Hsize;
	xtn.Hwrite = vif.msmon_cb.Hwrite;
	xtn.Htrans = vif.msmon_cb.Htrans;
	xtn.Hreadyin = vif.msmon_cb.Hreadyin;
	@(vif.msmon_cb);
	while(vif.msmon_cb.Hreadyout !== 1)
		@(vif.msmon_cb);
	if(xtn.Hwrite)
		xtn.Hwdata = vif.msmon_cb.Hwdata;
	else
		xtn.Hrdata = vif.msmon_cb.Hrdata;		

	xtn.print();
monitor_port.write(xtn);

endtask


