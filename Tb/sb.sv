
class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	src_trans ahb;
	dst_trans apb;
	
	env_config env_cfg;

	uvm_tlm_analysis_fifo #(src_trans) ahb_fifo[];
	uvm_tlm_analysis_fifo #(dst_trans) apb_fifo[];

	covergroup ahb_cg;
		HADDR : coverpoint ahb.Haddr{
				bins slave1 = {[32'h 8000_0000:32'h 8000_03ff]};
				bins slave2 = {[32'h 8400_0000:32'h 8400_03ff]};
				bins slave3 = {[32'h 8800_0000:32'h 8800_03ff]};
				bins slave4 = {[32'h 8c00_0000:32'h 8c00_03ff]};}
		HSIZE : coverpoint ahb.Hsize{
				bins byte_1 = {3'b00};
				bins byte_2 = {3'b01};
				bins byte_3 = {3'b10};}
		HWRITE : coverpoint ahb.Hwrite{
				bins wr = {1};
				bins rd = {0};}
		HTRANS : coverpoint ahb.Htrans{
				bins N_seq = {2};
				bins Seq   = {3};}
		CROSS : cross HADDR,HSIZE,HWRITE,HTRANS;
	endgroup

	covergroup apb_cg;
		PADDR : coverpoint apb.Paddr{
				bins slave1 = {[32'h 8000_0000:32'h 8000_03ff]};
				bins slave2 = {[32'h 8400_0000:32'h 8400_03ff]};
				bins slave3 = {[32'h 8800_0000:32'h 8800_03ff]};
				bins slave4 = {[32'h 8c00_0000:32'h 8c00_03ff]};}
		PSELX : coverpoint apb.Pselx{
				bins sel_1 = {1};
				bins sel_2 = {2};
				bins sel_3 = {4};
				bins sel_4 = {8};}
		PWRITE : coverpoint apb.Pwrite{
				bins wr = {1};
				bins rd = {0};}
		CROSS : cross PADDR,PSELX,PWRITE;
	endgroup


	extern function new(string name = "scoreboard", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task comparet(int Haddr, Paddr, Hdata, Pdata);
	extern task checkt(src_trans ahb1,dst_trans apb1);
endclass

function scoreboard::new(string name = "scoreboard", uvm_component parent);
	super.new(name, parent);
	ahb_cg = new();
	apb_cg = new();
endfunction

function void scoreboard::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal("CFG_SB","Cannot get ");
	
	ahb_fifo = new[env_cfg.no_of_src_agents];
	foreach(ahb_fifo[i])
		ahb_fifo[i] = new($sformatf("ahb_fifo[%d]",i),this);

	apb_fifo = new[env_cfg.no_of_dst_agents];
	foreach(apb_fifo[i])
		apb_fifo[i] = new($sformatf("apb_fifo[%d]",i),this);
endfunction

task scoreboard::run_phase(uvm_phase phase);
	super.run_phase(phase);
	
	forever
	begin
		fork
			begin
				ahb_fifo[0].get(ahb);
				ahb.print();
				ahb_cg.sample();
			end
			begin
				apb_fifo[0].get(apb);
				apb.print();
				apb_cg.sample();
			end
		join
		checkt(ahb,apb);
	end
endtask

task scoreboard::comparet(int Haddr,Paddr,Hdata,Pdata);

	if(Haddr == Paddr)
		$display("Address comparison successfull");
	else
	begin
		$display("Address failed");
		$display(Haddr,Paddr);
	end

	if(Hdata == Pdata)
		$display("Data comparison successfull");
	else
	begin
		$display("Data failed");
		$display(Hdata,Pdata);
	end
endtask

task scoreboard::checkt(src_trans ahb1,dst_trans apb1);
	if(ahb1.Hwrite == 1'b1)
	begin
		if(ahb1.Hsize == 2'b00)
			begin 
				if(ahb1.Haddr[1:0] == 2'b00)
					comparet(ahb1.Haddr,apb1.Paddr,ahb1.Hwdata[7:0],apb1.Pwdata[7:0]);
				if(ahb1.Haddr[1:0] == 2'b01)
					comparet(ahb1.Haddr,apb.Paddr,ahb1.Hwdata[15:8],apb1.Pwdata[7:0]);
				if(ahb1.Haddr[1:0] == 2'b10)
					comparet(ahb.Haddr,apb1.Paddr,ahb1.Hwdata[23:16],apb1.Pwdata[7:0]);
				if(ahb1.Haddr[1:0] == 2'b11)
					comparet(ahb1.Haddr,apb1.Paddr,ahb1.Hwdata[31:24],apb1.Pwdata[7:0]);
			end
		if(ahb1.Hsize == 2'b01)
			begin 
				if(ahb1.Haddr[1:0] == 2'b00)
					comparet(ahb1.Haddr,apb1.Paddr,ahb1.Hwdata[15:0],apb1.Pwdata[15:0]);
				if(ahb1.Haddr[1:0] == 2'b10)
					comparet(ahb1.Haddr,apb1.Paddr,ahb1.Hwdata[31:16],apb1.Pwdata[15:0]);
			end
		if(ahb1.Hsize == 2'b10)
			begin 
				if(ahb1.Haddr[1:0] == 2'b00)
					comparet(ahb1.Haddr,apb1.Paddr,ahb1.Hwdata[31:0],apb1.Pwdata[31:0]);
			end
	end
	else
	begin
		if(ahb1.Hsize == 2'b00)
			begin 
				if(ahb1.Haddr[1:0] == 2'b00)
					comparet(ahb1.Haddr,apb.Paddr,ahb1.Hrdata[7:0],apb1.Prdata[7:0]);
				if(ahb1.Haddr[1:0] == 2'b01)
					comparet(ahb1.Haddr,apb.Paddr,ahb1.Hrdata[7:0],apb1.Prdata[15:8]);
				if(ahb1.Haddr[1:0] == 2'b10)
					comparet(ahb1.Haddr,apb.Paddr,ahb1.Hrdata[7:0],apb1.Prdata[23:16]);
				if(ahb1.Haddr[1:0] == 2'b11)
					comparet(ahb1.Haddr,apb.Paddr,ahb1.Hrdata[7:0],apb1.Prdata[31:24]);
			end
		if(ahb1.Hsize == 2'b01)
			begin 
				if(ahb1.Haddr[1:0] == 2'b00)
					comparet(ahb1.Haddr,apb1.Paddr,ahb1.Hrdata[15:0],apb1.Prdata[15:0]);
				if(ahb1.Haddr[1:0] == 2'b10)
					comparet(ahb1.Haddr,apb1.Paddr,ahb1.Hrdata[15:0],apb1.Prdata[31:16]);
			end
		if(ahb1.Hsize == 2'b10)
			begin 
				if(ahb1.Haddr[1:0] == 2'b00)
					comparet(ahb1.Haddr,apb1.Paddr,ahb1.Hrdata[31:0],apb1.Prdata[31:0]);
			end
	end
endtask	
