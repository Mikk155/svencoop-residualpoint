/*
+ Created by Gaftherman and Mikk
+
+ What the heck do this script?
+
+ This script does is allow ammo/items to be taken once per player.
+
+ Reference:
+ https://github.com/adslbarxatov/xash3d-for-ESHQ
+ https://github.com/adslbarxatov/xash3d-for-ESHQ/blob/master/DLLS/healthkit.cpp
+ https://github.com/adslbarxatov/xash3d-for-ESHQ/blob/master/DLLS/items.cpp
+
*/

//default Ammo ( Me lo robe de Ins2 XD )
//9mm
const string DF_AMMO_9MM	= "9mm";
const int DF_MAX_CARRY_9MM	= 250;
const int DF_GIVEAMMO_9MMAR = 30;
const int DF_GIVEAMMO_GLOCK = 17;
//buckshot
const string DF_AMMO_BUCK	= "buckshot";
const int DF_MAX_CARRY_BUCK	= 125;
const int DF_GIVEAMMO_BUCK = 8;
//ARgrenades
const string DF_AMMO_ARGR	= "ARgrenades";
const int DF_MAX_CARRY_ARGR	= 10;
const int DF_GIVEAMMO_ARGR  = 2;
//357
const string DF_AMMO_357	= "357";
const int DF_MAX_CARRY_357	= 36;
//556
const string DF_AMMO_556	= "556";
const int DF_MAX_CARRY_556	= 600;
//rockets
const string DF_AMMO_RKT	= "rockets";
const int DF_MAX_CARRY_RKT	= 5;
const int DF_MAX_CARRY_RKT2	= 10;
//uranium
const string DF_AMMO_URAN	= "uranium";
const int DF_MAX_CARRY_URAN	= 100;

class ammo_9mmclip_individual : ScriptBasePlayerItemEntity
{	
	dictionary g_MaxPlayers;

	void Spawn()
	{ 
		Precache();

		if( self.SetupModel() == false )
			g_EntityFuncs.SetModel( self, "models/w_9mmclip.mdl" );
		else //Custom model
			g_EntityFuncs.SetModel( self, self.pev.model );

		BaseClass.Spawn();
	}
	
	void Precache()
	{
		BaseClass.Precache();

		if( string( self.pev.model ).IsEmpty() )
			g_Game.PrecacheModel("models/w_9mmclip.mdl");
		else //Custom model
			g_Game.PrecacheModel( self.pev.model );

		g_SoundSystem.PrecacheSound("items/9mmclip1.wav");
	}
	
	bool AddAmmo( CBasePlayer@ pPlayer, int GiveAmmo = DF_GIVEAMMO_GLOCK, string Type = DF_AMMO_9MM, int MaxAmmo = DF_MAX_CARRY_9MM ) 
	{ 
        string steamId = g_EngineFuncs.GetPlayerAuthId(pPlayer.edict());

		if( pPlayer is null  )
			return false;

		if( !g_MaxPlayers.exists(steamId) )
		{
			g_MaxPlayers[steamId] = @pPlayer;

			if (pPlayer.GiveAmmo( GiveAmmo, Type, MaxAmmo ) != -1)
			{
				g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM);
				return true;
			}
		}
		return false;
	}

	void Touch( CBaseEntity@ pOther )
	{
		if( pOther is null || !pOther.IsPlayer() || !pOther.IsAlive() )
			return;
				
		AddAmmo( cast<CBasePlayer@>( pOther ));
	}
		
	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if (pActivator.IsPlayer())
		{
			AddAmmo( cast<CBasePlayer@>( pActivator ));
		}
	}	
}

class ammo_9mmAR_individual : ScriptBasePlayerItemEntity
{	
	dictionary g_MaxPlayers;

	void Spawn()
	{ 
		Precache();

		if( self.SetupModel() == false )
			g_EntityFuncs.SetModel( self, "models/w_mp5_clip.mdl" );
		else //Custom model
			g_EntityFuncs.SetModel( self, self.pev.model );

		BaseClass.Spawn();
	}
	
	void Precache()
	{
		BaseClass.Precache();

		if( string( self.pev.model ).IsEmpty() )
			g_Game.PrecacheModel("models/w_mp5_clip.mdl");
		else //Custom model
			g_Game.PrecacheModel( self.pev.model );

		g_SoundSystem.PrecacheSound("items/9mmclip1.wav");
	}
	
	bool AddAmmo( CBasePlayer@ pPlayer, int GiveAmmo = DF_GIVEAMMO_9MMAR, string Type = DF_AMMO_9MM, int MaxAmmo = DF_MAX_CARRY_9MM ) 
	{ 
        string steamId = g_EngineFuncs.GetPlayerAuthId(pPlayer.edict());

		if( pPlayer is null  )
			return false;

		if( !g_MaxPlayers.exists(steamId) )
		{
			g_MaxPlayers[steamId] = @pPlayer;

			if (pPlayer.GiveAmmo( GiveAmmo, Type, MaxAmmo ) != -1)
			{
				g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM);
				return true;
			}
		}
		return false;
	}

	void Touch( CBaseEntity@ pOther )
	{
		if( pOther is null || !pOther.IsPlayer() || !pOther.IsAlive() )
			return;
				
		AddAmmo( cast<CBasePlayer@>( pOther ));
	}
		
	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if (pActivator.IsPlayer())
		{
			AddAmmo( cast<CBasePlayer@>( pActivator ));
		}
	}	
}

class ammo_buckshot_individual : ScriptBasePlayerItemEntity
{	
	dictionary g_MaxPlayers;

	void Spawn()
	{ 
		Precache();

		if( self.SetupModel() == false )
			g_EntityFuncs.SetModel( self, "models/w_shotbox.mdl" );
		else //Custom model
			g_EntityFuncs.SetModel( self, self.pev.model );

		BaseClass.Spawn();
	}
	
	void Precache()
	{
		BaseClass.Precache();

		if( string( self.pev.model ).IsEmpty() )
			g_Game.PrecacheModel("models/w_shotbox.mdl");
		else //Custom model
			g_Game.PrecacheModel( self.pev.model );

		g_SoundSystem.PrecacheSound("items/9mmclip1.wav");
	}
	
	bool AddAmmo( CBasePlayer@ pPlayer, int GiveAmmo = DF_GIVEAMMO_BUCK, string Type = DF_AMMO_BUCK, int MaxAmmo = DF_MAX_CARRY_BUCK ) 
	{ 
        string steamId = g_EngineFuncs.GetPlayerAuthId(pPlayer.edict());

		if( pPlayer is null  )
			return false;

		if( !g_MaxPlayers.exists(steamId) )
		{
			g_MaxPlayers[steamId] = @pPlayer;

			if (pPlayer.GiveAmmo( GiveAmmo, Type, MaxAmmo ) != -1)
			{
				g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM);
				return true;
			}
		}
		return false;
	}

	void Touch( CBaseEntity@ pOther )
	{
		if( pOther is null || !pOther.IsPlayer() || !pOther.IsAlive() )
			return;
				
		AddAmmo( cast<CBasePlayer@>( pOther ));
	}
		
	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if (pActivator.IsPlayer())
		{
			AddAmmo( cast<CBasePlayer@>( pActivator ));
		}
	}	
}

class ammo_ARgrenades_individual : ScriptBasePlayerItemEntity
{	
	dictionary g_MaxPlayers;

	void Spawn()
	{ 
		Precache();

		if( self.SetupModel() == false )
			g_EntityFuncs.SetModel( self, "models/w_argrenade.mdl" );
		else //Custom model
			g_EntityFuncs.SetModel( self, self.pev.model );

		BaseClass.Spawn();
	}
	
	void Precache()
	{
		BaseClass.Precache();

		if( string( self.pev.model ).IsEmpty() )
			g_Game.PrecacheModel("models/w_argrenade.mdl");
		else //Custom model
			g_Game.PrecacheModel( self.pev.model );

		g_SoundSystem.PrecacheSound("items/9mmclip1.wav");
	}
	
	bool AddAmmo( CBasePlayer@ pPlayer, int GiveAmmo = DF_GIVEAMMO_ARGR, string Type = DF_AMMO_ARGR, int MaxAmmo = DF_MAX_CARRY_ARGR ) 
	{ 
        string steamId = g_EngineFuncs.GetPlayerAuthId(pPlayer.edict());

		if( pPlayer is null  )
			return false;

		if( !g_MaxPlayers.exists(steamId) )
		{
			g_MaxPlayers[steamId] = @pPlayer;

			if (pPlayer.GiveAmmo( GiveAmmo, Type, MaxAmmo ) != -1)
			{
				g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM);
				return true;
			}
		}
		return false;
	}

	void Touch( CBaseEntity@ pOther )
	{
		if( pOther is null || !pOther.IsPlayer() || !pOther.IsAlive() )
			return;
				
		AddAmmo( cast<CBasePlayer@>( pOther ));
	}
		
	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if (pActivator.IsPlayer())
		{
			AddAmmo( cast<CBasePlayer@>( pActivator ));
		}
	}	
}

class item_battery_individual : ScriptBasePlayerItemEntity
{
	dictionary g_MaxPlayers;

	void Spawn()
	{ 
		Precache();

		if( self.SetupModel() == false )
			g_EntityFuncs.SetModel( self, "models/mil_crate.mdl" );
		else //Custom model
			g_EntityFuncs.SetModel( self, self.pev.model );

		switch( Math.RandomLong( 0, 2 ) )
		{
			case 0: self.pev.body = 7;
			break;

			case 1: self.pev.body = 8;
			break;

			case 2: self.pev.body = 11;
			break;
		}

		BaseClass.Spawn();
	}

	void Precache()
	{
		BaseClass.Precache();

		if( string( self.pev.model ).IsEmpty() )
			g_Game.PrecacheModel("models/mil_crate.mdl");
		else //Custom model
			g_Game.PrecacheModel( self.pev.model );

		g_SoundSystem.PrecacheSound("items/gunpickup2.wav");
	}
		
	void AddArmor( CBasePlayer@ pPlayer )
	{	
        string steamId = g_EngineFuncs.GetPlayerAuthId(pPlayer.edict());
        int pct;

		if( pPlayer is null || pPlayer.pev.armorvalue >= 100 && pPlayer.HasSuit() || !pPlayer.HasSuit() || g_MaxPlayers.exists(steamId)  )
			return;
		
        g_MaxPlayers[steamId] = @pPlayer;

		pPlayer.pev.armorvalue += int(g_EngineFuncs.CVarGetFloat( "sk_battery" ));
		pPlayer.pev.armorvalue = Math.min( pPlayer.pev.armorvalue, 100 );

		//Battery sound
		g_SoundSystem.EmitSound( pPlayer.edict(), CHAN_ITEM, "items/gunpickup2.wav", 1, ATTN_NORM );
					
		NetworkMessage msg( MSG_ONE, NetworkMessages::ItemPickup, pPlayer.edict() );
			msg.WriteString( "item_battery" );
		msg.End();

		// Suit reports new power level
		// For some reason this wasn't working in release build -- round it.
		pct = int(float(pPlayer.pev.armorvalue * 100.0) * (1.0 / 100) + 0.5);
		pct = (pct / 5);
		if (pct > 0)
			pct--;

		//EMIT_SOUND_SUIT(ENT(pev), szcharge);
		pPlayer.SetSuitUpdate( "!HEV_" + pct + "P", false, 30 );
				
		// Trigger targets
		self.SUB_UseTargets( pPlayer, USE_TOGGLE, 0 );
	}

	void Touch( CBaseEntity@ pOther )
	{
		if( pOther is null || !pOther.IsPlayer() || !pOther.IsAlive() )
			return;
				
		AddArmor( cast<CBasePlayer@>( pOther ) );
	}
		
	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if (pActivator.IsPlayer())
		{
			AddArmor( cast<CBasePlayer@>( pActivator ) );
		}
	}		
}

class item_healthkit_individual : ScriptBasePlayerItemEntity
{
	dictionary g_MaxPlayers;

	void Spawn()
	{ 
		Precache();

		if( self.SetupModel() == false )
			g_EntityFuncs.SetModel( self, "models/w_medkit.mdl" );
		else //Custom model
			g_EntityFuncs.SetModel( self, self.pev.model );

		BaseClass.Spawn();
	}

	void Precache()
	{
		BaseClass.Precache();

		if( string( self.pev.model ).IsEmpty() )
			g_Game.PrecacheModel("models/w_medkit.mdl");
		else //Custom model
			g_Game.PrecacheModel( self.pev.model );

		g_SoundSystem.PrecacheSound("items/smallmedkit1.wav");
	}
		
	void AddHealth( CBasePlayer@ pPlayer )
	{	
        string steamId = g_EngineFuncs.GetPlayerAuthId(pPlayer.edict());

		if( pPlayer is null || pPlayer.pev.health >= 100 || g_MaxPlayers.exists(steamId)  )
			return;
		
	    if( pPlayer.TakeHealth( int(g_EngineFuncs.CVarGetFloat( "sk_healthkit" )), DMG_GENERIC) )
		{
            g_MaxPlayers[steamId] = @pPlayer;

			NetworkMessage message( MSG_ONE, NetworkMessages::ItemPickup, pPlayer.edict() );
				message.WriteString( "item_healthkit" );
			message.End();

		    g_SoundSystem.EmitSound( pPlayer.edict(), CHAN_ITEM, "items/smallmedkit1.wav", 1, ATTN_NORM );

            // Trigger targets
            self.SUB_UseTargets( pPlayer, USE_TOGGLE, 0 );
        }
	}

	void Touch( CBaseEntity@ pOther )
	{
		if( pOther is null || !pOther.IsPlayer() || !pOther.IsAlive() )
			return;
				
		AddHealth( cast<CBasePlayer@>( pOther ) );
	}
		
	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if (pActivator.IsPlayer())
		{
			AddHealth( cast<CBasePlayer@>( pActivator ) );
		}
	}		
}

void CustomAmmoGlock()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "ammo_9mmclip_individual", "ammo_9mmclip_individual" );
	g_CustomEntityFuncs.RegisterCustomEntity( "ammo_9mmclip_individual", "ammo_9mm_individual" );
	g_CustomEntityFuncs.RegisterCustomEntity( "ammo_9mmclip_individual", "ammo_9mm_individual" );
    g_ItemRegistry.RegisterItem( "ammo_9mmclip_individual", "" );
    g_ItemRegistry.RegisterItem( "ammo_9mm_individual", "" );
    g_ItemRegistry.RegisterItem( "ammo_glock_individual", "" );
	g_Game.PrecacheOther( "ammo_9mmclip_individual" );
	g_Game.PrecacheOther( "ammo_9mm_individual" );
	g_Game.PrecacheOther( "ammo_9mm_individual" );
}

void CustomAmmo9mmAR()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "ammo_9mmAR_individual", "ammo_9mmAR_individual" );
    g_ItemRegistry.RegisterItem( "ammo_9mmAR_individual", "" );
	g_Game.PrecacheOther( "ammo_9mmAR_individual" );
}

void CustomAmmoBuckshot()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "ammo_buckshot_individual", "ammo_buckshot_individual" );
    g_ItemRegistry.RegisterItem( "ammo_buckshot_individual", "" );
	g_Game.PrecacheOther( "ammo_buckshot_individual" );
}

void CustomAmmoARgrenades()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "ammo_ARgrenades_individual", "ammo_ARgrenades_individual" );
    g_ItemRegistry.RegisterItem( "ammo_ARgrenades_individual", "" );
	g_Game.PrecacheOther( "ammo_ARgrenades_individual" );
}

void CustomBattery()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "item_battery_individual", "item_battery_individual" );
	g_CustomEntityFuncs.RegisterCustomEntity( "item_battery_individual", "item_helmet_individual" );
	g_CustomEntityFuncs.RegisterCustomEntity( "item_battery_individual", "item_armorvest_individual" );
	g_ItemRegistry.RegisterItem( "item_battery_individual", "" );
    g_ItemRegistry.RegisterItem( "item_helmet_individual", "" );
    g_ItemRegistry.RegisterItem( "item_armorvest_individual", "" );
	g_Game.PrecacheOther( "item_battery_individual" );
	g_Game.PrecacheOther( "item_helmet_individual" );
	g_Game.PrecacheOther( "item_armorvest_individual" );
}

void CustomHealthkit()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "item_healthkit_individual", "item_healthkit_individual" );
    g_ItemRegistry.RegisterItem( "item_healthkit_individual", "" );
	g_Game.PrecacheOther( "item_healthkit_individual" );
}

void RegisterAllItems()
{
	CustomAmmoGlock();
	CustomAmmo9mmAR();
	CustomAmmoBuckshot();
	CustomAmmoARgrenades();
	CustomBattery();
	CustomHealthkit();
}