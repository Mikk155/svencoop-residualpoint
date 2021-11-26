#include "residualpoint/monster_xenocrab"
#include "residualpoint/monster_zgrunt"
#include "residualpoint/monster_alien_worker"
#include "residualpoint/monster_nari_grunt"
#include "residualpoint/monster_baby_ichthyosaur"
#include "residualpoint/monster_zgrunt_dead"
#include "residualpoint/monster_civ_scientist_dead"

#include "residualpoint/checkpoint_spawner"
#include "beast/teleport_zone"

#include "cubemath/item_airbubble"

const string configfile = "maps/rp_global_config.cfg" ;
dictionary dCvars;

void MapInit()
{
	// I'm too lazy to change the classname and put the model on it -gaftherman
	XenCrab::Register();	  
	ZombieGrunt::Register();
	ZombieGruntDead::Register();
	ScientistCivdead::Register();
	BabyIcky::Register();
	AlienWorker::Register();
	NariGrunt::Register();
	
	Configurations();	// Easy configuration cfg for lazy server operators. -microphone
	
	RegisterAirbubbleCustomEntity();
	RegisterCheckPointSpawnerEntity();
	
	g_Hooks.RegisterHook( Hooks::Player::ClientPutInServer, @SpamTime );
	
	array<string> @dCvarsKeys = dCvars.getKeys();
	dCvarsKeys.sortAsc();
	string CvarValue;

	for( uint i = 0; i < dCvarsKeys.length(); ++i )
	{
		dCvars.get( dCvarsKeys[i], CvarValue );
		g_EngineFuncs.CVarSetFloat( dCvarsKeys[i], atof( CvarValue ) );
		g_EngineFuncs.ServerPrint( "StaticCfg: Set CVar " + dCvarsKeys[i] + " " + CvarValue + "\n" );
	}
}

void Configurations()	// StaticCfg by Outerbeast: https://github.com/Outerbeast/Addons/blob/main/StaticCfg.as
{
	File@ pFile = g_FileSystem.OpenFile( configfile, OpenFile::READ );
	if( pFile !is null && pFile.IsOpen() ){
		while( !pFile.EOFReached() )
		{
			string sLine;
			pFile.ReadLine( sLine );
			if( sLine.SubString(0,1) == "#" || sLine.IsEmpty() )
				continue;

			array<string> parsed = sLine.Split( " " );
			if( parsed.length() < 2 )
				continue;

			dCvars[parsed[0]] = parsed[1];
		}
		
		pFile.Close();
	}
}

HookReturnCode SpamTime(CBasePlayer@ pPlayer)
{
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Residual Point By Mikk & Gaftherman.\n" );
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Download this Map-Pack from scmapdb.com\n" );
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Open console to copy the link\n" );
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "  \n" );
	return HOOK_CONTINUE;
}