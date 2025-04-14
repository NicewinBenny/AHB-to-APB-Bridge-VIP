
class environment extends uvm_env;

	`uvm_component_utils(environment)

	src_agent_top src_top;
	dst_agent_top dst_top;
	
	scoreboard sbh;
	virtual_seqr v_sqrh;
	

	extern function new(string name ="environment", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

function environment::new(string name="environment", uvm_component parent);
	super.new(name,parent);
endfunction

function void environment::build_phase(uvm_phase phase);
	super.build_phase(phase);

	src_top = src_agent_top::type_id::create("src_top",this);
	dst_top = dst_agent_top::type_id::create("dst_top",this);
	sbh = scoreboard::type_id::create("sbh",this);
	v_sqrh = virtual_seqr::type_id::create("v_sqrh",this);

endfunction
	
function void environment::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	src_top.src_agt[0].monh.monitor_port.connect(sbh.ahb_fifo[0].analysis_export);
	dst_top.dst_agt[0].monh.monitor_port.connect(sbh.apb_fifo[0].analysis_export);

endfunction
