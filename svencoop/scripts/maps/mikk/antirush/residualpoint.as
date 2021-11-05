/*
*	Anti-Rush by Mikk
*
*	Special thanks to Cubemath, Sparks, Outerbeast and Gaftherman
*
*	Blank text cuz im lazy
		AntiRushAlt( "", "", "", "" );
		AntiRushPercent( "", "", "", "" );
		AntiRushBlocker( "", "", "" );
		AntiRushRelayInit( "", "", "" );




*/
void AntiRushSpawnEntities() // void MapActivate()
{			// Create entities only on this maps.
	if( string(g_Engine.mapname) == "rp_c04" )
	{
		AntiRushPercent( "66", "-1722 -474 -850", "-2438 -1254 -930", "1" );
		AntiRushBlocker( "1", "369", "-3392 -3200 776" );
		AntiRushPercent( "66", "2838 -2618 -362", "2410 -2902 -606", "2" );
		AntiRushBlocker( "2", "220", "400 -2864 776" );
	}
	
	if( string(g_Engine.mapname) == "rp_c03_m2" )
	{
		AntiRushPercent( "66", "-10835 -4075 -499", "-12081 -4652 -852", "1" );
		AntiRushAlt( "ANTI-RUSH: Please. kill remain enemies first.", "-11623 -4340 -687", "-11759 -4432 -828", "1" );
		AntiRushBlocker( "1", "272", "-12504 -3253 472" );
		
		AntiRushPercent( "66", "-9254 -2836 -1565", "-10700 -3307 -1733", "2" );
		AntiRushAlt( "ANTI-RUSH: Please. kill remain enemies first.", "-9322 -2945 -1617", "-9420 -3082 -1705", "2" );
		
		AntiRushPercent( "66", "-7078 -2658 -766", "-7755 -3539 -1067", "3" );
		AntiRushAlt( "ANTI-RUSH: Please. kill remain enemies first.", "-7721 -3353 -954", "-7757 -3442 -1043", "2" );
		
		AntiRushPercent( "66", "-7992 -3870 -509", "-8471 -4420 -692", "4" );
		
		AntiRushPercent( "66", "1948 -39 -1696", "983 -1375 -1949", "5" );
		
		AntiRushPercent( "66", "9658 -919 -1098", "9034 -1623 -1255", "6" );
		AntiRushBlocker( "6", "2", "7081 -3238 577" );
		
		AntiRushPercent( "66", "11991 -420 -1487", "11398 -1023 -1760", "7" );
	}
	
	if( string(g_Engine.mapname) == "rp_c03_m1" )
	{
		AntiRushPercent( "66", "-361 -5837 -844", "-576 -6637 -1018", "1" );
		AntiRushAlt( "ANTI-RUSH: Please. kill remain enemies first.", "-368 -6053 -894", "-416 -6253 -1014", "1" );
		LockPercentage( "1", "1" );
		
		AntiRushPercent( "66", "-256 -6378 -1622", "-707 -6588 -1805", "2" );
		LockPercentage( "2", "327" );
		AntiRushBlocker( "2", "327", "739 -8180 -936" );
		
		AntiRushPercent( "66", "2132 -5645 -2254", "1312 -6799 -2492", "3" );
		AntiRushAlt( "ANTI-RUSH: Please. kill remain enemies first.", "2124 -6248 -2377", "2056 -6413 -2505", "3" );
		AntiRushPercent( "66", "-1103 1298 -1025", "-1881 729 -1247", "3" );
		AntiRushBlocker( "3", "177", "-1256 732 -1192" );
	}
	
	if( string(g_Engine.mapname) == "rp_c02" )
	{
		AntiRushBlocker( "1", "184", "0 0 0" );
		AntiRushPercent( "66", "1570 4054 -452", "50 3146 -646", "1" );
	}
	
	if( string(g_Engine.mapname) == "rp_c01" )
	{
		AntiRushPercent( "66", "5950 -1290 -2482", "4370 -1821 -2654", "1" );
		
		AntiRushPercent( "66", "582 -2034 -2138", "2 -2686 -2310", "2" );
		AntiRushBlocker( "2", "226", "2016 -5278 -880" );
		
		LockPercentage( "3", "2" );
		AntiRushPercent( "66", "2262 -1458 -2154", "1410 -1686 -2310", "3" );
	}
	
	if( string(g_Engine.mapname) == "rp_c00_m5" )
	{
		AntiRushPercent( "66", "213 2075 1811", "-326 1681 1549", "1" );
	}
}

void LockPercentage( const string namese, const string namese2 )
{
	CBaseEntity@ pEntity = null;
	dictionary altmess;
	
	altmess =
	{
		{ "targetname", "antirush_skull_" + namese2 },
		{ "spawnflags", "12"},
		{ "killtarget", "antirush_2text_" + namese },
		{ "target", "antirush_master_" + namese }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "anti_rush", altmess, true );
}

// PERCENT LOCK STUFF
void AntiRushAlt( const string messag, const string maxh, const string minh, const string namese )
{
	CBaseEntity@ pEntity = null;
	dictionary altmess;
	
	altmess =
	{
		{ "m_flPercentage", "0.01"},
		{ "minhullsize", "" + minh },
		{ "maxhullsize", "" + maxh },
		{ "target", "antirush_vol2_" + namese },
		{ "m_flDelay", "1"}
	};
	@pEntity = g_EntityFuncs.CreateEntity( "trigger_multiple_mp", altmess, true );

	altmess =														// trigger_entity_volume by outerbeast
	{
		{ "intarget", "antirush_2text_" + namese },
		{ "zonecornermin", "" + minh },
		{ "zonecornermax", "" + maxh },
		{ "incount", "1"},
		{ "spawnflags", "1"},
		{ "targetname", "antirush_vol2_" + namese }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "trigger_entity_volume", altmess, true );

	altmess =													//	Display the text to the player who reach the zone.
	{															//	Dont spoiler the map with floating icons.
		{ "effect", "2" },
		{ "spawnflags", "2"},
		{ "y", "0.67"},
		{ "x", "-1"},
		{ "color", "100 100 100"},
		{ "color2", "240 110 0"},
		{ "fadein", "0.0"},
		{ "fadeout", "1"},
		{ "holdtime", "5"},
		{ "fxtime", "0.0"},
		{ "channel", "1"},
		{ "message", "" + messag },
		{ "targetname", "antirush_2text_" + namese }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", altmess, true );
}

// BLOCKER WALL
void AntiRushBlocker( const string namese, const string model, const string origin )
{
	CBaseEntity@ pEntity = null;
	dictionary wall;

	wall =														// BSP Model BLOCKER
	{
		{ "model", "*" + model },
		{ "origin", "" + origin },
		{ "rendermode", "1"},
		{ "renderamt", "255"},
		{ "rendercolor", "255 0 0"},
		{ "targetname", "antirush_target_" + namese }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "func_wall_toggle", wall, true );
}

// PERCENT LOCK STUFF
void AntiRushPercent( const string percent, const string maxh, const string minh, const string namese )
{
	CBaseEntity@ pEntity = null;
	dictionary antirush;

	antirush =														// antirush entities Mash-up
	{
		{ "percentage", "" + percent },
		{ "zonecornermin", "" + minh },
		{ "zonecornermax", "" + maxh },
		{ "master", "antirush_master_" + namese },
		{ "target", "antirush_target_" + namese },
		{ "killtarget", "antirush_vol_" + namese },
		{ "spawnflags", "12"}
	};
	@pEntity = g_EntityFuncs.CreateEntity( "anti_rush", antirush, true );

	antirush =
	{
		{ "m_flPercentage", "0.01"},
		{ "minhullsize", "" + minh },
		{ "maxhullsize", "" + maxh },
		{ "master", "antirush_master_" + namese },
		{ "target", "antirush_vol_" + namese },
		{ "m_flDelay", "1"}
	};
	@pEntity = g_EntityFuncs.CreateEntity( "trigger_multiple_mp", antirush, true );

	antirush =														// trigger_entity_volume by outerbeast
	{
		{ "intarget", "antirush_text_" + namese },
		{ "zonecornermin", "" + minh },
		{ "zonecornermax", "" + maxh },
		{ "incount", "1"},
		{ "spawnflags", "1"},
		{ "targetname", "antirush_vol_" + namese }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "trigger_entity_volume", antirush, true );

	antirush =													//	Display the text to the player who reach the zone.
	{															//	Dont spoiler the map with floating icons.
		{ "effect", "2" },
		{ "spawnflags", "2"},
		{ "y", "0.67"},
		{ "x", "-1"},
		{ "color", "100 100 100"},
		{ "color2", "240 110 0"},
		{ "fadein", "0.0"},
		{ "fadeout", "1"},
		{ "holdtime", "5"},
		{ "fxtime", "0.0"},
		{ "channel", "1"},
		{ "message", "ANTI-RUSH: "+ percent +" percent of players needed" },
		{ "targetname", "antirush_text_" + namese }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", antirush, true );
}

// map start blocker relay init
void AntiRushRelayInit( const string origin, const string model, const string times )
{
	CBaseEntity@ pEntity = null;
	dictionary relayinit;

	relayinit =														// BSP Model BLOCKER
	{
		{ "model", "*" + model },
		{ "origin", "" + origin },
		{ "rendermode", "5"},
		{ "renderamt", "255"},
		{ "targetname", "antirush_initwall" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "func_wall_toggle", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 30 seconds.." },
		{ "targetname", "msg_countdown_1" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 29 seconds.." },
		{ "targetname", "msg_countdown_2" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );
	
	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 28 seconds.." },
		{ "targetname", "msg_countdown_3" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );
	
	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 27 seconds.." },
		{ "targetname", "msg_countdown_4" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );
	
	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 26 seconds.." },
		{ "targetname", "msg_countdown_5" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );
	
	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 25 seconds.." },
		{ "targetname", "msg_countdown_6" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );
	
	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 24 seconds.." },
		{ "targetname", "msg_countdown_7" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );
	
	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 23 seconds.." },
		{ "targetname", "msg_countdown_8" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );
	
	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 22 seconds.." },
		{ "targetname", "msg_countdown_9" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );
	
	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 21 seconds.." },
		{ "targetname", "msg_countdown_10" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 20 seconds.." },
		{ "targetname", "msg_countdown_11" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 19 seconds.." },
		{ "targetname", "msg_countdown_12" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 18 seconds.." },
		{ "targetname", "msg_countdown_13" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 17 seconds.." },
		{ "targetname", "msg_countdown_14" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 16 seconds.." },
		{ "targetname", "msg_countdown_13" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 15 seconds.." },
		{ "targetname", "msg_countdown_14" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 14 seconds.." },
		{ "targetname", "msg_countdown_15" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 13 seconds.." },
		{ "targetname", "msg_countdown_16" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 12 seconds.." },
		{ "targetname", "msg_countdown_17" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 16 seconds.." },
		{ "targetname", "msg_countdown_18" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 15 seconds.." },
		{ "targetname", "msg_countdown_19" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 14 seconds.." },
		{ "targetname", "msg_countdown_20" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 13 seconds.." },
		{ "targetname", "msg_countdown_21" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 12 seconds.." },
		{ "targetname", "msg_countdown_22" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 11 seconds.." },
		{ "targetname", "msg_countdown_23" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 10 seconds.." },
		{ "targetname", "msg_countdown_24" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 9 seconds.." },
		{ "targetname", "msg_countdown_25" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 8 seconds.." },
		{ "targetname", "msg_countdown_26" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 7 seconds.." },
		{ "targetname", "msg_countdown_27" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 6 seconds.." },
		{ "targetname", "msg_countdown_28" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 5 seconds.." },
		{ "targetname", "msg_countdown_29" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 4 seconds.." },
		{ "targetname", "msg_countdown_30" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 3 seconds.." },
		{ "targetname", "msg_countdown_31" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 2 seconds.." },
		{ "targetname", "msg_countdown_32" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "spawnflags", "3"},
		{ "y", "-.25"},
		{ "x", "-1"},
		{ "color", "255 255 255"},
		{ "color2", "255 255 255"},
		{ "fadein", "1"},
		{ "fadeout", "0.5"},
		{ "holdtime", "2"},
		{ "fxtime", "0.25"},
		{ "channel", "4"},
		{ "message", "Game will begin in 1 seconds.." },
		{ "targetname", "msg_countdown_33" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", relayinit, true );

	relayinit =
	{
		{ "delay", "1"},
		{ "triggerstate", "1"},
		{ "target", "relay_init_map_" + times }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "trigger_auto", relayinit, true );

	relayinit =
	{
		{ "msg_countdown_1", "1.5"},
		{ "msg_countdown_2", "2.5"},
		{ "msg_countdown_3", "3.5"},
		{ "msg_countdown_4", "4.5"},
		{ "msg_countdown_5", "5.5"},
		{ "msg_countdown_6", "6.5"},
		{ "msg_countdown_7", "7.5"},
		{ "msg_countdown_8", "8.5"},
		{ "msg_countdown_9", "9.5"},
		{ "msg_countdown_10", "10.5"},
		{ "msg_countdown_11", "11.5"},
		{ "msg_countdown_12", "12.5"},
		{ "msg_countdown_13", "13.5"},
		{ "msg_countdown_14", "14.5"},
		{ "msg_countdown_15", "15.5"},
		{ "msg_countdown_16", "16.5"},
		{ "msg_countdown_17", "17.5"},
		{ "msg_countdown_18", "18.5"},
		{ "msg_countdown_19", "19.5"},
		{ "msg_countdown_20", "20.5"},
		{ "msg_countdown_21", "21.5"},
		{ "msg_countdown_22", "22.5"},
		{ "msg_countdown_23", "23.5"},
		{ "msg_countdown_24", "24.5"},
		{ "msg_countdown_25", "25.5"},
		{ "msg_countdown_26", "26.5"},
		{ "msg_countdown_27", "27.5"},
		{ "msg_countdown_28", "28.5"},
		{ "msg_countdown_29", "29.5"},
		{ "msg_countdown_30", "30.5"},
		{ "msg_countdown_31", "31.5"},
		{ "msg_countdown_32", "32.5"},
		{ "msg_countdown_33", "33.5"},
		{ "antirush_initwall", "33.5"},
		{ "targetname", "relay_init_map_30" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "multi_manager", relayinit, true );

	relayinit =
	{
		{ "msg_countdown_11", "1.5"},
		{ "msg_countdown_12", "2.5"},
		{ "msg_countdown_13", "3.5"},
		{ "msg_countdown_14", "4.5"},
		{ "msg_countdown_15", "5.5"},
		{ "msg_countdown_16", "6.5"},
		{ "msg_countdown_17", "7.5"},
		{ "msg_countdown_18", "8.5"},
		{ "msg_countdown_19", "9.5"},
		{ "msg_countdown_20", "10.5"},
		{ "msg_countdown_21", "11.5"},
		{ "msg_countdown_22", "12.5"},
		{ "msg_countdown_23", "13.5"},
		{ "msg_countdown_24", "14.5"},
		{ "msg_countdown_25", "15.5"},
		{ "msg_countdown_26", "16.5"},
		{ "msg_countdown_27", "17.5"},
		{ "msg_countdown_28", "18.5"},
		{ "msg_countdown_29", "19.5"},
		{ "msg_countdown_30", "20.5"},
		{ "msg_countdown_31", "21.5"},
		{ "msg_countdown_32", "22.5"},
		{ "msg_countdown_33", "23.5"},
		{ "antirush_initwall", "23.5"},
		{ "targetname", "relay_init_map_20" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "multi_manager", relayinit, true );

	relayinit =
	{
		{ "msg_countdown_24", "1.5"},
		{ "msg_countdown_25", "2.5"},
		{ "msg_countdown_26", "3.5"},
		{ "msg_countdown_27", "4.5"},
		{ "msg_countdown_28", "5.5"},
		{ "msg_countdown_29", "6.5"},
		{ "msg_countdown_30", "7.5"},
		{ "msg_countdown_31", "8.5"},
		{ "msg_countdown_32", "9.5"},
		{ "msg_countdown_33", "10.5"},
		{ "antirush_initwall", "10.5"},
		{ "targetname", "relay_init_map_10" }
	};
	@pEntity = g_EntityFuncs.CreateEntity( "multi_manager", relayinit, true );
}