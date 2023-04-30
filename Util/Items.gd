extends Node

@export var item = {
	"Key" : {
		"description" : "A key, it might be possible to use this to unlock something.",
	},
	"Healing Potion" : {
		"description" : "Heals your health to full.",
		"hp_heal" : 999,
	}
}

signal refresh_inv

func update_inventory():
	emit_signal("refresh_inv")
