extends "res://scripts/enemy.gd"

@export var punch_range: float = 120.0
@export var punch_damage: int = 30
@export var rock_damage: int = 20
@export var attack_cooldown_time: float = 3.0

var attacking: bool = false
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

@onready var punch_warning: Node2D = $PunchWarning
@onready var punch_delay: Timer = $"Timer(PunchDelay)"
@onready var cooldown: Timer = $"Timer(AttDelay)"
@onready var rock_spawn: Node2D = $RockSpawn
@onready var detection_area: Area2D = $DetectionArea
# NÃO redeclarar health, can_take_damage ou iframes

var rock_scene: PackedScene = preload("res://scenes/rock_projetil.tscn")

func _ready() -> void:
	rng.randomize()
	super._ready()
	health = 500
	
	if punch_warning:
		punch_warning.visible = false

	cooldown.wait_time = attack_cooldown_time
	cooldown.one_shot = true
	cooldown.start()

	if detection_area:
		if not detection_area.body_entered.is_connected(_on_detection_area_body_entered):
			detection_area.body_entered.connect(_on_detection_area_body_entered)
		if not detection_area.body_exited.is_connected(_on_detection_area_body_exited):
			detection_area.body_exited.connect(_on_detection_area_body_exited)

	if not punch_delay.timeout.is_connected(_on_punch_delay_timeout):
		punch_delay.timeout.connect(_on_punch_delay_timeout)

	# Conecta timer de invulnerabilidade herdado do enemy.gd
	if iframes and not iframes.timeout.is_connected(_on_iframes_timeout):
		iframes.timeout.connect(_on_iframes_timeout)

# -------------------------------
# GERENCIAR DANO DO BOSS
# -------------------------------
func apply_damage(amount: int):
	if not can_take_damage:
		return

	health -= amount
	print("💀 Boss health =", health)

	if health <= 0:
		drop_items()  # Se tiver drop
		queue_free()
		return

	can_take_damage = false
	if iframes:
		iframes.start()  # inicia i-frame

func _on_iframes_timeout() -> void:
	can_take_damage = true  # termina i-frame

# -------------------------------
# Restante do código do boss
# -------------------------------
func _physics_process(delta: float) -> void:
	deal_with_damage()

	if attacking:
		return

	if player_chase:
		var dir: Vector2 = (player.global_position - global_position).normalized()
		position += dir * speed * delta

		if cooldown.is_stopped():
			choose_attack()
	else:
		$AnimatedSprite2D.play("idle")

func choose_attack() -> void:
	attacking = true
	var choice: int = rng.randi_range(0, 1)
	if choice == 0:
		punch_attack()
	else:
		throw_rock()

func punch_attack() -> void:
	$AnimatedSprite2D.play("attack")
	if punch_warning:
		punch_warning.visible = true
		punch_warning.global_position = global_position
		punch_warning.call_deferred("show_circle", punch_range)

	punch_delay.wait_time = 1.0
	punch_delay.one_shot = true
	punch_delay.start()

func _on_punch_delay_timeout() -> void:
	if player and player.global_position.distance_to(global_position) <= punch_range:
		if player.has_method("take_damage"):
			player.take_damage(punch_damage)
			print("💢 Boss acertou o player com punch! Dano:", punch_damage)
	else:
		print("👀 Punch falhou — player fora do alcance.")

	$AnimatedSprite2D.play("slam")

	if punch_warning:
		punch_warning.call_deferred("hide_circle")

	end_attack()

func throw_rock() -> void:
	$AnimatedSprite2D.play("throw")
	await get_tree().create_timer(0.5).timeout

	if not rock_scene:
		push_error("rock_scene não carregado.")
		end_attack()
		return

	var rock_node: Node2D = rock_scene.instantiate()
	get_tree().current_scene.add_child(rock_node)
	rock_node.global_position = rock_spawn.global_position

	if not player or not is_instance_valid(player):
		print("⚠️ player inválido, não foi possível mirar")
		rock_node.queue_free()
		end_attack()
		return

	var dir: Vector2 = (player.global_position - rock_spawn.global_position).normalized()

	if rock_node.has_method("initialize"):
		rock_node.call("initialize", dir, rock_damage)
	else:
		push_error("rock_node não tem método initialize()")

	print("💥 Boss lançou uma pedra!")
	end_attack()

func end_attack() -> void:
	attacking = false
	cooldown.start()

var player_seen: bool = false  # novo: indica que o boss viu o player uma vez

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_chase = true
		player_seen = true
		print("👁️ Boss detectou o player!")

func _on_detection_area_body_exited(body: Node2D) -> void:
	# não resetar player_chase nem player
	pass
