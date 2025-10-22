class_name Main
extends Node2D

var hud_scene = preload("res://Mundo/Ui_HUD.tscn")
@onready var tile_map : TileMapLayer = $TileMap
@onready var highlight_tile : HighLightTile = $HighLightTile

func _ready() -> void:
	instantiate_HUD()
	

func instantiate_HUD():
	var hud_instance = hud_scene.instantiate()
	hud_instance.position = Vector2(0,0)
	$UI.add_child(hud_instance)

func _input(event):
	if event.is_action_pressed("clique_esquerdo"):
		var cell_position: Vector2i = tile_map.local_to_map(tile_map.get_local_mouse_position())
		var cell_data = tile_map.get_cell_tile_data(cell_position).get_custom_data("buildable")
		print_debug(cell_data)
