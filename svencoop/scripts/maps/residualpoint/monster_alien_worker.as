namespace AlienWorker
{
    class monster_alien_worker : ScriptBaseMonsterEntity
    {
		void Precache()
		{
			g_Game.PrecacheModel( "models/mikk/residualpoint/tor.mdl" );
		}

        void Spawn( void )
        {
            Precache();

            pev.solid = SOLID_NOT;

            dictionary keyvalues = 
            {
                { "model", "models/mikk/residualpoint/tor.mdl" },
                { "health", "200" },
                { "new_health", "200" },
                { "$i_dyndiff_skip", "1" },
                { "displayname", "Alien Worker" }

            };

            CBaseEntity@ pEntity = g_EntityFuncs.CreateEntity( "monster_alien_tor", keyvalues, false );

            CBaseMonster@ pWorker = pEntity.MyMonsterPointer();

            pWorker.pev.origin = pev.origin;
            pWorker.pev.angles = pev.angles;
            pWorker.pev.targetname = pev.targetname;
            pWorker.pev.netname = pev.netname;
            pWorker.pev.weapons = pev.weapons;
            pWorker.pev.body = pev.body;
            pWorker.pev.skin = pev.skin;
            pWorker.pev.mins = pev.mins;
            pWorker.pev.maxs = pev.maxs;
            pWorker.pev.scale = pev.scale;
            pWorker.pev.rendermode = pev.rendermode;
            pWorker.pev.renderamt = pev.renderamt;
            pWorker.pev.rendercolor = pev.rendercolor;
            pWorker.pev.renderfx = pev.renderfx;
            pWorker.pev.spawnflags = pev.spawnflags;

            g_EntityFuncs.DispatchSpawn( pWorker.edict() );

            pWorker.m_iTriggerCondition = self.m_iTriggerCondition;
            pWorker.m_iszTriggerTarget = self.m_iszTriggerTarget;

            g_EntityFuncs.Remove( self );
        }
    }

    void Register()
    {
        g_CustomEntityFuncs.RegisterCustomEntity( "AlienWorker::monster_alien_worker", "monster_alien_worker" );
    }
}