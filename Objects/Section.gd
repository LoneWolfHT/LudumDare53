extends Marker2D

@export_node_path("Marker2D") var unlocks

@onready var parent = get_parent()
@onready var unlock_node = get_node_or_null("Unlock")
@onready var location_button = get_node("../../UI/Buttons/TextButton")
@onready var location_text = get_node("../../UI/TextPanel")
@onready var location_description = get_node("../../UI/TextPanel/Description")
@onready var location_title = get_node("../../UI/TextPanel/RoomName")

signal moved_player
signal trigger_unlock

func _ready():
	assert(location_text, "Location Text panel not found")

	self.visible = true

	if unlock_node:
		unlock_node.visible = false

	if unlocks:
		unlocks = get_node(unlocks)

		if (self.trigger_unlock.connect(unlocks.unlock) != OK):
			push_error("Failed to connect unlock signal")

		if Settings.setting.completed.has(self.name as String):
			emit_signal("trigger_unlock")

	if (self.moved_player.connect(parent.moved_player) != OK):
		push_error("Failed to connect to parent for player movement")

	if Settings.setting.discovered.has(self.name as String):
		for child in get_children():
			if child is TextureRect and child.name != "Lock":
				child.queue_free()

	if get_node_or_null("Lock") and Settings.setting.unlocked.has(self.name as String):
		$Lock.visible = false

func on_arrival():
	Settings.setting.player_pos = self.name as String

	emit_signal("moved_player")

	for child in get_children():
		if child is Button:
			if child != unlock_node or Settings.setting.unlocked.has(self.name as String):
				child.visible = true

	for child in get_children():
		if child is TextureRect and child.name != "Lock":
			child.queue_free()

	if not Settings.setting.discovered.has(self.name as String):
		location_button.emit_signal("pressed")

	location_title.text = parent.roomtext[self.name as String].title
	location_description.bbcode_text = parent.roomtext[self.name as String].description

	Settings.setting.discovered[self.name as String] = true

	Settings.update()

func do_movement(to):
	for child in get_children():
		if child is Button:
			child.visible = false

	parent.get_node(to).on_arrival()

func unlock():
	Settings.setting.unlocked[self.name as String] = true

	$Lock.visible = false

	if Settings.setting.player_pos == (self.name as String):
		$Unlock.visible = true

	Settings.update()
