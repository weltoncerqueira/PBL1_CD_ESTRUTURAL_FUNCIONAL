// Decodificador BCD (0-9) para display de 7 segmentos - ANODO COMUM
// Versão estrutural usando apenas portas AND, OR e NOT

module bcd_to_7seg (
    input  wire [3:0] bcd,
    output wire [6:0] seg
);

    // Inversões dos bits de entrada
    wire n0, n1, n2, n3;
    not (n0, bcd[0]);
    not (n1, bcd[1]);
    not (n2, bcd[2]);
    not (n3, bcd[3]);

    // Mintermos para dígitos 0 a 9
    wire d0, d1, d2, d3, d4, d5, d6, d7, d8, d9;

    and (d0, n3, n2, n1, n0);          // 0000
    and (d1, n3, n2, n1, bcd[0]);      // 0001
    and (d2, n3, n2, bcd[1], n0);      // 0010
    and (d3, n3, n2, bcd[1], bcd[0]);  // 0011
    and (d4, n3, bcd[2], n1, n0);      // 0100
    and (d5, n3, bcd[2], n1, bcd[0]);  // 0101
    and (d6, n3, bcd[2], bcd[1], n0);  // 0110
    and (d7, n3, bcd[2], bcd[1], bcd[0]); // 0111
    and (d8, bcd[3], n2, n1, n0);      // 1000
    and (d9, bcd[3], n2, n1, bcd[0]);  // 1001

    // Sinais internos para cada segmento (ativo em 0 - ânodo comum)
    // seg[6:0] = {a,b,c,d,e,f,g}
	 
    wire seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g;

    // a = 0 (aceso) para: 0,2,3,5,6,7,8,9
    // a = 1 (apagado) para: 1,4
    or (seg_a, d1, d4);

    // b = 0 (aceso) para: 0,1,2,3,4,7,8,9
    // b = 1 (apagado) para: 5,6
    or (seg_b, d5, d6);

    // c = 0 (aceso) para: 0,1,3,4,5,6,7,8,9
    // c = 1 (apagado) para: 2
    or (seg_c, d2);

    // d = 0 (aceso) para: 0,2,3,5,6,8,9
    // d = 1 (apagado) para: 1,4,7
    or (seg_d, d1, d4, d7);

    // e = 0 (aceso) para: 0,2,6,8
    // e = 1 (apagado) para: 1,3,4,5,7,9
    or (seg_e, d1, d3, d4, d5, d7, d9);

    // f = 0 (aceso) para: 0,4,5,6,8,9
    // f = 1 (apagado) para: 1,2,3,7
    or (seg_f, d1, d2, d3, d7);

    // g = 0 (aceso) para: 2,3,4,5,6,8,9
    // g = 1 (apagado) para: 0,1,7
    or (seg_g, d0, d1, d7);

    // Saída na ordem {a,b,c,d,e,f,g} (MSB = a, LSB = g)
    // Para ânodo comum: 0 = aceso, 1 = apagado
    assign seg[6] = seg_a;
    assign seg[5] = seg_b;
    assign seg[4] = seg_c;
    assign seg[3] = seg_d;
    assign seg[2] = seg_e;
    assign seg[1] = seg_f;
    assign seg[0] = seg_g;

endmodule