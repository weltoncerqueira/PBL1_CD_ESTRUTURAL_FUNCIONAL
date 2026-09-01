`timescale 1ns / 1ps

module tb_bin_pra_decimal;

    // --- Sinais do Testbench ---
    reg  [15:0] valor_bin;
    wire [3:0]  dez_milhar;
    wire [3:0]  milhar;
    wire [3:0]  centena;
    wire [3:0]  dezena;
    wire [3:0]  unidade;

    // --- Instanciação do Módulo a ser Testado (DUT) ---
    bin_pra_decimal dut (
        .valor_bin(valor_bin),
        .dez_milhar(dez_milhar),
        .milhar(milhar),
        .centena(centena),
        .dezena(dezena),
        .unidade(unidade)
    );

    // --- Processo de Estímulos ---
    initial begin
        // Configuração para exibição no console
        $display("====================================================================");
        $display(" TIME | BINARIO (16-bits) | HEX    | DEC ESPERADO | DEC OBTIDO (BCD)");
        $display("====================================================================");

        // Teste 1: Valor mínimo (0)
        valor_bin = 16'd0;
        #10;
        exibir_resultado(0);

        // Teste 2: Valor simples (7)
        valor_bin = 16'd7;
        #10;
        exibir_resultado(7);

        // Teste 3: Mudança de dígito (9 para 10)
        valor_bin = 16'd9;
        #10;
        exibir_resultado(9);
        
        valor_bin = 16'd10;
        #10;
        exibir_resultado(10);

        // Teste 4: Valor de 3 dígitos (255 - limite de 8 bits)
        valor_bin = 16'd255;
        #10;
        exibir_resultado(255);

        // Teste 5: Valor intermediário de 4 dígitos (1234)
        valor_bin = 16'd1234;
        #10;
        exibir_resultado(1234);

        // Teste 6: Valor intermediário de 5 dígitos (28593)
        valor_bin = 16'd28593;
        #10;
        exibir_resultado(28593);

        // Teste 7: Maior potência de 10 possível abaixo de 65535 (50000)
        valor_bin = 16'd50000;
        #10;
        exibir_resultado(50000);

        // Teste 8: Valor máximo para 16 bits (65535)
        valor_bin = 16'd65535;
        #10;
        exibir_resultado(65535);

        $display("====================================================================");
        $display("Simulação concluída com sucesso!");
        $finish;
    end

    // --- Tarefa Auxiliar para Formatação de Saída ---
    task exibir_resultado(input integer esperado);
        begin
            $display("%4tn | %b | 0x%04X | %12d | %d%d%d%d%d", 
                     $time, valor_bin, valor_bin, esperado,
                     dez_milhar, milhar, centena, dezena, unidade);
        end
    endtask

endmodule