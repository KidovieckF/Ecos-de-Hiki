class_name ItemData extends Resource

@export var name : String = ""
@export_multiline var description : String = ""
@export var texture : Texture2D
@export_enum("consumable", "upgrade", "quest", "misc") 
var type: String = "consumable"

@export_enum("damage", "heal", "speed", "bullet_speed") 
var upgrade_type: String = ""
@export var upgrade_value: float = 0.0
