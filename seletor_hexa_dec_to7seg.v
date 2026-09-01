module seletor_hexa_dec_to7seg (
    input  wire [15:0] somaFinal,
    input  wire [1:0]  sel,
    output wire [6:0]  display0,
    output wire [6:0]  display1,
    output wire [6:0]  display2,
    output wire [6:0]  display3,
    output wire [6:0]  display4,
    output wire        erro
);

    wire [3:0] dez_milhar, milhar, centena, dezena, unidade;
    wire [3:0] nibble3, nibble2, nibble1, nibble0;    
    wire [6:0] dec4, dec3, dec2, dec1, dec0;
    wire [6:0] hex3, hex2, hex1, hex0;
    
    // --- Extração dos Nibbles para HEXADECIMAL (Conexão direta de fios) ---
    assign nibble3 = somaFinal[15:12];
    assign nibble2 = somaFinal[11:8];
    assign nibble1 = somaFinal[7:4];
    assign nibble0 = somaFinal[3:0];
    
    // --- Conversão BINÁRIO para DECIMAL ---    
    bin_pra_decimal bin_dec_1(
        .valor_bin(somaFinal),
        .dez_milhar(dez_milhar),
        .milhar(milhar),
        .centena(centena),
        .dezena(dezena),
        .unidade(unidade)
    );
    
    // --- Conversão DECIMAL para 7 Segmentos ---
    bcd_to_7seg bcd4 ( .bcd(dez_milhar), .seg(dec4) );
    bcd_to_7seg bcd3 ( .bcd(milhar),     .seg(dec3) );
    bcd_to_7seg bcd2 ( .bcd(centena),    .seg(dec2) );
    bcd_to_7seg bcd1 ( .bcd(dezena),     .seg(dec1) );
    bcd_to_7seg bcd0 ( .bcd(unidade),    .seg(dec0) );
    
    // --- Conversão HEXADECIMAL para 7 Segmentos ---
    bin_to_hex_7seg hex_d0 (.bin(nibble0), .seg(hex0) );
    bin_to_hex_7seg hex_d1 (.bin(nibble1), .seg(hex1) );
    bin_to_hex_7seg hex_d2 (.bin(nibble2), .seg(hex2) );
    bin_to_hex_7seg hex_d3 (.bin(nibble3), .seg(hex3) );
    
    // --- Instanciação Estrutural dos Seletores dos Displays ---
    // Display 4: No Hexadecimal fica desligado (7'b1111111) / No Decimal exibe a dezena de milhar (dec4)
    seletor_7seg sel_d0 ( .hexa(hex0), 		.deci(dec0), .sel(sel), .S(display0) );
    seletor_7seg sel_d1 ( .hexa(hex1),       .deci(dec1), .sel(sel), .S(display1) );
    seletor_7seg sel_d2 ( .hexa(hex2),       .deci(dec2), .sel(sel), .S(display2) );
    seletor_7seg sel_d3 ( .hexa(hex3),       .deci(dec3), .sel(sel), .S(display3) );
    seletor_7seg sel_d4 ( .hexa(7'b1111111), .deci(dec4), .sel(sel), .S(display4) );
    
    // Porta AND estrutural para sinalizar erro apenas no caso 11 (sel[1] == 1 e sel[0] == 1)
    and (erro, sel[1], sel[0]);

endmodule
