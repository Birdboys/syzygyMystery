extends RichTextLabel
@onready var typing = false
@onready var typing_increase 
signal done_typing
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(visible_ratio)
	pass

func finishTyping():
	visible_ratio = 1

func startTyping(ratio, step):
	typing = true
	visible_ratio = ratio
	typing_increase = step
	
func _on_typewriter_timer_timeout():
	visible_ratio += typing_increase
	if visible_ratio >= 1 and typing:
		visible_ratio = 1
		typing = false
		emit_signal("done_typing")
	pass # Replace with function body.
