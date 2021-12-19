void ChapterTittles()
{
    if( string(g_Engine.mapname) == "residual_point_lobby" )
    {
		Game_texts( "Half-Life Residual-Point Lobby" );
    }
    else if( string(g_Engine.mapname).StartsWith( "rp_c00", String::DEFAULT_COMPARE ) )
    {
		Game_texts( "Half-Life Residual-Point \n Chapter 00: 'Black Mesa Inbound' " );
    }
    else if( string(g_Engine.mapname) == "rp_c01" )
    {
		Game_texts( "Half-Life Residual-Point \n Chapter 01: 'In Security' " );
    }
    else if( string(g_Engine.mapname) == "rp_c02" )
    {
		Game_texts( "Half-Life Residual-Point \n Chapter 02: 'Incoming' " );
    }
    else if( string(g_Engine.mapname).StartsWith( "rp_c03", String::DEFAULT_COMPARE ) )
    {
		Game_texts( "Half-Life Residual-Point \n Chapter 03: 'Among The Ruins' " );
    }
    else if( string(g_Engine.mapname) == "rp_c04" )
    {
		Game_texts( "Half-Life Residual-Point \n Chapter 04: 'Office Facility' " );
    }
    else if( string(g_Engine.mapname) == "rp_c05" )
    {
		Game_texts( "Half-Life Residual-Point \n Chapter 05: 'Obscure True' " );
    }
    else if( string(g_Engine.mapname).StartsWith( "rp_c06", String::DEFAULT_COMPARE ) )
    {
		Game_texts( "Half-Life Residual-Point \n Chapter 06: 'Residue Pit' " );
    }
    else if( string(g_Engine.mapname).StartsWith( "rp_c07", String::DEFAULT_COMPARE ) )
    {
		Game_texts( "Half-Life Residual-Point \n Chapter 07: 'Bombing Surface' " );
    }
    else if( string(g_Engine.mapname).StartsWith( "rp_c08", String::DEFAULT_COMPARE ) )
    {
		Game_texts( "Half-Life Residual-Point \n Chapter 08: 'Recession' " );
    }
    else if( string(g_Engine.mapname).StartsWith( "rp_c09", String::DEFAULT_COMPARE ) )
    {
		Game_texts( "Half-Life Residual-Point \n Chapter 09: 'Distortion' " );
    }
    else if( string(g_Engine.mapname).StartsWith( "rp_c10", String::DEFAULT_COMPARE ) )
    {
		Game_texts( "Half-Life Residual-Point \n Chapter 10: 'Upper Yard' " );
    }
    else if( string(g_Engine.mapname) == "rp_c11" )
    {
		Game_texts( "Half-Life Residual-Point \n Chapter 11: 'Course to Lambda' " );
    }
    else if( string(g_Engine.mapname).StartsWith( "rp_c12", String::DEFAULT_COMPARE ) )
    {
		Game_texts( "Half-Life Residual-Point \n Chapter 12: 'Into the portal' " );
    }
    else if( string(g_Engine.mapname).StartsWith( "rp_c13", String::DEFAULT_COMPARE ) )
    {
		  Game_texts( "Half-Life Residual-Point \n Chapter 13: 'Dread Plot' " );
    }
    else if( string(g_Engine.mapname) == "rp_c14")
    {
		Game_texts( "Half-Life \n Residual-Point \n 'Secret Chapter' " );
    }
    else if( string(g_Engine.mapname) == "rps_c00" )
    {
	  	Game_texts( "Residual-Point: Survivor \n Chapter 'Security Area' " );
    }
    else if( string(g_Engine.mapname) == "rps_c01" )
    {
	  	Game_texts( "Residual-Point: Survivor \n Chapter 'In Security' " );
    }
    else if( string(g_Engine.mapname) == "rps_c02" )
    {
		Game_texts( "Residual-Point: Survivor \n Chapter 'Uforenseen Consequences' " );
    }
    else if( string(g_Engine.mapname) == "rps_sewer" )
    {
		Game_texts( "Residual-Point: Survivor \n Chapter 'On A Sewer' " );
    }
    else if( string(g_Engine.mapname) == "rps_surface" )
    {
		Game_texts( "Residual-Point: Survivor \n Chapter 'Invaser Of Army' " );
    }
    else if( string(g_Engine.mapname) == "rps_rails" )
    {
		Game_texts( "Residual-Point: Survivor \n Chapter 'On A Rail' " );
    }
    else if( string(g_Engine.mapname) == "rps_base" )
    {
		Game_texts( "Residual-Point: Survivor \n Chapter 'On A Basement' " );
    }
    else if( string(g_Engine.mapname) == "rps_final" )
    {
		Game_texts( "Residual-Point: Survivor \n Chapter 'On A Basement' " );
    }
}

void Game_texts( const string mensaje )
{    
    CBaseEntity@ pEntity = null;
    dictionary gametext;
    
    gametext =	
    {
        { "y", "0.05"	},
        { "x", "0.05"	},
        { "fadein", "0.05" },
        { "fadeout", "3.5" },
        { "holdtime", "10.0" },
        { "color", "100 100 100" },
        { "fxtime", "0.05" },
        { "channel", "7" },
        { "message", "" + mensaje },
        { "targetname", "chapter_tittle_as" }
    };
    @pEntity = g_EntityFuncs.CreateEntity( "game_text", gametext, true );
	
    gametext =	
    {
        { "target", "chapter_tittle_as"	},
		{ "delay", "5" },
        { "spawnflags", "64" },
        { "targetname", "game_playerjoin" }
    };
    @pEntity = g_EntityFuncs.CreateEntity( "trigger_relay", gametext, true );
}