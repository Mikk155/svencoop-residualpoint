#include "residualpoint/monsters/monster_xenocrab"	// Monster xeno headcrab by Gaftherman
#include "residualpoint/monsters/monster_zgrunt"	// Monster zombie grunt by Gaftherman
#include "anti_rush"								// Anti Rush Entity by Outerbeast
#include "beast/checkpoint_spawner"					// Checkpoint Spawner Entity by Outerbeast
#include "beast/teleport_zone"						// monster Teleport Zone Script by Outerbeast
#include "cubemath/item_airbubble"				// item airbubbles Entity by Cubemath

#include "residualpoint/configs"		// Configs file. feel free to customize the whole campaign config there.
#include "mikk/antirush/residualpoint"	// Anti-Rush Script
bool blAntiRushEnabled = true;			// true = Anti-Rush mode - Mikk

void MapInit()
{
	// Enable survival mode from here.
	g_EngineFuncs.CVarSetFloat( "mp_survival_starton", 0 );
	
	// Enables players headshot reduction balancing from here
	g_EngineFuncs.CVarSetFloat( "mp_disable_pcbalancing", 0 );

	// Residual Point Configuration 
	InitializeConfigsFile();
	
	// Checkpoint Spawner by Outerbeast
	RegisterCheckPointSpawnerEntity();

	// game_zone_player resize-able by Outerbeast
	RegisterTriggerEntityVolume();
	
	// Item_airbubbles by Cubemath
	RegisterAirbubbleCustomEntity();
	
	// I'm too lazy to change the classname and put the model on it
	XenCrab::Register();
	ZombieGrunt::Register();
	
	// HOOKS
	g_Hooks.RegisterHook( Hooks::Player::ClientPutInServer, @SpamTime );
	
	// Anti Rush Entity by Outerbeast
	ANTI_RUSH::anti_rush();
}

void MapActivate()
{
//	After register Outerbeast's entities. Will create entities if the next conditions are meet.
	if( blAntiRushEnabled )
	{
		AntiRushSpawnEntities();
	}
}

HookReturnCode SpamTime(CBasePlayer@ pPlayer)
{
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Residual Point By Mikk & Gaftherman.\n" );
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Download this Map-Pack from scmapdb.com\n" );
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Open console to get a link\n" );
	g_EngineFuncs.ServerPrint( "Download this Map-Pack from scmapdb. link: (inserte link when clean) \n" );
	return HOOK_CONTINUE;
}