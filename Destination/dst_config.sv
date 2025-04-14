class dst_config extends uvm_object;

	`uvm_object_utils(dst_config);

uvm_active_passive_enum is_active;

virtual bridge_interface vif;

int no_of_dst_agents;

function new(string name = "dst_config");
	super.new(name);
endfunction

endclass
