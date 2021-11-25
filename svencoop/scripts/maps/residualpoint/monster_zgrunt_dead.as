namespace ZombieGruntDead
{
	class monster_zgrunt_dead : ScriptBaseMonsterEntity
    {
		void Precache()
		{
			g_Game.PrecacheModel( "models/mikk/residualpoint/zgrunt.mdl" );
		}
		
        void Spawn( void )
        {
            Precache();

            pev.solid = SOLID_NOT;

            dictionary keyvalues2 = {
                { "model", "models/mikk/residualpoint/zgrunt.mdl" },
                { "bloodcolor", "2" }

            };

            CBaseEntity@ pEntity = g_EntityFuncs.CreateEntity( "monster_hgrunt_dead", keyvalues2, false );

            CBaseMonster@ pGrunt2 = pEntity.MyMonsterPointer();

            pGrunt2.pev.origin = pev.origin;
            pGrunt2.pev.angles = pev.angles;
            pGrunt2.pev.skin = pev.skin;
            pGrunt2.pev.body = pev.body;

            g_EntityFuncs.DispatchSpawn( pGrunt2.edict() );

            g_EntityFuncs.Remove( self );
        }
    }
	

    void Register()
    {
        g_CustomEntityFuncs.RegisterCustomEntity( "ZombieGruntDead::monster_zgrunt_dead", "monster_zgrunt_dead" );
    }
}