extends CharacterBody2D

@export var speed: float = 300.0
@export var damage: int = 20

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	$Sprite2D.play("default")

func _physics_process(delta: float) -> void:
	velocity = direction * speed

	var collision = move_and_collide(velocity * delta)

	if collision:
		var body = collision.get_collider()
		
		# Se bater em inimigo
		if body and body.has_method("enemy"):
			body.hit_by_bullet = true
			body.bullet_damage = GlobalPlayerStats.damage + 10
		
		# independente do que bateu (parede, objeto, inimigo)
		queue_free()
