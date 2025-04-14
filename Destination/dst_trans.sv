
class dst_trans extends uvm_sequence_item;
	`uvm_object_utils(dst_trans)

	bit Penable, Pwrite;
	bit [31:0] Paddr, Prdata, Pwdata;
	bit [3:0] Pselx;

	extern function new(string name = "dst_trans");
	extern function void do_print(uvm_printer printer);
endclass

function dst_trans::new(string name = "dst_trans");
	super.new(name);
endfunction

function void dst_trans::do_print(uvm_printer printer);
	super.do_print(printer);
	
	printer.print_field("Penable",	this.Penable,	1,	UVM_DEC);
	printer.print_field("Pwrite",	this.Pwrite,	1,	UVM_DEC);
	printer.print_field("Paddr",	this.Paddr,	32,	UVM_HEX);
	printer.print_field("Prdata",	this.Prdata,	32,	UVM_HEX);
	printer.print_field("Pwdata",	this.Pwdata,	32,	UVM_HEX);
	printer.print_field("Pselx",	this.Pselx,	4,	UVM_DEC);


endfunction
