void InitializeConfigsFile()
{	// Generic cvars that you can change
	g_EngineFuncs.CVarSetFloat( "mp_survival_startdelay", 25 );
	g_EngineFuncs.CVarSetFloat( "mp_timelimit", 90 );
	g_EngineFuncs.CVarSetFloat( "mp_disable_autoclimb", 1 );
	g_EngineFuncs.CVarSetFloat( "mp_allowmonsterinfo", 1 );
	g_EngineFuncs.CVarSetFloat( "mp_modelselection", 0 );
	g_EngineFuncs.CVarSetFloat( "mp_hevsuit_voice", 0 );
	g_EngineFuncs.CVarSetFloat( "mp_weaponstay", 0 );
	g_EngineFuncs.CVarSetFloat( "mp_npckill", 2 );
	g_EngineFuncs.CVarSetFloat( "mp_banana", 0 );
	g_EngineFuncs.CVarSetFloat( "sv_airaccelerate", 10 );
	g_EngineFuncs.CVarSetFloat( "sv_accelerate", 10 );
	g_EngineFuncs.CVarSetFloat( "sv_friction", 7 );
	g_EngineFuncs.CVarSetFloat( "sv_gravity", 800 );
	g_EngineFuncs.CVarSetFloat( "sv_maxspeed", 270 );
	g_EngineFuncs.CVarSetFloat( "sv_wateraccelerate", 10 );
}