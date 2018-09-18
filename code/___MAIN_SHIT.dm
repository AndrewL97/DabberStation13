//THese are special variables used for The Game.

#define WALL_PLANE 1
#define LIGHT_PLANE 3
#define ALARM_PLANE 2
#define CABLE_PLANE 1
#define TOP_PLANE 7
#define BELOW_SHADING 8
#define SHADING_PLANE 9
#define SPECIAL_PLANE 10
#define AIRLOCK_PLANE 5
#define MOB_PLANE 4 //ive never used these so its time to put a use to them?
#define MOB_PLANE_ALT 6
#define AREA_PLANE 10
#define WINDOW_PLANE 3
#define MACHINERY_PLANE 2
#define PARTICLE_PLANE 5
#define ITEM_PLANE 2
#define HUD_PLANE 99
#define HUD_PLANE_2 100
#define SPACE_PLANE -98

#define SOUND_CHANNEL_1 1120
#define SOUND_CHANNEL_AMBI 1
#define SOUND_CHANNEL_2 1000
#define SOUND_CHANNEL_3 1001
#define SOUND_CHANNEL_4 1002
#define MUSIC_CHANNEL 768
#define LOBBY_CHANNEL 767
#define MUSIC_CHANNEL_ALT 769
#define MOTOR_CHANNEL 900
#define PORTS_NOT_ALLOWED list(0,9999)
#define ALT_SERVERS list(25500,25501,25502)

#define admin_ranks list("Dab13 Administrator", "Host")
#if DM_VERSION < 512
#error Your BYOND is too outdated, please use 512 or higher. Dab13 is only supposed to compile on 512, because 511 doesn't support filters and stuff like that.
#endif

/*
THE JOBS CAN BE FOUND HERE!!!!!!!!! CHANGE MAX SLOTS AS REQUIRED
*/

var
	captainMax = 1
	hopMax = 1
	hosMax = 1
	chiefMax = 1
	engineerMax = 2
	scientistMax = 2
	chemistMax = 2
	geneticistMax = 2
	securityMax = 2
	doctorMax = 2
	atmosMax = 3

	barmanMax = 0
	directorMax = 0
	detectiveMax = 0
	chaplainMax = 0
	janitorMax = 0
	clownMax = 0
	chefMax = 0
	roboticsMax = 0
	cargoMax = 0
	hydroponicsMax = 0

obj
	item
		plane = ITEM_PLANE
	machinery
		plane = MACHINERY_PLANE

mob
	plane = MOB_PLANE
	appearance_flags = PIXEL_SCALE | LONG_GLIDE


var
	const
		LIGHT_LAYER = 100
	Lighting/lighting = new()

world
	fps = 60
	hub = "Exadv1.spacestation13"
	hub_password = "kMZy3U5jJHSiBQjr"

proc
	animate_flash(var/type,var/atom/se)
		se.icon_state = type
		switch(type)
			if("flash")
				se.alpha = 255
				animate(se,alpha=0,time=20)
			if("e_flash")
				se.alpha = 255
				animate(se,alpha=0,time=40)

obj
	disco_ball
		icon = 'boring shit.dmi'
		icon_state = "discoball"
		anchored = 1
		var/cycle = 0
		New()
			..()
			special_processing += src
		Del()
			special_processing -= src
			..()
		special_process()
			spawn()
				cycle += 1
				if(light && cycle > 25) // A full sec
					light.color = rgb(rand(180,255),rand(180,255),rand(180,255))
					cycle = 0
				else
					sd_SetLuminosity(10)
					light.intensity = 1
	spotlight
		icon = 'speciallighting.dmi'
		icon_state = "stand"
		plane = SPECIAL_PLANE
		anchored = 1
		var/obj/spotlight/the_light/l = null
		var/can_light = 1
		New()
			..()
			if(can_light)
				l = new(locate(x,y,z))
		Del()
			if(l)
				del l
			..()
		ex_act()
			return
		the_light
			mouse_opacity = 0
			var/sine = 0
			var/obj/spotlight/effect/A1
			icon = 'speciallighting3.dmi'
			icon_state = "light"
			can_light = 0
			pixel_y = -1016
			New()
				..()
				sine = sine + rand(0,360)
				special_processing += src
			Del()
				special_processing -= src
				..()
			special_process()
				sine = sine + 0.75
				var/matrix/M = matrix()
				M.Turn(sin(sine)*75)
				pixel_x = sin(sine)*-16
				pixel_y = -1028+abs(sin(sine)*16)
				transform = M
	title_screen
		icon = 'dab13.dmi'
		var/sine = 0
		pixel_w = 16
		layer = 5
		mouse_opacity = 0
		ex_act()
			return
		New()
			..()
			special_processing += src
		Del()
			special_processing -= src
			..()
		special_process()
			sine = sine + 1
			pixel_z = 10+(sin(sine)*10)
	title_screen_shadow
		pixel_w = 16
		mouse_opacity = 0
		icon = 'dab13.dmi'
		icon_state = "shadow"
		ex_act()
			return


/mob/living/carbon/human/kryfrac //RIS
	species = "shark"
	species_icon = 'shark.dmi'
	species_color = rgb(40,40,40)
	gender = FEMALE
	tail = "shark"
	desc = "Dances to get rid of her PTSD."
	name = "Kryfrac"
	real_name = "Kryfrac"
	hair_icon_state = "hair_kleeia"
	h_style = "Kleeia"
	tail_color = rgb(40,40,40)
	r_hair = 255
	g_hair = 20
	b_hair = 147
	Life()
		..()
		if(src.stat != 2)
			Disco_Fever() //hey guys remember when this was actually funny LOL

/mob/living/carbon/human/alcaro //RS4
	species = "vulpine"
	species_icon = 'vulpine.dmi'
	name = "Alcaro"
	real_name = "Alcaro"
	desc = "Looks like it hates it's life."
	gender = FEMALE
	species_color = rgb(0,206,209)
	tail = "vulptail1"
	hair_icon_state = "hair_kleeia"
	h_style = "Kleeia"
	tail_color = rgb(60,179,113)
	zangoose = "Yes"
	r_hair = 255
	g_hair = 20
	b_hair = 147
	dir = NORTH