#include <cstrike.inc>
#include <sdkhooks>

public Plugin:myinfo =
{
	name = "Zombie Mod - Weapons Module",
	author = "Frankvega",
	description = "Zombie Mod made for CSGO.",
	url = ""
}

public OnClientPutInServer(client)
{
	if( IsFakeClient( client ) )
    {
        SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
    }
}

public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype)
{
    if(IsClientInGame(victim) && IsClientInGame(attacker))
    {
		decl String:sWeapon[32];
		GetClientWeapon(attacker, sWeapon, sizeof(sWeapon));
        
		if(GetClientTeam(attacker) == CS_TEAM_T)
		{
			if(StrEqual(sWeapon, "weapon_flashbang"))
       		{
            	damage = 50.0;
            	return Plugin_Changed;
        	}
        	
			if(StrEqual(sWeapon, "weapon_knife"))
       		{
            	damage = 2000.0;
            	return Plugin_Changed;
        	}
        	
			if(StrEqual(sWeapon, "weapon_knife_t"))
       		{
            	damage = 2000.0;
            	return Plugin_Changed;
        	}
        	
			if(StrEqual(sWeapon, "weapon_bayonet"))
       		{
            	damage = 2000.0;
            	return Plugin_Changed;
        	}
        	
        	if(StrEqual(sWeapon, "weapon_knife_ghost"))
       		{
            	damage = 2000.0;
            	return Plugin_Changed;
        	}
        	
        	if(StrEqual(sWeapon, "weapon_knife_flip"))
       		{
            	damage = 2000.0;
            	return Plugin_Changed;
        	}
        	
        	if(StrEqual(sWeapon, "weapon_knife_gut"))
       		{
            	damage = 2000.0;
            	return Plugin_Changed;
        	}
        	
        	if(StrEqual(sWeapon, "weapon_knife_karambit"))
       		{
            	damage = 2000.0;
            	return Plugin_Changed;
        	}
        	
        	if(StrEqual(sWeapon, "weapon_knife_m9_bayonet"))
       		{
            	damage = 2000.0;
            	return Plugin_Changed;
        	}
        	
        	if(StrEqual(sWeapon, "weapon_knife_tactical"))
       		{
            	damage = 2000.0;
            	return Plugin_Changed;
        	}
        	
        	if(StrEqual(sWeapon, "weapon_knife_falchion"))
       		{
            	damage = 2000.0;
            	return Plugin_Changed;
        	}
        	
        	if(StrEqual(sWeapon, "weapon_knife_survival_bowie"))
       		{
            	damage = 2000.0;
            	return Plugin_Changed;
        	}
        	
        	if(StrEqual(sWeapon, "weapon_knife_butterfly"))
       		{
            	damage = 2000.0;
            	return Plugin_Changed;
        	}
        	
        	if(StrEqual(sWeapon, "weapon_knife_push"))
       		{
            	damage = 2000.0;
            	return Plugin_Changed;
        	}
        	
        	if(StrEqual(sWeapon, "weapon_knife_ursus"))
       		{
            	damage = 2000.0;
            	return Plugin_Changed;
        	}
        	
        	if(StrEqual(sWeapon, "weapon_knife_gypsy_jackknife"))
       		{
            	damage = 2000.0;
            	return Plugin_Changed;
        	}
        	
        	if(StrEqual(sWeapon, "weapon_knife_stiletto"))
       		{
            	damage = 2000.0;
            	return Plugin_Changed;
        	}
        	
        	if(StrEqual(sWeapon, "weapon_knife_widowmaker"))
       		{
            	damage = 2000.0;
            	return Plugin_Changed;
        	}
		}
        
    }
    return Plugin_Continue;
}