class dst_agent extends uvm_agent;

	`uvm_component_utils(dst_agent)

	dst_sequencer sqrh;
	dst_monitor monh;
	dst_driver drvh;
	
	dst_config dst_cfg;

	extern function new(string name="dst_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	
endclass

function dst_agent::new(string name ="dst_agent", uvm_component parent);
	super.new(name,parent);
endfunction

function void dst_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db#(dst_config)::get(this,"","dst_config",dst_cfg))
		`uvm_fatal("cfg","cannot get the cfg");

	monh = dst_monitor::type_id::create("monh",this);
	
	if(dst_cfg.is_active == UVM_ACTIVE)
		begin
		drvh = dst_driver::type_id::create("drvh",this);
		sqrh = dst_sequencer::type_id::create("sqrh",this);
		end
endfunction

function void dst_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	drvh.seq_item_port.connect(sqrh.seq_item_export);
endfunction
