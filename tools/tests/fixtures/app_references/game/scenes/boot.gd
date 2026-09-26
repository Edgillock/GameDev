class_name Boot
extends Node
# Allowed: the app may use any module's API, public types and scenes.
const ALPHA := preload("res://game/modules/alpha/alpha_api.gd")
const DEMO := preload("res://game/modules/alpha/scenes/demo_alpha.tscn")
var _alpha: AlphaApi
# Forbidden: never a module's internal/.
const SECRET := preload("res://game/modules/alpha/internal/alpha_secret.gd")
var _secret: AlphaSecret
