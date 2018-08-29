#define TIMETOKICK 60*2.5 //kick after 2.5 minutes
client
	New()
		..()
		InactivityLoop()
	proc/InactivityLoop()
		if(inactivity/10 > TIMETOKICK && kick_inactive_players == 1)
			src << "<font size=6><font color='red'>Due to your inactivity (You have been inactive for more than [TIMETOKICK] seconds), you have been kicked to prevent round delays."
			del src
		else
			spawn(10) InactivityLoop()