tool
class_name XcodeWindow
extends Control

onready var editor := $Panel/HBoxContainer/Main/Content/SourceView/Editor
onready var tree := $Panel/HBoxContainer/Sidebar/Content/Tree
onready var win_title := $Panel/HBoxContainer/Main/Content/NSToolbar/WindowTitle

onready var tree_root: TreeItem
onready var files: Array = []

var last_file := ""

func _ready() -> void:
	_make_tree()
	if not Engine.editor_hint:
		update_source_editor_random()
	else:
		_load_file("AppClient.lift")
	editor.add_color_region("//", "", Color("#6c7986"), true)
	editor.add_color_region("/*", "*/", Color("#6c7986"), true)
	editor.add_color_region('"', '"', Color("#fc6a5d"))
	for child in get_children():
		if not child is Control:
			continue
		child.mouse_filter = MOUSE_FILTER_IGNORE
		
func update_source_editor_random() -> void:
	if len(files) == 0: return
	var new_file = files[rand_range(0, len(files))]
	if new_file == last_file:
		files[rand_range(0, len(files))]
	_load_file(new_file)
	last_file = new_file
	if not Engine.editor_hint:
		$Alert.play()

func update_window_title_with_remaining(time_remaining: int, score: int = 0) -> void:
	win_title.text = "" if score < 1 else "(Score: %s) " % score
	win_title.text += ("On My Hack | %s seconds remaining" % time_remaining) if time_remaining > 0 else\
		"On My Hack | Build finished"

func _create_structure() -> void:
	var xcodeproj_dir := Directory.new()
	xcodeproj_dir.open("res://xcodeproj/")
	xcodeproj_dir.list_dir_begin(false, true)
	while true:
		var file = xcodeproj_dir.get_next()
		if file.begins_with("."): continue
		if file == "":
			break
		files.append(file)
	xcodeproj_dir.list_dir_end()
	files.sort()
	for file in files:
		var child = tree.create_item(tree_root)
		child.set_text(0, file)
	
func _make_tree() -> void:
	var root = tree.create_item()
	tree.set_hide_root(true)
	tree_root = tree.create_item(root)
	tree_root.set_text(0, "    My Project")
	_create_structure()
	
func _load_file(filename: String) -> void:
	var file = File.new()
	var _contents = file.open("res://xcodeproj/" + filename, File.READ)
	editor.text = file.get_as_text()
	if filename.ends_with(".lift"):
		editor.add_color_region("@", " ", Color("#fc5fa3"))
		for word in LiftLang.keywords:
			editor.add_keyword_color(word, Color("#fc5fa3"))
		for word in LiftLang.default_types:
			editor.add_keyword_color(word, Color("#d0a8ff"))
	elif filename.ends_with(".lxproj"):
		editor.add_color_region("[", "]", Color("#d0a8ff"))
	elif filename.ends_with(".list"):
		editor.add_color_region("<", ">", Color("#fc6a5d"))
