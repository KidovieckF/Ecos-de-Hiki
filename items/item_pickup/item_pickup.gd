@tool
class_name ItemPickup extends Node2D

@export var item_data : ItemData : set = _set_item_data

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D

signal item_picked

func _ready() -> void:
	_update_texture()
	if Engine.is_editor_hint():
		return
	
	area_2d.body_entered.connect(_on_body_entered)
	
func _on_body_entered(b) -> void:
	if b.has_method("player"):
		 
		if item_data:
			if GlobalPlayerManager.INVENTORY_DATA.add_item(item_data) == true:
				if item_data.type == "upgrade":
					_apply_item_upgrade(item_data)
				
				emit_signal("item_picked")
				item_picked_up()
	pass

func _apply_item_upgrade(item_data: ItemData) -> void:
	# Exemplo: item_data pode conter "upgrade_type" e "upgrade_value"
	if item_data.upgrade_type and item_data.upgrade_value:
		GlobalPlayerStats.apply_upgrade(item_data.upgrade_type, item_data.upgrade_value)


func item_picked_up() -> void:
	area_2d.body_entered.disconnect(_on_body_entered)
	#audio_stream_player_2d.play()
	visible = false
	#await audio_stream_player_2d.finished
	queue_free()
	

func  _set_item_data(value : ItemData) -> void:
	item_data = value
	
	

func _update_texture() -> void:
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture
	
