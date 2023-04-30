extends TextureButton

func _ready():
	self.button_pressed = not Settings.setting.music_enabled

func _on_toggled(val:bool):
	Audio.play("Select")
	val = not val

	Settings.setting.music_enabled = val
	Settings.update()

	if not val:
		Audio.stop("Battle")
		Audio.stop("Main")
	else:
		if get_parent().name == "Main Area":
			Audio.play("Main")
		else:
			Audio.play("Battle")
