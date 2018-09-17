/mob/verb/listen_ooc()
	set name = "(Un)Mute OOC"

	if (src.client)
		src.client.listen_ooc = !src.client.listen_ooc
		if (src.client.listen_ooc)
			src << "\blue You are now listening to messages on the OOC channel."
		else
			src << "\blue You are no longer listening to messages on the OOC channel."

/mob/verb/ooc(msg as text)
	log_ooc("[src.name]/[src.key] : [msg]")

	for (var/client/C)
		if (C.listen_ooc)
			C << "<font color='#D9FFE3'>OOC: <b>[src.key]</b>: [msg]"
	call("ByondPOST.dll", "send_post_request")("[WebhookURL]", " { \"content\" : \"OOC: **[src.key]**: [msg]\" } ", "Content-Type: application/json")