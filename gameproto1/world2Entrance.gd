#world2Entrance.gd
extends Area2D

export(String, FILE, "*.tscn") var nextWorld # exported value.

func _physics_process(delta):
	var bodies = get_overlapping_bodies() # array of overlapping bodies.
	for body in bodies:
		if body.name == "Player":
			get_tree().change_scene(nextWorld)