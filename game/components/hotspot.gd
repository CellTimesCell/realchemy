class_name Hotspot
extends Area2D
## Interactive spot: shows a prompt while the hero stands inside the area.

signal hero_entered(hotspot: Hotspot)
signal hero_exited(hotspot: Hotspot)

@export var prompt_text: String = "Осмотреть"
@export var prompt: Label


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if prompt:
		prompt.text = prompt_text
		prompt.visible = false


func _on_body_entered(body: Node2D) -> void:
	if body is Hero:
		if prompt:
			prompt.visible = true
		hero_entered.emit(self)


func _on_body_exited(body: Node2D) -> void:
	if body is Hero:
		if prompt:
			prompt.visible = false
		hero_exited.emit(self)
