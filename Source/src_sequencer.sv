
class src_sequencer extends uvm_sequencer #(src_trans);
	`uvm_component_utils(src_sequencer)

	extern function new(string name = "src_sequencer", uvm_component parent);
endclass

function src_sequencer::new(string name = "src_sequencer", uvm_component parent);
	super.new(name, parent);
endfunction
