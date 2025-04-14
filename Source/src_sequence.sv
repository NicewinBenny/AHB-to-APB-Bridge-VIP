
class src_sequence extends uvm_sequence #(src_trans);

	`uvm_object_utils(src_sequence)

	bit [31:0] haddr;
	bit [2:0] hburst, hsize;
	bit hwrite;
	bit [1:0] htrans;
	bit [9:0] hlength;

	extern function new(string name ="src_sequence");
endclass

function src_sequence::new(string name = "src_sequence");
	super.new(name);
endfunction

class single_transfer extends src_sequence;

	`uvm_object_utils(single_transfer)

	extern function new(string name = "single_transfer");
	extern task body();
endclass

function single_transfer::new(string name = "single_transfer");
	super.new(name);
endfunction

task single_transfer::body();

	req = src_trans::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {(Htrans == 2'b10); (Hwrite == 1'b0);});
	`uvm_info("SRC_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH) 
	finish_item(req);

endtask	

class increment_transfer extends src_sequence;

	`uvm_object_utils(increment_transfer)

	extern function new(string name = "increment_transfer");
	extern task body();
endclass

function increment_transfer::new(string name = "increment_transfer");
	super.new(name);
endfunction

task increment_transfer::body();

	req = src_trans::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {Htrans == 2'b10; Hburst inside {1,3,5,7};})
	finish_item(req);

	haddr = req.Haddr;
	hwrite = req.Hwrite;
	hsize = req.Hsize;
	hburst = req.Hburst;
	hlength = req.Hlength;

	for(int i = 1; i<hlength; i++)
		begin
		start_item(req);
		assert(req.randomize() with{Hwrite == hwrite;	Hsize == hsize;
					Hburst == hburst;	Htrans == 2'b11;
					Hlength == hlength;
					Haddr == haddr + (2**hsize);});
		finish_item(req);
		haddr = req.Haddr;
		end
	req.print();
endtask


class wrap_transfer extends src_sequence;

	`uvm_object_utils(wrap_transfer)

	bit [31:0] Starting_addr, Boundary_addr;

	extern function new(string name = "wrap_transfer");
	extern task body();
endclass

function wrap_transfer::new(string name = "wrap_transfer");
	super.new(name);
endfunction

task wrap_transfer::body();

	req = src_trans::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {Htrans == 2'b10; Hburst inside {2,4,6};});
	finish_item(req);

	haddr = req.Haddr;
	hwrite = req.Hwrite;
	hsize = req.Hsize;
	hburst = req.Hburst;
	hlength = req.Hlength;

	Starting_addr = int'(haddr/(hlength*(2**hsize))*(hlength*(2**hsize)));

	Boundary_addr = Starting_addr + (hlength*(2**hsize));

	haddr = req.Haddr + (2**hsize) ;

	for(int i = 1; i<hlength; i++)
	begin
		if(haddr == Boundary_addr)
			haddr = Starting_addr;

		start_item(req);
		assert(req.randomize() with{Haddr == haddr; Htrans == 2'b11;
						Hwrite == hwrite; Hsize == hsize;
						Hburst == hburst; Hlength == hlength;});
		finish_item(req);
		haddr = req.Haddr + (2**hsize);
	end
endtask

