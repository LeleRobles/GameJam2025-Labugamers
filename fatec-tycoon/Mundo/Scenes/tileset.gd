extends Node2D
class_name Main

const IS_BUILDABLE = "buildable"
const PREDIO_GROUP = "PREDIO_GROUP"
var global_multiplicador_dinheiro: float = 1.0

@onready var sfx_player: AudioStreamPlayer2D = $ClickAudio
@onready var passarim_audio: AudioStreamPlayer2D = $PassarimAudio

var selected_tile: Vector2i = Vector2i.ZERO
var predio_shop_scene = preload("res://Predios/Inventario_Predios/shop.tscn")
var HUD_scene = preload("res://Mundo/Scenes/Ui_HUD.tscn")
var input_enabled := true
@export var predio_packed_scene: PackedScene = null
@export var predios_data: Array[PredioData] = []  # seu array de Resources
@export var predio_data : PredioData
@export var modal_scene = preload("res://Mundo/Scenes/ModalDinheiro.tscn")
@onready var tile_map: TileMapLayer = $TileMap
@onready var ui_node: Node = $UI


var used_tiles: Array[Vector2i] = []

func _ready() -> void:
	passarim_audio.play()
	instanciar_HUD()

func instanciar_HUD() -> void:
	var hud_instance = HUD_scene.instantiate()
	$UI.add_child(hud_instance)
	
func instanciar_Modal_Dinheiro() -> void:
	var modal_instance = modal_scene.instantiate()
	$UI.add_child(modal_instance)

func _input(event):
	if not input_enabled:
		return
	if event.is_action_pressed("clique_esquerdo"):
		SoundMana.tocar_som(SoundMana.CLICK)
		var cell_position = tile_map.local_to_map(tile_map.get_local_mouse_position())
		
		if used_tiles.has(cell_position):
			
			return
		
		var tile_data = tile_map.get_cell_tile_data(cell_position)
		if tile_data == null:
			return
		
		if tile_data.get_custom_data(IS_BUILDABLE) == true:
			selected_tile = cell_position  # salva o tile
			print("Tile selecionado:", selected_tile)
			
			# Instancia o menu de prédios
			var shop_instance = predio_shop_scene.instantiate()
			shop_instance.main_ref = self
			input_enabled = false  # passa Main
			ui_node.add_child(shop_instance)

func place_building(cell_position: Vector2i, predio_data: PredioData):
		
	if used_tiles.has(cell_position):
		return

	
	print("Comprado: ", predio_data.nome, " | Novo saldo:", Economia.dinheiro)
	var new_building = Node2D.new()
	var sprite = Sprite2D.new()
	sprite.texture = predio_data.texture
	sprite.scale = Vector2(1.5,1.5)
	new_building.add_child(sprite)
	new_building.position = cell_position * 32
	add_child(new_building)
	aplicar_buff(predio_data)
	new_building.add_to_group(PREDIO_GROUP)
	used_tiles.append(cell_position)
	print("Construído:", predio_data.nome, "em:", cell_position)

func aplicar_buff(predio_data: PredioData):

# Buff multiplicador (por exemplo, aumenta ganhos futuros)
	if predio_data.buff_multiplicador != 1.0:
		# Exemplo: salva um multiplicador global
		global_multiplicador_dinheiro *= predio_data.buff_multiplicador
		if predio_data.nome == "Laborátio de Informática":
			Economia.conhecimento_mult += 2
		Economia.verba_base *= predio_data.buff_multiplicador
		print(predio_data.nome, "aumentou o multiplicador de dinheiro para", global_multiplicador_dinheiro)
