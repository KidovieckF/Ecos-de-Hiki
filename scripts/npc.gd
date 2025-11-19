extends Node2D

@export var npc_name: String = "NPC"
@export var dialogue_lines: Array[String] = [
	"Olá viajante!",
	"Está perdido?",
	"Eu ja te vi antes?",
	"Bom...",
	"Vou te ensinar como andar por estas areas.",
	"Cada área tem uma porta que você precisa achar.",
	"Aperta as setinha para andar",
	" 'E' para interagir",
	" 'Q' para atirar bolas de fogo",
	" 'ESQ' abre o menu de pause",
	"Cuidado com inimigos de cada área",
	"Não deixe eles te baterem",
	"Mas caso derrota-los ele podem dropar artefatos",
	"Eles dão bonûs para te ajudar na sua jornada",
	"Boa sorte!"
]

var player = null
var player_in_area := false
var interacting := false

@onready var area := $Area2D
@onready var hud_scene := preload("res://scenes/hud_dialogo.tscn")
var hud_instance: Node


func _ready():
	# instancia HUD uma vez
	$AnimatedSprite2D.play("Idle")
	hud_instance = hud_scene.instantiate()
	get_tree().current_scene.add_child(hud_instance)
	hud_instance.scale = Vector2(0.5, 0.5)
	hud_instance.hide_dialog()

	# conecta área de interação
	area.body_entered.connect(_on_area_body_entered)
	area.body_exited.connect(_on_area_body_exited)


func _process(delta):
	if player_in_area and Input.is_action_just_pressed("interact"):
		if not interacting:
			start_dialogue()
		else:
			hud_instance.next_line()


func _on_area_body_entered(body):
	if body.has_method("player"):
		player = body
		player_in_area = true


func _on_area_body_exited(body):
	if body == player:
		player_in_area = false
		end_dialogue()


func start_dialogue():
	interacting = true
	hud_instance.show_dialog(npc_name, dialogue_lines)

	if player.has_method("set_can_move"):
		player.set_can_move(false)


func end_dialogue():
	interacting = false
	hud_instance.hide_dialog()

	if player and player.has_method("set_can_move"):
		player.set_can_move(true)
