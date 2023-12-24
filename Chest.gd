extends Area2D

func _on_body_entered(body):
	queue_free()
	var Chest = get_tree().get_nodes_in_group("Chest")
	if Chest.size() == 1:
		Events.level_completed.emit()
