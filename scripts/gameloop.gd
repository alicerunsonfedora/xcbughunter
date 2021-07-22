extends Node2D

onready var bug := $Bug
onready var bug_collider := $Bug/Detector
onready var bug_squisher := $Bug/Squash
onready var timer := $GameTimer
onready var window := $UI/GameWindow

var score = 0

func _ready() -> void:
	$IncrementedTimer.connect("timeout", self, "_second_passes")
	$GameTimer.connect("timeout", self, "_game_over")
	bug_collider.connect("input_event", self, "_bug_click")
	_relocate_bug()
	
	if Globals.ran_first_time:
		$UI/Tutorial.visible = false
		timer.start()

func _second_passes() -> void:
	window.update_window_title_with_remaining(timer.time_left, score)
	
func _game_over() -> void:
	Globals.recent_score = score
	get_tree().change_scene("res://scenes/game_over.tscn")

func _bug_click(_viewport, event: InputEvent, _shape_idx) -> void:
	if not event is InputEventMouseButton and not event.is_pressed():
		return
	if not Globals.ran_first_time:
		Globals.ran_first_time = true
		$UI/Tutorial.visible = false
		timer.start()
	score += 1
	bug_squisher.play()
	$Bloodbath.restart()
	$Bloodbath.emitting = true
	_relocate_bug()
	window.update_source_editor_random()

func _relocate_bug() -> void:
	if not Globals.ran_first_time:
		return
		
	$Bloodbath.global_position = bug.global_position
	
	var x_offset = 32 * (score / 2) if score < 15 else 300
	var y_offset = 32 * (score / 2) if score < 15 else 96
	bug.global_position = Vector2(
		clamp(rand_range(x_offset, 1280-32), 0, 1280 - 32),
		clamp(rand_range(y_offset, 720-32), 0, 720 - 32)
	)

func _reset_timer() -> void:
	var overage = timer.time_left
	timer.stop()
	timer.wait_time = clamp(overage + 2.5, 0, 30)
	timer.start()
