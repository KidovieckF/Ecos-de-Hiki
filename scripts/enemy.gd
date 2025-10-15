extends CharacterBody2D

const PICKUP = preload("res://items/item_pickup/ItemPickup.tscn")
@export_category("Item Drops")
@export var drops : Array[Dropdata]
var speed = 40
var player_chase = false
var player = null
var health = 100
var player_inattack_zone = false
var can_take_damage = true

var hit_by_bullet = false
var bullet_damage = 0



func _ready() -> void:
	$AnimatedSprite2D.play("idle_front")

func _physics_process(delta):
	deal_with_damage()
	
	#inimigo corre atras do player
	if player_chase:
		position += (player.position - position)/speed
		
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("walk_side")
		elif((player.position.x - position.x) > 0):
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("walk_side")
			
	elif  player_chase == false:
		$AnimatedSprite2D.play("idle_front")
		
func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false
		
func deal_with_damage():
	if player_inattack_zone and Fase.player_current_attack == true:
		if can_take_damage == true:
			health = health -20
			$iframes.start()
			can_take_damage = false
			print("slime health = ", health)
			if health <= 0:
				self.queue_free()
				
	if hit_by_bullet and can_take_damage:
		apply_damage(bullet_damage)
		hit_by_bullet = false  # reseta depois de aplicar


func apply_damage(amount: int):
	health -= amount
	$iframes.start()
	can_take_damage = false
	print("slime health = ", health)
	if health <= 0:
		drop_items()
		queue_free()
		
func _on_iframes_timeout() -> void:
	can_take_damage = true
	
func drop_items() -> void:
	print("teste")
	if drops.size() == 0:
		return

	for i in range(drops.size()):
		if drops[i] == null or drops[i].item == null:
			continue
		
		var drop_count: int = drops[i].get_drop_count()
		for j in range(drop_count):
			print("teste2")
			var drop: ItemPickup = PICKUP.instantiate() as ItemPickup
			drop.scale = Vector2(0.5,0.5)
			drop.item_data = drops[i].item
			get_tree().current_scene.add_child(drop)
			drop.global_position = global_position + Vector2(randf() * 16, randf() * 16)
