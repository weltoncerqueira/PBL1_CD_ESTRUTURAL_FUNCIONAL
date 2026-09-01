// ============================================================
// Decodificador HEXADECIMAL (0-F) para display de 7 segmentos
// Lógica 100% ESTRUTURAL
// Ânodo Comum - saída ativa em nível BAIXO (0 = aceso, 1 = apagado)
// Mapeamento PADRONIZADO: seg[6:0] = {a, b, c, d, e, f, g}
// Mapeamento de Entrada: bin[3:0] = {A, B, C, D} (A=MSB, D=LSB)
// ============================================================

module bin_to_hex_7seg (
    input  wire [3:0] bin,
    output wire [6:0] seg
);

    // 1. Buffers de entrada (A=MSB, D=LSB)
    wire A, B, C, D;
    buf (A, bin[3]);
    buf (B, bin[2]);
    buf (C, bin[1]);
    buf (D, bin[0]);

    // 2. Inversores das entradas
    wire An, Bn, Cn, Dn;
    not (An, A);
    not (Bn, B);
    not (Cn, C);
    not (Dn, D);

    // 3. Fios para conexões dos mintermos
    wire [27:0] m;

    // --- Segmento A (seg[6]) ---
    and (m[0], An, Bn, Cn, D);
    and (m[1], An, B, Cn, Dn);
    and (m[2], A, B, Cn, D);
    and (m[3], A, Bn, C, D);
    or  (seg[6], m[0], m[1], m[2], m[3]);

    // --- Segmento B (seg[5]) ---
    and (m[4], An, B, Cn, D);
    and (m[5], An, B, C, Dn);
    and (m[6], A, Bn, C, D);
    and (m[7], A, B, Cn, Dn);
    and (m[25], A, B, C, Dn); // E (1110)
    and (m[26], A, B, C, D);  // F (1111)
    or  (seg[5], m[4], m[5], m[6], m[7], m[25], m[26]);

    // --- Segmento C (seg[4]) ---
    and (m[8], An, Bn, C, Dn);
    and (m[9], A, B, Cn, Dn);
    and (m[10], A, B, C);     // E (1110) e F (1111)
    or  (seg[4], m[8], m[9], m[10]);

    // --- Segmento D (seg[3]) --- (CORRIGIDO: adicionado m[27] para o digito F)
    and (m[11], An, Bn, Cn, D);
    and (m[12], An, B, Cn, Dn);
    and (m[13], An, B, C, D);
    and (m[14], A, Bn, C, Dn);
    and (m[27], A, B, C, D);  // F (1111) - Desliga o segmento d
    or  (seg[3], m[11], m[12], m[13], m[14], m[27]);

    // --- Segmento E (seg[2]) ---
    and (m[15], An, D);
    and (m[16], An, B, Cn);
    and (m[17], Bn, Cn, D);
    or  (seg[2], m[15], m[16], m[17]);

    // --- Segmento F (seg[1]) ---
    and (m[18], An, Bn, D);
    and (m[19], An, Bn, C);
    and (m[20], An, C, D);
    and (m[21], A, B, Cn, D);
    or  (seg[1], m[18], m[19], m[20], m[21]);

    // --- Segmento G (seg[0]) ---
    and (m[22], An, Bn, Cn);
    and (m[23], An, B, C, D);
    and (m[24], A, B, Cn, Dn);
    or  (seg[0], m[22], m[23], m[24]);

endmodule
