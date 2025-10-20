extends Node2D

var hud_scene = preload("res://Mundo/Ui_HUD.tscn")

func _ready() -> void:
	instantiate_HUD()
	

func instantiate_HUD():
	var hud_instance = hud_scene.instantiate()
	hud_instance.position = Vector2(0,0)
	$UI.add_child(hud_instance)
