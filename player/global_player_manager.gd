extends Node

const INVENTORY_DATA: InventoryData = preload("res://inventário/player_inventory.tres")

# Sinal para notificar a UI
signal inventory_updated

# Método para adicionar item e emitir sinal
func add_item(item: ItemData) -> bool:
	INVENTORY_DATA.slots.append(item)  # adiciona no InventoryData existente
	emit_signal("inventory_updated")    # notifica a UI
	return true
