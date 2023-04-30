extends TextureButton

func _ready():
	self.button_pressed = not Settings.setting.sounds_enabled

func _on_toggled(val:bool):
	Settings.setting.sounds_enabled = not val
	Settings.update()

	Audio.play("Select")
