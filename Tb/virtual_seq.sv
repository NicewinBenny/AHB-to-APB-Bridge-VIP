class virtual_seq extends uvm_sequence #(uvm_sequence_item);
	`uvm_object_utils(virtual_seq)

	extern function new(string name = "virtual_seq");
endclass

function virtual_seq::new(string name = "virtual_seq");
	super.new(name);
endfunction

