/client/proc/authorize()
	set name = "Authorize"

	if (src.authenticating)
		return

	if (!config.enable_authentication)
		src.authenticated = 1
		return

	src.authenticating = 1

	spawn (rand(4, 18))

		src.verbs -= /client/proc/authorize
		var/account = key
		src.authenticated = account
		src << "Key authorized: Hello [html_encode(account)]!"
		src << "\blue[auth_motd]"
		src.authenticating = 0

/client/proc/beta_tester_auth()
	set name = "Tester?"
	/*if(istester(src))
		src << "\blue <B>Key accepted as beta tester</B>"
	else
		src << "\red<B>Key not accepted as beta tester. You may only observe the rounds. Please join #Dabberstation on irc.synirc.net and ask to be a tester if you'd like to help!</B>"
	*/
/client/proc/Dabberauth()
	set name = "Dabber?"
	var/account = key

	src.authenticating = 1

	spawn (rand(4, 18))
		src.verbs -= /client/proc/Dabberauth
		src.Dabber = account
		src << "Key authorized: Hello [html_encode(account)]!"
		src << "\blue[auth_motd]"
		Dabber_key(src.ckey, account)
		src.authenticating = 0

var/Dabber_keylist[0]
var/list/beta_tester_keylist

/proc/beta_tester_loadfile()
	beta_tester_keylist = new/list()
	var/text = file2text("config/testers.txt")
	if (!text)
		diary << "Failed to load config/testers.txt\n"
	else
		var/list/lines = dd_text2list(text, "\n")
		for(var/line in lines)
			if (!line)
				continue

			var/tester_key = copytext(line, 1, 0)
			beta_tester_keylist.Add(tester_key)


/proc/Dabber_loadfile()
	var/savefile/S=new("data/Dabber.Dabber")
	S["key[0]"] >> Dabber_keylist
	log_admin("Loading Dabber_keylist")
	if (!length(Dabber_keylist))
		Dabber_keylist=list()
		log_admin("Dabber_keylist was empty")

/proc/Dabber_savefile()
	var/savefile/S=new("data/Dabber.Dabber")
	S["key[0]"] << Dabber_keylist

/proc/Dabber_key(key as text,account as text)
	var/ckey=ckey(key)
	if (!Dabber_keylist.Find(ckey))
		Dabber_keylist.Add(ckey)
	Dabber_keylist[ckey] = account
	Dabber_savefile()

/proc/isDabber(X)
	if (istype(X,/mob)) X=X:ckey
	if (istype(X,/client)) X=X:ckey
	if ((ckey(X) in Dabber_keylist)) return 1
	else return 0

/proc/istester(X)
	if (istype(X,/mob)) X=X:ckey
	if (istype(X,/client)) X=X:ckey
	if ((ckey(X) in beta_tester_keylist)) return 1
	else return 0

/proc/remove_Dabber(key as text)
	var/ckey=ckey(key)
	if (key && Dabber_keylist.Find(ckey))
		Dabber_keylist.Remove(ckey)
		Dabber_savefile()
		return 1
	return 0