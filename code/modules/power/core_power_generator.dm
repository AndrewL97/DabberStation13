/obj/machinery/power/core
	name = "Core power generator."
	desc = "A core-powered generator. It could overheat. Thus blowing up."
	icon = 'power.dmi'
	icon_state = "core"
	anchored = 1
	density = 1
	directwired = 1
	var/temp = 0
	var/procc = 1
	var/melt_down_alert = 0
	layer = 3
	var/list/particles = list()

	New()
		..()
		if(procc)
			var/rnd = rand(0,90)
			for(var/i in 1 to 4)
				var/obj/Particle/Core_Particle/P = new()
				P.loc = locate(x,y,z)
				P.owner = src
				P.timer = rnd+i*45
				particles += P
	Del()
		for(var/obj/Particle/G in particles)
			del G
		..()

/obj/machinery/power/core/process()
	temp = temp + 0.5
	if(temp < 0)
		temp = 0
	if(temp > 3500 && melt_down_alert == 0)
		for(var/mob/living/carbon/human/M in Mobs)
			if(istype(M.ears,/obj/item/device/radio/headset))
				M << "<font color='red'><b>Alert! Core temperature is higher than 3500 C*, meltdown possible."
		melt_down_alert = 1
	if(temp < 3500 && melt_down_alert == 1)
		melt_down_alert = 0
	if(temp > 5000)
		explosion(locate(x,y,z), 11, 15, 20, 30,1) //deadly ass explosion, it's your fault it blew up
		del(src)
		return

	if(stat & BROKEN)
		return

	var/sgen = 8000
	add_avail(sgen)

/obj/machinery/power/core/examine()
	set src in view()
	if(temp < 0)
		temp = 0
	usr << "This is a core power generator, it's temperature seems to display : [temp] C*"

/obj/machinery/power/core/coolant
	name = "Coolant tank"
	desc = "Looks like it's used to cool the core."
	icon = 'power.dmi'
	icon_state = "core_cooler9"
	procc = 0
	var/coolant_left = 999999
	var/max_coolant = 8000


/obj/machinery/power/core/coolant/process()
	if(!(stat & (NOPOWER|BROKEN)) )
		use_power(250)
	if(coolant_left > max_coolant)
		coolant_left = max_coolant //cap
	icon_state = "core_cooler[round((coolant_left/max_coolant)*9)]"
	if(coolant_left > 0)
		for(var/obj/machinery/power/core/e in orange(1,src))
			e.temp = e.temp - 2
			coolant_left = coolant_left - 2
	if(coolant_left < 0)
		coolant_left = 0

/obj/machinery/power/core/coolant/examine()
	set src in view()
	usr << "This is a coolant tank, the amount left is : [coolant_left]/[max_coolant]"
