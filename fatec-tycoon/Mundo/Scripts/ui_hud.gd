extends Control

@onready var dinheiro_text: Label = $GridContainer/HBoxContainer/Dinheiro
@onready var tempo_text: Label = $GridContainer/HBoxContainer/Tempo
@onready var ponto_conhecimento_text: Label = $GridContainer/HBoxContainer/PontoConhecimento

@export var doubleSpeed: Texture
@export var normalSpeed: Texture

var is_fast := false
var game_state = true

func _ready() -> void:
	# Atualiza os textos iniciais
	_atualizar_dinheiro(Economia.dinheiro)
	_atualizar_conhecimento(Economia.conhecimento)
	
	# Conecta aos sinais da classe global
	Economia.connect("dinheiro_alterado", Callable(self, "_atualizar_dinheiro"))
	Economia.connect("ciclo_concluido", Callable(self, "_atualizar_ciclo"))


func _process(delta: float) -> void:
	# Atualiza o tempo restante do ciclo
	var tempo_restante = Economia.ciclo_duracao - Economia.tempo_ciclo
	var minutos = int(tempo_restante) / 60
	var segundos = int(tempo_restante) % 60
	tempo_text.text = "Tempo: %02d:%02d" % [minutos, segundos]


func _atualizar_dinheiro(novo_valor: float) -> void:
	dinheiro_text.text = "Dinheiro: " + str(round(novo_valor))

func _atualizar_conhecimento(novo_valor: int) -> void:
	ponto_conhecimento_text.text = "Conhecimento: " + str(novo_valor)

func _atualizar_ciclo(conhecimento: int, ganho: float, novo_saldo: float) -> void:
	ponto_conhecimento_text.text = "Conhecimento: " + str(conhecimento)
	# Atualiza o dinheiro também ao final do ciclo
	_atualizar_dinheiro(novo_saldo)


func _on_button_pressed() -> void:
	print("debug")# Replace with function body.


func _on_pause_pressed() -> void:
	if game_state == true:
		game_state = false
		get_tree().paused = true
	elif game_state == false:
		get_tree().paused = false
		game_state = true





func _on_x_speed_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Engine.time_scale = 2.0
	else:
		Engine.time_scale = 1.0
