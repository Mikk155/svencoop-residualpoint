
#include "residualpoint/monster_xenocrab"

array<ItemMapping@> g_ItemMappings = { ItemMapping( "weapon_m16", "weapon_9mmAR" ) };


bool ShouldRestartIfClassicModeChangesOn( const string& in szMapName )
{
	return 

	szMapName != "" && 
	szMapName != "" && 
	szMapName != "" && 
	szMapName != "" && 
	szMapName != ""; //<- Nombre de los mapas del tren (Despues de que terminen todos los mapas pueda comenzar el classicmode sin la necesidad de hacer restart)
}

void MapInit()
{
	// I'm too lazy to change the classname and put the model on it
	XenCrab::Register();

	g_ClassicMode.SetItemMappings( @g_ItemMappings );

	//We want classic mode voting to be enabled here
	g_ClassicMode.EnableMapSupport();

	if( !ShouldRestartIfClassicModeChangesOn( g_Engine.mapname ) )
		g_ClassicMode.SetShouldRestartOnChange( false );
}
