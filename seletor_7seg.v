module seletor_7seg (
    input  wire [6:0] hexa,
    input  wire [6:0] deci,
    input  wire [1:0] sel,
    output wire [6:0] S
);

	// seletor 01 = Hexa
	// seletor 10 = DeC
	// seletor 00 = displays apagados
	// seletor 11 = Flag Error

    // Fios de inversão do seletor
    wire nsel1, nsel0;

    // Sinais de habilitação de modo
    wire m_hex, m_dec;
    wire nm_hex, nm_dec;

    // Barramentos mascarados
    wire [6:0] w_hex;
    wire [6:0] w_dec;

    // --- 1. Inversores do Seletor ---
    not (nsel1, sel[1]);
    not (nsel0, sel[0]);

    // --- 2. Mintermos dos Modos ---
    // 01 -> Hexadecimal
    and (m_hex, nsel1, sel[0]);
    // 10 -> Decimal
    and (m_dec, sel[1], nsel0);

    // Inversores dos mintermos (usados para forçar nível 1/apagado nas linhas inativas)
    not (nm_hex, m_hex);
    not (nm_dec, m_dec);

    // --- 3. Mascaramento dos barramentos e fusão AND bit-a-bit ---
    // Bit 0
    or  (w_hex[0], hexa[0], nm_hex);
    or  (w_dec[0], deci[0], nm_dec);
    and (S[0], w_hex[0], w_dec[0]);

    // Bit 1
    or  (w_hex[1], hexa[1], nm_hex);
    or  (w_dec[1], deci[1], nm_dec);
    and (S[1], w_hex[1], w_dec[1]);

    // Bit 2
    or  (w_hex[2], hexa[2], nm_hex);
    or  (w_dec[2], deci[2], nm_dec);
    and (S[2], w_hex[2], w_dec[2]);

    // Bit 3
    or  (w_hex[3], hexa[3], nm_hex);
    or  (w_dec[3], deci[3], nm_dec);
    and (S[3], w_hex[3], w_dec[3]);

    // Bit 4
    or  (w_hex[4], hexa[4], nm_hex);
    or  (w_dec[4], deci[4], nm_dec);
    and (S[4], w_hex[4], w_dec[4]);

    // Bit 5
    or  (w_hex[5], hexa[5], nm_hex);
    or  (w_dec[5], deci[5], nm_dec);
    and (S[5], w_hex[5], w_dec[5]);

    // Bit 6
    or  (w_hex[6], hexa[6], nm_hex);
    or  (w_dec[6], deci[6], nm_dec);
    and (S[6], w_hex[6], w_dec[6]);

endmodule