extends VBoxContainer

@onready var time_display = $TimeDisplay
@onready var score_display = $ScoreDisplay

var gameTime: String = "13:45"
var score: String = str(1996)

func _process(delta: float) -> void:
	update_text()

func update_text():
	time_display.text = "Time: " + gameTime
	score_display.text = "Score: " + score
	
