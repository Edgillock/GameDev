shader_type spatial;
// Allowed: alpha's public include. // #include "res://game/modules/alpha/internal/x.gdshaderinc" is a comment.
#include "res://game/modules/alpha/public/common.gdshaderinc"
// Forbidden: alpha's internal include.
#include "res://game/modules/alpha/internal/secret.gdshaderinc"
