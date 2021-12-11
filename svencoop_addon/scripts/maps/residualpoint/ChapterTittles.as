void ChapterTittles()
{
    if(string(g_Engine.mapname) == "rp_c00_lobby" ){
		Game_texts( "Chapter 00: Residual Point Lobby" );
    }
    if(string(g_Engine.mapname) == "rp_c00_m1"
	or string(g_Engine.mapname) == "rp_c00_m2"
	or string(g_Engine.mapname) == "rp_c00_m3"
	or string(g_Engine.mapname) == "rp_c00_m4"
	or string(g_Engine.mapname) == "rp_c00_m5" ){
		Game_texts( "Chapter 00: Black Mesa Inbound" );
    }
    if(string(g_Engine.mapname) == "rp_c01" ){
		Game_texts( "Chapter 01: In Security" );
    }
    if(string(g_Engine.mapname) == "rp_c02" ){
		Game_texts( "Chapter 02: Incoming" );
    }
    if(string(g_Engine.mapname) == "rp_c03_m1"
	or string(g_Engine.mapname) == "rp_c03_m2" ){
		Game_texts( "Chapter 03: Among The Ruins" );
    }
    if(string(g_Engine.mapname) == "rp_c04" ){
		Game_texts( "Chapter 04: Office Facility" );
    }
    if(string(g_Engine.mapname) == "rp_c05" ){
		Game_texts( "Chapter 05: Obscure True" );
    }
    if(string(g_Engine.mapname) == "rp_c06"
	or string(g_Engine.mapname) == "rp_c06_pump" ){
		Game_texts( "Chapter 06: Residue Pit" );
    }
    if(string(g_Engine.mapname) == "rp_c07_m1"
	or string(g_Engine.mapname) == "rp_c07_m2sewer"
	or string(g_Engine.mapname) == "rp_c07_m2surface" ){
		Game_texts( "Chapter 07: Bombing Surface" );
    }
    if(string(g_Engine.mapname) == "rp_c08_m1sewer"
	or string(g_Engine.mapname) == "rp_c08_m2sewer"
	or string(g_Engine.mapname) == "rp_c08_m3"
	or string(g_Engine.mapname) == "rp_c08_m4sewer"
	or string(g_Engine.mapname) == "rp_c08_m1surface"
	or string(g_Engine.mapname) == "rp_c08_m2surface"
	or string(g_Engine.mapname) == "rp_c08_m3surface"
	or string(g_Engine.mapname) == "rp_c08_m4" ){
		Game_texts( "Chapter 08: Recession" );
    }
    if(string(g_Engine.mapname) == "rp_c09_m1"
	or string(g_Engine.mapname) == "rp_c09_m2"
	or string(g_Engine.mapname) == "rp_c09_m3" ){
		Game_texts( "Chapter 09: Distortion" );
    }
    if(string(g_Engine.mapname) == "rp_c10_m1"
	or string(g_Engine.mapname) == "rp_c10_m2"
	or string(g_Engine.mapname) == "rp_c10_m3" ){
		Game_texts( "Chapter 10: Upper Yard" );
    }
    if(string(g_Engine.mapname) == "rp_c11" ){
		Game_texts( "Chapter 11: Course to Lambda" );
    }
    if(string(g_Engine.mapname) == "rp_c12_m1"
	or string(g_Engine.mapname) == "rp_c12_m2"
	or string(g_Engine.mapname) == "rp_c12_m3" ){
		Game_texts( "Chapter 12: Into the portal" );
    }
    if(string(g_Engine.mapname) == "rp_c13_m1"
	or string(g_Engine.mapname) == "rp_c13_m2b"
	or string(g_Engine.mapname) == "rp_c13_m2a"
	or string(g_Engine.mapname) == "rp_c13_m3a"
	or string(g_Engine.mapname) == "rp_c13_m3b"
	or string(g_Engine.mapname) == "rp_c13_m4" ){
		Game_texts( "Chapter 13: Dread Plot" );
    }
    if(string(g_Engine.mapname) == "rp_c14"){
		Game_texts( "Secret Chapter: " );
    }
    if(string(g_Engine.mapname) == "rp_ws_c00_m1"
	or string(g_Engine.mapname) == "rp_ws_c00_m2"
	or string(g_Engine.mapname) == "rp_ws_c00_m3" ){
		Game_texts( "Chapter 00: Security Area" );
    }
}

void Game_texts( const string mensaje )
{    
    CBaseEntity@ pEntity = null;
    dictionary gametext;
    
    gametext =	{
        {	"y",			"0.05"				},
        {	"x",			"0.05"				},
        {	"fadein",		"0.05"				},
        {	"fadeout",		"3.5"				},
        {	"holdtime",		"10.0"				},
        {	"color",		"100 100 100"		},
        {	"fxtime",		"0.05"				},
        {	"channel",		"7"					},
        {	"message",		"" + mensaje		},
        {	"targetname",	"chapter_tittle_as"	}
    };
    @pEntity = g_EntityFuncs.CreateEntity( "game_text", gametext, true );
	
    gametext =	{
        {	"target",		"chapter_tittle_as"	},
		{	"delay", 		"5" 				},
        {	"targetname",	"game_playerjoin" 	}
    };
    @pEntity = g_EntityFuncs.CreateEntity( "game_text", gametext, true );
}