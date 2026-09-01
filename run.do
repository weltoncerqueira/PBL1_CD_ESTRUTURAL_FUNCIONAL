# Encerra simulação anterior (se houver)
quit -sim

# Cria e limpa a biblioteca work
vlib work
vmap work work

# Compila os subcircuitos/submódulos básicos primeiro
vlog meio_somador.v
vlog somador_completo.v

# Compila o multiplicador e o testbench
vlog multiplicador_8x8.v
vlog tb_multiplicador_8x8.v

# Inicia a simulação do testbench
vsim -voptargs=+acc work.tb_multiplicador_8x8

# Adiciona sinais essenciais no Waveform
add wave -hex /tb_multiplicador_8x8/A
add wave -hex /tb_multiplicador_8x8/B
add wave -hex /tb_multiplicador_8x8/S

# Executa o teste
run -all