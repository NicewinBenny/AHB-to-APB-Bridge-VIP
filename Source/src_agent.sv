
class src_agent extends uvm_agent;

	`uvm_component_utils(src_agent)

	src_sequencer sqrh;
	src_monitor monh;
	src_driver drvh;
	
	src_config src_cfg;

	extern function new(string name="src_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	
endclass

function src_agent::new(string name ="src_agent", uvm_component parent);
	super.new(name,parent);
endfunction

function void src_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db#(src_config)::get(this,"","src_config",src_cfg))
		`uvm_fatal("cfg","cannot get the cfg");

	monh = src_monitor::type_id::create("monh",this);
	
	if(src_cfg.is_active == UVM_ACTIVE)
		begin
		drvh = src_driver::type_id::create("drvh",this);
		sqrh = src_sequencer::type_id::create("sqrh",this);
		end
endfunction

function void src_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(src_cfg.is_active == UVM_ACTIVE)
		begin
		drvh.seq_item_port.connect(sqrh.seq_item_export);
		end
endfunction
		
	
