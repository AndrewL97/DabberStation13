 #define WALL_PLANE 1
#define LIGHT_PLANE 3
#define ALARM_PLANE 2
#define CABLE_PLANE 1
#define TOP_PLANE 7
#define SHADING_PLANE 8
#define SPECIAL_PLANE 9
#define AIRLOCK_PLANE 5
#define MOB_PLANE 4 //ive never used these so its time to put a use to them?
#define MOB_PLANE_ALT 6
#define AREA_PLANE 10
#define WINDOW_PLANE 3
#define MACHINERY_PLANE 2
#define PARTICLE_PLANE 5
#define ITEM_PLANE 2

#define SOUND_CHANNEL_1 1120
#define SOUND_CHANNEL_AMBI 1
#define SOUND_CHANNEL_2 1000
#define SOUND_CHANNEL_3 1001
#define SOUND_CHANNEL_4 1002
#define MUSIC_CHANNEL 768
#define LOBBY_CHANNEL 767
#define MUSIC_CHANNEL_ALT 769
#define MOTOR_CHANNEL 900
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

/*

hi welcome to the main shit file, i wouldn't touch the shit on here if i were you (unless your a tgcoder and you know how to make your CPU spike to %75 with atmospherics), thank you.

-alcaro the frick

*/

obj
	item
		plane = ITEM_PLANE
	machinery
		plane = MACHINERY_PLANE

mob
	plane = MOB_PLANE
	appearance_flags = PIXEL_SCALE | LONG_GLIDE

var/titlemusic = 'title1.ogg'

var
	const
		LIGHT_LAYER = 100
	Lighting/lighting = new()

world
	fps = 100
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


/mob/living/carbon/human/kryfrac //forever known as the nigger
	species = "shark"
	species_icon = 'shark.dmi'
	species_color = rgb(10,10,10)
	tail = "shark"
	hair_icon_state = "hair_kleeia"
	h_style = "Kleeia"
	tail_color = rgb(10,10,10)
	r_hair = 255
	g_hair = 20
	b_hair = 147

client
	New()
		..()
		if(byond_version < 512)
			spawn(20)
				src << "<font size=6><font color='red'><b>Your byond is too outdated. Please update to BYOND [world.byond_version] or higher if you want to see the game properly, you won't see effects."
		src << browse_rsc('html_assets/back.png',"back.png")
		if(world.port != 9999)
			call("ByondPOST.dll", "send_post_request")("[WebhookURL]", " { \"content\" : \"**[key]** joined (BYOND Version [byond_version].[byond_build]).\" } ", "Content-Type: application/json")
			world << "<font color='yellow'>[key] joined."
	Del()
		if(world.port != 9999)
			call("ByondPOST.dll", "send_post_request")("[WebhookURL]", " { \"content\" : \"**[key]** left.\" } ", "Content-Type: application/json")
			world << "<font color='yellow'>[key] left."
		..()
