class monster_lasertripmine : ScriptBaseMonsterEntity
{
    float TRIPMINE_LASERDAMAGE  = 2000.0f;
    int TRIPMINE_RED            = 0;
    int TRIPMINE_GREEN          = 214;
    int TRIPMINE_BLUE           = 198;
    
    float       m_flPowerUp;
    Vector      m_vecDir;
    Vector      m_vecEnd;
    float       m_flBeamLength;
 
    edict_t@    m_hOwner;
    CBeam@      m_pBeam;
    Vector      m_posOwner;
    Vector      m_angleOwner;
 
    void Spawn()
    {
        Precache();
        self.pev.movetype = MOVETYPE_FLY;
        self.pev.solid = SOLID_NOT;
 
        g_EntityFuncs.SetModel( self, "models/v_tripmine.mdl" );
        self.pev.frame = 0;
        self.pev.body = 3;
        self.pev.sequence = 7;
        self.ResetSequenceInfo();
        self.pev.framerate = 0;
		self.m_bloodColor = DONT_BLEED;
 
        g_EntityFuncs.SetSize( self.pev, Vector(-8, -8, -8), Vector(8, 8, 8) );
        g_EntityFuncs.SetOrigin( self, pev.origin );
 
        @m_pBeam = null; //?
 
        if( (pev.spawnflags & 1) == 1 )
            m_flPowerUp = g_Engine.time + 1.0f;
        else
            m_flPowerUp = g_Engine.time + 2.5f;
 
        SetThink( ThinkFunction(this.PowerupThink) );
        self.pev.nextthink = g_Engine.time + 0.2f;
 
        self.pev.takedamage = DAMAGE_YES;
		self.pev.dmg = 35;
		self.pev.health = 10000000; // don't let die normally
 
        if( pev.owner !is null )
        {
            g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "weapons/mine_deploy.wav", 1.0f, 0.8f, 0, 100 ); 
            g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_BODY, "weapons/mine_charge.wav", 0.2f, 0.8f, 0, 100 ); 
        }
 
        Math.MakeAimVectors( pev.angles );
 
        m_vecDir = g_Engine.v_forward;
        m_vecEnd = pev.origin + m_vecDir * 2048;
    }
 
    void Precache()
    {
        g_Game.PrecacheModel( "models/v_tripmine.mdl" );
        g_Game.PrecacheModel( "sprites/zbeam2.spr" );
 
        g_SoundSystem.PrecacheSound( "weapons/mine_deploy.wav" );
        g_SoundSystem.PrecacheSound( "weapons/mine_activate.wav" );
        g_SoundSystem.PrecacheSound( "weapons/mine_charge.wav" );
    }
 
    void PowerupThink()
    {
        TraceResult tr;
 
        if( m_hOwner is null )
        {
            edict_t@ oldowner = pev.owner;
            @pev.owner = null;
            g_Utility.TraceLine( pev.origin + m_vecDir * 8, pev.origin - m_vecDir * 32, ignore_monsters, self.edict(), tr );
            if( tr.fStartSolid != 0 or (oldowner !is null and tr.pHit is oldowner) )
            {
                @pev.owner = oldowner;
                m_flPowerUp += 0.1f;
                pev.nextthink = g_Engine.time + 0.1f;
 
                return;
            }
 
            if( tr.flFraction < 1.0f )
            {
                @pev.owner = tr.pHit;
                @m_hOwner = pev.owner;
                m_posOwner = m_hOwner.vars.origin;
                m_angleOwner = m_hOwner.vars.angles;
            }
            else
            {
                g_SoundSystem.StopSound( self.edict(), CHAN_VOICE, "weapons/mine_deploy.wav" );
                g_SoundSystem.StopSound( self.edict(), CHAN_BODY, "weapons/mine_charge.wav" );
                pev.nextthink = g_Engine.time + 0.1f;
                CBaseEntity@ pMine = g_EntityFuncs.Create( "weapon_lasertripmine", pev.origin + m_vecDir * 24, pev.angles, false );
                return;
            }
        }
        else if( m_posOwner != m_hOwner.vars.origin or m_angleOwner != m_hOwner.vars.angles )
        {
            g_SoundSystem.StopSound( self.edict(), CHAN_VOICE, "weapons/mine_deploy.wav" );
            g_SoundSystem.StopSound( self.edict(), CHAN_BODY, "weapons/mine_charge.wav" );
            CBaseEntity@ pMine = g_EntityFuncs.Create( "weapon_lasertripmine", pev.origin + m_vecDir * 24, pev.angles, false );
            pMine.pev.spawnflags |= SF_NORESPAWN;
 
            pev.nextthink = g_Engine.time + 0.1f;
            return;
        }
 
        if( g_Engine.time > m_flPowerUp )
        {
            pev.solid = SOLID_BBOX;
            g_EntityFuncs.SetOrigin( self, pev.origin );
 
            MakeBeam();
 
            g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "weapons/mine_activate.wav", 0.5f, ATTN_NORM, 1.0f, 75 );
        }
 
        pev.nextthink = g_Engine.time + 0.1f;
    }
 
    void BeamBreakThink()
    {
        bool bBeamBroken = false;
 
        TraceResult tr;
 
        g_Utility.TraceLine( pev.origin, m_vecEnd, dont_ignore_monsters, self.edict(), tr );
 
        if( m_pBeam is null )
        {
            MakeBeam();
            if( tr.pHit !is null )
                @m_hOwner = tr.pHit;
        }
 
        if( abs(m_flBeamLength - tr.flFraction) > 0.001f )
            bBeamBroken = true;
 
        if( bBeamBroken )
        {
            if( tr.pHit is null ) return;
 
            CBaseEntity@ pEntity = g_EntityFuncs.Instance( tr.pHit );
 
            if( pEntity.pev.takedamage == DAMAGE_NO ) return;
 
            g_WeaponFuncs.ClearMultiDamage();
 
            float flDamage = TRIPMINE_LASERDAMAGE;
 
            pEntity.TraceAttack( self.pev, flDamage, g_vecZero, tr, (DMG_ENERGYBEAM|DMG_ALWAYSGIB) );
            g_WeaponFuncs.ApplyMultiDamage( self.pev, self.pev );
 
            bBeamBroken = false;
        }
 
        pev.nextthink = g_Engine.time + 0.01f;
    }

    void MakeBeam()
    {
        TraceResult tr;
 
        g_Utility.TraceLine( self.pev.origin, m_vecEnd, ignore_monsters, self.edict(), tr );
 
        m_flBeamLength = tr.flFraction;
 
        SetThink( ThinkFunction(this.BeamBreakThink) );
        pev.nextthink = g_Engine.time + 0.1f;
 
        Vector vecTmpEnd = pev.origin + m_vecDir * 2048 * m_flBeamLength;
 
        @m_pBeam = g_EntityFuncs.CreateBeam( "sprites/zbeam2.spr", 24 );
        m_pBeam.PointEntInit( vecTmpEnd, self.entindex() );
        m_pBeam.SetColor( TRIPMINE_RED, TRIPMINE_GREEN, TRIPMINE_BLUE );
        m_pBeam.SetScrollRate( 32 );
        m_pBeam.SetBrightness( 200 );
        m_pBeam.SetFlags(bits_COND_LIGHT_DAMAGE|bits_COND_HEAVY_DAMAGE); //768
    }
}

void RegisterLaserMine()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "monster_lasertripmine", "monster_lasertripmine" );
}