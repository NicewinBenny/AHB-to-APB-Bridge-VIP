
module top;

	import uvm_pkg::*;
	import bridge_pkg::*;

	bit Hclk;

	always #10 Hclk = ~Hclk;

	bridge_interface in(Hclk);
	bridge_interface out(Hclk);

	rtl_top DUV (.Hclk(Hclk),.Hresetn(in.Hresetn), .Htrans(in.Htrans), .Hwrite(in.Hwrite), .Hsize(in.Hsize), .Hreadyin(in.Hreadyin), .Hwdata(in.Hwdata), .Haddr(in.Haddr),.Hresp(in.Hresp), .Hrdata(in.Hrdata), .Hreadyout(in.Hreadyout),.Penable(out.Penable), .Pwrite(out.Pwrite), .Pwdata(out.Pwdata), .Paddr(out.Paddr),.Pselx(out.Pselx), .Prdata(out.Prdata));

	initial
		begin
			`ifdef VCS
				$fsdbDumpvars(0,top);
			`endif
			
			uvm_config_db#(virtual bridge_interface)::set(null,"*","in",in);
			uvm_config_db#(virtual bridge_interface)::set(null,"*","out",out);

			run_test();
		end

endmodule
