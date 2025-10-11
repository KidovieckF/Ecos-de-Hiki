extends Area2D


@export var speed: float = 100.0
@export var damage: int = 20


var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	$Sprite2D.play("default")

func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_body_entered(body: Node) -> void:
	if body.has_method("enemy"): # confirma que é inimigo
		body.hit_by_bullet = true
		body.bullet_damage = damage
		queue_free() # bala some ao bater
