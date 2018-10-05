/*
This currently works, but the damage method could be redone.
*/
proc/atan2(x, y)
	if(!x && !y) return 0
	return y >= 0 ? arccos(x / sqrt(x * x + y * y)) : -arccos(x / sqrt(x * x + y * y))
/atom/proc/bullet_act(var/obj/projectile/bullet)
	return //This is for bullets.
/obj/item/weapon/gun
	icon = 'guns.dmi'
	icon_state = "gun"
	desc = "A gun"
	var/automatic = 0
	var/ammo = 0
	var/ammo_max = 0
	var/fire_rate = 0
	var/reload_rate = 0
	var/list/gun_sounds = list()
	var/reload_sound = 'reload.ogg'
	var/bullet_speed = 0
	var/bullet_damage = 0
	var/automatic_reload = 0
	var/sound_range = 15
	machine_gun
		icon_state = "gun"
		automatic = 1
		ammo = 50
		ammo_max = 50
		fire_rate = 5
		reload_rate = 15
		gun_sounds = list('shot.ogg')
		bullet_speed = 15
		bullet_damage = 5
		automatic_reload = 1
	pistol
		icon_state = "pistol"
		automatic = 0
		ammo = 24
		ammo_max = 24
		gun_sounds = list('shot2.ogg')
		bullet_speed = 20
		bullet_damage = 20
		sound_range = 25 //alot louder
	proc/fire(mob/user,xoff,yoff)
		if(ammo > 0)
			if(automatic == 1)
				if(frm_counter % fire_rate == 1)
				else
					return
			ammo -= 1
			var/obj/projectile/G = new(user.loc)
			G.heightZ = user.heightZ+16
			G.pixel_z = G.heightZ
			var/angle = atan2((xoff+32)-((G.x*32)+G.real_pixel_x),(yoff+32)-((G.y*32)+G.real_pixel_y))
			G.X_SPEED = cos(angle)*bullet_speed
			G.Y_SPEED = sin(angle)*bullet_speed
			G.damage = bullet_damage
			G.owner = user
			playsound(user, pick(gun_sounds), 100, 1, sound_range, (rand()-0.5)*0.2)
		else

			if(automatic == 0)
				playsound(user, reload_sound, 100, 1, sound_range, 0)
				ammo = ammo_max
			/*else
				user << "\red <b>No ammunition!"*/
	New()
		..()
		special_processing += src
	Del()
		special_processing -= src
		..()
	special_process()
		desc = "<font color=#FF1493>A gun, it seems to hold [ammo]/[ammo_max] ammunition.<br><b>Extra stats : </b><br><br>Bullet Speed : [bullet_speed]<br>Reload Rate : [reload_rate]<br>Fire Rate : [fire_rate]<br>Bullet Damage : [bullet_damage]</font>"
		if(automatic_reload)
			if(frm_counter % reload_rate == 1)
				ammo += 1
				if(ammo > ammo_max)
					ammo = ammo_max

var/list/bullets = list()
/obj/projectile
	icon = 'guns.dmi'
	icon_state = "bullet"
	var/X_SPEED = 0
	var/Y_SPEED = 0
	var/mob/owner = null
	var/damage = 30
	var/heightZ = 0
	var/obj/shadow/MyShadow = null //Shadow. This is handled in master controller.
	pixel_collision_size_x = 2
	pixel_collision_size_y = 2
	real_pixel_x = 15
	real_pixel_y = 0
	plane = MOB_PLANE_ALT
	pixel_w = -1
	pixel_x = 15
	animate_movement = 0
	density = 0
	New()
		..()
		MyShadow = new()
		MyShadow.icon = icon
		MyShadow.icon_state = icon_state
		MyShadow.color = "#808080"
		MyShadow.alpha = 75
		MyShadow.animate_movement = 0
		MyShadow.pixel_x = pixel_x+pixel_w
		MyShadow.pixel_y = pixel_y
		MyShadow.loc = loc
		bullets += src
	Del()
		if(MyShadow)
			del MyShadow
		bullets -= src
		..()
	pixel_hit(atom/e)
		e.bullet_act(src)
	proc/bullet_process()
		..()
		if(!PixelMove(X_SPEED,Y_SPEED,owner))
			del src
		MyShadow.pixel_x = pixel_x+pixel_w
		MyShadow.pixel_y = pixel_y
		MyShadow.loc = loc
		pixel_z = heightZ

/mob/bullet_act(obj/projectile/G)
	if(G.heightZ >= heightZ && G.heightZ+2 <= heightZ+heightSize)
		TakeBruteDamage(G.damage)