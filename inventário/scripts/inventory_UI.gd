class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://inventário/InventorySlot.tscn")

@export var data : InventoryData

var timer := 0.0

func _ready() -> void:
	_update_inventory()


func _process(delta: float) -> void:
	timer += delta
	if timer >= 1.0:  # 1 segundo
		_update_inventory()
		timer = 0.0

func _update_inventory() -> void:
	# limpa slots antigos
	for c in get_children():
		c.queue_free()
	
	# adiciona todos os slots existentes
	for s in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
