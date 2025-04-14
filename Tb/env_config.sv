
class env_config extends uvm_object;

	`uvm_object_utils(env_config);

src_config src_cfg[];
dst_config dst_cfg[];

//uvm_active_passive_enum src_active;
//uvm_active_passive_enum dst_active;

int no_of_src_agents;
int no_of_dst_agents;

function new(string name = "env_config");
	super.new(name);
endfunction

endclass
