extends Control

onready var btn_main := $VBoxContainer/NewGame

func _ready() -> void:
	btn_main.connect("button_up", self, "_start_game")
	
func _start_game() -> void:
	Globals.recent_score = 0
	get_tree().change_scene("res://scenes/gameloop.tscn")
