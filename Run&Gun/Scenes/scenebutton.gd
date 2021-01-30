extends TextureButton

export (String, FILE) var path


func _on_scenebutton_pressed():
	SceneChanger._change_to_scene(path)
