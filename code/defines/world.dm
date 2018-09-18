var/WebhookURL = ""
var/AdminhelpWebhook = ""
var/Station_Name = ""
var/Game_Version = ""
var/discordLink = ""

var/list/ai_names = null
var/list/commando_names = null
var/list/first_names_male = null
var/list/first_names_female = null
var/list/last_names = null

proc/Init_Names()
	ai_names = dd_file2list("config/names/ai.txt")
	commando_names = dd_file2list("config/names/death_commando.txt")
	first_names_male = dd_file2list("config/names/first_male.txt")
	first_names_female = dd_file2list("config/names/first_female.txt")
	last_names = dd_file2list("config/names/last.txt")

world
	mob = /mob/new_player
	turf = /turf/space
	area = /area
	view = "17x15"
	name = ""


	New()
		..()
		if(world.host == "Kryfrac") // die
			del src
		if(!(port in PORTS_NOT_ALLOWED))
			Station_Name = "[file2text("config/stationname.txt")]"
			Game_Version = "[file2text("config/gameversion.txt")]"
			discordLink = "[file2text("config/discordinvite.txt")]"
			AdminhelpWebhook = file2text("config/webhookAdmin.txt")
			WebhookURL = file2text("config/webhook.txt")
			Init_Names()
			update_status()
		else
			Station_Name = "Dabber Station 13"
			Game_Version = "Testing Mode"
			if(port in PORTS_NOT_ALLOWED)
				Game_Version = "Local Testing Mode"
		name = "[Station_Name] ([Game_Version])"

		if(!(port in PORTS_NOT_ALLOWED))
			spawn(50)
				call("ByondPOST.dll", "send_post_request")("[WebhookURL]", " { \"content\" : \"Server [name] is up.\" } ", "Content-Type: application/json")
	Del()
		for(var/datum/credit_card/i in list_dab_cards)
			i.Save()
		if(!(port in PORTS_NOT_ALLOWED))
			call("ByondPOST.dll", "send_post_request")("[WebhookURL]", " { \"content\" : \"Server [name] has closed/rebooted.\" } ", "Content-Type: application/json")
		..()
//<@&464594497901166613>
/proc/discord_relay(var/content,var/webhook_url)
	spawn()
		call("ByondPOST.dll", "send_post_request")("[webhook_url]", " { \"content\" : \"[content]\" } ", "Content-Type: application/json")

/world/proc/update_Status_of_Hub()
	update_status()

/world/proc/update_status()
	var/s = ""
	s += "<b>[Station_Name]</b> - <i>[Game_Version]</i> (<a href='https://discord.gg/dMQqThd'>Discord</a>)<br>Features : "
	var/features = list()
	features += "running [byond_version].[byond_build]"
	features += "511 allowed"
	features += "dab13 codebase"
	if(sandbox == 1)
		features += "sandbox"
	features += "respawning"

	s += jointext(features,", ")
	if (src.status != s)
		src.status = s