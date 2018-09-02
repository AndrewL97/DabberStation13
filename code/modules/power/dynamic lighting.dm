atom
	var
		obj/light/light


Lighting
	var

		// the list of z levels that have been initialized
		list/initialized = list()

		// the list of all light sources
		list/lights = list()


	New()
		spawn(1)
			loop()

	proc
		loop()

			for(var/obj/light/l in lights)
				l.loop()
		init()

			var/list/z_levels = list()

			for(var/a in args)
				if(isnum(a))
					z_levels += a
				else if(isicon(a))
					world << "The lighting's icon should now be set by setting the lighting.icon var directly, not by passing an icon to init()."

			// if you didn't specify any z levels, initialize all z levels
			if(z_levels.len == 0)
				for(var/i = 1 to world.maxz)
					z_levels += i

			var/list/light_objects = list()

			// initialize each z level
			for(var/z in z_levels)

				// if it's already been initialized, skip it
				if(z in initialized)
					continue

				// keep track of which z levels have been initialized
				initialized += z

				// to intialize a z level, we create a /shading object
				// on every turf of that level
				for(var/x = 1 to world.maxx)
					for(var/y = 1 to world.maxy)

						var/turf/t = locate(x, y, z)
						var/area/a = t.loc
						if(a)
							if(a.forced_lighting == 1)
								if(a.sd_lighting == 1)

									// create the shading object for this tile
									t.shading = new(locate(x,y,z))
									light_objects += t.shading
								else
									if(!istype(t,/turf/space))
										// create the shading object for this tile
										t.shading = new(locate(x,y,z))
										light_objects += t.shading

turf
	var
		obj/shading/shading

// shading objects are a type of /obj placed in each
// turf that are used to graphically show the darkness
// as a result of dynamic lighting.
obj/shading
	mouse_opacity = 0
	anchored = 1
	plane = SHADING_PLANE
	layer = LIGHT_LAYER
	icon_state = "black"
	icon = 'RGBlights.dmi'

	pixel_x = 0
	pixel_y = 0

	//layer = LIGHT_LAYER
	ex_act()
		return 0


obj/light

	ex_act()
		return 0

	anchored = 1
	plane = SHADING_PLANE
	blend_mode = BLEND_ADD
	appearance_flags= RESET_COLOR

	icon = 'RGBlights.dmi'
	icon_state = "light"
	mouse_opacity = 0
	layer = LIGHT_LAYER + 1
	Move()
		//Do Nothing
	var
		// the atom the light source is attached to
		atom/owner

		// the radius, intensity, and ambient value control how large of
		// an area the light illuminates and how brightly it's illuminated.
		radius = 0
		intensity = 1

		// whether the light is turned on or off.
		on = 1

		// this flag is set when a property of the light source (ex: radius)
		// has changed, this will trigger an update of its effect.
		changed = 1

		// this is used to determine if the light is attached to a mobile
		// atom or a stationary one.
		mobile = 0

	New(atom/a, radius = 3, intensity = 1)
		if(!a || !istype(a))
			CRASH("The first argument to the light object's constructor must be the atom that is the light source. Expected atom, received '[a]' instead.")

		owner = a

		if(istype(owner, /atom/movable))
			loc = owner.loc
			mobile = 1
		else
			loc = owner
			mobile = 0

		src.radius = radius
		src.intensity = intensity

		x = a.x
		y = a.y

		// the lighting object maintains a list of all light sources
		lighting.lights += src

	proc
		// this used to be called be an infinite loop that was local to
		// the light object, but now there is a single infinite loop in
		// the global lighting object that calls this proc.
		loop()
			// if the light is mobile (if it was attached to an atom of
			// type /atom/movable), check to see if the owner has moved
			if(mobile)
				if(x != owner.x || x != owner.y)
					x = owner.x
					y = owner.y
					changed = 1

			if(changed)
				var/matrix/M = matrix()
				M.Scale((radius*on)/0.5)
				animate(src,alpha=255*intensity,transform = M,time = 5)
				changed = 0


		// turn the light source on
		on()
			if(on) return

			on = 1
			changed = 1

		// turn the light source off
		off()
			if(!on) return

			on = 0
			changed = 1

		// toggle the light source's on/off status
		toggle()
			if(on)
				off()
			else
				on()

		radius(r)
			if(radius == r) return

			radius = r
			changed = 1

		intensity(i)
			if(intensity == i) return

			intensity = i
			changed = 1
