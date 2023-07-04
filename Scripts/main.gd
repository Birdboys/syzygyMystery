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
	#theme_id = RandomNumberGenerator.new().randi_range(0,num_themes)
	theme_id = 0
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
	match parsed_command['verb']:
		'help': executeHelp(parsed_command)
		'look': executeLook(parsed_command, command)
		'speak': executeSpeak(parsed_command)
		'use': executeUse(parsed_command)
		'go': executeGo(parsed_command)
		'map': executeMap(parsed_command)
		'inventory': executeInventory(parsed_command)
		'take': executeTake(parsed_command)
		_ : print("THE FUCK JUST HAPPENED")

func executeLook(command_data, command):
	print(command_data, command)
	var look_target = command_data['direct_object']
	if look_target == null: #validate empty look
		if command == '> look': #if its really empty
			look_target = currentRoom
		else: #if its empty because command is bad
			UI.addLogText("Can not look there")
			return
	var look_prep = command_data['prep'] #get the preposition from the look command
	var look_result = null
	if look_target == 'room':
		look_target = currentRoom
	if look_target == currentRoom: #if we are looking at current room
		look_result = TextLoader.getLookText(currentRoom, currentRoom, rooms[currentRoom].look_text_id, null)
		if look_result == null: #invalid object look id
			UI.addLogText("UNIMPLEMENTED LOOK ID")
		else:
			print(look_result)
			UI.addLogText(look_result)
	else:
		var look_data = rooms[currentRoom].isObjectInRoom(look_target, look_prep) #get data from looked at object if it exists
		if look_data == null: #if that object doesn't exist
			UI.addLogText('You cannot look there')
			return
		look_result = TextLoader.getLookText(currentRoom, look_data[0], look_data[1], look_data[2])
		if look_result == null: #invalid object look id
			UI.addLogText("UNIMPLEMENTED LOOK ID")
		else:
			print(look_result)
			UI.addLogText(look_result)
	
func executeHelp(command_data):
	UI.addLogText(help_text)
func executeMap(command_data):
	print("EXECUTING MAP COMMAND")
func executeUse(command_data):
	print("EXECUTING USE COMMAND")
func executeGo(command_data):
	var room_change = command_data['direct_object']
	if room_change == null:
		UI.addLogText("You must enter a location to move")
		return
	if rooms[currentRoom].isRoomConnected(room_change):
		if room_change != currentRoom:
			currentRoom = room_change
			UI.updateLookImage(currentRoom, theme_names[theme_id])
			UI.updateLookText(currentRoom[0].to_upper()+currentRoom.substr(1))
			UI.addLogText("You have moved into the %s" %(room_change))
		else:
			UI.addLogText("You are already in the %s" %(room_change))
	else:
		UI.addLogText("Location not found: %s" %(room_change))
	#print("EXECUTING GO COMMAND")

func executeInventory(command_data):
	print("EXECUTING INVENTORY COMMAND")
func executeSpeak(command_data):
	print("EXECUTING SPEAK COMMAND")
func executeTake(command_data):
	print("EXECUTING TAKE COMMAND")
func updateUITheme(theme):
	UI.updateTheme(theme)
#[entry, closet, bathroom, kitchen, lounge room, balcony]
func initRooms(): #n, adj, out, obj
	rooms['entry'] = entryRoom.new()
	rooms['closet'] = defaultRoom.new('closet',['entry','bathroom','bedroom'], false, [], 'closet_default')
	rooms['bathroom'] = defaultRoom.new('bathroom', ['closet','bedroom','entry'], false, [], 'bathroom_default')
	rooms['kitchen'] = defaultRoom.new('kitchen', ['entry','lounge'], false, [], 'kitchen_default')
	rooms['lounge'] = defaultRoom.new('lounge', ['kitchen','balcony'], false, [], 'lounge_default')
	rooms['balcony'] = defaultRoom.new('balcony', ['lounge'], true, [], 'balcony_default')
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
	
