
class virtual_seqr extends uvm_sequencer #(uvm_sequence_item);
	`uvm_component_utils(virtual_seqr)

	extern function new(string name = "virtual_seqr",uvm_component parent);
endclass

function virtual_seqr::new(string name = "virtual_seqr",uvm_component parent);
	super.new(name,parent);
endfunction
