extends CanvasLayer

@onready var bubble :=  $HUD_Painel                # balão do diálogo
@onready var dialogue_label := $HUD_Painel/Dialogo       # texto da fala
@onready var name_box := $Panel2             # caixa do nome
@onready var name_label := $Panel2/Label          # nome do NPC

var lines: Array = []
var index := 0
var active := false

func _ready() -> void:
	hide_dialog()


func show_dialog(npc_name: String, dialogue_lines: Array) -> void:
	lines = dialogue_lines
	index = 0
	active = true

	name_label.text = npc_name
	dialogue_label.text = lines[index]

	bubble.visible = true
	dialogue_label.visible = true

	name_box.visible = true
	name_label.visible = true

	visible = true


func next_line() -> void:
	if not active:
		return

	index += 1

	if index >= lines.size():
		hide_dialog()
		return

	dialogue_label.text = lines[index]


func hide_dialog() -> void:
	active = false
	visible = false
	bubble.visible = false
	name_box.visible = false
