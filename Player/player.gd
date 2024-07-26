extends CharacterBody2D

@onready var Coyote_Timer = $CoyoteTimer
@onready var Jump_Buffer_Timer = $JumpBuffer
@onready var Debug_Text = $DebugText

@export var Jump_Buffer_Time: float
@export var Coyote_Jump_Time :float

@export var Jump_Strength: float
@export var Speed : float

var Jump_Available :bool = false
var Jump_Buffer: bool = false

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):

	# checking if there are floor
	#turn off coyote timer and check if jump buffer is on
	if is_on_floor():
		Coyote_Timer.stop()
		Jump_Available = true
		if Jump_Buffer and is_on_floor():
				Jump()
	
	#check if it not on floor
	if not is_on_floor():
		#start the timer for Coyote jump
		if Coyote_Timer.is_stopped() and Jump_Available:
			Coyote_Timer.start(Coyote_Jump_Time)
		#putting gravity
		velocity.y += gravity * delta
		
	
	
	# Handle Jump.
	if Input.is_action_just_pressed("Jump"):
		#Make Jump buffer true and start the timer
		Jump_Buffer = true
		Jump_Buffer_Timer.start(Coyote_Jump_Time)
		if Jump_Available:
			Jump()
		
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
	
	
	move_and_slide()
	
	Reset_Game()

#make the player jump... WHAT ELSE DO YOU EXPECT?!?!?!
func Jump() -> void:
	velocity.y = Jump_Strength
	Jump_Available = false

@warning_ignore("unused_parameter")
func _process(delta):

#Toggle to see the Debug Feature
	if Input.is_action_just_pressed("Debug_View"):
		if Debug_Text.visible == true:
			Debug_Text.visible = false
		else:
			Debug_Text.visible = true
	
	
	Debug_View()

#Reset the Scene/Game 
func Reset_Game():
	if Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()
	pass

func Debug_View():
	#Debug for Jump Buffer and Coyote Jump
	Debug_Text.text = "Jump Buffer: " + str(Jump_Buffer) \
		+ "\n Jump Bufer Timer: " + str(Jump_Buffer_Timer.time_left) \
		+ "\n Jump Available: " + str(Jump_Available) \
		+ "\n Jump Available Timer: " + str(Coyote_Timer.time_left) \
		+ "\n Jump Strength: " + str(velocity.y) \
		+ "\n Speed: " + str(velocity.x)
	pass

#turn off Coyote Jump
func _on_coyote_timer_timeout():
	Jump_Available = false
	pass # Replace with function body.

#turn off Jump Buffer
func Jump_Buffer_Timeout():
	Jump_Buffer = false
	pass # Replace with function body.
