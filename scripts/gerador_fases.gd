extends Node2D

const SALA_INICIAL = preload("res://scenes/fase_hub.tscn")
const SALAS = [
	preload("res://scenes/Sala2.tscn"),
	preload("res://scenes/Sala3.tscn")
]

@export var debug_mode: bool = false

var sala_atual: Node2D
var jogador: Node2D

func _ready():
	jogador = get_node("player")
	carregar_sala_inicial()


func carregar_sala_inicial():
	var sala = SALA_INICIAL.instantiate()
	add_child(sala)
	sala.position = Vector2.ZERO
	sala.connect("saiu_da_sala", Callable(self, "_quando_saiu_da_sala"))
	sala_atual = sala


	if debug_mode:
		print("====================")
		print("[DEBUG] Sala inicial em:", sala.global_position)
		print("[DEBUG] Jogador em:", jogador.global_position)
		print("====================")
		desenhar_debug(sala.global_position, "Sala Inicial", Color.GREEN)
		desenhar_debug(jogador.global_position, "Spawn Player", Color.BLUE)


func _quando_saiu_da_sala():
	if is_instance_valid(sala_atual):
		sala_atual.queue_free()

	var nova_sala = SALAS.pick_random().instantiate()
	add_child(nova_sala)

	# 🔹 Nova sala na MESMA posição da anterior
	nova_sala.position = sala_atual.position
	nova_sala.connect("saiu_da_sala", Callable(self, "_quando_saiu_da_sala"))
	sala_atual = nova_sala


	
	if debug_mode:
		print("====================")
		print("[DEBUG] Nova sala:", nova_sala.name)
		print("[DEBUG] Posição da sala:", nova_sala.global_position)
		print("[DEBUG] Jogador posicionado em:", jogador.global_position)
		print("====================")
		desenhar_debug(nova_sala.global_position, "Nova Sala", Color.YELLOW)
		desenhar_debug(jogador.global_position, "Novo Spawn", Color.RED)


func desenhar_debug(posicao: Vector2, texto: String, cor: Color):
	var debug_label = Label.new()
	debug_label.text = texto
	debug_label.modulate = cor
	debug_label.position = posicao + Vector2(20, -20)
	add_child(debug_label)

	var marker = ColorRect.new()
	marker.color = cor
	marker.size = Vector2(10, 10)
	marker.position = posicao - marker.size / 2
	add_child(marker)
