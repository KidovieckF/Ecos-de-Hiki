extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Fase.game_first_loadin == true:
		$player.position.x = Fase.player_start_posx
		$player.position.y = Fase.player_start_posy
	else: 
		$player.position.x = Fase.player_exit_cliffside_posx
		$player.position.y = Fase.player_exit_cliffside_posy
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_scene()



		
func _on_cliff_side_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Fase.transition_scene = true
		
		
func change_scene():
	if Fase.transition_scene == true:
		if Fase.current_scene == "fase":
			get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
			Fase.game_first_loadin = false
			Fase.finish_changescenes()
