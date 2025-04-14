
class src_agent_top extends uvm_env;

	`uvm_component_utils(src_agent_top)

	src_agent src_agt[];

	env_config env_cfg;

	extern function new(string name="src_agent_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	
endclass

function src_agent_top::new(string name ="src_agent_top", uvm_component parent);
	super.new(name,parent);
endfunction

function void src_agent_top::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal("cfg","cannot get the cfg");
	src_agt = new[env_cfg.no_of_src_agents];
foreach(src_agt[i])
begin
	src_agt[i] = src_agent::type_id::create($sformatf("src_agt[%d]",i),this);
	uvm_config_db#(src_config)::set(this,$sformatf("src_agt[%d]*",i),"src_config",env_cfg.src_cfg[i]);
end
	
endfunction
