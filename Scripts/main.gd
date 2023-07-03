extends Node2D

@onready var UI = $UILAYER/UI
@onready var themes = {'monitorglow':preload("res://Assets/themes/monitorglow.tres"), 'pixelink':preload("res://Assets/themes/pixelink.tres"), 'paperback':preload("res://Assets/themes/paperback.tres"), 'ygreen':preload('res://Assets/themes/ygreen.tres'),'noiretruth':preload("res://Assets/themes/noiretruth.tres")}
@onready var theme_names = ['monitorglow','pixelink','paperback','ygreen','noiretruth']
@onready var help_text = FileAccess.open("res://Assets/texts/help_text.txt", FileAccess.READ).get_as_text()
@onready var rooms = {}
@onready var theme_id = 0
@onready var num_themes = 4
@export var currentRoom: String

# Called when the node enters the scene tree for the first time.
func _ready():
	initRooms()
	theme_id = RandomNumberGenerator.new().randi_range(0,num_themes)
	currentRoom = 'entry'
	setTheme(theme_names[theme_id])
	UI.updateLookImage(currentRoom, theme_names[theme_id])
	UI.updateLookText(currentRoom[0].to_upper()+currentRoom.substr(1))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ui_issue_command(command):
	UI.addLogText("[b]%s[/b]" %(command))
	var parsed_command = Parser.parseCommand(command)
	if parsed_command == null:	
		UI.addLogText("I don't know what you mean")
		return
	match parsed_command['operation']:
		'help': executeHelp(parsed_command)
		'look': executeLook(parsed_command)
		'speak': executeSpeak(parsed_command)
		'use': executeUse(parsed_command)
		'go': executeGo(parsed_command)
		'map': executeMap(parsed_command)
		'inventory': executeInventory(parsed_command)
		'examine': executeExamine(parsed_command)
		'take': executeTake(parsed_command)
		_ : print("THE FUCK JUST HAPPENED")

func executeLook(command_data):
	var txt = TextLoader.look_text[rooms[currentRoom].look_text]
	UI.addLogText(txt)
	print("EXECUTING LOOK COMMAND")
func executeHelp(command_data):
	UI.addLogText(help_text)
func executeMap(command_data):
	print("EXECUTING MAP COMMAND")
func executeUse(command_data):
	print("EXECUTING USE COMMAND")
func executeGo(command_data):
	var data = command_data['data']
	var room_count = 0
	var room_change = null
	for token in data:
		if rooms[currentRoom].isRoomConnected(token):
			room_count += 1
			room_change = token
	if room_change:
		if room_count == 1:
			if room_change != currentRoom:
				currentRoom = room_change
				UI.updateLookImage(currentRoom, theme_names[theme_id])
				UI.updateLookText(currentRoom[0].to_upper()+currentRoom.substr(1))
				UI.addLogText("You have moved into the %s" %(room_change))
			else:
				UI.addLogText("You are already in the %s" %(room_change))
		else:
			UI.addLogText("You can only move to one room at a time")
	else:
		UI.addLogText("Room not found")
	print("EXECUTING GO COMMAND")
func executeExamine(command_data):
	print("EXECUTING EXAMINE COMMAND")
func executeInventory(command_data):
	print("EXECUTING INVENTORY COMMAND")
func executeSpeak(command_data):
	print("EXECUTING SPEAK COMMAND")
func executeTake(command_data):
	print("EXECUTING TAKE COMMAND")
func updateUITheme(theme):
	UI.updateTheme(theme)
#[entry, closet, bathroom, kitchen, living room, balcony]
func initRooms(): #n, adj, out, obj
	rooms['entry'] = defaultRoom.new('entry', ['kitchen','closet','bathroom','bedroom'], false, [], 'entry_default')
	rooms['closet'] = defaultRoom.new('closet',['entry','bathroom','bedroom'], false, [], 'closet_default')
	rooms['bathroom'] = defaultRoom.new('bathroom', ['closet','bedroom','entry'], false, [], 'bathroom_default')
	rooms['kitchen'] = defaultRoom.new('kitchen', ['entry','living'], false, [], 'kitchen_default')
	rooms['living'] = defaultRoom.new('living', ['kitchen','balcony'], false, [], 'living_default')
	rooms['balcony'] = defaultRoom.new('balcony', ['living'], true, [], 'balcony_default')
	rooms['bedroom'] = defaultRoom.new('bedroom', ['bathroom', 'entry', 'closet'], false, [], 'bedroom_default')

func _input(event):
	if event.is_action_pressed("toggle_theme"):
		theme_id = (theme_id +1) % 5
		setTheme(theme_names[theme_id])
		print(theme_names[theme_id])
		
func setTheme(t):
	UI.updateTheme(themes[t])
	$UILAYER/BG.theme = themes[t]
	UI.updateLookImage(currentRoom,t)
	
