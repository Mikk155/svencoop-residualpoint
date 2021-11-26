namespace BabyIcky
{
    class monster_baby_ichthyosaur : ScriptBaseMonsterEntity
    {

		void Precache()
		{
			g_Game.PrecacheModel( "models/mikk/residualpoint/baby_icky.mdl" );
		}
		
        void Spawn( void )
        {
            Precache();

            pev.solid = SOLID_NOT;

            dictionary keyvalues = {
                { "model", "models/mikk/residualpoint/baby_icky.mdl" },
                { "displayname", "Baby ichthyosaur" }
                { "health", "250" },

            };

            CBaseEntity@ pEntity = g_EntityFuncs.CreateEntity( "monster_human_grunt", keyvalues, false );

            CBaseMonster@ pIcky = pEntity.MyMonsterPointer();

            pIcky.pev.origin = pev.origin;
            pIcky.pev.angles = pev.angles;
            pIcky.pev.targetname = pev.targetname;
            pIcky.pev.netname = pev.netname;
            pIcky.pev.scale = pev.scale;
            pIcky.pev.spawnflags = pev.spawnflags;

            g_EntityFuncs.DispatchSpawn( pIcky.edict() );

            pIcky.m_iTriggerCondition = self.m_iTriggerCondition;
            pIcky.m_iszTriggerTarget = self.m_iszTriggerTarget;

            g_EntityFuncs.Remove( self );
        }
    }

    void Register()
    {
        g_CustomEntityFuncs.RegisterCustomEntity( "BabyIcky::monster_baby_ichthyosaur", "monster_baby_ichthyosaur" );
    }
}