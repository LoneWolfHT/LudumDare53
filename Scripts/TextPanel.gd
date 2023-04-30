extends Panel

@onready var fadeout = self.get_parent().get_node("FadeOut")
@onready var mybutton = self.get_parent().get_node("Buttons/TextButton")
@onready var otherbutton = self.get_parent().get_node("Buttons/InventoryButton")
@onready var mybutton_text = mybutton.text

func _ready():
	self.visible = false

func _on_text_button_pressed():
	self.visible = not self.visible
	fadeout.visible = self.visible

	mybutton.set_meta("showing", self.visible)
	Audio.play("Select")

	if self.visible:
		mybutton.text = "> " + mybutton_text
	else:
		mybutton.text = mybutton_text

	if self.visible and otherbutton.get_meta("showing"):
		otherbutton.emit_signal("pressed")

func _on_closebutton_pressed():
	Audio.play("Select")
	mybutton.emit_signal("pressed")
