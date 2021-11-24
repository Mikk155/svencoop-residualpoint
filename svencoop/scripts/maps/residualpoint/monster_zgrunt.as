namespace ZombieGrunt
{
    class monster_zgrunt : ScriptBaseMonsterEntity
    {
        void Precache()
        {
            g_Game.PrecacheModel( "models/mikk/residualpoint/zgrunt.mdl" );

            g_SoundSystem.PrecacheSound( "null.wav" ); // cache
            g_Game.PrecacheGeneric( "sound/" + "null.wav" ); // client has to download
        }

        void Spawn( void )
        {
            Precache();

            pev.solid = SOLID_NOT;

            dictionary keyvalues = 
            {
                { "model", "models/mikk/residualpoint/zgrunt.mdl" },
                { "soundlist", "../mikk/residualpoint/zgrunt.txt" },
                { "displayname", "Zombified Human Grunt" },
                { "classify", "7" },
                { "health", "350" },
                { "bloodcolor", "2" },
                { "TriggerCondition", "1" }

            };

            CBaseEntity@ pEntity = g_EntityFuncs.CreateEntity( "monster_human_grunt", keyvalues, false );

            CBaseMonster@ pGrunt = pEntity.MyMonsterPointer();

            pGrunt.pev.origin = pev.origin;
            pGrunt.pev.angles = pev.angles;
            pGrunt.pev.health = pev.health;
            pGrunt.pev.targetname = pev.targetname;
            pGrunt.pev.netname = pev.netname;
            pGrunt.pev.weapons = pev.weapons;
            pGrunt.pev.body = pev.body;
            pGrunt.pev.skin = pev.skin;
            pGrunt.pev.mins = pev.mins;
            pGrunt.pev.maxs = pev.maxs;
            pGrunt.pev.scale = pev.scale;
            pGrunt.pev.rendermode = pev.rendermode;
            pGrunt.pev.renderamt = pev.renderamt;
            pGrunt.pev.rendercolor = pev.rendercolor;
            pGrunt.pev.renderfx = pev.renderfx;
            pGrunt.pev.spawnflags = pev.spawnflags;

            g_EntityFuncs.DispatchSpawn( pGrunt.edict() );

            pGrunt.m_iTriggerCondition = self.m_iTriggerCondition;
            pGrunt.m_iszTriggerTarget = self.m_iszTriggerTarget;

            g_EntityFuncs.Remove( self );
        }
    }

    void Register()
    {
        g_CustomEntityFuncs.RegisterCustomEntity( "ZombieGrunt::monster_zgrunt", "monster_zgrunt" );

    }
}