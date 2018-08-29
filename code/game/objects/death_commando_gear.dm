/obj/beam/a_laser/pulse_laser
	name = "pulse laser"
	icon_state = "u_laser"

	Bump(atom/A)
		spawn()
			if(A)
				if(A.can_bullet_act()) A.bullet_act(PROJECTILE_PULSE)
			del(src)