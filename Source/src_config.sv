class src_config extends uvm_object;

	`uvm_object_utils(src_config);

uvm_active_passive_enum is_active;

virtual bridge_interface vif;

int no_of_src_agents;

function new(string name = "src_config");
	super.new(name);
endfunction

endclass
