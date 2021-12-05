#include "residualpoint/archievemets"
#include "residualpoint/monsters"
#include "residualpoint/ammo_individual"
#include "residualpoint/weapon_hlsatchel"
#include "residualpoint/Difficulty"

#include "residualpoint/checkpoint_spawner"
#include "beast/teleport_zone"

#include "cubemath/item_airbubble"

float flSurvivalStartDelay = g_EngineFuncs.CVarGetFloat( "mp_survival_startdelay" );

bool blSpawnNpcRequired = true; // Change to true = spawn npcs required for the map when they die instead of restart the map NOTE: if enabled, archivemets will be disabled.
bool bSurvivalEnabled = true;	// Change to true = survival mode enabled NOTE: if disabled, archivemets will be disabled.

void MapInit()
{
	// Take'd from weapon_hlsatchel by JulianR0
	// https://github.com/JulianR0/TPvP/blob/master/src/map_scripts/hl_weapons/weapon_hlsatchel.as
	RegisterHLSatchel();

	RegisterAllMonsters();
	RegisterAllItems();
	RegisterAirbubbleCustomEntity();
	RegisterCheckPointSpawnerEntity();

	DiffVerify();
	
    if( string(g_Engine.mapname) == "rp_c13_m3a" )
	{
		ControllerMapInit();
		g_Scheduler.SetTimeout( "Entitys", 10 ); 
	}

	g_Hooks.RegisterHook( Hooks::Player::ClientPutInServer, @SpamTime );
}

void MapActivate()
{
	Archievemets();
	
	if( blSpawnNpcRequired )
	{
		NpcRequiredStuff();
	}
	
	if( !bSurvivalEnabled && blSpawnNpcRequired)
	{
		UpdateOnRemove();
	}
	
	// https://github.com/Mikk155/angelscript/blob/main/plugins/SurvivalDeluxe.as
	if( bSurvivalEnabled )
	{	
		g_SurvivalMode.Disable();
		g_Scheduler.SetTimeout( "SurvivalModeEnable", flSurvivalStartDelay );
		g_EngineFuncs.CVarSetFloat( "mp_survival_startdelay", 0 );
		g_EngineFuncs.CVarSetFloat( "mp_survival_starton", 0 );
		g_EngineFuncs.CVarSetFloat( "mp_dropweapons", 0 );
	}
}

void UpdateOnRemove()
{
    CBaseEntity@ pEntity = null;
    while((@pEntity = g_EntityFuncs.FindEntityByClassname(pEntity, "trigger_save")) !is null)
    {
        g_EntityFuncs.Remove( pEntity );
    }
}

void SurvivalModeEnable()
{
    g_SurvivalMode.Activate( true );
    g_EngineFuncs.CVarSetFloat( "mp_dropweapons", 1 );
    NetworkMessage message( MSG_ALL, NetworkMessages::SVC_STUFFTEXT );
    message.WriteString( "spk buttons/bell1" );
    message.End();
}

HookReturnCode SpamTime(CBasePlayer@ pPlayer)
{
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Residual Point By Mikk & Gaftherman.\n" );
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Download this Map-Pack from scmapdb.com\n" );
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Open console to copy the link\n" );
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "  \n" );
	return HOOK_CONTINUE;
}