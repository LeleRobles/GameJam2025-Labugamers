extends Button
class_name PredioSlot

var data_predio : SlotsPredio : set = set_slot_data


@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@export var predio_packed_scene: PackedScene

var main_ref  # referência para o Main

func _ready():
	texture_rect.texture = null
	label.text = ""
	mouse_entered.connect(_on_hover_entered)
	mouse_exited.connect(_on_hover_exited)
	if main_ref == null:
		# assume que Main é o pai da cena
		main_ref = get_tree().current_scene

func _pressed():
	if main_ref and data_predio:   # data_predio é o Resource que veio do array
		main_ref.place_building(main_ref.selected_tile, data_predio.predio_data)
		get_parent().get_parent().queue_free()
		
func set_slot_data(value : SlotsPredio) -> void:
	data_predio = value
	if data_predio == null:
		return
	texture_rect.texture = data_predio.predio_data.texture
	label.text = str( data_predio.quantity )

func _on_hover_entered() -> void:
	if data_predio != null:
		if data_predio.predio_data != null:
			var shop_instance = get_parent().get_parent().get_parent()  # sobe dois níveis, se necessário
			shop_instance.update_descricao(data_predio.predio_data.descricao)
	pass

func _on_hover_exited() -> void:
	var shop_instance = get_parent().get_parent().get_parent()  # sobe dois níveis, se necessário
	shop_instance.update_descricao("")
	pass
