/*
* env_hurt
* Point Entity
* Custom trigger_hurt zone with variable hullsize
* Outerbeast - based on CubeMath's scripts
*/
class env_hurt : ScriptBaseEntity
{
	private int iDamageType = 0;
	private bool fIsOn = true;

	bool KeyValue( const string& in szKey, const string& in szValue )
	{
		if( szKey == "minhullsize" )
			g_Utility.StringToVector( self.pev.vuser1, szValue );
		else if( szKey == "maxhullsize" )
			g_Utility.StringToVector( self.pev.vuser2, szValue );
		else if( szKey == "damagetype" ) 
			iDamageType = atoi( szValue );
		else
			return BaseClass.KeyValue( szKey, szValue );

		return true;
	}

	void Spawn()
	{
		self.pev.movetype 	= MOVETYPE_NONE;
		self.pev.solid 		= SOLID_TRIGGER;
		
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		g_EntityFuncs.SetSize( self.pev, self.pev.vuser1, self.pev.vuser2 );

		if( self.pev.dmg == 0.0f )
			self.pev.dmg = 10.0f;

		if(	iDamageType == 32)
			iDamageType = 0;

		if( self.pev.spawnflags & 1 != 0 && self.GetTargetname() != "" )
			fIsOn = false;

		SetThink( ThinkFunction( this.KeepActive ) );
        self.pev.nextthink = g_Engine.time + 1.0f;
	}

	void KeepActive()
	{
        self.pev.nextthink = g_Engine.time + 1.0f;
	}

	void Touch(CBaseEntity@ pOther)
	{
		if( pOther is null )
			return;
		
		if( fIsOn )
		{
			pOther.TakeDamage( null, null, self.pev.dmg, iDamageType );
			pOther.pev.flags &= ~( FL_GODMODE );
		}
	}
	
	void Use(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float value)
	{
		if( fIsOn )
			fIsOn = false;
		else
			fIsOn = true;
	}
}

void RegisterEnvHurtEntity()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "env_hurt", "env_hurt" );
}