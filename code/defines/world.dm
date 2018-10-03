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

proc/Random_Station_Name()
	var/list/first = list("Blobby","Javier","Kryfrac","Ikea","Pezoa","Dabber","RETARDS IN SPACE","Noober","Alcaro","Free Fire")
	var/list/second = list("land","research establishment","station","gang") //retards in space fucking sucks btw
	Station_Name = "[pick(first)] [pick(second)] [rand(1,99)]"
	world.name = "Dabber Station 13 - [Station_Name] ([Game_Version])"
	world.update_status()
world
	mob = /mob/new_player
	turf = /turf/space
	area = /area
	view = "17x15"
	name = ""
	sleep_offline = 0
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
		else
			Game_Version = "Testrun"
		Random_Station_Name()

		if(!(port in PORTS_NOT_ALLOWED))
			spawn(2)
				call("ByondPOST.dll", "send_post_request")("[WebhookURL]", " { \"content\" : \"Server [name] is up. byond://[internet_address]:[port]\" } ", "Content-Type: application/json")
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

/world/proc/update_status()
	var/s = ""
	s += "<b>Dab13 : [Station_Name]</b> - <i>[Game_Version]</i> (<a href='https://discord.gg/dMQqThd'>Discord</a>)<br>Features : "
	var/features = list()
	features += "[clients.len]/[MAX_PLAYERS] players"
	features += "dab13 codebase"
	if(sandbox == 1)
		features += "sandbox"
	features += "respawning"

	s += jointext(features,", ")
	if (src.status != s)
		src.status = s