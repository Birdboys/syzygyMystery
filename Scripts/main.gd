extends Node2D

@onready var UI = $UILAYER/UI
@onready var themes = {'monitorglow':preload("res://Assets/themes/monitorglow.tres"), 'pixelink':preload("res://Assets/themes/pixelink.tres"), 'paperback':preload("res://Assets/themes/paperback.tres"), 'ygreen':preload('res://Assets/themes/ygreen.tres'),'noiretruth':preload("res://Assets/themes/noiretruth.tres")}
@onready var theme_names = ['monitorglow','pixelink','paperback','ygreen','noiretruth']
@onready var help_text = FileAccess.open("res://Assets/texts/help_text.txt", FileAccess.READ).get_as_text()
@onready var rooms = {}
@onready var theme_id = 0
@onready var num_themes = 4
@onready var mode = 0 #0-LOOK,1-MENU
@onready var currentRoom
@onready var prevRoom = null
@onready var inventory = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	initRooms()
	#theme_id = RandomNumberGenerator.new().randi_range(0,num_themes)
	theme_id = 0
	currentRoom = 'entry'
	setTheme(theme_names[theme_id])
	UI.updateLookImage(currentRoom, theme_names[theme_id])
	UI.updateLookText(currentRoom[0].to_upper()+currentRoom.substr(1))
	EventListener.event_triggered.connect(handleEvent)
	
	UI.map_pressed.connect(executeMap)
	UI.inventory_pressed.connect(executeInventory)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(mode)
	pass

func _on_ui_issue_command(command):
	match mode:
		0: #navigation mode
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
		1 | 2: #map mode
			if Parser.parseCloseCommand(command): #if close action
				UI.closeMenu(mode)
				mode = 0
				

func executeLook(command_data, command):
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
			UI.addLogText(look_result)
	elif look_target in inventory: #check if its in inventory
		look_result = TextLoader.getLookText(inventory[look_target].room, look_target, "inv", look_prep)
		if look_result == null: #invalid object look id
			UI.addLogText("UNIMPLEMENTED LOOK ID")
		else:
			EventListener.processEvent("%s%s%s" %[look_target, "inv", look_prep])
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
			EventListener.processEvent('look'+"".join(look_data))
			UI.addLogText(look_result)
	
func executeHelp(command_data):
	UI.addLogText(help_text)
func executeMap(command_data):
	mode = 1
	if command_data == null:
		UI.addLogText('[b]> map[/b]')
	UI.enterMap(theme_names[theme_id])
	print("EXECUTING MAP COMMAND")
func executeUse(command_data):
	print("EXECUTING USE COMMAND")
func executeGo(command_data):
	var room_change = command_data['direct_object']
	if room_change == null:
		UI.addLogText("You must enter a location to move")
		return
	elif room_change == "back":
		if prevRoom:
			var temp = currentRoom
			currentRoom = prevRoom
			prevRoom = currentRoom
			UI.updateLookImage(currentRoom, theme_names[theme_id])
			UI.updateLookText(currentRoom[0].to_upper()+currentRoom.substr(1))
			UI.addLogText("You have moved into the %s" %(currentRoom))
		else:
			UI.addLogText("There is no where to go back to")
		return
			
	if rooms[currentRoom].isRoomConnected(room_change):
		if room_change != currentRoom:
			prevRoom = currentRoom
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
	mode = 2
	print(inventory)
	if command_data == null:
		UI.addLogText('[b]> inventory[/b]', true)
	var lines = []
	for item in inventory:
		lines.append([inventory[item].name, inventory[item].room])
	UI.enterInventory(theme_names[theme_id], lines)
	print("EXECUTING INVENTORY COMMAND")
func executeSpeak(command_data):
	print("EXECUTING SPEAK COMMAND")
func executeTake(command_data):
	var look_target = command_data['direct_object']
	var look_prep = command_data['prep']
	var look_ind = command_data['indirect_object']
	if look_target == null: #validate empty look		
		UI.addLogText("You need to take an object")
		return
		
	var take_data = rooms[currentRoom].isTakableObjectInRoom(look_target, look_prep, look_ind) #get data from looked at object if it exists
	print(take_data)
	if take_data == null: #invalid object look id
		UI.addLogText("You cannot take that object")
	elif take_data[0] == "-1":
		UI.addLogText("The %s is already in your inventory" % take_data[1])
	else:
		var take_result = TextLoader.getTakeText(currentRoom, take_data[0], take_data[1], take_data[2])
		UI.addLogText(take_result)

func updateUITheme(theme):
	UI.updateTheme(theme)
#[entry, closet, bathroom, kitchen, lounge room, balcony]
func initRooms(): #n, adj, out, obj
	rooms['entry'] = entryRoom.new()
	rooms['kitchen'] = kitchenRoom.new()
	rooms['closet'] = defaultRoom.new('closet',['entry','bathroom','bedroom'], false, [], 'closet_default')
	rooms['bathroom'] = defaultRoom.new('bathroom', ['closet','bedroom','entry'], false, [], 'bathroom_default')
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
	UI.updateShopImage(t)

func addToInventory(item):
	inventory[item.name] = item
	
func handleEvent(event):
	match event:
		"found_entry_key": rooms["entry"].foundObject('key')
		"found_kitchen_wire":  rooms["kitchen"].foundObject('cord')
		"take_entry_key": var ret_item = rooms["entry"].tookObject('key','floor_mat'); addToInventory(ret_item); print("took key %s" %(inventory))
		"take_freezer_wire": var ret_item = rooms["kitchen"].tookObject('cord','freezer'); addToInventory(ret_item); print("took cord %s" %(inventory))
	pass

func _on_ui_menu_closed():
	mode = 0
	pass # Replace with function body.
