var/nuke_enabled = 0
var/nuke_timer = 10
var/sinewave = 1
var/sinemult = 0.5
/*
for it not to shake, requirements must be met

Y < 100
X < 97
*/
/datum/controller/gameticker/proc/process_timer()

	if(nuke_enabled == 1)
		nuke_timer = nuke_timer - (1/world.fps) //Decrement!
		if(nuke_timer < 41 && nuke_timer > 40)
			world << sound('chaos dunk.ogg',channel=SOUND_CHANNEL_2)
		if(nuke_timer < 3.8 && nuke_timer > 3.7)
			world << sound('oh no.ogg',channel=SOUND_CHANNEL_4)
		if(nuke_timer < 3.8)
			sinemult = sinemult * 1.01
		if(nuke_timer < 3.5 && nuke_timer > 2.5)
			world << sound('ass.ogg',channel=SOUND_CHANNEL_3)
		//world << "<font color='red'>[nuke_timer]"
		if(nuke_timer < 0)
			nuke_enabled = 2
			world << sound('nice.ogg',channel=SOUND_CHANNEL_2)
		if(nuke_timer < 41)
			sinemult = sinemult * -1
			sinewave = 2+sin(nuke_timer*2) //dang
			for(var/client/i in clients)
				if(i.mob.x < 194 && i.mob.y < 200)
					i.pixel_w = sinewave*sinemult
					if(i.color != "#FFDFDF")
						i.color = "#FFDFDF"
				else
					i.pixel_w = 0
					//i << sound(null,channel=768)
					if(i.color != "#FFFFFF")
						i.color = "#FFFFFF"
	if(nuke_enabled == 2)
		for(var/client/i in clients)
			i.pixel_w = 0
			if(i:mob.x < 194 && i:mob.y < 200)
				i:mob:gib()
		nuke_enabled = 3
		for(var/obj/machinery/nuclearbomb/Bomb in world)
			explosion(Bomb.loc, 30, 60, 120, 0, 0)


/datum/controller/gameticker/proc/nuke_enable()
	if(nuke_enabled == 0)
		world << sound("escape2.ogg",channel=MUSIC_CHANNEL,repeat=1)
		nuke_enabled = 1
		call_shuttle_proc(src)

proc/timer_enable()
	ticker.nuke_enable()

client/proc/Get_Number_Time()
	if(nuke_enabled == 1)
		var/secs = round(nuke_timer)
		var/mins = 0
		while(secs > 59)
			secs = secs - 60
			mins = mins + 1
		var/secs_in_text = "[secs]"
		if(secs < 10)
			secs_in_text = "0[secs]"
		var/nuke_timer_text = "[mins]:[secs_in_text]"
		var/obj/screen_number/numbG2 = new()
		numbG2.screen_loc = "CENTER-1:-8,NORTH"
		numbG2.icon_state = "timer"
		screen += numbG2
		for(var/i in 1 to length(nuke_timer_text))
			var/obj/screen_number/numbG = new()
			numbG.icon_state = copytext(nuke_timer_text,i,i+1) //Get every digit
			numbG.screen_loc = "CENTER:[round(((-length(nuke_timer_text)*16)/2)+(i*16))],NORTH"
			screen += numbG

/obj/screen_number
	icon = 'number_font.dmi'
	appearance_flags = PIXEL_SCALE | NO_CLIENT_COLOR
	plane = 10