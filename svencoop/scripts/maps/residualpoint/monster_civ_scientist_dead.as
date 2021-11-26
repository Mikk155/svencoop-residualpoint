namespace ScientistCivdead
{
	class monster_civ_scientist_dead : ScriptBaseMonsterEntity
    {
		void Precache()
		{
			g_Game.PrecacheModel( "models/mikk/residualpoint/civ_scientist.mdl" );
		}
		
        void Spawn( void )
        {
            Precache();

            pev.solid = SOLID_NOT;

            dictionary keyvalues2 = {
                { "model", "models/mikk/residualpoint/civ_scientist.mdl" }

            };

            CBaseEntity@ pEntity = g_EntityFuncs.CreateEntity( "monster_scientist_dead", keyvalues2, false );

            CBaseMonster@ pCiv = pEntity.MyMonsterPointer();

            pCiv.pev.origin = pev.origin;
            pCiv.pev.angles = pev.angles;
            pCiv.pev.skin = pev.skin;
            pCiv.pev.body = pev.body;

            g_EntityFuncs.DispatchSpawn( pCiv.edict() );

            g_EntityFuncs.Remove( self );
        }
    }
	

    void Register()
    {
        g_CustomEntityFuncs.RegisterCustomEntity( "ScientistCivdead::monster_civ_scientist_dead", "monster_civ_scientist_dead" );
    }
}