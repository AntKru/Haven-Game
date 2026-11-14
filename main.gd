extends Node

var deathCount = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.start($spawn.position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		_on_player_damage()

func _on_player_damage() -> void:
	deathCount += 1
	$HUD/DeathCount.text = "Death count: " + str(deathCount)
	_ready()
