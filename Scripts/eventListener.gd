extends Node
var has_triggered = {'lookfloor_matunder':false, 'lookfreezerin':false, 'take_freezer_wire':false,'take_entry_key':false}
signal event_triggered(event_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func processEvent(eventid):
	match eventid:
		'lookfloor_matunder' : 
			if not has_triggered[eventid]:
				has_triggered[eventid] = true
				emit_signal("event_triggered","found_entry_key")
		'lookfreezerin':
			if not has_triggered[eventid]:
				has_triggered[eventid] = true
				emit_signal("event_triggered","found_kitchen_wire")
		'take_entry_key':
			if not has_triggered[eventid]:
					has_triggered[eventid] = true
					emit_signal("event_triggered","take_entry_key")
		'take_freezer_wire':
			if not has_triggered[eventid]:
				has_triggered[eventid] = true
				emit_signal("event_triggered","take_freezer_wire")
