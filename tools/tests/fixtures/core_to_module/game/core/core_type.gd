class_name CoreType
extends RefCounted
# Allowed: core may use core.
const OTHER := preload("res://game/core/core_other.gd")
# Forbidden: core may not reference any module, by path or by class name.
const ALPHA := preload("res://game/modules/alpha/alpha_api.gd")
var _alpha: AlphaApi
