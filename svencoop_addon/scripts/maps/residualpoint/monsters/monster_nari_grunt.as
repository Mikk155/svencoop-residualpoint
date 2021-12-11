namespace NariGrunt
{
    class monster_nari_grunt : ScriptBaseMonsterEntity
    {
		void Precache()
		{
			g_Game.PrecacheModel( "models/mikk/residualpoint/ngrunt.mdl" );
		}

        void Spawn( void )
        {
            Precache();

            pev.solid = SOLID_NOT;

            dictionary keyvalues = {
                { "model", "models/mikk/residualpoint/ngrunt.mdl" },
                { "displayname", "Human Grunt" }

            };

            CBaseEntity@ pEntity = g_EntityFuncs.CreateEntity( "monster_male_assassin", keyvalues, false );

            CBaseMonster@ pNrunt = pEntity.MyMonsterPointer();

            pNrunt.pev.origin = pev.origin;
            pNrunt.pev.angles = pev.angles;
            pNrunt.pev.health = pev.health;
            pNrunt.pev.targetname = pev.targetname;
            pNrunt.pev.netname = pev.netname;
            pNrunt.pev.weapons = pev.weapons;
            pNrunt.pev.body = pev.body;
            pNrunt.pev.skin = pev.skin;
            pNrunt.pev.spawnflags = pev.spawnflags;

            g_EntityFuncs.DispatchSpawn( pNrunt.edict() );

            pNrunt.m_iTriggerCondition = self.m_iTriggerCondition;
            pNrunt.m_iszTriggerTarget = self.m_iszTriggerTarget;

            g_EntityFuncs.Remove( self );
        }
    }

    void Register()
    {
        g_CustomEntityFuncs.RegisterCustomEntity( "NariGrunt::monster_nari_grunt", "monster_nari_grunt" );
    }
}