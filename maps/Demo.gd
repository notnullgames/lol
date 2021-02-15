extends Node2D

# expose text var to UI
export(String, MULTILINE) var text

# eSxpose naem to UI
export(String) var dialog_name

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.show_dialog(dialog_name, text, "left")
