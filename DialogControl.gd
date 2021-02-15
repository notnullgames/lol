# DialogControl

extends Control

var scroll = 0
onready var font = $NinePatchRect/Text.get_font("normal_font")
onready var window_size = $NinePatchRect/Text.get_size()
onready var font_height = font.get_height()
onready var max_lines = floor(window_size[1] / font_height)

# handle Dialog input
func _input(event):
	if self.visible:
		if event.is_action_pressed("ui_accept"):
			scroll = scroll + max_lines
			print(scroll)
			$NinePatchRect/Text.scroll_to_line(scroll)
		if event.is_action_pressed("ui_cancel"):
			self.visible = false

func _ready():
	self.visible = false
	# hide the scrollbar, but keep scroll behavior
	$NinePatchRect/Text.get_child(0).rect_scale.x = 0

# this is exposed for Global.show_dialog
func show_dialog(name, text, name_align):
	if name_align == "left":
		$Name.bbcode_text = name
	if name_align == "right":
		$Name.bbcode_text = "[right]%s[/right]" % name
	if name_align == "center":
		$Name.bbcode_text = "[center]%s[/center]" % name
	$NinePatchRect/Text.bbcode_text = text + "\n\n"
	scroll = 0
	self.visible = true
	$NinePatchRect/Text.scroll_to_line(scroll)
	return self
