extends CanvasLayer

#Notes so far: 
#In Project > Project Settings
#	General > Display > Window > Stretch > Mode: set to Viewport
#		Scratch that, I changed Mode to Canvas_Item and Aspect to Expand so that wider monitors dont get stretching or black boxes
#	Input Map: Add key for Toggle Settings (currently set to Escape)
#	Globals > Autoload (should be here by default): Added script to Autoload as "GUI"
#	Current Working Script: "extends Node" was changed to "extends CanvasLayer"
#These were to do the following:
#1). Camera will readjust to the stretching of the screen size (change of resolution)
#2). Added a method for us to access the settings (key input)
#3). Added as an autoload so no pre-reqs to trigger the script activation --> can always hit escape
#4). Set to Canvas Layer, so it is a pop up overlay on the game, not physically changing scenes

#I also decided to preset the resolution to 1280 x 720 since that seemed like a wise choice.
#empty Control Node, named settings_menu is created
#Used as base framework
var gui_components = [
	"res://Scenes/settings_menu.tscn"
]

#The possible resolutions which will be used
var resolutions = {
	"3840x2160": Vector2i(3840,2160),
	"2560x1440": Vector2i(2560,1440),
	"1920x1080": Vector2i(1920,1080),
	"1366x768": Vector2i(1366,768),
	"1280x720": Vector2i(1280,720),
	"1440x900": Vector2i(1440,900),
	"1600x900": Vector2i(1600,900),
	"1024x600": Vector2i(1024,600),
	"800x600": Vector2i(800,600)
}

#Here we actually load the process
#load the scene (beginning pause menu, from when you hit escape)
#create a new scene, which is the canvas layer that overlay
#the scene starts off hidden since the game should *start* with the menu open
func _ready():
	for i in gui_components:
		var new_scene = load(i).instantiate()
		add_child(new_scene)
		new_scene.hide()

#I'm tired of notes fuck this noise I'll do this once I'm done
func _input(_event):
	if Input.is_action_just_pressed("toggle_settings"):
		var settings_menu = get_node("SettingsMenu")
		settings_menu.visible = !settings_menu.visible
		if settings_menu.visible:
			settings_menu.update_button_values()

func center_window():
	var screen_center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(screen_center - window_size / 2)
