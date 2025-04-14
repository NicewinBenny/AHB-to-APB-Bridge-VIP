
class test extends uvm_test;

	`uvm_component_utils(test)

	env_config env_cfg;
	src_config src_cfg[];
	dst_config dst_cfg[];
	
	environment envh;

	virtual_seq v_seqh;

	src_sequence src_seq;
	
	int no_of_src_agents = 1;
	int no_of_dst_agents = 1;


	extern function new(string name = "test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);

endclass

function test::new(string name ="test", uvm_component parent);
	super.new(name,parent);
endfunction

function void test::build_phase(uvm_phase phase);
	super.build_phase(phase);

	src_cfg = new[no_of_src_agents];
	foreach(src_cfg[i])
	begin
		src_cfg[i] = src_config::type_id::create($sformatf("src_cfg[%d]",i),this);

		if(!uvm_config_db#(virtual bridge_interface)::get(this,"","in",src_cfg[i].vif))
		`uvm_fatal("TEST_IN_CONFIG","Cannot get")
	
		src_cfg[i].is_active = UVM_ACTIVE;
	end

	dst_cfg = new[no_of_dst_agents];
	foreach(dst_cfg[i])
	begin
		dst_cfg[i] = dst_config::type_id::create($sformatf("dst_cfg[%d]",i),this);

		if(!uvm_config_db#(virtual bridge_interface)::get(this,"","out",dst_cfg[i].vif))
		`uvm_fatal("TEST_OUT_CONFIG","Cannot get")
	
		dst_cfg[i].is_active = UVM_ACTIVE;
	end


	env_cfg = env_config::type_id::create("env_cfg",this);

	env_cfg.src_cfg = src_cfg;
	env_cfg.dst_cfg = dst_cfg;

	env_cfg.no_of_src_agents = no_of_src_agents;
	env_cfg.no_of_dst_agents = no_of_dst_agents;

	uvm_config_db#(env_config)::set(this,"*","env_config",env_cfg);
	
	envh = environment::type_id::create("envh",this);
	v_seqh = virtual_seq::type_id::create("v_seqh",this);

endfunction

function void test::end_of_elaboration_phase(uvm_phase phase);

	uvm_top.print_topology();

endfunction

class single_test extends test;

	`uvm_component_utils(single_test)

	single_transfer single;

	extern function new(string name = "single_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function single_test::new(string name ="single_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void single_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task single_test::run_phase(uvm_phase phase);
	super.run_phase(phase);

	single = single_transfer::type_id::create("single");

	phase.raise_objection(this);
	
	single.start(envh.src_top.src_agt[0].sqrh);
#50;	
	phase.drop_objection(this);
endtask

	
class increment_test extends test;

	`uvm_component_utils(increment_test)

	increment_transfer increment;

	extern function new(string name = "increment_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function increment_test::new(string name ="increment_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void increment_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task increment_test::run_phase(uvm_phase phase);
	super.run_phase(phase);

	increment = increment_transfer::type_id::create("increment");

	phase.raise_objection(this);
	
	increment.start(envh.src_top.src_agt[0].sqrh);
#30;	
	phase.drop_objection(this);
endtask


class wrap_test extends test;

	`uvm_component_utils(wrap_test)

	wrap_transfer wrap;

	extern function new(string name = "wrap_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function wrap_test::new(string name ="wrap_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void wrap_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task wrap_test::run_phase(uvm_phase phase);
	super.run_phase(phase);

	wrap = wrap_transfer::type_id::create("wrap");

	phase.raise_objection(this);
	
	wrap.start(envh.src_top.src_agt[0].sqrh);
#30;	
	phase.drop_objection(this);
endtask

	i
