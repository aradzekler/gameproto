extends Control



func _on_StartGameButton_pressed():
	get_tree().change_scene("res://World.tscn")

func _on_OptionsButton_pressed():
	pass # replace with function body

func _on_QuitGameButton_pressed():
	get_tree().quit()
