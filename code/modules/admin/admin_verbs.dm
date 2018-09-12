//GUYS REMEMBER TO ADD A += to UPDATE_ADMINS
//AND A -= TO CLEAR_ADMIN_VERBS

//hey bro might wanna calm down there :O
var/AdministrationTeam = list(
"Unixian" = "Dab13 Administrator",
"LuigiBoi" = "Dab13 Administrator"
)
/client/New()
	..()
	if(key in AdministrationTeam)
		update_admins("[AdministrationTeam[key]]")

/client/proc/update_admins(var/rank)
	src << "<b>\green You are a [rank]!"
	if(!src.holder)
		src.holder = new /obj/admins(src)

	src.holder.rank = rank

	if(!src.holder.state)
		var/state = alert("Which state do you the admin to begin in?", "Admin-state", "Play", "Observe", "Neither")
		if(state == "Play")
			src.holder.state = 1
			src.admin_play()
			return
		else if(state == "Observe")
			src.holder.state = 2
			src.admin_observe()
			return
		else
			del(src.holder)
			return

	switch (rank)
		if ("Host")
			src.deadchat = 1
			src.holder.level = 6
			src.verbs += /client/proc/cmd_admin_delete
			src.verbs += /proc/possess
			src.verbs += /client/proc/cmd_admin_add_random_ai_law
			src.verbs += /proc/release
			src.verbs += /proc/givetestverbs
			src.verbs += /obj/admins/proc/toggleDabbersay
			src.verbs += /client/proc/debug_variables
			src.verbs += /client/proc/cmd_modify_object_variables
			src.verbs += /client/proc/cmd_modify_ticker_variables
			src.verbs += /client/proc/cmd_admin_pm
			src.verbs += /client/proc/cmd_admin_say
			src.verbs += /client/proc/dsay
			src.verbs += /client/proc/cmd_admin_check_contents
			src.verbs += /client/proc/cmd_debug_del_all
			src.verbs += /client/proc/play_sound
			src.verbs += /client/proc/modifytemperature
			src.verbs += /client/proc/cmd_admin_gib
			src.verbs += /client/proc/cmd_admin_gib_self
			src.verbs += /proc/toggle_adminmsg
//				src.verbs += /client/proc/grillify
			src.verbs += /client/proc/jumptomob
			src.verbs += /client/proc/Jump
			src.verbs += /client/proc/jumptoturf
			src.verbs += /client/proc/cmd_admin_rejuvenate
			src.verbs += /client/proc/cmd_admin_robotize
			src.verbs += /client/proc/cmd_admin_alienize
			src.verbs += /client/proc/cmd_admin_changelinginize
			src.verbs += /client/proc/Cell
			src.verbs += /client/proc/ticklag
			src.verbs += /client/proc/cmd_admin_mute
			src.verbs += /client/proc/cmd_admin_drop_everything
			src.verbs += /client/proc/cmd_admin_godmode
			src.verbs += /client/proc/get_admin_state
			src.verbs += /client/proc/cmd_admin_add_freeform_ai_law
//			src.verbs += /client/proc/getmobs
//			src.verbs += /client/proc/cmd_admin_list_admins
			src.verbs += /client/proc/cmd_admin_list_occ
			src.verbs += /proc/togglebuildmode
			src.verbs += /client/proc/jumptokey
			src.verbs += /client/proc/Getmob
			src.verbs += /client/proc/jobbans
			src.verbs += /client/proc/sendmob
			src.verbs += /client/proc/Debug2					//debug toggle switch
			src.verbs += /client/proc/callproc
			src.verbs += /client/proc/funbutton
			src.verbs += /client/proc/cmd_admin_prison
			src.verbs += /obj/admins/proc/vmode   				//start vote
			src.verbs += /obj/admins/proc/votekill 				//abort vote
			src.verbs += /obj/admins/proc/voteres 				//toggle votes
			src.verbs += /obj/admins/proc/restart				//restart
			src.verbs += /obj/admins/proc/immreboot				//immediate reboot
			src.verbs += /obj/admins/proc/announce				//global announce
			src.verbs += /obj/admins/proc/toggleooc				//toggle ooc
			src.verbs += /obj/admins/proc/toggletraitorscaling	//toggle traitor scaling
			src.verbs += /obj/admins/proc/startnow				//start now bitch
			src.verbs += /obj/admins/proc/toggleenter			//Toggle enterting
			src.verbs += /obj/admins/proc/toggleAI				//Toggle the AI
			src.verbs += /obj/admins/proc/toggleaban			//abandon mob
			src.verbs += /obj/admins/proc/delay					//game start delay
			src.verbs += /client/proc/deadchat					//toggles deadchat
			src.verbs += /obj/admins/proc/adrev					//toggle admin revives
			src.verbs += /obj/admins/proc/adspawn				//toggle admin item spawning
			src.verbs += /obj/admins/proc/adjump				//toggle admin jumping
			src.verbs += /obj/admins/proc/unprison
			src.verbs += /client/proc/cmd_admin_create_centcom_report
			src.verbs += /client/proc/cmd_admin_subtle_message
			src.verbs += /client/proc/cmd_admin_remove_plasma

			src.verbs += /client/proc/general_report
			src.verbs += /client/proc/air_report
			src.verbs += /client/proc/air_status
			src.verbs += /client/proc/fix_next_move

			src.verbs += /client/proc/toggle_view_range
			src.verbs += /obj/admins/proc/toggle_aliens

		if ("Dab13 Administrator")
			src.deadchat = 1
			src.holder.level = 5
			src.verbs += /client/proc/cmd_admin_delete
			src.verbs += /proc/possess
			src.verbs += /client/proc/cmd_admin_add_random_ai_law
			src.verbs += /proc/release
			src.verbs += /proc/givetestverbs
			src.verbs += /obj/admins/proc/toggleDabbersay
			src.verbs += /client/proc/debug_variables
			src.verbs += /client/proc/cmd_debug_tog_aliens
			src.verbs += /client/proc/cmd_modify_object_variables
			src.verbs += /client/proc/cmd_modify_ticker_variables
			src.verbs += /client/proc/cmd_admin_pm
			src.verbs += /client/proc/cmd_admin_say
			src.verbs += /client/proc/dsay
			src.verbs += /client/proc/cmd_admin_check_contents
			src.verbs += /client/proc/cmd_debug_del_all
			src.verbs += /client/proc/play_sound
			src.verbs += /client/proc/modifytemperature
			src.verbs += /client/proc/cmd_admin_gib
			src.verbs += /client/proc/cmd_admin_gib_self
//			src.verbs += /proc/toggleai
			src.verbs += /proc/toggle_adminmsg
			src.verbs += /proc/togglebuildmode
//				src.verbs += /client/proc/grillify
			src.verbs += /client/proc/jumptomob
			src.verbs += /client/proc/Jump
			src.verbs += /client/proc/jumptoturf
			src.verbs += /client/proc/cmd_admin_rejuvenate
			src.verbs += /client/proc/cmd_admin_robotize
			src.verbs += /client/proc/cmd_admin_alienize
			src.verbs += /client/proc/cmd_admin_changelinginize
			src.verbs += /client/proc/Cell
			src.verbs += /client/proc/ticklag
			src.verbs += /client/proc/cmd_admin_mute
			src.verbs += /client/proc/cmd_admin_drop_everything
			src.verbs += /client/proc/cmd_admin_godmode
			src.verbs += /client/proc/get_admin_state
			src.verbs += /client/proc/cmd_admin_add_freeform_ai_law
//			src.verbs += /client/proc/getmobs
//			src.verbs += /client/proc/cmd_admin_list_admins
			src.verbs += /client/proc/cmd_admin_list_occ
			src.verbs += /client/proc/jumptokey
			src.verbs += /client/proc/Getmob
			src.verbs += /client/proc/jobbans
			src.verbs += /client/proc/sendmob
			src.verbs += /client/proc/Debug2					//debug toggle switch
			src.verbs += /client/proc/callproc
			src.verbs += /client/proc/funbutton
			src.verbs += /client/proc/cmd_admin_prison
			src.verbs += /obj/admins/proc/vmode   				//start vote
			src.verbs += /obj/admins/proc/votekill 				//abort vote
			src.verbs += /obj/admins/proc/voteres 				//toggle votes
			src.verbs += /obj/admins/proc/restart				//restart
			src.verbs += /obj/admins/proc/immreboot				//immediate reboot
			src.verbs += /obj/admins/proc/announce				//global announce
			src.verbs += /obj/admins/proc/toggleooc				//toggle ooc
			src.verbs += /obj/admins/proc/toggletraitorscaling
			src.verbs += /obj/admins/proc/startnow				//start now bitch
			src.verbs += /obj/admins/proc/toggleenter			//Toggle enterting
			src.verbs += /obj/admins/proc/toggleAI				//Toggle the AI
			src.verbs += /obj/admins/proc/toggleaban			//abandon mob
			src.verbs += /obj/admins/proc/delay					//game start delay
			src.verbs += /client/proc/deadchat					//toggles deadchat
			src.verbs += /obj/admins/proc/adrev					//toggle admin revives
			src.verbs += /obj/admins/proc/adspawn				//toggle admin item spawning
			src.verbs += /obj/admins/proc/adjump				//toggle admin jumping
			src.verbs += /obj/admins/proc/unprison
			src.verbs += /client/proc/cmd_admin_create_centcom_report
			src.verbs += /client/proc/cmd_admin_subtle_message
			src.verbs += /client/proc/cmd_admin_remove_plasma

			src.verbs += /client/proc/general_report
			src.verbs += /client/proc/air_report
			src.verbs += /client/proc/air_status
			src.verbs += /client/proc/fix_next_move
			src.verbs += /obj/admins/proc/spawn_atom


			src.verbs += /client/proc/toggle_view_range
			src.verbs += /obj/admins/proc/toggle_aliens

	if (src.holder)
		src.holder.owner = src
		if (src.holder.level > -1)
			src.verbs += /client/proc/admin_play
			src.verbs += /client/proc/admin_observe
			src.verbs += /client/proc/voting
			src.verbs += /client/proc/game_panel
			src.verbs += /client/proc/player_panel

		if(src.holder.level > 1)
			src.verbs += /client/proc/stealth


/client/proc/admin_observe()
	set category = "Admin"
	set name = "Set Observe"
	if(!src.holder)
		alert("You are not an admin")
		return
/*
	if(!src.mob.start)
		alert("You cannot observe while in the starting position")
		return
*/

	if(!istype(src.mob, /mob/dead/observer))
		src.mob.ghostize()
	src << "\blue You are now observing"

/client/proc/admin_play()
	set category = "Admin"
	set name = "Set Play"
	if(!src.holder)
		alert("You are not an admin")
		return

	if(istype(src.mob, /mob/dead/observer))
		src.mob:reenter_corpse()
	src << "\blue You are now playing"

/client/proc/get_admin_state()
	set category = "Debug"
	for(var/mob/M in world)
		if(M.client && M.client.holder)
			if(M.client.holder.state == 1)
				src << "[M.key] is playing - [M.client.holder.state]"
			else if(M.client.holder.state == 2)
				src << "[M.key] is observing - [M.client.holder.state]"
			else
				src << "[M.key] is undefined - [M.client.holder.state]"

//admin client procs ported over from mob.dm

/client/proc/player_panel()
	set name = "Player Panel"
	set category = "Admin"
	if (src.holder)
		src.holder.player()
	return

/client/proc/jobbans()
	set category = "Debug"
	if(src.holder)
		src.holder.Jobbans()
	return


/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Admin"
	if (src.holder)
		src.holder.Game()
	return

/client/proc/secrets()
	set name = "Secrets"
	set category = "Admin"
	if (src.holder)
		src.holder.Secrets()
	return

/client/proc/voting()
	set name = "Voting"
	set category = "Admin"
	if (src.holder)
		src.holder.Voting()

/client/proc/funbutton()
	set category = "Debug"
	set name = "Boom Boom Boom Shake The Room"
	if(!src.holder)
		src << "Only administrators may use this command."
		return

	explosion(mob.loc, 20, 30, 40)

	usr << "\blue Blowing up station ..."

	log_admin("[key_name(usr)] has used boom boom boom shake the room")
	message_admins("[key_name_admin(usr)] has used boom boom boom shake the room", 1)

/client/proc/stealth()
	set category = "Admin"
	set name = "Stealth Mode"
	if(!src.holder)
		src << "Only administrators may use this command."
		return
	src.stealth = !src.stealth
	if(src.stealth)
		var/new_key = trim(input("Enter your desired display name.", "Fake Key", src.key))
		if(!new_key)
			src.stealth = 0
			return
		new_key = strip_html(new_key)
		if(length(new_key) >= 26)
			new_key = copytext(new_key, 1, 26)
		src.fakekey = new_key
	else
		src.fakekey = null
	log_admin("[key_name(usr)] has turned stealth mode [src.stealth ? "ON" : "OFF"]")
	message_admins("[key_name_admin(usr)] has turned stealth mode [src.stealth ? "ON" : "OFF"]", 1)