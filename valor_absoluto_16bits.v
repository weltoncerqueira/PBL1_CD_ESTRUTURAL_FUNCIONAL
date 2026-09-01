// valor_absoluto.v
// Função: Retorna o valor absoluto de um número em complemento de 2, seja o valor negativo ou positivo

module valor_absoluto_16bits (
    input  wire [15:0] entrada,
    output wire [15:0] valor_absoluto
);
    wire bs;

    buf b1 (bs, entrada[15]);

    complementoDe2_16bits complemento_16bit (
        .A(entrada),
        .bs(bs),
        .out(valor_absoluto)
    );

endmodule