extends Control

export var SCORE = -1

onready var score_text := $VBoxContainer/ScoreText
onready var btn_game := $VBoxContainer/NewGame
onready var btn_main := $VBoxContainer/MainMenu

func _ready() -> void:
	score_text.text = "You fixed %s bugs!" % (SCORE if SCORE != -1 else Globals.recent_score)
	btn_game.connect("button_up", self, "_btn_press_game")
	btn_main.connect("button_up", self, "_btn_press_main")

func _btn_press_game() -> void:
	get_tree().change_scene("res://scenes/gameloop.tscn")
	
func _btn_press_main() -> void:
	get_tree().change_scene("res://scenes/main.tscn")
