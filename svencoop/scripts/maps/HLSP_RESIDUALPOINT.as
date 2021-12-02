#include "residualpoint/monster_xenocrab"
#include "residualpoint/monster_zgrunt"
#include "residualpoint/monster_alien_worker"
#include "residualpoint/monster_nari_grunt"
#include "residualpoint/monster_baby_ichthyosaur"
#include "residualpoint/monster_zgrunt_dead"
#include "residualpoint/monster_civ_barney_dead"
#include "residualpoint/monster_civ_scientist_dead"
#include "residualpoint/monster_required"
#include "residualpoint/weapon_hlsatchel"
#include "residualpoint/monster_zombie_hev"
#include "residualpoint/monster_boss"
#include "residualpoint/ammo_individual"

#include "residualpoint/checkpoint_spawner"
#include "beast/teleport_zone"

#include "cubemath/item_airbubble"

bool blSpawnNpcRequired = true; // Change to true = spawn npcs required for the map when they die instead of restart the map NOTE: if enabled. archivemets will be disabled
bool bSurvivalEnabled = true;	// Change to true = survival mode enabled NOTE: if disabled. archivemets will be disabled

// Take'd from StaticCfg plugin by Outerbeast
const string configfile = "maps/rp_global_config.cfg";	// a simple configuration cfg file for the whole campaign. made'd for lazy server operators. -microphone
dictionary dCvars;
// https://github.com/Outerbeast/Addons/blob/main/StaticCfg.as

float flSurvivalStartDelay = g_EngineFuncs.CVarGetFloat( "mp_survival_startdelay" );

void MapInit()
{
	// take'd from monster_cleansuit_scientist_dead by Rick 
	ScientistCivdead::Register();
	ZombieGruntDead::Register();
	DeadCivBarney::Register();
	// https://github.com/RedSprend/svencoop_plugins/blob/master/svencoop/scripts/maps/opfor/monsters/monster_cleansuit_scientist_dead.as
	
	// Take'd from weapon_hlsatchel by JulianR0
	RegisterHLSatchel();
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
	
	// I'm too lazy to change the classname and put the model on it -Pavotherman
	XenCrab::Register();	  
	ZombieGrunt::Register();
	Configurations();
	BabyIcky::Register();
	AlienWorker::Register();
	NariGrunt::Register();
	MonsterZombieHev::Register();
	g_Game.PrecacheOther( "monster_zombie_hev" );
	g_Game.PrecacheOther( "monster_headcrab" );
	RegisterAllItems();
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
	
    if( string(g_Engine.mapname) == "rp_c13_m3a" ){
		ControllerMapInit();
	}
}

void MapActivate()
{
    if( string(g_Engine.mapname) == "rp_c13_m3a" ) // This is for Limitless potential server
	{	//  that use this custom keyvalue to prevent DynamicDifficulty change npcs health values
		CBaseEntity@ pEntity = null;
		while( ( @pEntity = g_EntityFuncs.FindEntityByClassname( pEntity, "squad*" ) ) !is null ){
			g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "$i_dyndiff_skip", "1" );
		}
		while( ( @pEntity = g_EntityFuncs.FindEntityByClassname( pEntity, "monster_*" ) ) !is null ){
			g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "$i_dyndiff_skip", "1" );
		}
	}
	
	if( blSpawnNpcRequired )
	{
		NpcRequiredStuff();
	}
	
	if( bSurvivalEnabled )
	{	/* https://github.com/Mikk155/angelscript/blob/main/plugins/SurvivalDeluxe.as */
		g_SurvivalMode.Disable();
		g_Scheduler.SetTimeout( "SurvivalModeEnable", flSurvivalStartDelay );
		g_EngineFuncs.CVarSetFloat( "mp_survival_startdelay", 0 );
		g_EngineFuncs.CVarSetFloat( "mp_survival_starton", 0 );
		g_EngineFuncs.CVarSetFloat( "mp_dropweapons", 0 );
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

void ActivateSurvival(CBaseEntity@ pActivator,CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	g_SurvivalMode.Activate();
}

HookReturnCode SpamTime(CBasePlayer@ pPlayer)
{
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Residual Point By Mikk & Gaftherman.\n" );
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Download this Map-Pack from scmapdb.com\n" );
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Open console to copy the link\n" );
	g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "  \n" );
	return HOOK_CONTINUE;
}