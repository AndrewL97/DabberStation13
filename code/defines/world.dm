var/WebhookURL = ""
var/AdminhelpWebhook = ""
var/Station_Name = ""
var/Game_Version = ""
var/discordLink = ""
world
	mob = /mob/new_player
	turf = /turf/space
	area = /area
	view = "17x15"
	name = ""


	New()
		..()
		Station_Name = "[file2text("config/stationname.txt")]"
		Game_Version = "[file2text("config/gameversion.txt")]"
		name = "[Station_Name] ([Game_Version])"
		discordLink = "[file2text("config/discordinvite.txt")]"
		AdminhelpWebhook = file2text("config/webhookAdmin.txt")
		WebhookURL = file2text("config/webhook.txt")
		update_status()
		if(port != 9999)
			spawn(50)
				call("ByondPOST.dll", "send_post_request")("[WebhookURL]", " { \"content\" : \"Server [name] is up.\" } ", "Content-Type: application/json")
	Del()
		for(var/datum/credit_card/i in list_dab_cards)
			i.Save()
		if(port != 9999)
			call("ByondPOST.dll", "send_post_request")("[WebhookURL]", " { \"content\" : \"Server [name] has closed/rebooted.\" } ", "Content-Type: application/json")
		..()
//<@&464594497901166613>
/proc/discord_relay(var/content,var/webhook_url)
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