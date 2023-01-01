extends Area2D

export(int) var speed = 400


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta


func _on_Laser_area_entered(area: Area2D) -> void:
	queue_free()


func _on_Laser_body_entered(body: Node) -> void:
	queue_free()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
