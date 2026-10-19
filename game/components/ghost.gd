class_name Ghost
extends Node2D
## The ghost grandmother (hint system). The ghost look comes from
## shaders/ghost.gdshader on the sprite; this node fades her in and out and
## owns her ReactionPlayer.

const FADE_TIME: float = 0.4

@export var anim: AnimatedSprite2D
@export var reactions: ReactionPlayer
@export var start_visible: bool = false


func _ready() -> void:
	visible = start_visible


func appear() -> void:
	if visible:
		return
	modulate.a = 0.0
	visible = true
	anim.play(reactions.idle_animation)
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, FADE_TIME)
	await tween.finished


func vanish() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, FADE_TIME)
	await tween.finished
	visible = false
