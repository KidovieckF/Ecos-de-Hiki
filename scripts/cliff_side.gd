extends Node2D


func _process(delta):
	change_scenes()

#checando se entrou na hitbox de trocas de areas
func _on_cliff_side_exit_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Fase.transition_scene = true
		print("Teste")



#função de trocar de area		
func change_scenes():
	if Fase.transition_scene == true:
		print(Fase.current_scene)
		if Fase.current_scene == "cliff_side":
			get_tree().change_scene_to_file("res://scenes/fase.tscn")
			Fase.finish_changescenes()
