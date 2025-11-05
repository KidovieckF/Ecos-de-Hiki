extends CharacterBody2D

signal health_changed(current, maximum)

@export var bullet_scene: PackedScene
var menu_scene = preload("res://scenes/control.tscn")
var hud_scene = preload("res://scenes/hud.tscn")
var inventory_scene = preload("res://scenes/Inventario.tscn")
var menu_morte_scene = preload("res://scenes/menu_morte.tscn")



var enemy_inatacck_range = false
var enemy_attack_cooldown = true

var health = 100
var max_health = 100

var player_alive = true
var menu_instance = null


var attack_ip = false
const speed = 100
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")
	$AnimatedSprite2D2.play("Idle_M")
	instantiate_HUD()
	instantiate_inventory()
	instantiate_menu()
	if $world_camera:
		$world_camera.make_current()
	else:
		print("Erro")
	
	print("🔍 Player instanciado em:", name, " | Cena:", get_tree().current_scene.name)
	print("Todos os Players atuais:", get_tree().get_nodes_in_group("player"))
	emit_signal("health_changed", health, max_health)
	
func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	shoot()
	
	
func instantiate_HUD():
	var hud_instance = hud_scene.instantiate()
	hud_instance.position = Vector2(0,0)
	$UI.add_child(hud_instance)
	self.health_changed.connect(hud_instance.update_health)
	
func instantiate_inventory():
	var inventory_instance = inventory_scene.instantiate()
	inventory_instance.scale = Vector2(0.4,0.4)
	inventory_instance.position = Vector2(115,3)
	$UI.add_child(inventory_instance)
	

func instantiate_menu():
	print("Chamando instantiate_menu() — Cena atual:", get_tree().current_scene.name)
	if not $UI:
		push_error("Nó 'UI' (CanvasLayer) não encontrado! Adicione um CanvasLayer como filho do Player.")
		return
	
	
	menu_instance = menu_scene.instantiate()
	menu_instance.scale = Vector2(0.35, 0.35)
	var viewport_size = get_viewport().get_visible_rect().size
	menu_instance.position = viewport_size / 4 - (menu_instance.size / 4)
	
	
	# Adiciona dentro do CanvasLayer
	$UI.add_child(menu_instance)
	print("✅ Menu criado em posição:", menu_instance.position)
	
	
		
		
func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	else: 
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()
	
func take_damage(amount: int):
	health -= amount
	health = clamp(health, 0, max_health)
	emit_signal("health_changed", health, max_health)
	
	if health <= 0:
		player_alive = false
		print("player has been killed")
		var menu_morte_instance = menu_morte_scene.instantiate()
		menu_morte_instance.scale = Vector2(0.35, 0.35)
		var viewport_size = get_viewport().get_visible_rect().size
		menu_morte_instance.position = viewport_size / 1.75 - (menu_morte_instance.size / 1.75)
		get_tree().current_scene.add_child(menu_morte_instance)
		queue_free()
		
		
func heal(amount: int):
	health += amount
	health = clamp(health, 0, max_health)
	emit_signal("health_changed", health, max_health)

	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		if movement == 1:
			anim.play("side_walk_right")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle_right")
	if dir == "left":
		if movement == 1:
			anim.play("side_walk_left")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle_left")
	if dir == "down":
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")
	if dir == "up":
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("back_idle")

#identificador que se trata de um player
func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inatacck_range = true


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inatacck_range = false

func enemy_attack():
	if enemy_inatacck_range and enemy_attack_cooldown == true:
		take_damage(20)
		enemy_attack_cooldown = false
		$iframes.start()
		print(health)
		emit_signal("health_changed", health)

#janela de invulnerabilidade para ataques
func _on_iframes_timeout() -> void:
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		Fase.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$attack_cd.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$attack_cd.start()
		if dir == "down":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("front_attack")
			$attack_cd.start()
		if dir == "up":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("back_attack")
			$attack_cd.start()
			
func shoot():
	if Input.is_action_just_pressed("shoot") and attack_ip == false: # defina "shoot" no InputMap
		attack_ip = true
		var bullet = bullet_scene.instantiate()
		var offset = Vector2(-4, -8) # 16 pixels à direita
		if current_dir == "left":
			offset = Vector2(-30, -8)
		elif current_dir == "up":
			offset = Vector2(-16, -16)
		elif current_dir == "down":
			offset = Vector2(-16, 13)
		
		bullet.position = global_position + offset

		var dir = Vector2.ZERO
		match current_dir:
			"right":
				dir = Vector2.RIGHT
				$attack_cd.start()
			"left":
				dir = Vector2.LEFT
				$attack_cd.start()
			"up":
				dir = Vector2.UP
				$attack_cd.start()
			"down":
				dir = Vector2.DOWN
				$attack_cd.start()
				
		if dir != Vector2.ZERO:
			bullet.get_node("Sprite2D").rotation = dir.angle()
		bullet.velocity = dir * bullet.speed
		get_tree().current_scene.add_child(bullet)
		

#tempo de espera para atirar
func _on_attack_cd_timeout() -> void:
	$attack_cd.stop()
	Fase.player_current_attack = false
	attack_ip = false
	
