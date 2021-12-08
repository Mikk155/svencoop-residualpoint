void MapActivate()
{
    if(string(g_Engine.mapname) == "rp_c08_m3sewer" )
    {
        Vector origin;

        switch( Math.RandomLong( 0, 9 ) )
        {
            case 0: 
            origin = Vector( 1472, -24, -2360 );
            break;

            case 1: 
            origin = Vector( 832, 296, -2320 );
            break;

            case 2: 
            origin = Vector( 280, 48, -3480 );
            break;

            case 3: 
            origin = Vector( 672, -2128, -3408 );
            break;

            case 4: 
            origin = Vector( 2264, -1200, -3312 );
            break;

            case 5: 
            origin = Vector( 2656, -736, -2344 );
            break;

            case 6: 
            origin = Vector( 1208, 376, -3424 );
            break;

            case 7: 
            origin = Vector( 1096, 728, -3568 );
            break;

            case 8: 
            origin = Vector( 1248, -1344, -2392 );
            break;

            case 9: 
            origin = Vector( 110, -920, -3413 );
            break;
        }

        array<Vector> Aom01_Coords = 
        {
            origin
        };

        for( uint i = 0; i < Aom01_Coords.length(); i++ )
        {
			g_EntityFuncs.Create( TriggerOnce, Aom01_Coords[i], g_vecZero, false );
		}
    }
}

void TriggerOnce( const string origin )
{    
    CBaseEntity@ pEntity = null;
    dictionary CheckPointer;
    
    CheckPointer ={                                                            
        { "model", "*181" },
        { "origin", "" + origin },
        { "target", "SpawnCheckpoin" }
    };
    @pEntity = g_EntityFuncs.CreateEntity( "trigger_once", CheckPointer, true );
	
	CheckPointer ={
        { "origin", "" + origin },
		{ "targetname", "SpawnCheckpoin" },
		{ "model", "models/mikk/residualpoint/limitless_potential.mdl" }
    };
    @pEntity = g_EntityFuncs.CreateEntity( "checkpoint_spawner", CheckPointer, true );
}