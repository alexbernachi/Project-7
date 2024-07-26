extends CharacterBody2D

@onready var Coyote_Timer = $CoyoteTimer
@onready var Jump_Buffer_Timer = $JumpBuffer
@onready var Debug_Text = $DebugText


const SPEED = 300.0
const JUMP_FORCE = -400.0

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
			Coyote_Timer.start()
		#putting gravity
		velocity.y += gravity * delta
		
	
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept"):
		#Make Jump buffer true and start the timer
		Jump_Buffer = true
		Jump_Buffer_Timer.start()
		if Jump_Available:
			Jump()
		
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	

	move_and_slide()

#make the player jump... WHAT ELSE DO YOU EXPECT?!?!?!
func Jump() -> void:
	velocity.y = JUMP_FORCE
	Jump_Available = false

@warning_ignore("unused_parameter")
func _process(delta):
	#Debug for Jump Buffer and Coyote Jump
	Debug_Text.text = "Jump Buffer: " + str(Jump_Buffer) \
	+ "\n Jump Bufer Timer: " + str(Jump_Buffer_Timer.time_left) \
	+ "\n Jump Available: " + str(Jump_Available) \
	+ "\n Jump Available Timer: " + str(Coyote_Timer.time_left)
	pass

#turn off Coyote Jump
func _on_coyote_timer_timeout():
	Jump_Available = false
	pass # Replace with function body.

#turn off Jump Buffer
func Jump_Buffer_Timeout():
	Jump_Buffer = false
	pass # Replace with function body.
