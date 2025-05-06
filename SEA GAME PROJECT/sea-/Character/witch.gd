extends CharacterBody2D

var active := false
@onready var emotes = $Emotes2
@onready var anim = $Emotes2/Emote_animation
@onready var actionable_finder = $Actionables  # Area2D

func _ready():
	# Connect signals from the Area2D
	actionable_finder.connect("body_entered", Callable(self, "_on_body_entered"))
	actionable_finder.connect("body_exited", Callable(self, "_on_body_exited"))

func _process(_delta):
	emotes.visible = active
	if active and not anim.is_playing():
		anim.play("chat")

func _on_body_entered(body):
	if body.name == "Captain":
		active = true

func _on_body_exited(body):
	if body.name == "Captain":
		active = false
