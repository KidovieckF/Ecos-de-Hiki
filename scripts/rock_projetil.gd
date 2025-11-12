extends Area2D

@export var speed: float = 220.0
@export var damage: int = 20
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	# conectar sinal (caso queira)
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		global_position += direction * speed * delta
	rotation += delta * 6.0  # rotação visual opcional

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		print("teste")
		body.take_damage(damage)
	queue_free()

# --------- INTERFACE PÚBLICA ----------
# Use esta função para inicializar o projétil — evita acessar variáveis diretamente.
func initialize(dir: Vector2, dmg: int) -> void:
	direction = dir
	damage = dmg
