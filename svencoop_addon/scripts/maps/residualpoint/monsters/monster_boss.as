int psychAttackPhase = 0;
float psych_NextAttack = 0;
float psychAttack_Ready = 0;
float psychAuraNextShake = 0;
bool psychAuraSound = false;

EHandle controllerH;
EHandle controllerTargetH;

void ControllerMapInit()
{
	g_Game.AlertMessage( at_console, "Precaching Boss's sound\n" );
	g_SoundSystem.PrecacheSound("mikk/residualpoint/boss/tube_prepare.ogg");
	g_SoundSystem.PrecacheSound("mikk/residualpoint/boss/first_hit.ogg");
	g_SoundSystem.PrecacheSound("mikk/residualpoint/boss/final_hit.ogg");
}

/*const array <string> pMonsters = { "monster_zombie_hev", "monster_xenocrab", "monster_headcrab", "monster_human_grunt" };

void Entitys()
{
	AdjustDifficultyByClassname( pMonsters[0], 5, 0, 15 );
	AdjustDifficultyByClassname( pMonsters[1], 30, 0, 0  );
	AdjustDifficultyByClassname( pMonsters[2], 320, 0, 15 );
	AdjustDifficultyByClassname( pMonsters[3], 1, 5, 15 );
}

void AdjustDifficultyByClassname( const string sClassName, int MaxLife, int iPerPlayerInc, int iMoreHealth )
{
	//If 1 player or less, don't do anything
	//if( g_PlayerFuncs.GetNumPlayers() <= 1 )
		//return;
			
	if( iPerPlayerInc <= 0 ) 
		iPerPlayerInc = 1;
			
	CBaseEntity@ pEntity = null;
    while( ( @pEntity = g_EntityFuncs.FindEntityByClassname( pEntity, sClassName ) ) !is null )
    {
        if ( pEntity is null || !pEntity.IsAlive() )
            continue;

        int iSkill = Math.clamp( 1, 3, int( g_EngineFuncs.CVarGetFloat( "skill" ) ) ); // Get current skill level and ensure this is between 1 and 3
		
		int iMultiPlayersInGame = g_PlayerFuncs.GetNumPlayers() * iPerPlayerInc;

        int iCalcNewHealth = ( iMultiPlayersInGame * iSkill ) + iMoreHealth;
		
		int iNewHealth = Math.clamp( 0, MaxLife, iCalcNewHealth );

		if( pEntity.pev.health == pEntity.pev.max_health )
		{
			if( pEntity.pev.health > MaxLife )
			{
				pEntity.pev.health = MaxLife;
				pEntity.pev.max_health = MaxLife;
			}
			else
			{
				pEntity.pev.health = iNewHealth + pEntity.pev.health;		
				pEntity.pev.max_health = iNewHealth + pEntity.pev.max_health;
			}
			g_PlayerFuncs.ClientPrintAll( HUD_PRINTNOTIFY, "DEBUG: " + pEntity.pev.classname + " health has been set to " + pEntity.pev.health + " for " + g_PlayerFuncs.GetNumPlayers() + " players.\n" );
		}
		else
		{
			g_PlayerFuncs.ClientPrintAll( HUD_PRINTNOTIFY, "DEBUG: " + pEntity.pev.classname + " health has not been changed, because the entity has received damage before the health change" + "\n" );
		}
    }
}*/

/* npc_controller
Controller's psychic attacks
Uses trigger_script in think mode :
target : Controller's targetname
Time between thinks : 0.5 (Will affect the frequency of psychic aura damage)
The trigger_script must be deactivated at the controller's death
*/
void npc_controller(CBaseEntity@ controllerScript)
{
	CBaseEntity@ scriptTarget = g_EntityFuncs.FindEntityByTargetname( null, controllerScript.pev.target );
	CBaseMonster@ controller = cast<CBaseMonster@>(scriptTarget);
	controllerH = controller;
	
	CBaseEntity@ controllerTarget = controller.m_hEnemy;
	CBaseMonster@ controllerTargetM = cast<CBaseMonster@>(controllerTarget);
	
	//Psychic attack schedule
	ScriptSchedule@ psychAttack = ScriptSchedule(0, 0, "psychAttack");
	
	ScriptTask psychAttack_T1;	psychAttack_T1.iTask = TASK_STOP_MOVING;
	ScriptTask psychAttack_T2;	psychAttack_T2.iTask = TASK_RANGE_ATTACK1;
	ScriptTask psychAttack_T3;	psychAttack_T3.iTask = TASK_FACE_ENEMY;
	
	psychAttack.AddTask(psychAttack_T1);
	psychAttack.AddTask(psychAttack_T2);
	psychAttack.AddTask(psychAttack_T3);
	
	Schedule@ psychAttackSched = psychAttack.opImplCast();
	
	//Psychic attack
	bool controllerSeeTarget = (@controllerTarget != null) && (controller.HasConditions(bits_COND_SEE_ENEMY) == true) && ( (controller.pev.origin - controllerTarget.pev.origin).Length() < 1350 );
	bool controllerCanSeeTarget = (@controllerTarget != null) && (controller.HasConditions(bits_COND_ENEMY_OCCLUDED) == false) && ( (controller.pev.origin - controllerTarget.pev.origin).Length() < 1350 );
	
	switch (psychAttackPhase)
	{
	case 0: //No psychic attack started
	
		//Can try to attack if ready
		if (g_Engine.time > psych_NextAttack && controller.m_Activity != ACT_MELEE_ATTACK1 && controller.m_Activity != ACT_SMALL_FLINCH && controller.m_Activity != ACT_BIG_FLINCH)
		{
		//Will attack on sight or random chance to attack if target is visible but currently not in field of view
			if (controllerSeeTarget || (controllerCanSeeTarget && Math.RandomLong(1,100)>10)) 
			{
			controller.ChangeSchedule(psychAttackSched);
			g_SoundSystem.EmitSound(controllerTarget.edict(), CHAN_ITEM, "mikk/residualpoint/boss/tube_prepare.ogg",0.8,ATTN_NORM);
			psychAttackPhase = 1;
			psychAttack_Ready = g_Engine.time + 1.2;
			}
		}
		
		break;
		
	case 1: //Loading psychic attack
		if (controllerSeeTarget && g_Engine.time > psychAttack_Ready && g_Engine.time < (psychAttack_Ready + 2) && controller.m_Activity == ACT_RANGE_ATTACK1)
		{
			g_SoundSystem.EmitSound(controllerTarget.edict(), CHAN_ITEM, "mikk/residualpoint/boss/first_hit.ogg",1,ATTN_NORM);
			controller.SetSequenceByName("psychattack_hit");
			
			 //Camera effect on players
			if (controllerTargetM.pev.classname == "player")
			{
			Vector vecToTarget = (controller.pev.origin - controllerTargetM.pev.origin + Vector(0,0,48));
						
			Vector psychCamAngles = Math.VecToAngles(vecToTarget * Vector(1,1,-1));
			Vector psychCamOrigin = controller.pev.origin + Vector(0,0,64) - vecToTarget * 55 / vecToTarget.Length();

			CBaseEntity@ psychCam = g_EntityFuncs.Create("trigger_camera", psychCamOrigin, psychCamAngles,false);

			psychCam.pev.spawnflags = 4;
			psychCam.KeyValue("wait","1");
			
			
			psychCam.Use(@controllerTargetM,@controllerTargetM,USE_ON);
			g_PlayerFuncs.ScreenFade(controllerTargetM, Vector(255,255,255),0.8,0.2,150,1);
			}
			
			//Scheduling last attack phase
			controllerTargetH = controllerTargetM;
			g_Scheduler.SetTimeout("ControllerAttackHit",1);

			psychAttackPhase = 0;
			psych_NextAttack = g_Engine.time + 4;
		}

		else if (g_Engine.time > (psychAttack_Ready + 2)) //Attack expiration
		{
			psychAttackPhase = 0;
			psych_NextAttack = g_Engine.time + 1;
		}
		break;
	}
	
		
	//Psychic aura effects
	CBaseEntity@ playerInAura = null;
	CBaseEntity@ NPCInAura = null;
	
	//Damage on players
	while ((@playerInAura = g_EntityFuncs.FindEntityInSphere(playerInAura, controller.pev.origin, 512, "player", "classname")) != null)
	{
		CBaseMonster@ playerInAuraM =  cast<CBaseMonster@>(@playerInAura);
		float psychAuraDmg = 4 * (1 - (controller.pev.origin - playerInAuraM.pev.origin).Length() / 512);
		playerInAuraM.TakeDamage(controller.pev, controller.pev, psychAuraDmg, DMG_FALL);
	}
	
	//Mind control on "controllable" NPCs (Defined by targetname)
	while ((@NPCInAura = g_EntityFuncs.FindEntityInSphere(NPCInAura, controller.pev.origin, 512, "controllable", "targetname")) != null)
	{
		CBaseMonster@ NPCInAuraM = cast<CBaseMonster@>(@NPCInAura);
		NPCInAuraM.SetClassification(CLASS_ALIEN_MONSTER);
		NPCInAuraM.pev.targetname = "";
	}

	
	
	//Psychic aura shake
	if (g_Engine.time >= psychAuraNextShake)
	{
	g_PlayerFuncs.ScreenShake(controller.pev.origin, 10, 10, 3, 510);
	psychAuraNextShake = g_Engine.time + 3;
	}

}

void ControllerAttackHit()
{
	if(controllerTargetH)
	{
		CBaseEntity@ controllerTarget = controllerTargetH;
		
		if (controllerH)
		{
			CBaseEntity@ controller = controllerH;
		
			g_SoundSystem.EmitSound(controllerTarget.edict(), CHAN_ITEM, "mikk/residualpoint/boss/final_hit.ogg",1,ATTN_NORM);
			controllerTarget.TakeDamage(controller.pev, controller.pev, 40, DMG_FALL);
			
			if (controllerTarget.pev.classname == "player") //Special effects on players
			{		
				g_PlayerFuncs.ScreenFade(controllerTarget, Vector(22,12,12),5,2,240,2);
				// g_PlayerFuncs.ScreenFade(controllerTargetM, Vector(62,32,32),5,2,230,0);
				
				controllerTarget.pev.angles = controllerTarget.pev.angles + Vector(Math.RandomLong(-100,100),Math.RandomLong(-100,100),0);
				controllerTarget.pev.fixangle = FAM_FORCEVIEWANGLES;
			}
		}
	}
}