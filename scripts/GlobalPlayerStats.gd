extends Node


# Atributos principais do jogador
var damage: float = 10.0
var max_health: float = 100.0
var move_speed: float = 1
var bullet_speed: float = 1
var multi_shot_count: int = 1

var vida_atual: float = 100

# Itens de upgrade coletados (pode ser útil para reverter ou salvar progresso)
var upgrades_collected: Array[String] = []

# Método para aplicar upgrades
func apply_upgrade(upgrade_type: String, value: float = 0.0) -> void:
	match upgrade_type:
		"damage":
			damage += value
		"health":
			max_health += value
		"speed":
			move_speed += value
		"bullet_speed":
			bullet_speed *= value
		"multi_shot":
			multi_shot_count += int(value)
		_:
			push_warning("Tipo de upgrade desconhecido: %s" % upgrade_type)

	print("[UPGRADE] %s aplicado! Novos stats: dano=%.1f, vida=%.1f" % [upgrade_type, damage, max_health])
