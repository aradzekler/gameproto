extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 21
const MAX_SPEED = 200
const ACCELERATION = 50
const JUMP_HEIGHT = -550
const MAX_JUMPS = 2
const DASH_TIMER = 30
const MAX_FALL_TIME = 50

#states for input_states.gd 
const INPUT_RELEASED = 0
const INPUT_JUST_PRESSED = 1
const INPUT_PRESSED = 2
const INPUT_JUST_RELEASED = 3

var input_states = preload("Scripts/input_states.gd") #imports script.
var motion = Vector2() # initializes with 0, holds player location.
var jumpCount = 0
var deathFallCounter = 0
var dashTimerCounter = 0
var myDelta = 0
var moveLeft = input_states.new("ui_left")
var moveRight = input_states.new("ui_right")
var moveUp = input_states.new("ui_select")
var moveDown = input_states.new("ui_down")

##TODO: [] Add duck.
##		[] Fix double jump speed
func get_input():
	var friction = false
	var onFloor = is_on_floor() #boolean
	jumpCount = 0
	
	if moveRight.check() == INPUT_PRESSED:
		$Sprite.play("Run")
		motion.x = clamp(motion.x + ACCELERATION, -MAX_SPEED, MAX_SPEED) # prevents endless acceleration.
		$Sprite.flip_h = false
	elif moveLeft.check() == INPUT_PRESSED:
		$Sprite.play("Run")
		motion.x = clamp(motion.x - ACCELERATION, -MAX_SPEED, MAX_SPEED)
		$Sprite.flip_h = true
	elif moveDown.check() and onFloor:
		#$Sprite.play("Duck") future duck sprite.
		deathFallCounter = 0
		friction = true
	else:
		$Sprite.play("Idle")
		deathFallCounter = 0
		friction = true
	if moveUp.check() and onFloor:
		motion.y += JUMP_HEIGHT
		jumpCount += 1
	if friction == true and onFloor:
		motion.x = lerp(motion.x, 0, 0.2) #slowing down 20% every frame.
	if moveUp.check() and jumpCount < MAX_JUMPS and !onFloor: # double jump.
		motion.y += JUMP_HEIGHT * 0.5 # half of original jump height
		jumpCount += 1
	if motion.y < 0 and jumpCount < MAX_JUMPS and !onFloor:
		$Sprite.play("Jump")
	elif motion.y < 0 and jumpCount == MAX_JUMPS and !onFloor:
		$Sprite.play("DoubleJump")
	elif !onFloor:
		deathFallCounter += 1
		$Sprite.play("Fall")
	if friction == true and !onFloor:
		motion.x = lerp(motion.x, 0, 0.05) #less friction while moving through air.

# resets scene after player falls too much
func fall_killer():
	if deathFallCounter > MAX_FALL_TIME:
		    if !is_on_floor():
     			 get_tree().reload_current_scene()

#a way to get the delta into a var
func _fixed_process(delta):
  myDelta = delta

#main drive function. updates 60 per second.
func _physics_process(delta):
	motion.y += GRAVITY # basic gravity,  adds every frame.

	get_input()
	fall_killer()
	motion = move_and_slide(motion, UP)	# making movement
	pass

