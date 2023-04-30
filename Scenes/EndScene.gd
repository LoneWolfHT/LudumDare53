extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Audio.stop("Main")
	$AnimationPlayer.play("new_animation")
