var dashing          = false   # whether player is dash or not
var max_dash_delay   = 0.5     # time between keypress (.5 secs)
var max_dash_time    = 2.0     # how long player can run for (2 secs)
var dash_timer       = 0       # timer to reset dash state
var dash_press_count = 0       # keep track of double tap count
var move_speed       = 5       # the normal move speed
var dash_speed       = 10      # the dash speed
var speed            = 0       # used to store whichever speed the player is moving at
var velocity                   # the velocity which governs the player's movement

# using ndee85 state values [ 0 - released, 1 - just pressed, 2 - pressed, 3 - just released ] below for readability
var INPUT_RELEASED      = 0
var INPUT_JUST_PRESSED  = 1
var INPUT_PRESSED       = 2
var INPUT_JUST_RELEASED = 3

#velocity = Vector2()  # default velocity
	
func player_dash():
	speed = move_speed  
    # only attempt to dash if the player's not dashing
    if (dash_action.check() == INPUT_JUST_PRESSED and not dashing) :
        dash_press_count += 1

    # start the dash timer when player just presses the dash action
    if (dash_press_count > 0 and not dashing) :
        dash_timer += delta

        # the player took too long to perform the second tap so reset values
        if (dash_timer > max_dash_delay) :
            dash_timer = 0
            dash_press_count = 0

    # the player managed to dash successfully
    if (dash_press_count >= 2 and not dashing) :
        dashing = true
        dash_timer = 0
        dash_press_count = 0

        # player now uses the dash speed until timer elapses
        speed = dash_speed

    # the player will continue to dash until the timer elapses
    if (dashing) :
        dash_timer += delta
        if (dash_timer >= max_dash_time) :
            dashing = false
            dash_timer = 0

            # timer elapsed, reset to the normal speed
            speed = move_speed

    # move using whichever speed is chosen
    velocity += Vector2( speed * delta, velocity.y )

    # assuming you're using kinematicbody2d otherwise use set_pos(velocity)
    move (velocity) 