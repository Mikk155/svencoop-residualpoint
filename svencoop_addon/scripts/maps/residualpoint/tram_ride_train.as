/*
	Not solidity zone for tram ride like maps. "target" must be the train.
	spawnflag 1 start off
	use killtarget on this entity to disable it.
*/
void RegisterSolidityZone() 
{
	g_CustomEntityFuncs.RegisterCustomEntity( "tram_ride_train", "tram_ride_train" );
}

enum tram_ride_train_flag
{
    SF_NTS_START_OFF = 1 << 0
}

class tram_ride_train : ScriptBaseEntity 
{
	private bool toggle 			= true;
	void Spawn() 
	{
        self.Precache();

        self.pev.movetype = MOVETYPE_NONE;
        self.pev.solid = SOLID_NOT;

		g_EntityFuncs.SetOrigin( self, self.pev.origin );

        if( !self.pev.SpawnFlagBitSet( SF_NTS_START_OFF ) )
		{
			toggle = false;
			SetThink( ThinkFunction( this.TriggerThink ) );
			self.pev.nextthink = g_Engine.time + 0.1f;
		}

        BaseClass.Spawn();
	}
	
    void Use(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float value)
    {
		if( toggle )
		{
			SetThink( ThinkFunction( this.TriggerThink ) );
			self.pev.nextthink = g_Engine.time + 0.1f;
		}
		else
		{
			SetThink( null );
			g_Scheduler.SetTimeout( this, "ResetValues", 0.25 );
		}

		toggle = !toggle;
	}

    void UpdateOnRemove()
    {
		g_Scheduler.SetTimeout( this, "ResetValues", 0.25 );
        BaseClass.UpdateOnRemove();
    }

	void ResetValues()
	{
		for( int iPlayer = 1; iPlayer <= g_PlayerFuncs.GetNumPlayers(); ++iPlayer )
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( iPlayer );
				
			if( pPlayer is null || !pPlayer.IsConnected() || !pPlayer.IsAlive() )
				continue;

			pPlayer.pev.rendermode  = kRenderNormal;
			pPlayer.pev.renderamt   = 255;
		}
	}
	
	void TriggerThink() 
	{
        CBaseEntity@ pTrain = null;
		while((@pTrain = g_EntityFuncs.FindEntityByTargetname(pTrain, self.pev.target)) !is null)
			g_EntityFuncs.SetOrigin( self, pTrain.Center());

		for( int iPlayer = 1; iPlayer <= g_PlayerFuncs.GetNumPlayers(); ++iPlayer )
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( iPlayer );
				
			if( pPlayer is null || !pPlayer.IsConnected() || !pPlayer.IsAlive() )
				continue;

			if( ( self.pev.origin - pPlayer.pev.origin ).Length() <= 200 ) // 200 units aprox.
			{
				pPlayer.pev.solid = SOLID_NOT;
				pPlayer.pev.flags |= FL_NOTARGET;
				pPlayer.pev.rendermode = kRenderTransAlpha;
				pPlayer.pev.renderamt = 0;
			}else{ // Respawn players that somehow get out of the train.
				g_PlayerFuncs.RespawnPlayer(pPlayer, true, true);
			}
		}
		
		self.pev.nextthink = g_Engine.time + 0.1f;
	}
}