/*

VEHICLES

*/


/*
Basic trigonometry

vx = v * cos(angle)
vy = v * sin(angle)
*/

/obj/machinery/vehicle
	name = "Vehicle Pod"
	icon = 'escapepod.dmi'
	icon_state = "recon"
	anchored = 1.0
	plane = MOB_PLANE_ALT
	animate_movement = 0 //set it
	var/forcedloc = null
	var
		vector2
			forward // Forward directional unit vector.
			velocity // Velocity of the ship in pixels per decisecond (p/ds).
		turning = 0
		accelerating = 0
		Spinning = 0
		CanMove = 0
	proc
		TurnRate() return 5
		// How fast you accelerate, in pixels per decisecond... per decisecond. (p/ds^2)
		Acceleration() return 1.6
	New()
		..()
		forward = Vector2_North // Initialize direction to north.
		velocity = Vector2_Zero // Initialize velocity to zero.

		special_processing += src
		var/icon/E = icon('escapepod.dmi',"recon")
		var/icon/I = icon('escapepod.dmi',"overlay")
		I += rgb(rand(0,255),rand(0,255),rand(0,255))
		I.Blend(E,ICON_OVERLAY)
		icon = I
		del E
		del I
	Del()
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
		special_processing -= src
		..()


/obj/machinery/vehicle/special_process()
	if(CanMove == 1)

		density = 0

		if(frm_counter % 5 && accelerating)
			var/obj/Particle/Spark/Heat/S = new()
			S.loc = loc
			S.x_pos = pixel_x+rand(0,32)
			S.y_pos = pixel_y+rand(0,32)
			S.x_spd = forward.x*-5
			S.y_spd = forward.y*-5

		if(turning)
			// Turn the forward direction and keep it normalized.
			forward = forward.Turn((turning * TurnRate()) * tick_lag_original).Normalized()
			transform = initial(transform) * forward.ToRotation()

		if(accelerating)
			// Accelerate!
			velocity += forward * (Acceleration() * tick_lag_original)
		else
			velocity *= 0.995 //slowly stop accelerating
		//world << velocity.SquareMagnitude()

		if(velocity.SquareMagnitude() > 1)
			if(PixelMove(velocity.x*tick_lag_original,velocity.y*tick_lag_original)==0)
				velocity *= -1
		else
			if(!accelerating)
				velocity = Vector2_Zero
		pixel_x = real_pixel_x
		pixel_y = real_pixel_y
		for(var/mob/A as mob in src)

			if(A.client)
				A.client.pixel_x = pixel_x
				A.client.pixel_y2 = pixel_y
	else
		//animate(src,transform = initial(transform),time = 5)
		real_pixel_x = real_pixel_x * 0.9
		real_pixel_y = real_pixel_y * 0.9
		pixel_x = real_pixel_x
		pixel_y = real_pixel_y
		density = 1
/obj/machinery/vehicle/meteorhit(var/obj/O as obj)
	for(var/atom/movable/A as mob|obj in src)
		A.loc = src.loc
	del(src)

/obj/machinery/vehicle/ex_act(severity)
	for(var/atom/movable/A as mob|obj in src)
		A.loc = src.loc
		A.ex_act(severity)
	del(src)

/obj/machinery/vehicle/blob_act()
	for(var/atom/movable/A as mob|obj in src)
		A.loc = src.loc
	del(src)

/obj/machinery/vehicle/relaymove(mob/user as mob, direction)
	if (user.stat)
		return

	if ((user in src))
		turning = (direction & EAST) - (direction & WEST) // 0, 1, or -1.
		accelerating = (direction & NORTH) - (direction & SOUTH) // 0 or 1.



/mob
	var/obj/machinery/vehicle/veh = null
	var/changingPOD = 0
	var/can_exit_pod = 1

/mob/verb/podCon()
	set name = "Pod Enter/Exit"
	var/mob/M = src
	if(!can_exit_pod)
		src << "<b>\red You cannot do this!"
		return
	if(changingPOD)
		return
	if(veh)
		changingPOD = 1
		veh.CanMove = 0
		sleep(5)
		M.loc = veh.loc
		if (M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE
			M.client.pixel_y2 = 0
			M.client.pixel_x = 0
		src << sound(null, channel=MOTOR_CHANNEL)
		//veh.forward = Vector2_North // Initialize direction to north.
		veh.velocity = Vector2_Zero // Initialize velocity to zero.
		veh = null
		changingPOD = 0
	else
		if(istype(src,/mob/dead) && src.health > 0 )
			return //Can't do this you fucking idiot
		var/list/faf = list()
		for(var/obj/machinery/vehicle/fef in oview(1))
			faf += fef
		var/obj/machinery/vehicle/a = input("Which pod to board?","Board") in faf
		var/turf/T = locate(x,y,z)
		if(T)
			if(a && istype(a,/obj/machinery/vehicle) && heightZ == T.TurfHeight)
				if(a.contents.len > 0)
					src << "<b>\red There is no room!"
				if (M.client)
					M.client.perspective = EYE_PERSPECTIVE
					M.client.eye = veh
					M.client.pixel_y2 = 0
					M.client.pixel_x = 0
				M.veh = a
				a.CanMove = 1
				a.velocity = Vector2_Zero // Initialize velocity to zero.
				M.loc = a
