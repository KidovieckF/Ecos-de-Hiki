extends Node2D

@export var closed_texture: Texture2D
@export var open_texture: Texture2D
@export var drop_scene: PackedScene = preload("res://items/item_pickup/ItemPickup.tscn")
@export_category("Item Drops")
@export var drops : Array[Dropdata] # Array de Resources de itens possíveis
@export var drop_offset: Vector2 = Vector2(0, 0)

var player: CharacterBody2D
var player_in_area: bool = false
var opened: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D

func _ready():
	assert(sprite != null, "Sprite2D não encontrado! Verifique o nome do nó dentro do baú.")
	sprite.texture = closed_texture
	
	# conecta sinais da Area2D
	if area:
		if not area.body_entered.is_connected(_on_area_body_entered):
			area.body_entered.connect(_on_area_body_entered)
		if not area.body_exited.is_connected(_on_area_body_exited):
			area.body_exited.connect(_on_area_body_exited)


func _input(event: InputEvent) -> void:
	if opened or not player_in_area:
		return

	if event.is_action_pressed("interact"):
		open_chest()


func _on_area_body_entered(body: Node) -> void:
	if body.has_method("player"):  # verifica se é o player
		player = body
		player_in_area = true
		print("👋 Player entrou na área do baú!")


func _on_area_body_exited(body: Node) -> void:
	if body == player:
		player_in_area = false
		print("👋 Player saiu da área do baú!")


func open_chest():
	opened = true
	sprite.texture = open_texture
	drop_items()


func drop_items() -> void:
	if drops.size() == 0:
		print("⚠️ Nenhum item configurado para drop no baú!")
		return

	for i in range(drops.size()):
		if drops[i] == null or drops[i].item == null:
			continue
		
		var drop_count: int = drops[i].get_drop_count()
		for j in range(drop_count):
			var drop: ItemPickup = drop_scene.instantiate() as ItemPickup
			drop.scale = Vector2(0.5,0.5)
			drop.item_data = drops[i].item
			get_tree().current_scene.add_child(drop)
			drop.global_position = global_position + Vector2(randf() * 16 - 8, randf() * 16 - 8)

	print("🎁 Baú abriu e dropou", drops.size(), "itens!")
