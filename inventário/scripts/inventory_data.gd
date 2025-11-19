class_name InventoryData extends Resource

@export var slots : Array[ SlotData ]


func add_item( item : ItemData, count : int = 1) -> bool:
	if item.upgrade_type == "heal":
		print("Aplicando cura imediata.")
		GlobalPlayerStats.apply_upgrade("heal", item.upgrade_value)
		return true 

	for s in slots:
		if s:
			if s.item_data == item:
				s.quantity += count
				return true
				
	for i in slots.size():
		if slots[ i ] == null:
			var new = SlotData.new()
			new.item_data = item
			new.quantity = count
			slots [ i ] = new
			return true

	print("inventory was full!")
	return false

func clear():
	for i in slots.size():
		slots[i] = null
	emit_signal("inventory_changed")
