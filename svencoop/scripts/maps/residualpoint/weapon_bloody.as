namespace BloodyWeapon
{
    class weapon_bloodly_9mmAR : ScriptBaseMonsterEntity
    {
        void Precache()
        {
            g_Game.PrecacheModel( "models/residualpoint/monsters/zgrunt.mdl" );
        }

        void Spawn( void )
        {
            Precache();

            dictionary keyvalues = 
            {
                { "model", "models/residualpoint/monsters/zgrunt.mdl" },
                { "soundlist", "../mikk/rp/zgrunt.txt" },
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

            g_EntityFuncs.DispatchSpawn( pGrunt.edict() );

            g_EntityFuncs.Remove( self );
        }
    }
	
    class weapon_bloodly_shotgun : ScriptBaseMonsterEntity
    {
    }

    void Register()
    {
        g_CustomEntityFuncs.RegisterCustomEntity( "BloodyWeapon::weapon_bloodly_9mmAR", "weapon_bloodly_9mmAR" );
        g_CustomEntityFuncs.RegisterCustomEntity( "BloodyWeapon::weapon_bloodly_shotgun", "weapon_bloodly_shotgun" );
    }
}