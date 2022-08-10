// Include the entity
#include "mikk/entities/trigger_once_mp"

void MapInit()
{
	// Register the entity
	RegisterAntiRushEntity();
	
	// Precache your things
	PrecacheMyThings();
}

void PrecacheMyThings()
{
	// Precache sprites and models
	g_Game.PrecacheModel( "models/cubemath/chars/d6.mdl" );
	g_Game.PrecacheModel( "models/cubemath/chars/percent.mdl" );
	g_Game.PrecacheModel( "sprites/laserbeam.spr" );
	
	// Precache audio
	g_SoundSystem.PrecacheSound( "buttons/bell1.wav" );
	
	// Precache sprites and audio
	g_Game.PrecacheGeneric( "sprites/laserbeam.spr" );
	g_Game.PrecacheGeneric( "sound/buttons/bell1.wav" );
}

void MapStart()
{
	// Load .txt for anti-rush
	LoadFileFromAntiRush();
}