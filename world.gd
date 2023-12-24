extends Node2D

@export var next_level: PackedScene

var level_time = 0.0
var start_level_msec = 0.0

#@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D
#@onready var polygon_2d = $StaticBody2D/CollisionPolygon2D/Polygon2D
@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var start_in = %StartIn
@onready var start_in_label = %StartInLabel
@onready var animation_player = $AnimationPlayer
@onready var level_time_label = %LevelTimeLabel


func _ready():
	if not next_level is PackedScene:
		level_completed.next_level_button.text = "Victory Screen"
		next_level = load("res://victory_screen.tscn")
	Events.level_completed.connect(show_level_completed)
	RenderingServer.set_default_clear_color(Color.DEEP_SKY_BLUE)
	get_tree().paused = true
	start_in.visible = true
	LevelTransition.fade_from_black()
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false
	start_in.visible = false
	start_level_msec = Time.get_ticks_msec()
	#polygon_2d.polygon = collision_polygon_2d.polygon


func go_to_next_level():
	if not next_level is PackedScene: return
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)

func retry():
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	var current_level = load(scene_file_path)
	get_tree().change_scene_to_file(scene_file_path)
	

func _process(delta):
	level_time = Time.get_ticks_msec() - start_level_msec
	level_time_label.text = str(level_time / 1000.0)

func show_level_completed():
	level_completed.show()
	level_completed.retry_button.grab_focus()
	get_tree().paused = true
	
	

func _on_level_completed_next_level():
	go_to_next_level()


func _on_level_completed_retry():
	retry()
