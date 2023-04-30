extends Node

signal on_quit

func _notification(notif):
	if (notif == NOTIFICATION_WM_CLOSE_REQUEST || notif == NOTIFICATION_WM_GO_BACK_REQUEST):
		emit_signal("on_quit")

func quit():
	emit_signal("on_quit")

	get_tree().quit()
