
#include "residualpoint/monster_xenocrab"
#include "residualpoint/anti_rush"
#include "residualpoint/checkpoint_spawner"
#include "residualpoint/teleportzone"

const bool blAntiRushEnable = true; //Enable this to get Anti-Rush mode -mikk

bool blSurvivalEnable = true; //Enable this to get Survival mode -mikk

array<ItemMapping@> g_ItemMappings = { ItemMapping( "weapon_m16", "weapon_9mmAR" ) };

bool ActivateSurvivalAndClassicMode( const string& in szMapName )
{
	return 

    szMapName != "rp_c00_m1" && 
    szMapName != "rp_c00_m2" && 
    szMapName != "rp_c00_m3" && 
    szMapName != "rp_c00_m4" &&
    szMapName != "rp_c00_m5" &&    
    szMapName != "rp_c01" 	 &&
    szMapName != "rp_c02"; //<- name of the maps that classic/survival mode can be enabled / disabled via vote without restart
}

void MapInit()
{
	RegisterCheckPointSpawnerEntity();
		
	if( blAntiRushEnable )
		RegisterAntiRushEntity();

	// I'm too lazy to change the classname and put the model on it
	XenCrab::Register();

	//We want classic mode voting to be enabled here
	g_ClassicMode.EnableMapSupport();
	
	g_ClassicMode.SetItemMappings( @g_ItemMappings );
	
	if( !ActivateSurvivalAndClassicMode( g_Engine.mapname ) )
		g_ClassicMode.SetShouldRestartOnChange( false );	
}

void MapStart()
{
	if( !ActivateSurvivalAndClassicMode( g_Engine.mapname ) )
		blSurvivalEnable = false;
		
	if( blSurvivalEnable )
		Survival_on();
}

void Survival_on()
{
	dictionary survivalon =
	{
		{ "triggerstate", "1" },
		{ "delay", "25"},
		{ "target", "survival_on" }
	};
	
	dictionary survivalon2 =
	{
		{ "m_iMode", "1" },
		{ "m_iszScriptFunctionName", "ActivateSurvival"},
		{ "targetname", "survival_on" }
	};

	CBaseEntity@ test1 = g_EntityFuncs.CreateEntity( "trigger_auto", survivalon, true );
	
	CBaseEntity@ test2 = g_EntityFuncs.CreateEntity( "trigger_script", survivalon2, true );
	
}

void ActivateSurvival(CBaseEntity@ pActivator,CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	g_SurvivalMode.Activate();
}
