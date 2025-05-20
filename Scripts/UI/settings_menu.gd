extends Control
#I slapped this bitch on an empty control node and I said YIPPIE. Thats all it needs.
#GUI_AUTOLOAD says this (as of writing)
#"res://Scenes/settings_menu.tscn"
#so it expects it to be here. If not, then change the GUI_Autoload. Dont touch here.
#Dont worry about anything here.
#For context, this is an extension of the GUI_autoload.gd script. It is useless on its own
#Well, not really, but like, it wont get called nor function without the GUI_autoload script
#Basically, this shit should be encapsulated unless you wish to cry. Dont look at it, dont think about it
#This is nightmare hell town and it doesnt need to be viewed....
#except that it isnt done yet and you can have fun figuring out WHAT THE FUCK IS HAPPENING HERE
#But I leave this note here for a few reasons.

#Whatever you think you need to touch in here, really ask if you know what you're doing
#In addition, anything that is occurring here should instead be touched up in GUI_autoload
#Furthermore, if you wish to replicate what is happening here cause you want more settings
#Understand this shit is specific for resolutions
#As well as it is a shitstorm. This is hours of googling and watching tutorials
#Frankensteining grotesque code and then reading docs until it finally works
#It doesnt even work proper. Fuck this code. Dont touch it. Unless you can fix it. Then do so.
#Dont break it more please

@onready var resolutions_button: OptionButton = OptionButton.new()
@onready var screen_mode_button: OptionButton = OptionButton.new()

func _ready():
	init_ui()
	add_resolutions()
	resolutions_button.connect("item_selected", Callable(self, "_on_resolution_selected"))
	screen_mode_button.connect("item_selected", Callable(self, "_on_mode_selected"))


#THE ESCAPE MENU IS NOT FUCKIGN FOIGNG TIN THE FUCKIGN CETNER IT IS ON THE LEFT
#Fuck the HBOX I've tried Center Container wth am I suppsoe to do 
#I hate this its 130am and I am tired this shit can lick my bunghole
func init_ui():
	var panel = Control.new()
	var hbox = HBoxContainer.new()
	var vbox = VBoxContainer.new()
	var label = Label.new()

	add_child(panel)
	panel.add_child(hbox)
	hbox.add_child(vbox)
	vbox.add_child(label)
	vbox.add_child(resolutions_button)
	vbox.add_child(screen_mode_button)
	
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	vbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

	label.text = "Graphics Quality"
	var font_size = int(get_viewport().get_visible_rect().size.x * 0.05)
	label.add_theme_font_size_override("font_size", font_size)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	resolutions_button.custom_minimum_size = Vector2(200, 50)
	screen_mode_button.custom_minimum_size = Vector2(200, 50)
	
	resolutions_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	resolutions_button.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	screen_mode_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	screen_mode_button.size_flags_vertical = Control.SIZE_SHRINK_BEGIN

	
func add_resolutions():
	for r in GUI.resolutions:
		resolutions_button.add_item(r)
	screen_mode_button.add_item("Windowed")
	screen_mode_button.add_item("Fullscreen")
	screen_mode_button.add_item("Borderless")

func update_button_values():
	var current_size = Vector2i(get_window().size.x, get_window().size.y)
	for i in GUI.resolutions.keys().size():
		var res_str = GUI.resolutions.keys()[i]
		if GUI.resolutions[res_str] == current_size:
			resolutions_button.select(i)
			break

	var current_mode = DisplayServer.window_get_mode()
	if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		screen_mode_button.select(1)
	elif DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS):
		screen_mode_button.select(2)
	else:
		screen_mode_button.select(0)


#BRUH FUCK THIS I CHANGE THE SCREEN MODE FROM BORDERLESS TO WINDOW AND IT DOESNT WORK
#SO NOW I"M MAKING A FUNCTION IN ORDER FOR IT TO BE LIKE "HEY LETS MANUALLY RESET THE RESOLUTION".
#Lo and Behold, turns out the solution was just to go Borderless -> Full Screen -> Windowed
#I hate this so much. But fuck it this function gets to stay, as some disgusting remnant of my failures
func apply_resolution(key: String):
	if key in GUI.resolutions:
		var res_size = GUI.resolutions[key]
		get_tree().root.content_scale_size = res_size
		get_viewport().set_size(res_size)
		DisplayServer.window_set_size(res_size)
		DisplayServer.window_set_min_size(res_size)
		GUI.center_window()


func _on_resolution_selected(index):
	var key = resolutions_button.get_item_text(index)
	apply_resolution(key)

func _on_mode_selected(index):
	var key = resolutions_button.get_item_text(resolutions_button.selected)
	match index:
		0: # Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			await get_tree().process_frame
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			apply_resolution(key)

		1: # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

		2: # Borderless <-- fuck you in particular
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			await get_tree().process_frame
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

			var screen_size = DisplayServer.screen_get_size()
			get_tree().root.content_scale_size = screen_size
			get_viewport().set_size(screen_size)
			DisplayServer.window_set_size(screen_size)
			GUI.center_window()
