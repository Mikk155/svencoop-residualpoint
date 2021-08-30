
#include "residualpoint/monster_xenocrab"
#include "residualpoint/anti_rush"
#include "residualpoint/env_hurt"
#include "residualpoint/checkpoint_spawner"

const bool blAntiRushEnable = true; //Enable this to get Anti-Rush mode -mikk

const bool blSurvivalEnable = true; //Enable this to get Survival mode -mikk

array<ItemMapping@> g_ItemMappings = { ItemMapping( "weapon_m16", "weapon_9mmAR" ) };

bool ShouldRestartIfClassicModeChangesOn( const string& in szMapName )
{
	return 

	szMapName != "rp_c00_m1" && 
	szMapName != "rp_c00_m2" && 
	szMapName != "rp_c00_m3" && 
	szMapName != "rp_c00_m4" && 
	szMapName != "rp_c00_m5"; //<- name of the maps that classic mode can be enabled / disabled via vote without restart
}

void MapInit()
{
	
	if( blAntiRushEnable )
		RegisterAntiRushEntity();
		
	if( blSurvivalEnable )
		Survival_on();

	if( blSurvivalEnable )
		RegisterCheckPointSpawnerEntity();
	
	RegisterEnvHurtEntity();

	// I'm too lazy to change the classname and put the model on it
	XenCrab::Register();

	//We want classic mode voting to be enabled here
	g_ClassicMode.EnableMapSupport();
	
	g_ClassicMode.SetItemMappings( @g_ItemMappings );

	if( !ShouldRestartIfClassicModeChangesOn( g_Engine.mapname ) )
		g_ClassicMode.SetShouldRestartOnChange( false );
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
