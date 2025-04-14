
class dst_agent_top extends uvm_env;

	`uvm_component_utils(dst_agent_top)

	dst_agent dst_agt[];
	
	env_config env_cfg;

	extern function new(string name="dst_agent_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	
endclass

function dst_agent_top::new(string name ="dst_agent_top", uvm_component parent);
	super.new(name,parent);
endfunction

function void dst_agent_top::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal("cfg","cannot get the cfg");
	dst_agt = new[env_cfg.no_of_dst_agents];
foreach(dst_agt[i])
begin
	dst_agt[i] = dst_agent::type_id::create($sformatf("dst_agt[%d]",i),this);
	uvm_config_db#(dst_config)::set(this,$sformatf("dst_agt[%d]*",i),"dst_config",env_cfg.dst_cfg[i]);
end	
endfunction
