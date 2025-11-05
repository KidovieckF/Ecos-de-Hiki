extends Control



func _on_home_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/inGameUI.tscn")
	


func _on_sair_pressed() -> void:
	get_tree().quit()
	
