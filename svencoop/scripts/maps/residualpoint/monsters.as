// Commented things has been done via Mapping in a recently update.
#include "monsters/monster_xenocrab"
// #include "monsters/monster_zgrunt"
// #include "monsters/monster_alien_worker"
// #include "monsters/monster_nari_grunt"
// #include "monsters/monster_baby_ichthyosaur"
// #include "monsters/monster_zgrunt_dead"
// #include "monsters/monster_civ_barney_dead"
// #include "monsters/monster_civ_scientist_dead"
#include "monsters/monster_required"
#include "monsters/monster_zombie_hev"
#include "monsters/monster_boss"

void RegisterAllMonsters()
{
	// I'm too lazy to change the classname and put the model on it -Pavotherman
	// Monsters
	XenCrab::Register();	  
//	ZombieGrunt::Register();
//	BabyIcky::Register();
//	AlienWorker::Register();
//	NariGrunt::Register();
	MonsterZombieHev::Register();

	// take'd from monster_cleansuit_scientist_dead by Rick 
//	ScientistCivdead::Register();
//	ZombieGruntDead::Register();
//	DeadCivBarney::Register();
	// https://github.com/RedSprend/svencoop_plugins/blob/master/svencoop/scripts/maps/opfor/monsters/monster_cleansuit_scientist_dead.as
}