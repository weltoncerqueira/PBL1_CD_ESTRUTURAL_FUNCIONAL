`timescale 1ns / 1ps

module tb_equacao_completa;

    // --- Sinais de Entrada ---
    reg [7:0] x;
    reg [1:0] sel_hex_dec;

    // --- Sinais de Saída ---
    wire [6:0] display0, display1, display2, display3, display4;
    wire led4, led5, led6, led7, led8, led9;
    wire overflow;
    wire zero;
    wire cout;
    wire erro;

    // --- Instanciação do Módulo a ser Testado (DUT) ---
    equacao_completa dut (
        .x(x),
        .sel_hex_dec(sel_hex_dec),
        .display0(display0),
        .display1(display1),
        .display2(display2),
        .display3(display3),
        .display4(display4),
        .led4(led4), .led5(led5), .led6(led6), 
        .led7(led7), .led8(led8), .led9(led9),
        .overflow(overflow),
        .zero(zero),
        .cout(cout),
        .erro(erro)
    );

    // --- Função Auxiliar: Decodifica Anodo Comum {a,b,c,d,e,f,g} para Caractere ---
    function [7:0] seg2char(input [6:0] seg);
        begin
            case (seg)
                7'b0000001: seg2char = "0";
                7'b1001111: seg2char = "1";
                7'b0010010: seg2char = "2";
                7'b0000110: seg2char = "3";
                7'b1001100: seg2char = "4";
                7'b0100100: seg2char = "5";
                7'b0100000: seg2char = "6";
                7'b0001111: seg2char = "7";
                7'b0000000: seg2char = "8";
                7'b0000100: seg2char = "9";
                7'b0001000: seg2char = "A";
                7'b1100000: seg2char = "b";
                7'b0110001: seg2char = "C";
                7'b1000010: seg2char = "d";
                7'b0110000: seg2char = "E";
                7'b0111000: seg2char = "F";
                7'b1111111: seg2char = " "; // Apagado
                default:   seg2char = "?";
            endcase
        end
    endfunction

    // --- Processo de Estímulos ---
    initial begin
        $display("==========================================================================================");
        $display(" TIME  | SEL |  X  | f(x) ESPERADO | DISPLAYS (D4 D3 D2 D1 D0) | ZERO | ERRO | OVERFLOW ");
        $display("==========================================================================================");

        // ====================================================================
        // PARTE 1: Foco Principal -> Modo Decimal (sel_hex_dec = 10)
        // ====================================================================
        sel_hex_dec = 2'b10;

        // Teste 1.1: x = 0  -> f(0) = 0 - 0 + 6 = 6
        x = 8'd0; #10;
        exibir_resultado(6);

        // Teste 1.2: x = 2  -> Raiz da equação: f(2) = 4 - 10 + 6 = 0 (Deve ativar ZERO)
        x = 8'd2; #10;
        exibir_resultado(0);

        // Teste 1.3: x = 3  -> Raiz da equação: f(3) = 9 - 15 + 6 = 0 (Deve ativar ZERO)
        x = 8'd3; #10;
        exibir_resultado(0);

        // Teste 1.4: x = 5  -> f(5) = 25 - 25 + 6 = 6
        x = 8'd5; #10;
        exibir_resultado(6);

        // Teste 1.5: x = 10 -> f(10) = 100 - 50 + 6 = 56
        x = 8'd10; #10;
        exibir_resultado(56);

        // Teste 1.6: x = 20 -> f(20) = 400 - 100 + 6 = 306
        x = 8'd20; #10;
        exibir_resultado(306);

        // Teste 1.7: x = 50 -> f(50) = 2500 - 250 + 6 = 2256
        x = 8'd50; #10;
        exibir_resultado(2256);

        // Teste 1.8: x = 100 -> f(100) = 10000 - 500 + 6 = 9506
        x = 8'd100; #10;
        exibir_resultado(9506);

        // Teste 1.9: x = 127 (Valor máximo positivo em complemento de 2 de 8 bits)
        // f(127) = 16129 - 635 + 6 = 15500
        x = 8'd127; #10;
        exibir_resultado(15500);

        // ====================================================================
        // PARTE 2: Teste das demais posições do Seletor com x = 10 (f(10) = 56)
        // ====================================================================
        x = 8'd10;

        // Seletor 00: Displays Apagados
        sel_hex_dec = 2'b00; #10;
        exibir_resultado(56);

        // Seletor 01: Hexadecimal -> 56 em Hex = 0x0038
        sel_hex_dec = 2'b01; #10;
        exibir_resultado(56);

        // Seletor 11: Flag de Erro Ativa
        sel_hex_dec = 2'b11; #10;
        exibir_resultado(56);

        $display("==========================================================================================");
        $display("Simulação concluída com sucesso!");
        $finish;
    end

    // --- Tarefa Auxiliar de Impressão ---
    task exibir_resultado(input integer esperado);
        begin
            $display("%5tn |  %b  | %3d |     %5d     |     %c  %c  %c  %c  %c    |  %b   |  %b   |    %b", 
                     $time, sel_hex_dec, x, esperado,
                     seg2char(display4), seg2char(display3), 
                     seg2char(display2), seg2char(display1), 
                     seg2char(display0),
                     zero, erro, overflow);
        end
    endtask

endmodule