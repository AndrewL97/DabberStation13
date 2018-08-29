atom
	var
		obj/light/light


Lighting
	var
		// the number of shades of light
		states = 0
		posColors = 256
		// need to be updated this tick
		list/changed = list()

		// the list of z levels that have been initialized
		list/initialized = list()

		// the list of all light sources
		list/lights = list()


	New()
		spawn(1)
			loop()

	proc
		loop()



			// apply all light sources. each apply() proc will
			// check if any changes have occurred, so it's not
			// a bad thing that we're calling this for all lights,
			// if a light hasn't changed since the last tick,
			// nothing will happen.

			for(var/obj/light/l in lights)
				l.loop()

			/*var/list/LightsAA = list()
			for(var/client/i in clients)
				for(var/obj/shading/s in range(i.view,i) ) //fuck h
					LightsAA += s*/
			//holy shit this method is so laggy nvm about using it

			// update all shading objects in the list and clear
			// their "changed" flag, this guarantees that each
			// shading object is updated once per tick, even if
			// multiple light sources change in a way that affects
			// its illumination.


			//oh boy now its time for some epic improvements here
			for(var/obj/shading/s in changed) //should be changed
				//6.
				s.get_refs() //just making sure its ref's exist.
				if(s && s.c1 && s.c2 && s.c3)


					var/ce0 = text2num("[s.lum]") //center s
					var/ce1 = text2num("[s.c1.lum]") //bottom right c1
					var/ce2 = text2num("[s.c2.lum]") //bottom left c2
					var/ce3 = text2num("[s.c3.lum]") //top left c3

					/*
					COLOR REF :

					WEST          CE3   CE0   ORIGINAL LUM
                                     CE4
					SOUTHWEST     CE2   CE1          SOUTH

					NORTH         U3     U2      NORTHEAST

					ORIGINAL LUM  U0     U1           EAST

					c1 = locate(/shading) in get_step(loc, SOUTH)
					c2 = locate(/shading) in get_step(loc, SOUTHWEST)
					c3 = locate(/shading) in get_step(loc, WEST)

					u1 = locate(/shading) in get_step(loc, EAST)
					u2 = locate(/shading) in get_step(loc, NORTHEAST)
					u3 = locate(/shading) in get_step(loc, NORTH)

					NORTHWEST = locate(/shading) in get_step(loc, NORTHWEST)
					SOUTHEAST = locate(/shading) in get_step(loc, SOUTHEAST)

					*/
					var/newColor = list(
								0, 0, 0, 1-(ce2/lighting.posColors), //This is the xXxx part, aka ce2.
								0, 0, 0, 1-(ce1/lighting.posColors), //This is the Xxxx part, aka ce1.
								0, 0, 0, 1-(ce3/lighting.posColors), //This is the xxXx part, aka ce3.
								0, 0, 0, 1-(ce0/lighting.posColors), //This is the xxxX part, aka ce0.
								0, 0, 0, 0)
					if(s.color != newColor)
						animate(s, color = newColor, time = 2)
					//s.icon_state = "[s.c1.lum][s.c2.lum][s.c3.lum][s.lum]" This is the original formula.
					s.changed = 0

			// reset the changed list
			changed = list()

		// Initialize lighting for a single z level or for all
		// z levels. This initialization can be time consuming,
		// so you might want to initialize z levels only as you
		// need to.
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
									t.shading = new(t, 'extra images/RGBlights.dmi', 0)
									light_objects += t.shading
								else
									if(!istype(t,/turf/space))
										// create the shading object for this tile
										t.shading = new(t, 'extra images/RGBlights.dmi', 0)
										light_objects += t.shading

			// initialize the shading objects
			for(var/obj/shading/s in light_objects)
				s.init()

				// this is the inline call to update()
				if(s.loc && !s.changed)
					s.changed = 1
					lighting.changed += s

turf
	var
		obj/shading/shading

var
	obj/shading/null_shading = new(null, null, 0)

// shading objects are a type of /obj placed in each
// turf that are used to graphically show the darkness
// as a result of dynamic lighting.
obj/shading
	mouse_opacity = 0
	anchored = 1
	plane = SHADING_PLANE
	icon_state = "RGB"
	color = list(					0, 0, 0, 1, //This is the xXxx part, aka ce2.
									0, 0, 0, 1, //This is the Xxxx part, aka ce1.
									0, 0, 0, 1, //This is the xxXx part, aka ce3.
									0, 0, 0, 1, //This is the xxxX part, aka ce0.
									0, 0, 0, 0)
	//parent_type = /obj

	pixel_x = 0
	pixel_y = 0

	layer = LIGHT_LAYER
	ex_act()
		return 0
	var
		lum = 0
		__lum = 0

		// these are the shading objects whose lum values
		// we need to compute the icon_state for this obj
		obj/shading/c1
		obj/shading/c2
		obj/shading/c3

		// these are the shading objects whose icons need to
		// change when this object's lum value changes
		obj/shading/u1
		obj/shading/u2
		obj/shading/u3

		changed = 0


	New(turf/t, i, l)
		..(t)
		icon = i
		lum = l

	proc
		init()
			get_refs()
		get_refs()
			// get references to its neighbors
			c1 = locate(/obj/shading) in get_step(loc, SOUTH)
			c2 = locate(/obj/shading) in get_step(loc, SOUTHWEST)
			c3 = locate(/obj/shading) in get_step(loc, WEST)

			u1 = locate(/obj/shading) in get_step(loc, EAST)
			u2 = locate(/obj/shading) in get_step(loc, NORTHEAST)
			u3 = locate(/obj/shading) in get_step(loc, NORTH)

			// some of these vars will be null around the edge of the
			// map, so in that case we set them to the global null_shading
			// instance so we don't constantly have to check if these
			// vars are null before referencing them.

			if(!c1) c1 = null_shading
			if(!c2) c2 = null_shading
			if(!c3) c3 = null_shading

			if(!u1) u1 = null_shading
			if(!u2) u2 = null_shading
			if(!u3) u3 = null_shading

		lum(l)
			__lum += l


			// __lum can be a decimal, but lum is used to set the
			// icon_state, so we want it to be rounded off
			var/new_lum = __lum * lighting.posColors

			// we also have to keep lum within certain bounds
			if(new_lum < 0)
				new_lum = 0
			else if(new_lum > lighting.posColors)
				new_lum = lighting.posColors - 1

			if(round(new_lum) == round(lum)) return

			lum = new_lum

			// update this shading object and its dependent neighbors
			if(src && loc && !changed)
				changed = 1
				lighting.changed += src

			if(u1 && u1.loc && !u1.changed)
				u1.changed = 1
				lighting.changed += u1

			if(u2 && u2.loc && !u2.changed)
				u2.changed = 1
				lighting.changed += u2

			if(u3 && u3.loc && !u3.changed)
				u3.changed = 1
				lighting.changed += u3

		changed()
			if(changed) return

			if(loc)
				changed = 1
				lighting.changed += src

				if(u1 && u1.loc && !u1.changed)
					u1.changed = 1
					lighting.changed += u1

				if(u2 && u2.loc && !u2.changed)
					u2.changed = 1
					lighting.changed += u2

				if(u3 && u3.loc && !u3.changed)
					u3.changed = 1
					lighting.changed += u3

obj/light

	ex_act()
		return 0

	anchored = 1
	mouse_opacity = 0
	Move()
		//Do Nothing
	var
		// the atom the light source is attached to
		atom/owner

		// the radius, intensity, and ambient value control how large of
		// an area the light illuminates and how brightly it's illuminated.
		radius = 2
		intensity = 1

		radius_squared = 4

		// the coordinates of the light source - these can be decimal values
		__x = 0
		__y = 0

		// whether the light is turned on or off.
		on = 1

		// this flag is set when a property of the light source (ex: radius)
		// has changed, this will trigger an update of its effect.
		changed = 1

		// this is used to determine if the light is attached to a mobile
		// atom or a stationary one.
		mobile = 0

		// This is the illumination effect of this light source. Storing this
		// makes it very easy to undo the light's exact effect.
		list/effect

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
		src.radius_squared = radius * radius
		src.intensity = intensity

		__x = a.x
		__y = a.y

		// the lighting object maintains a list of all light sources
		lighting.lights += src

	proc
		// this used to be called be an infinite loop that was local to
		// the light object, but now there is a single infinite loop in
		// the global lighting object that calls this proc.
		loop()
			anchored = 1

			// if the light is mobile (if it was attached to an atom of
			// type /atom/movable), check to see if the owner has moved
			if(mobile)

				// compute the owner's coordinates
				var/opx = owner.x
				var/opy = owner.y

				// if pixel movement is enabled we need to take step_x
				// and step_y into account


				// see if the owner's coordinates match
				if(opx != __x || opy != __y)
					__x = opx
					__y = opy
					changed = 1

			if(changed)
				apply()

		apply()
			//world << "Applying Light Change"
			changed = 0

			// before we apply the effect we remove the light's current effect.
			if(effect)

				// negate the effect of this light source
				for(var/obj/shading/s in effect)
					s.lum(-effect[s])

				// clear the effect list
				effect.Cut()

			// only do this if the light is turned on and is on the map
			if(on && loc)

				// identify the effects of this light source
				effect = effect()

				// apply the effect
				for(var/obj/shading/s in effect)
					s.lum(effect[s])

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
			radius_squared = r * r
			changed = 1

		intensity(i)
			if(intensity == i) return

			intensity = i
			changed = 1

		// compute the center of the light source, this is used
		// for light sources attached to mobs when you're using
		// pixel movement.
		center()
			if(istype(owner, /atom/movable))

				var/atom/movable/m = owner

				. = m.loc
				var/d = bounds_dist(m, .)

				for(var/turf/t in m.locs)
					var/dt = bounds_dist(m, t)
					if(dt < d)
						d = dt
						. = t
			else
				var/turf/t = owner
				while(!istype(t))
					t = t.loc

				return t

		// compute the total effect of this light source
		effect()

			var/list/L = list()

			for(var/obj/shading/s in range(radius, owner))

				// we call this object's lum() proc to compute the illumination
				// value we contribute to each shading object, this way you can
				// override the lum() proc to change how lighting works but leave
				// this proc alone.
				var/lum = lum(s)

				if(lum > 0)
					L[s] = lum

			return L

		// compute the amount of illumination this light source
		// contributes to a single atom
		lum(atom/a)

			if(!radius)
				return 0

			// compute the distance to the tile, we use the __x and __y vars
			// so the light source's pixel offset is taken into account (provided
			// that's enabled)
			var/d = (__x - a.x) * (__x - a.x) + (__y - a.y) * (__y - a.y)

			// if the turf is outside the radius the light doesn't illuminate it
			if(d > radius_squared) return 0

			d = sqrt(d)

			// this creates a circle of light that non-linearly transitions between
			// the value of the intensity var and zero.
			return cos(90 * d / radius) * intensity