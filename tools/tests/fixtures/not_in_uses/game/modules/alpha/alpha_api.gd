class_name AlphaApi
extends RefCounted
# Forbidden: alpha does not list beta in its uses, by path and by class name.
const BETA := preload("res://game/modules/beta/beta_api.gd")
var _beta: BetaApi
