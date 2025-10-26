extends Control

@onready var health_bar: TextureProgressBar = $HealthBar
# @onready var mana_bar: TextureProgressBar = $ManaBar  Preparado para quando implementar
@onready var health_bg: NinePatchRect = $HBoxContainer/NinePatchRect

func _ready() -> void:
	var player_node = get_tree().get_first_node_in_group("player")
	
	if player_node:
		health_bar.max_value = player_node.max_health
		health_bar.value = player_node.health
		
		player_node.health_changed.connect(update_health)
		
		# Preparado para mana (quando implementar)
		# mana_bar.max_value = player_node.max_mana
		# mana_bar.value = player_node.mana

func update_health(current: int, maximum: int):
	health_bar.max_value = maximum
	health_bar.value = current

# Preparado para quando implementar mana
#func update_mana(current: int, maximum: int):
	#mana_bar.max_value = maximum
	#mana_bar.value = current
