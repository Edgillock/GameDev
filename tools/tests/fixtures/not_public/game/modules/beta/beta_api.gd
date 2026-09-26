class_name BetaApi
extends RefCounted
# Allowed: alpha's API and public/ types, by path and by class name.
const API := preload("res://game/modules/alpha/alpha_api.gd")
const VALUE := preload("res://game/modules/alpha/public/alpha_value.gd")
var _value: AlphaValue
var _note := "AlphaSecret"  # names in strings and comments are not references: AlphaSecret
# res://game/modules/alpha/internal/alpha_secret.gd in a comment is ignored too.
# Forbidden: alpha's internal/ and data/, by path and by class name.
const SECRET := preload("res://game/modules/alpha/internal/alpha_secret.gd")
const DATA := preload("res://game/modules/alpha/data/alpha_tuning.tres")
var _secret: AlphaSecret
