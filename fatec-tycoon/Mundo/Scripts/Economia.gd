extends Node

signal dinheiro_alterado(novo_valor)
signal ciclo_concluido(conhecimento, ganho, novo_saldo)

# Variáveis principais
var dinheiro: float = 1000.0
var conhecimento: int = 0
var verba_base: float = 100.0  # valor base ganho por ciclo
var ciclo_duracao: float = 10.0  # 1 minuto
var tempo_ciclo: float = 0.0

func _process(delta: float) -> void:
	tempo_ciclo += delta
	if tempo_ciclo >= ciclo_duracao:
		aplicar_ciclo()
		tempo_ciclo = 0.0


func aplicar_ciclo() -> void:
	conhecimento += 2
	
	# Cada ponto de conhecimento aumenta a verba em 2%
	var bonus_percentual = conhecimento * 0.02
	var ganho_ciclo = verba_base * (1.0 + bonus_percentual)
	
	dinheiro += ganho_ciclo
	
	emit_signal("dinheiro_alterado", dinheiro)
	emit_signal("ciclo_concluido", conhecimento, ganho_ciclo, dinheiro)
	
	print("--------------------------------")
	print("Ciclo concluído!")
	print("Conhecimento:", conhecimento)
	print("Bônus:", str(round(bonus_percentual * 100)), "%")
	print("Ganho no ciclo:", round(ganho_ciclo))
	print("Novo saldo:", round(dinheiro))
