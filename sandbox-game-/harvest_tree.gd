extends Node2D

var state = "no trees" #no trees, trees
var player_in_area = false # Called when the node enters the scene tree for the first time.

var wood = preload("res://scenes/wood_collectable.tscn")

func _ready() -> void:
	if state == "no trees":
		$growth_timer.start()

func _process(_delta):
	if state == "trees":
		$AnimatedSprite2D.play("trees")
		if player_in_area && Input.is_action_just_pressed("R"):
			state = "no trees"
			drop_wood()
		else: $AnimatedSprite2D.play("no trees")

func _on_harvestable_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true


func _on_harvestable_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false

func _on_growth_timer_timeout() -> void:
	if state == "no trees":
		state = "trees"

func drop_wood():
	var wood_instance = wood.instantiate()
	wood_instance.global_position = $Marker2D.global_position
	get_parent().add_child(wood_instance)
	
	await get_tree().create_timer(3).timeout
	$growth_timer.start()
