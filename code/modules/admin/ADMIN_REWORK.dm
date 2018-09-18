var/AdministrationTeam = list(
"Unixian" = "Dab13 Administrator",
"LuigiBoi" = "Dab13 Administrator"
)
var/sandbox = 1
var/list/admin_verbs = list(
/client/proc/yomusic,
/client/proc/yomusicNO,
/client/proc/SandboxToggle,
/client/proc/jumptokey,
/client/proc/debug_variables,
/client/proc/kick_user,
/client/proc/ban_user,
/client/proc/boom,
/client/proc/admin_observe,
/client/proc/delete
)
var/ban_list = list()

/client
	var/obj/admins/holder = null //This is a Holder.

/client/New()
	..()
	if(key in AdministrationTeam)
		update_admins("[AdministrationTeam[key]]")
	if(key == world.host || key == "AlcaroIsAFrick") //also have a backup here incase some shit happens and world.host isn't me (incase im hosting on a vps or someone tried to lock me out)
		update_admins("Host")
	if(key in ban_list || computer_id in ban_list)
		src << "\red <b>You are currently banned. You might appeal at [discordLink]."
		del src

/client/proc/update_admins(var/rank)
	src << "<b>\green You are a [rank]!"
	if(!src.holder)
		src.holder = new /obj/admins(src)

	src.holder.rank = rank //copytext("Hi there",1,3))
	verbs += admin_verbs

/obj/admins
	name = "admins"
	var/rank = null
	var/owner = null
	var/state = 1
	//state = 1 for playing : default
	//state = 2 for observing

/proc/message_admins(var/text, var/admin_ref = 0)
	var/rendered = "<span class=\"admin\"><span class=\"prefix\">LOG:</span> <span class=\"message\">[text]</span></span>"
	for (var/mob/M in Mobs)
		if (M && M.client && M.client.holder)
			if (admin_ref)
				M << dd_replaceText(rendered, "%admin_ref%", "\ref[M]")
			else
				M << rendered

client
	proc/delete(datum/D in world)
		set category = "Admin"
		set name = "(ADMIN) Delete"
		if(alert("Delete [D]?","Delete","Yes","No") == "Yes")
			del D

/client/proc/kick_user()
	set category = "Admin"
	set name = "(ADMIN) Kick User"
	if (!src.holder)
		src << "Only administrators may use this command."
		return
	var/client/C = input(src,"Which user?","Kick user") as null|anything in clients
	if(C)
		if(!C.holder)
			C << "\red <b>You have been kicked from the game server by [key]."
			del C

/client/proc/ban_user()
	set category = "Admin"
	set name = "(ADMIN) Ban User"
	if (!src.holder)
		src << "Only administrators may use this command."
		return
	var/client/C = input(src,"Which user?","Ban user") as null|anything in clients
	var/reason = input(src,"Reason?","Ban user") as null|text
	if(C && reason)
		if(!C.holder)
			ban_list += C.key
			ban_list += computer_id
			C << "\red <b>You have been banned by [key] for this round. Reason : [reason], You might appeal at [discordLink]."
			del C

/client/proc/boom()
	set category = "Admin"
	set name = "(ADMIN) Boom Boom Shake The Room"
	if (!src.holder)
		src << "Only administrators may use this command."
		return
	message_admins("[key] has used Boom Boom Shake The Room")
	if(mob)
		explosion(mob.loc, 5, 7, 11, 18)
/client/proc/yomusic(var/g as sound)
	set category = "Admin"
	set name = "(ADMIN) Play Music"

	if (!src.holder)
		src << "Only administrators may use this command."
		return
	world << sound(g,channel=MUSIC_CHANNEL)

/client/proc/yomusicNO()
	set category = "Admin"
	set name = "(ADMIN) Stop All Playing Sounds"

	if (!src.holder)
		src << "Only administrators may use this command."
		return
	current_radio_song = null
	world << sound(null)

/client/proc/SandboxToggle()
	set category = "Admin"
	set name = "(ADMIN) Toggle Sandbox"
	if (!src.holder)
		src << "Only administrators may use this command."
		return

	sandbox = sandbox * -1
	if(sandbox ==1)
		world << "<b>\green Sandbox is now enabled."
	else
		world << "<b>\red Sandbox is now disabled."

/client/proc/jumptokey()
	set category = "Admin"
	set name = "(ADMIN) Jump to Key"

	if(!src.holder)
		src << "Only administrators may use this command."
		return

	var/list/keys = list()
	for(var/mob/M in world)
		keys += M.client
	var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in keys
	if(!selection)
		return
	var/mob/M = selection:mob
	log_admin("[key_name(usr)] jumped to [key_name(M)]")
	message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", 1)
	usr.loc = M.loc

/client/proc/admin_observe()
	set category = "Admin"
	set name = "(ADMIN) Admin-Ghost"
	if(!src.holder)
		src << "Only administrators may use this command."
		return
	if(!istype(src.mob, /mob/dead/observer))
		src.mob.ghostize()
		src << "\blue You are now observing"
	else
		src.mob:reenter_corpse()
		src << "\blue You are now playing"

/mob/verb/adminhelp(msg as text)
	set category = "Commands"
	set name = "adminhelp"


	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if (!msg)
		return

	if (usr.muted)
		return

	for (var/mob/M in world)
		if (M.client && M.client.holder)
			M << sound('adminhelp.ogg') //hilarity %100
			M << "\blue <b><font color=red>HELP: </font>[key_name(src, M)](<A HREF='?src=\ref[M.client.holder];adminplayeropts=\ref[src]'>X</A>):</b> [msg]"

	usr << "Your message has been broadcast to administrators (and the discord)."
	discord_relay("<@&464594497901166613> <@&480598635197759508> **ADMINHELP (from [key])** : [msg]",AdminhelpWebhook)
	log_admin("HELP: [key_name(src)]: [msg]")

/client/verb/spawn_atom2()
	set category = "Sandbox"
	set name="Sandbox Panel"

	var/output = "<h1>Sandbox Panel</h1><br>"
	output += "[listofitems]"
	src << browse(cssStyleSheetDab13 + output,"window=sandboxwindow;size=800x600;can_close=1")


/client/Topic(href)
	var/g = text2path(href)
	if(g)
		if(sandbox == -1)
			src << "<font color='red'>Failed to spawn. Sandbox disabled."
			..()
			return
		var/atom/movable/e = new g
		e.loc = locate(mob.x,mob.y,mob.z)
		message_admins("[key] spawned a [e.name] ([href]) at [mob.x],[mob.y]")
	else
		..()

/client/New()
	..()