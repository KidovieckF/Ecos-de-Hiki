extends MarginContainer

@export var menu_screen: VBoxContainer
@export var open_menu_screen: VBoxContainer
var menu_open = false

func toggle_visibility(object):
	if object.visible:
		object.visible = false
	else:
		object.visible = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		toggle_visibility(menu_screen)
		update_pause_state()	

func update_pause_state():
	if menu_screen.visible:
		get_tree().paused = true
	else:
		get_tree().paused = false


func _on_home_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/inGameUI.tscn")


func _on_close_button_pressed() -> void:
	
	toggle_visibility(menu_screen)
	update_pause_state()
