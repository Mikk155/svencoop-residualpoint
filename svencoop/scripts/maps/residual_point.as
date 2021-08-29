
#include "residualpoint/monster_xenocrab"
#include "residualpoint/anti_rush"

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

	RegisterAntiRushEntity();

	// I'm too lazy to change the classname and put the model on it
	XenCrab::Register();

	g_ClassicMode.SetItemMappings( @g_ItemMappings );

	//We want classic mode voting to be enabled here
	g_ClassicMode.EnableMapSupport();

	if( !ShouldRestartIfClassicModeChangesOn( g_Engine.mapname ) )
		g_ClassicMode.SetShouldRestartOnChange( false );
}
