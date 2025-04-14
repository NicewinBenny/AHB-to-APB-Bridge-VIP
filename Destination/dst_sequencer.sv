class dst_sequencer extends uvm_sequencer#(dst_trans);
	`uvm_component_utils(dst_sequencer)

	extern function new(string name = "dst_sequencer", uvm_component parent);
endclass

function dst_sequencer::new(string name = "dst_sequencer", uvm_component parent);
	super.new(name, parent);
endfunction
