void NpcRequiredStuff()
{
    if(string(g_Engine.mapname) == "rp_c08_m1sewer" )
	{
		KillThisNpc( "z3f_sci_03" );
		MakeTextofIt();
	}
    if(string(g_Engine.mapname) == "rp_c08_m2surface" )
	{
		KillThisNpc( "p03_scientist_b" );
		KillThisNpc( "p03_scientist_a" );
		MakeTextofIt();
	}
    if(string(g_Engine.mapname) == "rp_c08_m3surface" )
	{
		KillThisNpc( "p03_scientist_a" );
		MakeTextofIt();
	}
    if(string(g_Engine.mapname) == "rp_c11_m1" )
	{
		KillThisNpc( "suvi_barney" );
		MakeTextofIt();
	}
    if(string(g_Engine.mapname) == "rp_c11_m1" )
	{
		KillThisNpc( "o3n_kelly" );
		MakeTextofIt();
	}
}

void KillThisNpc( const string targetname )
{
	CBaseEntity@ pEntity = null;
	while((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, targetname )) !is null)
	{
		g_EntityFuncs.Remove(pEntity);
	}
}

void MakeTextofIt(){
	CBaseEntity@ pEntity = null;
	dictionary keyvalues;

	keyvalues =	
	{
		{ "effect", "2" },
		{ "spawnflags", "2"},
		{ "y", "0.67"},
		{ "x", "-1"},
		{ "color", "237 28 36"},
		{ "color2", "240 110 0"},
		{ "fadein", "0.5"},
		{ "fadeout", "3"},
		{ "holdtime", "10"},
		{ "fxtime", "0.5"},
		{ "channel", "8"},
		{ "message", "MAP: required npc are dead. new one will spawn in 1 minute." },
		{ "targetname", "npc_required_die"}
	};
	@pEntity = g_EntityFuncs.CreateEntity( "game_text", keyvalues, true );

	keyvalues =	
	{
		{ "delay", "0.5"},
		{ "triggerstate", "1" },
		{ "target", "spawn_npc_required"}
	};
	@pEntity = g_EntityFuncs.CreateEntity( "trigger_auto", keyvalues, true );
}