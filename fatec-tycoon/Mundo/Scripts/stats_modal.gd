extends Control

@onready var verba_label: Label = $TextureRect/VBoxContainer2/VBoxContainer/VerbaBase
@onready var ganho_label: Label = $TextureRect/VBoxContainer2/VBoxContainer/GanhoConhecimento
@onready var despesa_label: Label = $TextureRect/VBoxContainer2/VBoxContainer/Despesas
@onready var close_button: Button = $TextureRect/VBoxContainer2/Fechar

func _ready():
	close_button.pressed.connect(_on_fechar_pressed)
	_update_labels()

func _update_labels():
	# Usa os valores atuais da Economia
	verba_label.text = "💰 Verba Base: " + str(Economia.verba_base)
	ganho_label.text = "📘 Ganho por Conhecimento: " + str((Economia.conhecimento * 0.12 * 100))  + "%"
	despesa_label.text = "💸 Despesas: " + str(Economia.despesas_totais)

	


func _on_fechar_pressed() -> void:
	queue_free()
