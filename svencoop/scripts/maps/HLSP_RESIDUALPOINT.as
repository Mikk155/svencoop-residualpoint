#include "residualpoint/monsters/monster_xenocrab"
#include "residualpoint/monsters/monster_zgrunt"
#include "beast/checkpoint_spawner"	// Checkpoint Spawner Entity by Outerbeast
#include "beast/teleport_zone"		// monster Teleport Zone Script by Outerbeast
#include "cubemath/item_airbubble"	// item airbubbles Entity by Cubemath

void MapInit()
{
	XenCrab::Register();	  // I'm too lazy to change the 
	ZombieGrunt::Register(); // classname and put the model on it
	RegisterAirbubbleCustomEntity();
	RegisterCheckPointSpawnerEntity();
	
	g_Hooks.RegisterHook( Hooks::Player::ClientPutInServer, @SpamTime );
}

HookReturnCode SpamTime(CBasePlayer@ pPlayer)
{
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Residual Point By Mikk & Gaftherman.\n" );
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Download this Map-Pack from scmapdb.com\n" );
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Open console to get a link\n" );
	g_EngineFuncs.ServerPrint( "Download this Map-Pack from scmapdb. link: (inserte link when clean) \n" );
	return HOOK_CONTINUE;
}