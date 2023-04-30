extends Button

signal movement_pressed(toname)

@export var toname: String

func _ready():
	assert(toname)

	var parent = get_parent()

	self.pressed.connect(_movement_pressed)
	self.movement_pressed.connect(parent.do_movement)

	if Settings.setting.player_pos != parent.name:
		self.visible = false

func _movement_pressed():
	Audio.play("Select")
	emit_signal("movement_pressed", toname)
