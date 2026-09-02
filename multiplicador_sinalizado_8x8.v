
module multiplicador_8x8_sinalizado (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] S
);

    wire [7:0] A_abs, B_abs;
    wire [15:0] P_mag;
    wire sinal;
	 
	 // Coleta o sinal final da multiplicação
    xor (sinal, A[7], B[7]);
	 
	 // Verifica se os valores são negativos ou positivos
    valor_absoluto va (.entrada(A), .valor_absoluto(A_abs));
    valor_absoluto vb (.entrada(B), .valor_absoluto(B_abs));
	 
	 // Realiza a multiplicação
    multiplicador_8x8 mul_u (
        .A(A_abs),
        .B(B_abs),
        .S(P_mag)
    );
	
	 // Verifica se o valor resultante precisará do complemento de 2
    complementoDe2_16bits comp16 (
        .A(P_mag),
        .bs(sinal),
        .out(S)
    );

endmodule
