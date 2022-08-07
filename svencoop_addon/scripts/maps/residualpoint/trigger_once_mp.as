/*
*	Original Script by Cubemath
*	Modified a bit by mikk & gaftherman
*
*	USAGE: 
*	
*	spawnflags 1 meant the script will be Off until trigger.
*	  no messages shown. useful for backward-maps style.
*
*	"health" defines how many time this entity need to be triggered to enable the percentage area.
*	  used for "skull" method. same as game_counter.
*
*	"message" will show a custom message of your own on the game_text.
*	  use in conjunction with "health" value of how many tasks you want to fire this entity.
*
*	"killtarget" self explain
*
*	"percent" or "m_flPercentage" (for legacy) is used to speficy percentage.
*	  leave it empty for 66%
*
*	"model" defines a brush model to use boundaries instead
*	  if mappig just tie to entity any brush.
*
*	"blipsound" defines the sound when the entity conditions are true. NOTE: If using the external file method. make sure to precache the sound at MapInit first x[
*	  default is bell1.wav. Precached at MapInit
*
*	"frags" will start a countdown with the value specified once the percentage is true (if leave = countdown stop at current time)
*	  when countdown reach 0 it'll fire its target.
*	
*	This script will create a env_render_individual intermediary for your effects.
*	  Name your env_beam/item_generic as "your trigger_once's target" + "_FX"
*	  Now only players inside the zone will see the efects while outside ones will not see those spoiler icons for new maps.
*	    -Idea Sparks
*
*	"netname" must be a brush model value i.e "*255" for lock doors, butons, or anything with "master" keyvalue.
*/

void RegisterAntiRushEntity() 
{
	g_CustomEntityFuncs.RegisterCustomEntity( "trigger_once_mp", "trigger_once_mp" );
	
	// Cuz spawned via MapStart x[
	g_SoundSystem.PrecacheSound( "buttons/bell1.wav" );
	g_Game.PrecacheGeneric( "sound/buttons/bell1.wav" );
}

/*
	Suggestions:
	-
	
	Place here your suggestions
	-
	
	a vote for toggle antirush- 
	if antirush is disabled use function Touch() for trigger its target and self-remove. 
	so when it gets ON via vote only non-reached entities are functional.
*/


enum trigger_once_flag
{
    SF_AR_START_OFF = 1 << 0
}

class trigger_once_mp : ScriptBaseEntity 
{
	private float frags = 0.0;
	private float m_flPercentage = 0.66; //Percentage of living people to be inside trigger to trigger
	private string killtarget	= "";
	private string strSound = "buttons/bell1.wav";
	
	bool BlIsEnabled = true;
	
	bool KeyValue( const string& in szKey, const string& in szValue ) 
	{
		if( szKey == "percent" || szKey == "m_flPercentage" ) 
		{
			m_flPercentage = atof( szValue );
			return true;
		} 
		else if( szKey == "minhullsize" ) 
		{
			g_Utility.StringToVector( self.pev.vuser1, szValue );
			return true;
		} 
		else if( szKey == "maxhullsize" ) 
		{
			g_Utility.StringToVector( self.pev.vuser2, szValue );
			return true;
		}
		else if( szKey == "killtarget" )
		{
            killtarget = szValue;
			return true;
		}
		else if( szKey == "blipsound" )
		{
			strSound = szValue;
			return true;
		}
		else 
			return BaseClass.KeyValue( szKey, szValue );
	}

	void Precache()
	{
		g_SoundSystem.PrecacheSound( strSound );

		g_Game.PrecacheGeneric( "sound/" + strSound );

		BaseClass.Precache();
	}
	
	void Spawn() 
	{
        self.Precache();

        self.pev.movetype = MOVETYPE_NONE;
        self.pev.solid = SOLID_NOT;
		self.pev.effects = EF_NODRAW;

        if( self.GetClassname() == "trigger_once_mp" && string( self.pev.model )[0] == "*" && self.IsBSPModel() )
        {
            g_EntityFuncs.SetModel( self, self.pev.model );
            g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
        }
		else
		{
			g_EntityFuncs.SetSize( self.pev, self.pev.vuser1, self.pev.vuser2 );		
		}

		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		if( !string( self.pev.targetname ).IsEmpty() )
		{
			BlIsEnabled = false;
		}

        if( !self.pev.SpawnFlagBitSet( SF_AR_START_OFF ) )
		{
			SetThink( ThinkFunction( this.TriggerThink ) );
			self.pev.nextthink = g_Engine.time + 0.1f;
		}

		CreateMasterTarget();
		CreateFXIndividual();
		CreateGameTextMLan();
		CreateLockerForMMS();
		
        BaseClass.Spawn();
	}

    void Use(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float value)
    {
        if( self.pev.SpawnFlagBitSet( SF_AR_START_OFF ) )
		{	
			SetThink( ThinkFunction( this.TriggerThink ) );
			self.pev.nextthink = g_Engine.time + 0.1f;
		}
		else
		{
			self.pev.health -= 1;
		}
	}

/*	void Touch( CBaseEntity@ pOther )
	{
	}*/
	
	void TriggerThink() 
	{
		float TotalPlayers = 0, PlayersTrigger = 0, CurrentPercentage = 0;

		for( int iPlayer = 1; iPlayer <= g_PlayerFuncs.GetNumPlayers(); ++iPlayer )
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( iPlayer );
				
			if( pPlayer is null || !pPlayer.IsConnected() || !pPlayer.IsAlive() )
				continue;

			if( Inside( pPlayer ) )
				PlayersTrigger = PlayersTrigger + 1.0f;
					
			TotalPlayers = TotalPlayers + 1.0f;	
		}

		if(TotalPlayers > 0) 
		{
			CurrentPercentage = PlayersTrigger / TotalPlayers + 0.00001f;

			CBaseEntity@ pText = null;
			
			for( int iPlayer = 1; iPlayer <= g_PlayerFuncs.GetNumPlayers(); ++iPlayer )
			{
				CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( iPlayer );

				if( pPlayer is null || !pPlayer.IsConnected() || !pPlayer.IsAlive() )
					continue;

				if( Inside( pPlayer ) )
				{
					g_EntityFuncs.FireTargets( ""+self.pev.target+"_TEXT", pPlayer, pPlayer, USE_TOGGLE ); // Multi language message -mikk
					g_EntityFuncs.FireTargets( "FX_" + self.pev.target, pPlayer, pPlayer, USE_TOGGLE ); // Don't spoiler outside people
					
					if( BlIsEnabled and CurrentPercentage <= m_flPercentage and self.pev.health <= 0 )
					{
						while((@pText = g_EntityFuncs.FindEntityByTargetname(pText, ""+self.pev.target+"_TEXT")) !is null)
						{
							edict_t@ pEdict = pText.edict();
							g_EntityFuncs.DispatchKeyValue( pEdict, "message", "ANTI-RUSH: " + int(m_flPercentage*100) + "% Of players needed to continue. Current: "+ int(CurrentPercentage*100) + "%\n" );
							g_EntityFuncs.DispatchKeyValue( pEdict, "message_spanish", "ANTI-RUSH: " + int(m_flPercentage*100) + "% De jugadores necesario para continuar. Actual: "+ int(CurrentPercentage*100) + "%\n" );
							g_EntityFuncs.DispatchKeyValue( pEdict, "message_portuguese", "ANTI-RUSH: " + int(m_flPercentage*100) + "% De jogadores necessarios para continuar. Atual: "+ int(CurrentPercentage*100) + "%\n" );
						}
					}
					
					if( self.pev.health != 0 and self.pev.message == "" )
					{
						while((@pText = g_EntityFuncs.FindEntityByTargetname(pText, ""+self.pev.target+"_TEXT")) !is null)
						{
							edict_t@ pEdict = pText.edict();
							g_EntityFuncs.DispatchKeyValue( pEdict, "message", "ANTI-RUSH: Kill remaining " + self.pev.health + " enemies for progress.\n" );
							g_EntityFuncs.DispatchKeyValue( pEdict, "message_spanish", "ANTI-RUSH: Elimina los " + self.pev.health + " enemigos restantes para continuar.\n" );
							g_EntityFuncs.DispatchKeyValue( pEdict, "message_portuguese", "ANTI-RUSH: Mate " + self.pev.health + " inimigos restantes para continuar.\n" );
						}
					}
				}
				else{
					g_EntityFuncs.FireTargets( "FX_RETURN_" + self.pev.target, pPlayer, pPlayer, USE_TOGGLE ); // Don't spoiler outside people
				}
			}
			
			
			if( BlIsEnabled and CurrentPercentage >= m_flPercentage ) 
			{
				if( self.pev.frags > 0 )
				{
					while((@pText = g_EntityFuncs.FindEntityByTargetname(pText, ""+self.pev.target+"_TEXT")) !is null)
					{
						edict_t@ pEdict = pText.edict();
						g_EntityFuncs.DispatchKeyValue( pEdict, "message", "ANTI-RUSH: Count-down: " + self.pev.frags );
						g_EntityFuncs.DispatchKeyValue( pEdict, "message_spanish", "ANTI-RUSH: Cuenta-regresiva: " + self.pev.frags );
						g_EntityFuncs.DispatchKeyValue( pEdict, "message_portuguese", "ANTI-RUSH: Contagem-regressiva: " + self.pev.frags );
					}
					self.pev.frags -= 0.1;
				}
				else
				{
					g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, strSound, 1.0f, ATTN_NORM );
						
					if( killtarget != "" && killtarget != self.GetTargetname() )
					{
						do g_EntityFuncs.Remove( g_EntityFuncs.FindEntityByTargetname( null, killtarget ) );
						while( g_EntityFuncs.FindEntityByTargetname( null, killtarget ) !is null );
					}

					self.SUB_UseTargets( @self, USE_TOGGLE, 0 );

					g_EntityFuncs.Remove( self );
				}
			}
			
			if( self.pev.health <= 0 )
				BlIsEnabled = true;
		}
		
		self.pev.nextthink = g_Engine.time + 0.1f;
	}
	
	void CreateFXIndividual()
	{
		dictionary myFXs;
		myFXs ["targetname"] = "FX_" + self.pev.target;
		myFXs ["spawnflags"] = "64";
		myFXs ["rendermode"] = "0";
		myFXs ["renderamt"] = "255";
		myFXs ["target"] = "" + self.pev.target + "_FX";
		g_EntityFuncs.CreateEntity( "env_render_individual", myFXs, true );
		
		
		myFXs ["targetname"] = "FX_RETURN_" + self.pev.target;
		myFXs ["spawnflags"] = "64";
		myFXs ["rendermode"] = "4";
		myFXs ["renderamt"] = "0";
		myFXs ["target"] = "" + self.pev.target + "_FX";
		g_EntityFuncs.CreateEntity( "env_render_individual", myFXs, true );
	}

	void CreateGameTextMLan()
	{
		CBaseEntity@ pTextos = null;
		dictionary keyvalues;

		if( g_CustomEntityFuncs.IsCustomEntity( "game_text_custom" ) )
		{
			keyvalues =	
			{
				{ "message", ""},
				{ "message_spanish", ""},
				{ "message_portuguese", ""},
				{ "x", "-1"},
				{ "y", "0.90"},
				{ "effect", "0"},
				{ "holdtime", "1"},
				{ "fadeout", "0"},
				{ "fadein", "0"},
				{ "channel", "6"},
				{ "fxtime", "0"},
				{ "color", "255 0 0"},
				{ "spawnflags", "2"}, // No echo console + activator only
				{ "targetname", "" + self.pev.target + "_TEXT" }
			};
			@pTextos = g_EntityFuncs.CreateEntity( "game_text_custom", keyvalues, true );
		}
		else
		{
			keyvalues =	
			{
				{ "message", ""},
				{ "x", "-1"},
				{ "y", "0.90"},
				{ "effect", "0"},
				{ "holdtime", "1"},
				{ "fadeout", "0"},
				{ "fadein", "0"},
				{ "channel", "6"},
				{ "fxtime", "0"},
				{ "color", "255 0 0"},
				{ "spawnflags", "2"}, // No echo console + activator only
				{ "targetname", "" + self.pev.target + "_TEXT" }
			};
			@pTextos = g_EntityFuncs.CreateEntity( "game_text", keyvalues, true );
		}
	}
	
	void CreateMasterTarget()
	{
		dictionary mymaster;
		mymaster ["targetname"] = "" + self.pev.target;
		g_EntityFuncs.CreateEntity( "multisource", mymaster, true );
	}
	
	void CreateLockerForMMS()
	{
		CBaseEntity@ pLock = null;
		while((@pLock = g_EntityFuncs.FindEntityByClassname(pLock, "*")) !is null)
		{
			if( pLock.pev.model == ""+self.pev.netname+"" )
			{
				edict_t@ pEdict = pLock.edict();
				g_EntityFuncs.DispatchKeyValue( pEdict, "master", ""+self.pev.target+"" );
			}
		}
	}
	
	bool Inside(CBasePlayer@ pPlayer)
	{
		bool a = true;
		a = a && pPlayer.pev.origin.x + pPlayer.pev.maxs.x >= self.pev.origin.x + self.pev.mins.x;
		a = a && pPlayer.pev.origin.y + pPlayer.pev.maxs.y >= self.pev.origin.y + self.pev.mins.y;
		a = a && pPlayer.pev.origin.z + pPlayer.pev.maxs.z >= self.pev.origin.z + self.pev.mins.z;
		a = a && pPlayer.pev.origin.x + pPlayer.pev.mins.x <= self.pev.origin.x + self.pev.maxs.x;
		a = a && pPlayer.pev.origin.y + pPlayer.pev.mins.y <= self.pev.origin.y + self.pev.maxs.y;
		a = a && pPlayer.pev.origin.z + pPlayer.pev.mins.z <= self.pev.origin.z + self.pev.maxs.z;

		if(a)
			return true;
		else
			return false;
	}
}