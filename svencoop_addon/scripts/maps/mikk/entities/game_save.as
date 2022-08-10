/*
	Replacemet for point_checkpoint that will save everyone's lifes and players are able to spawn if they join for first time.
	
	some code taken from Gaftherman and Outerbeast
	
	NOTE: This scripts required you to Include https://github.com/Outerbeast/Entities-and-Gamemodes/blob/master/respawndead_keepweapons.as
	
SEE LINE 320		RESPAWNDEAD_KEEPWEAPONS::ReEquipCollected( pPlayer );
*/

void RegisterGameSave()
{
	g_Hooks.RegisterHook( Hooks::Player::ClientPutInServer, @ClientPutInServer );
	g_CustomEntityFuncs.RegisterCustomEntity( "point_checkpoint", "point_checkpoint" );
	g_Game.PrecacheOther( "point_checkpoint" );

	CBaseEntity@ pTextos = null;
	dictionary keyvalues;

	keyvalues =	
	{
		{ "message", "Press the 'R' key to respawn"},
		{ "message_spanish", "Presione la tecla 'R' para reaparecer"},
		{ "message_portuguese", "Pressione a tecla 'R' para reaparecer"},
		{ "message_french", "Appuyez sur la touche 'R' pour reapparaitre"},
		{ "message_italian", "Premi il tasto 'R' per rigenerarti"},
		{ "message_esperanto", "Premu la 'R' klavon por reakiri"},
		{ "message_german", "Drucken Sie die 'R'-Taste, um zu respawnen"},
		{ "x", "-1"},
		{ "y", "0.67"},
		{ "effect", "0"},
		{ "holdtime", "1"},
		{ "fadeout", "0"},
		{ "fadein", "0"},
		{ "channel", "7"},
		{ "fxtime", "0"},
		{ "color", "255 0 0"},
		{ "color2", "100 100 100"},
		{ "spawnflags", "2"}, // No echo console + activator only
		{ "targetname", "GZ_IZL_HOWTOUSE"}
	};
	if( g_CustomEntityFuncs.IsCustomEntity( "game_text_custom" ) )
	{@pTextos = g_EntityFuncs.CreateEntity( "game_text_custom", keyvalues, true ); }
	else{ @pTextos = g_EntityFuncs.CreateEntity( "game_text", keyvalues, true ); }
}

dictionary g_WhoSpawn;

HookReturnCode ClientPutInServer( CBasePlayer@ pPlayer ) 
{
	string SteamID = g_EngineFuncs.GetPlayerAuthId(pPlayer.edict());

	if( g_SurvivalMode.IsActive() && !g_WhoSpawn.exists(SteamID) )
	{
		g_WhoSpawn[SteamID] = @pPlayer;

		g_PlayerFuncs.RespawnPlayer(pPlayer, true, true);
	}

	return HOOK_CONTINUE;
}

class PlayerKeepData
{
	float health, max_health; //Health - Max Health
	float armor, max_armor; //Armor - Max Armor
	int touched; //How many game_save we took
	int spawned = 1; //How many spawns we activated
}

dictionary g_SpawnNumber;
HUDTextParams SpawnCountHudText, SpawnHudText;

class game_save : ScriptBaseEntity  
{
    private dictionary g_IDPlayers, g_IDPlayersAlt, g_Data;

	private string strFunnelSprite = "sprites/glow01.spr";
	private string strStartSound = "ambience/particle_suck2.wav";
	private string strEndSound = "debris/beamstart7.wav";
	private string m_sActivationMusic = "../media/valve.mp3"; // Class member so it can be customisable - Outerbeast

	bool KeyValue( const string& in szKey, const string& in szValue )
	{
		if( szKey == "minhullsize" )
			g_Utility.StringToVector( self.pev.vuser1, szValue );
		else if( szKey == "maxhullsize" )
			g_Utility.StringToVector( self.pev.vuser2, szValue );
		else if( szKey == "sprite" )
			strFunnelSprite = szValue;
		else if( szKey == "startsound" )
			strStartSound = szValue;
		else if( szKey == "endsound" )
			strEndSound = szValue;
		else if( szKey == "m_sActivationMusic" ) // Key to change activation music to something other than valve theme - Outerbeast
		{
			m_sActivationMusic = szValue;
			return true;
		}
		else
			return BaseClass.KeyValue( szKey, szValue );

		return true;
	}

	void Spawn()
	{
		Precache();
		
		self.pev.movetype 		= MOVETYPE_NONE;
		self.pev.solid 			= SOLID_TRIGGER;
		
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		// Make blue if not specified.
		if( self.pev.rendercolor != g_vecZero )
		{
			self.pev.rendercolor = Vector( 255, 255, 255 );
		}

		if( !self.pev.SpawnFlagBitSet( 1 ) )
		{
			SetIcon();
			
			SetTouch( TouchFunction( this.SpawnTouch ) );
			self.pev.nextthink = g_Engine.time + 0.1f;
		}
		
		if( self.pev.vuser2 != g_vecZero && self.pev.vuser1 != g_vecZero )
		{
			g_EntityFuncs.SetSize( self.pev, Vector( -16, -16, -16 ), Vector( 16, 16, 16 ) );
		}
		
	    BaseClass.Spawn();
	}
	
	void SetIcon()
	{
		self.pev.framerate 		= 1.0f;
		
		self.pev.rendermode		= kRenderTransTexture;
		self.pev.renderamt		= 255;
		
		if( string( self.pev.model ).IsEmpty() )
			g_EntityFuncs.SetModel( self, "models/common/lambda.mdl" );
		else
			g_EntityFuncs.SetModel( self, self.pev.model );
	}

	void Precache()
	{
		// Allow for custom models
		if( string( self.pev.model ).IsEmpty() )
		{
			g_Game.PrecacheModel( "models/common/lambda.mdl" );
			g_Game.PrecacheGeneric( "models/common/lambda.mdl" );
		}
		else
		{
			g_Game.PrecacheModel( self.pev.model );
			g_Game.PrecacheGeneric( string( self.pev.model ) );
		}

		g_Game.PrecacheModel( strFunnelSprite );
		g_Game.PrecacheModel( "sprites/fexplo1.spr" ); // Outerbeast: Fix for precache host error in CreateSpawnEffect()
		g_Game.PrecacheGeneric( strFunnelSprite );

		g_SoundSystem.PrecacheSound( strStartSound );
		g_SoundSystem.PrecacheSound( strEndSound );

		g_Game.PrecacheGeneric( "sound/" + strStartSound );
		g_Game.PrecacheGeneric( "sound/" + strEndSound );
		
		g_SoundSystem.PrecacheSound( m_sActivationMusic );

		BaseClass.Precache();
	}

	void Use(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
	{
		if( !self.pev.SpawnFlagBitSet( 1 ) )
		{
			g_Scheduler.SetTimeout( this, "SpawnSnd", 1.6f );

			NetworkMessage largefunnel( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
				largefunnel.WriteByte( TE_LARGEFUNNEL );

				largefunnel.WriteCoord( self.pev.origin.x );
				largefunnel.WriteCoord( self.pev.origin.y );
				largefunnel.WriteCoord( self.pev.origin.z );

				largefunnel.WriteShort( g_EngineFuncs.ModelIndex( "" + strFunnelSprite ) );
				largefunnel.WriteShort( 0 );
			largefunnel.End();

			g_Scheduler.SetTimeout( this, "CreateCheckpoint", 6.0f );
		}
		else
		{
			g_SoundSystem.EmitSound( self.edict(), CHAN_STATIC, m_sActivationMusic, 1.0f, ATTN_NONE ); // Change to use custom activation music if set - Outerbeast
			
			g_PlayerFuncs.ClientPrintAll( HUD_PRINTTALK, "GAME SAVED: Game saved by the map\n" );
			
			self.SUB_UseTargets( self, USE_TOGGLE, 0 );
			
			SaveStore();
			
			SetThink( ThinkFunction( this.SpawnThink ) );
			
			Disabled = false;
		}
	}

	void SpawnSnd()
	{
		g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, strStartSound, 1.0f, ATTN_NORM );
	}

    void CreateCheckpoint()
    {
		g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, strEndSound, 1.0f, ATTN_NORM );
		
		SetIcon();
		
		SetTouch( TouchFunction( this.SpawnTouch ) );

		self.pev.nextthink = g_Engine.time + 0.1f;
	}
	
	bool Disabled = true;

	void SpawnTouch( CBaseEntity@ pOther )
	{
		if( !Disabled )
			return;

		if( pOther !is null && pOther.IsPlayer() && pOther.IsAlive() )
		{
			CBasePlayer@ pPlayer = cast<CBasePlayer@>( pOther ); //Cast the CBaseEntity to CBasePlayer
			string SteamID = g_EngineFuncs.GetPlayerAuthId(pPlayer.edict()); //Getting the SteamID of the player
			
			if( pPlayer is null || g_IDPlayers.exists(SteamID) || g_IDPlayersAlt.exists(SteamID)  )
				return;
			
			g_SoundSystem.EmitSound( self.edict(), CHAN_STATIC, m_sActivationMusic, 1.0f, ATTN_NONE ); // Change to use custom activation music if set - Outerbeast
			
			g_Game.AlertMessage( at_logged, "GAME SAVED: \"%1\" Game saved by \n", pOther.pev.netname );
			g_PlayerFuncs.ClientPrintAll( HUD_PRINTTALK, "Game saved by " + pOther.pev.netname + "\n" );
			
			// Trigger targets. The one who touch is the !activator -mikk
			self.SUB_UseTargets( pPlayer, USE_TOGGLE, 0 );
			
			SaveStore();
			
			SetThink( ThinkFunction( this.SpawnThink ) );
			
			Disabled = false;
		}
		
		self.pev.nextthink = g_Engine.time + 0.1f;
	}
	
	void SaveStore()
	{		
		for( int iPlayer = 1; iPlayer <= g_PlayerFuncs.GetNumPlayers(); ++iPlayer )
		{
			CBasePlayer@ allPlayers = g_PlayerFuncs.FindPlayerByIndex( iPlayer );

			if( allPlayers is null || !allPlayers.IsConnected() )
				continue;
			
			string SteamID = g_EngineFuncs.GetPlayerAuthId(allPlayers.edict()); //Getting the SteamID of the player
			PlayerKeepData@ pData = GetPlayerSpawn(allPlayers);
			g_Data[SteamID] = ++pData.touched; //What number of spawn is this for the player
			pData.health = allPlayers.pev.health; //Save health at the moment
			pData.max_health = allPlayers.pev.max_health; //Save Max Health at the moment
			pData.armor = allPlayers.pev.armorvalue; //Save Armor at the moment
			pData.max_armor = allPlayers.pev.armortype; //Save Max Armor at the moment

			g_IDPlayers[SteamID] = @allPlayers; //Save SteamID and player entity
		}
	}
	
	void SpawnThink()
	{
		if ( self.pev.renderamt > 0 )
		{
			self.pev.renderamt -= 10;
		}
		
		if ( self.pev.renderamt < 10 )
		{
			self.pev.effects |= EF_NODRAW;
		}
		
		for( int iPlayer = 1; iPlayer <= g_PlayerFuncs.GetNumPlayers(); ++iPlayer )
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( iPlayer );

			if( pPlayer is null || !pPlayer.IsConnected() )
				continue;

			PlayerKeepData@ pData = GetPlayerSpawn(pPlayer); //Getting the data saved of the player
            string SteamID = g_EngineFuncs.GetPlayerAuthId(pPlayer.edict()); //Getting the SteamID of the player

			SpawnCountHUDText(pPlayer, pData); //Message of how many spawns he has

			if( !pPlayer.IsAlive() && pPlayer.GetObserver().IsObserver() && g_IDPlayers.exists(SteamID) )
			{
				SpawnHUDText(pPlayer, pData); //Message of what he need to do to spawn
				if( int(g_Data[SteamID]) == pData.spawned && pPlayer.pev.button & IN_RELOAD != 0 )
				{
					pPlayer.GetObserver().RemoveDeadBody(); //Remove the dead player body
					//pPlayer.SetOrigin( self.Center() ); //Move the player to the center of the brush
					//pPlayer.Revive(); //Revive the player
					//const uint32 Hooks::Player::GetPlayerSpawnSpot
					g_PlayerFuncs.RespawnPlayer( pPlayer, false, true );
					
					// Must include https://github.com/Outerbeast/Entities-and-Gamemodes/blob/master/respawndead_keepweapons.as
					RESPAWNDEAD_KEEPWEAPONS::ReEquipCollected( pPlayer );
					
					g_SoundSystem.EmitSound( self.edict(), CHAN_STATIC, strEndSound, 1.0f, ATTN_NORM );
					
					int iBeamCount = 8;
					Vector vBeamColor = Vector(217,226,146);
					int iBeamAlpha = 128;
					float flBeamRadius = 256;

					Vector vLightColor = Vector(39,209,137);
					float flLightRadius = 160;

					Vector vStartSpriteColor = Vector(65,209,61);
					float flStartSpriteScale = 1.0f;
					float flStartSpriteFramerate = 12;
					int iStartSpriteAlpha = 255;

					Vector vEndSpriteColor = Vector(159,240,214);
					float flEndSpriteScale = 1.0f;
					float flEndSpriteFramerate = 12;
					int iEndSpriteAlpha = 255;

					// create the clientside effect

					NetworkMessage msg( MSG_PVS, NetworkMessages::TE_CUSTOM, pPlayer.pev.origin );
						msg.WriteByte( 2 /*TE_C_XEN_PORTAL*/ );
						msg.WriteVector( pPlayer.pev.origin );
						// for the beams
						msg.WriteByte( iBeamCount );
						msg.WriteVector( vBeamColor );
						msg.WriteByte( iBeamAlpha );
						msg.WriteCoord( flBeamRadius );
						// for the dlight
						msg.WriteVector( vLightColor );
						msg.WriteCoord( flLightRadius );
						// for the sprites
						msg.WriteVector( vStartSpriteColor );
						msg.WriteByte( int( flStartSpriteScale*10 ) );
						msg.WriteByte( int( flStartSpriteFramerate ) );
						msg.WriteByte( iStartSpriteAlpha );
						
						msg.WriteVector( vEndSpriteColor );
						msg.WriteByte( int( flEndSpriteScale*10 ) );
						msg.WriteByte( int( flEndSpriteFramerate ) );
						msg.WriteByte( iEndSpriteAlpha );
					msg.End();
					
					++pData.spawned;

					pPlayer.pev.health = Math.max( 1, pData.health ); //Set Health saved to the player
					pPlayer.pev.max_health = Math.max( 100, pData.max_health ); //Set Max Health saved to the player
					pPlayer.pev.armorvalue = Math.max( 0, pData.armor ); //Set Armor saved to the player
					pPlayer.pev.armortype = Math.max( 100, pData.max_armor ); //Set Max Armor saved to the player

					g_IDPlayers.delete(SteamID); //Delete the old SteamID in the g_IDPlayers dictionary
					g_IDPlayersAlt[SteamID] = @pPlayer; //Save the SteamID in the g_IDPlayersAlt dictionary

					//Why we do that?
					//Because that's the easier way to prevent an infinitive spawn cycle -Gaf El Hombre R (pero mal escrito)
				}
			}
        }
        
        self.pev.nextthink = g_Engine.time + 0.1f; //per frame
    }

	void SpawnCountHUDText( CBasePlayer@ pPlayer, PlayerKeepData@ pData )
	{
		if( (pData.touched-(pData.spawned-1) ) == 0)
		return;
		
		SpawnCountHudText.x = 0.05;
		SpawnCountHudText.y = 0.05;
		SpawnCountHudText.effect = 0;
		SpawnCountHudText.r1 = RGBA_SVENCOOP.r;
		SpawnCountHudText.g1 = RGBA_SVENCOOP.g;
		SpawnCountHudText.b1 = RGBA_SVENCOOP.b;
		SpawnCountHudText.a1 = 0;
		SpawnCountHudText.r2 = RGBA_SVENCOOP.r;
		SpawnCountHudText.g2 = RGBA_SVENCOOP.g;
		SpawnCountHudText.b2 = RGBA_SVENCOOP.b;
		SpawnCountHudText.a2 = 0;
		SpawnCountHudText.fadeinTime = 0; 
		SpawnCountHudText.fadeoutTime = 0.25;
		SpawnCountHudText.holdTime = 0.2;
		SpawnCountHudText.fxTime = 0;
		SpawnCountHudText.channel = 6;

		g_PlayerFuncs.HudMessage(pPlayer, SpawnCountHudText, "Spawns: " + (pData.touched-(pData.spawned-1)));
	}

	void SpawnHUDText( CBasePlayer@ pPlayer, PlayerKeepData@ pData )
	{
		g_EntityFuncs.FireTargets( "GZ_IZL_HOWTOUSE", pPlayer, pPlayer, USE_TOGGLE ); // Multi language message -mikk
	}

	PlayerKeepData@ GetPlayerSpawn(CBasePlayer@ pPlayer)
	{
		string SteamID = g_EngineFuncs.GetPlayerAuthId(pPlayer.edict());

		if( !g_SpawnNumber.exists(SteamID) )
		{
			PlayerKeepData pData;
			g_SpawnNumber[SteamID] = pData;
		}

		return cast<PlayerKeepData@>( g_SpawnNumber[SteamID] );
	}
}