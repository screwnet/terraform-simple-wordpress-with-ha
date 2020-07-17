resource "random_password" "dbpass" {
  length           = 30
  upper            = true
  number           = true
  special          = true
  override_special = "_-!?."
  min_lower        = 5
  min_numeric      = 5
  min_special      = 6
  min_upper        = 9
}
resource "random_password" "wp_admin_pass" {
  length           = 30
  upper            = true
  number           = true
  special          = true
  override_special = "_-!#?.&^$()><;:[]{}"
  min_lower        = 6
  min_numeric      = 7
  min_special      = 6
  min_upper        = 9
}
