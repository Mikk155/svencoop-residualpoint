void InitializeHardcoreMode()
{
	g_EngineFuncs.CVarSetFloat( "sv_ai_enemy_detection_mode", 1 );
	g_EngineFuncs.CVarSetFloat( "mp_weapon_respawndelay", -1 );
	g_EngineFuncs.CVarSetFloat( "mp_ammo_respawndelay", -1 );
	g_EngineFuncs.CVarSetFloat( "mp_item_respawndelay", -1 );
	g_EngineFuncs.CVarSetFloat( "mp_weapon_droprules", 1 );
	g_EngineFuncs.CVarSetFloat( "npc_dropweapons", 0 );
}