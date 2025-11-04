extends Node2D

@export var nome_sala: String = "SalaBase"
@export var tem_saida: bool = true
@export var tem_entrada: bool = true
@export var spawn_inimigos: Array[NodePath]
@export var spawn_baus: Array[NodePath]

signal saiu_da_sala(direcao: String)

func _ready():
	pass

func get_spawn_positions(tipo: String) -> Array:
	var result = []
	if tipo == "inimigo":
		for s in spawn_inimigos:
			result.append(get_node(s).global_position)
	elif tipo == "bau":
		for s in spawn_baus:
			result.append(get_node(s).global_position)
	return result

func _on_entrada_body_entered(body: Node2D) -> void:
	if  body.has_method("player"):
		print("teste")
		emit_signal("saiu_da_sala")
