module meio_somador (

	input wire A,
	input wire B,
	output wire cout,
	output wire sum
	
);

	xor (sum, A, B);
	and (cout, A, B);

endmodule 