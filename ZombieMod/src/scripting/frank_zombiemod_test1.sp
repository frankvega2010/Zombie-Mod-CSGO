#include <sourcemod>
#include <cstrike.inc>
#include <sdktools_functions>

public Plugin:myinfo =
{
	name = "Zombie Mod Test",
	author = "Frankvega",
	description = "Zombie Mod made for CSGO.",
	url = ""
}

public OnPluginStart()
{
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Pre);
	HookEvent("item_pickup", Event_ItemPickUp, EventHookMode_Pre);
}

public void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int victimId = event.GetInt("userid");
	int victim = GetClientOfUserId(victimId);
		
	if(GetClientTeam(CS_TEAM_CT))
	{
		CS_SwitchTeam(victim, CS_TEAM_T);
		ForcePlayerSuicide(victim);
	}
}

public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int userId = event.GetInt("userid");
	int user = GetClientOfUserId(userId);
		
	if(GetClientTeam(user) == CS_TEAM_T)
	{
		new knife = "weapon_knife";
		
		if(GetPlayerWeaponSlot(user, CS_SLOT_PRIMARY) != -1) RemovePlayerItem(user, GetPlayerWeaponSlot(user, CS_SLOT_PRIMARY));
		if(GetPlayerWeaponSlot(user, CS_SLOT_SECONDARY) != -1) RemovePlayerItem(user, GetPlayerWeaponSlot(user, CS_SLOT_SECONDARY));
		EquipPlayerWeapon(user, knife); 
	}
}

public void Event_ItemPickUp(Event event, const char[] name, bool dontBroadcast)
{
	int userId = event.GetInt("userid");
	int user = GetClientOfUserId(userId);	
		
	if(GetClientTeam(user) == CS_TEAM_T)
	{
		new knife = "weapon_knife";
		
		if(GetPlayerWeaponSlot(user, CS_SLOT_PRIMARY) != -1) RemovePlayerItem(user, GetPlayerWeaponSlot(user, CS_SLOT_PRIMARY));
		if(GetPlayerWeaponSlot(user, CS_SLOT_SECONDARY) != -1) RemovePlayerItem(user, GetPlayerWeaponSlot(user, CS_SLOT_SECONDARY));
		EquipPlayerWeapon(user, knife); 
	}
}