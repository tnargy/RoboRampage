extends Control


func game_over():
	get_tree().paused = true
	visible = true
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_VISIBLE


func _on_restart_btn_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_btn_pressed():
	get_tree().quit()
