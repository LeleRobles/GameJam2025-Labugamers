extends Node2D
class_name Main

const IS_BUILDABLE = "buildable"
const PREDIO_GROUP = "PREDIO_GROUP"


var selected_tile: Vector2i = Vector2i.ZERO
var predio_shop_scene = preload("res://Predios/Inventario_Predios/shop.tscn")
var HUD_scene = preload("res://Mundo/Scenes/Ui_HUD.tscn")
@export var predio_packed_scene: PackedScene = null
@export var predios_data: Array[PredioData] = []  # seu array de Resources
@export var predio_data : PredioData
@onready var tile_map: TileMapLayer = $TileMap
@onready var ui_node: Node = $UI

var used_tiles: Array[Vector2i] = []

func _ready() -> void:
	instanciar_HUD()

func instanciar_HUD() -> void:
	var hud_instance = HUD_scene.instantiate()
	$UI.add_child(hud_instance)

func _input(event):
	if event.is_action_pressed("clique_esquerdo"):
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
			shop_instance.main_ref = self  # passa Main
			ui_node.add_child(shop_instance)

func place_building(cell_position: Vector2i, predio_data: PredioData):
	if Economia.dinheiro < predio_data.preco:
		print( "Dinheiro Insuficiente")
		return
		
	if used_tiles.has(cell_position):
		return

	Economia.dinheiro -= predio_data.preco
	print("Comprado: ", predio_data.nome, " | Novo saldo:", Economia.dinheiro)
	var new_building = Node2D.new()
	var sprite = Sprite2D.new()
	sprite.texture = predio_data.texture
	sprite.scale = Vector2(1.5,1.5)
	new_building.add_child(sprite)
	new_building.position = cell_position * 32
	add_child(new_building)

	new_building.add_to_group(PREDIO_GROUP)
	used_tiles.append(cell_position)
	print("Construído:", predio_data.nome, "em:", cell_position)
