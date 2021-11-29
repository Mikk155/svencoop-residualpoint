#include "residualpoint/monster_xenocrab"
#include "residualpoint/monster_zgrunt"
#include "residualpoint/monster_alien_worker"
#include "residualpoint/monster_nari_grunt"
#include "residualpoint/monster_baby_ichthyosaur"
#include "residualpoint/monster_zgrunt_dead"
#include "residualpoint/monster_civ_barney_dead"
#include "residualpoint/monster_civ_scientist_dead"
#include "residualpoint/monster_required"
//#include "residualpoint/weapon_hlsatchel"

#include "residualpoint/checkpoint_spawner"
#include "beast/teleport_zone"

#include "cubemath/item_airbubble"

bool blSpawnNpcRequired = true; // Change to true = spawn npcs required for the map when they die instead of restart the map

// Take'd from StaticCfg plugin by Outerbeast
const string configfile = "maps/rp_global_config.cfg";	// a simple configuration cfg file for the whole campaign. made'd for lazy server operators. -microphone
dictionary dCvars;
// https://github.com/Outerbeast/Addons/blob/main/StaticCfg.as

void MapInit()
{
	// I'm too lazy to change the classname and put the model on it -Pavotherman
	XenCrab::Register();	  
	ZombieGrunt::Register();
	
	// take'd from monster_cleansuit_scientist_dead by Rick 
	ScientistCivdead::Register();
	ZombieGruntDead::Register();
	DeadCivBarney::Register();
	// https://github.com/RedSprend/svencoop_plugins/blob/master/svencoop/scripts/maps/opfor/monsters/monster_cleansuit_scientist_dead.as
	
	BabyIcky::Register();
	AlienWorker::Register();
	NariGrunt::Register();
	
	// Take'd from weapon_hlsatchel by JulianR0
//	RegisterHLSatchel();
	/* idk no precacha
	g_Game.PrecacheModel( "models/v_satchel.mdl" );
	g_Game.PrecacheModel( "models/p_satchel.mdl" );
	g_Game.PrecacheModel( "models/w_satchel.mdl" );
	g_Game.PrecacheGeneric( "models/v_satchel.mdl" );
	g_Game.PrecacheGeneric( "models/p_satchel.mdl" );
	g_Game.PrecacheGeneric( "models/w_satchel.mdl" );
	g_Game.PrecacheModel( "models/v_satchel_radio.mdl" );
	g_Game.PrecacheModel( "models/p_satchel_radio.mdl" );
	g_Game.PrecacheGeneric( "models/v_satchel_radio.mdl" );
	g_Game.PrecacheGeneric( "models/p_satchel_radio.mdl" );*/
	// https://github.com/JulianR0/TPvP/blob/master/src/map_scripts/hl_weapons/weapon_hlsatchel.as
	
	Configurations();
	
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

void MapActivate()
{
	if( blSpawnNpcRequired )
	{
		NpcRequiredStuff();
	}
}

void Configurations()
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