extends Node2D

const SALA_INICIAL = preload("res://scenes/fase_hub.tscn")

# 🔹 Conjunto de fases da primeira parte
const SALAS_PARTE1 = [
	preload("res://scenes/Sala2.tscn"),
	preload("res://scenes/Sala3.tscn"),
]

# 🔹 Fase fixa (boss / transição / cutscene)
const SALA_FIXA = preload("res://scenes/mapatesouro.tscn")

# 🔹 Conjunto de fases da segunda parte
const SALAS_PARTE2 = [
	preload("res://scenes/mapa1.tscn"),
	preload("res://scenes/mapa2.tscn"),
]

@export var debug_mode: bool = false

var sala_atual: Node2D
var jogador: Node2D
var salas_completadas: int = 0
var usando_segunda_parte: bool = false


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

	# 🔹 Atualiza o contador
	salas_completadas += 1
	print("📊 Salas completadas:", salas_completadas)

	var proxima_sala: PackedScene

	# 🔹 Após 2 salas da primeira parte, carrega a sala fixa
	if salas_completadas % 3 == 0:
		proxima_sala = SALA_FIXA
		usando_segunda_parte = true
	# 🔹 Se já passou pela sala fixa, usa o segundo grupo
	elif usando_segunda_parte:
		proxima_sala = SALAS_PARTE2.pick_random()
	else:
		proxima_sala = SALAS_PARTE1.pick_random()

	var nova_sala = proxima_sala.instantiate()
	add_child(nova_sala)

	# Mantém posição
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
