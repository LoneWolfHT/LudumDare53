extends Panel

@onready var fadeout = self.get_parent().get_node("FadeOut")
@onready var mybutton = self.get_parent().get_node("Buttons/InventoryButton")
@onready var otherbutton = self.get_parent().get_node("Buttons/TextButton")
@onready var mybutton_text = mybutton.text

@onready var description = $Description

func _ready():
	if (Items.refresh_inv.connect(_repopulate) != OK):
		push_error("[Inventory] Failed to connect to Items global")

	_repopulate()

	self.visible = false

func _repopulate():
	var itemlist = $ItemList

	itemlist.clear()

	for item in Settings.setting.player_inventory:
		itemlist.add_item(item)

func _on_inventory_button_pressed():
	self.visible = not self.visible
	fadeout.visible = self.visible

	mybutton.set_meta("showing", self.visible)
	Audio.play("Select")

	if self.visible:
		_repopulate()
		mybutton.text = "> " + mybutton_text
	else:
		mybutton.text = mybutton_text

	if self.visible and otherbutton.get_meta("showing"):
		otherbutton.emit_signal("pressed")

func _on_item_list_item_activated(index:int):
	var item = Items.item[Settings.setting.player_inventory[index]]
	Audio.play("Select")

	if item.hp_heal:
		Settings.setting.player_hp = clamp(Settings.setting.player_hp + item.hp_heal, 0, Settings.setting.player_hp_max)
		description.text = "You consume the %s. Your HP is now %d/%d" % [Settings.setting.player_inventory[index], Settings.setting.player_hp, Settings.setting.player_hp_max]

		$ItemList.remove_item(index)
		Settings.setting.player_inventory.pop_at(index)
	else:
		description.text = "You consider consuming the %s but have second thoughts" % Settings.setting.player_inventory[index]

func _on_item_list_item_selected(index:int):
	var item = Items.item[Settings.setting.player_inventory[index]]

	Audio.play_low("Select", -5)

	description.text = item.description

	if item.hp_heal:
		description.text += " Your HP is %d/%d" % [Settings.setting.player_hp, Settings.setting.player_hp_max]
