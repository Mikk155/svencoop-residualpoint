void Archievemets()
{
    if(string(g_Engine.mapname) == "rp_c07_m2sewer"
	or string(g_Engine.mapname) == "rp_c07_m2surface"
	or string(g_Engine.mapname) == "rp_c08_m3surface"
	or string(g_Engine.mapname) == "rp_c13_m2a"
	or string(g_Engine.mapname) == "rp_c13_m2b"
	or string(g_Engine.mapname) == "rp_c14" )
	{
		TextFormat( "Explorer 1 of 6 paths" );
    }
    if(string(g_Engine.mapname) == "rp_c05"
    or string(g_Engine.mapname) == "rp_c08_m2sewer"
    or string(g_Engine.mapname) == "rp_c08_m3sewer" )
    {
        TextFormat( "Fish Diver 1 of 3 maps" );
    }
    if(string(g_Engine.mapname) == "rp_c00_m5"
    or string(g_Engine.mapname) == "rp_c01"
    or string(g_Engine.mapname) == "rp_c02"
    or string(g_Engine.mapname) == "rp_c03_m1"
    or string(g_Engine.mapname) == "rp_c03_m2" )
    {
        TextFormat( "Secret hunter: 1 of items" );
    }
}

void TextFormat( const string mensaje )
{    
    CBaseEntity@ pEntity = null;
    dictionary gametext;
    
    gametext ={                                                            
        { "y", "0.05"},
        { "x", "0.05"},
        { "fadein", "0.0"},
        { "fadeout", "0.0"},
        { "holdtime", "10.0"},
        { "color", "100 100 100"},
        { "fxtime", "0.0"},
        { "channel", "7"},
        { "message", "Archievemet unlocked: " + mensaje },
        { "targetname", "archievemets_text" }
    };
    @pEntity = g_EntityFuncs.CreateEntity( "game_text", gametext, true );
	
	gametext ={
		{ "archievemets_text", "10" },
		{ "targetname", "archievemets_text" },
		{ "spawnflags", "1" }
    };
    @pEntity = g_EntityFuncs.CreateEntity( "multi_manager", gametext, true );
}