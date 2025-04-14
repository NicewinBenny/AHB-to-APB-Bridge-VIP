
`include "definitions.v"

interface bridge_interface(input bit Hclk);

	logic Hresetn, Hreadyin; bit Hwrite; logic Hreadyout;
	logic Pwrite, Penable;
	logic [1:0] Htrans, Hresp;
	logic [2:0] Hsize;
	logic [`WIDTH-1:0] Hwdata, Haddr, Hrdata;
	logic [`WIDTH-1:0] Prdata, Paddr, Pwdata;
	logic [`SLAVES-1:0] Pselx;

clocking msdrv_cb@(posedge Hclk);
	default input #1 output #1;

	output Hresetn, Htrans, Hwrite, Hsize, Hreadyin, Hwdata, Haddr;
	input Hresp, Hrdata, Hreadyout;

endclocking

clocking msmon_cb@(posedge Hclk);
	default input #1 output #1;


	input Hresetn, Htrans, Hwrite, Hsize, Hreadyin, Hwdata, Haddr;
	input Hresp, Hrdata, Hreadyout;

endclocking

clocking svdrv_cb@(posedge Hclk);
	default input #1 output #1;

	
	
	input Penable, Pwrite, Pwdata, Paddr,Pselx;
	output Prdata;

endclocking

clocking svmon_cb@(posedge Hclk);
	default input #1 output #1;

	
	input Penable, Pwrite, Pwdata, Paddr,Pselx;
	input Prdata;

endclocking

modport MSDRV(clocking msdrv_cb);
modport MSMON(clocking msmon_cb);
modport SVDRV(clocking svdrv_cb);
modport SVMON(clocking svmon_cb);

endinterface

