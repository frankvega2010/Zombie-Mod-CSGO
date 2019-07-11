#include <smlib>
#include <sourcemod>
#include <cstrike.inc>
#include <sdktools_functions>
#include <console>
#include <sdktools>
#include <sdktools_sound>
#include <sdktools_gamerules>
#include <sdkhooks>
#include <csgoitems>

new Handle:CallhTimerTest; 
new Seconds;
new float:GrenadeCoolDown[32];
new bool:FirstZombiePicked = false;
new bool:lastSurvivorPicked = false;
new bool:ZombiesWin = false;
new bool:SurvivorsWin = false;
new bool:SetCTScoreOnce = false;
new bool:SetTTScoreOnce = false;
int g_roundStartedTime = -1;
Handle hudtext;
Handle hudtext2;
Handle hudtext3;

public Plugin:myinfo =
{
	name = "Zombie Mod - Core Module",
	author = "Frankvega",
	description = "Zombie Mod made for CSGO.",
	url = ""
}

public OnPluginStart()
{
	hudtext = CreateHudSynchronizer();
	hudtext2 = CreateHudSynchronizer();
	hudtext3 = CreateHudSynchronizer();
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Pre);
	HookEvent("player_blind", Event_PlayerBlind, EventHookMode_Pre); 
	HookEvent("round_start", Event_RoundStart, EventHookMode_Pre);
	HookEvent("round_end", Event_RoundEnd, EventHookMode_Pre);
}

public OnMapStart()
{
	PrecacheSound("coop_radio/m1_finish.wav");
	PrecacheSound("player/vo/seal/ct_death01.wav");
	PrecacheSound("music/skog_03/bombplanted.mp3");
	PrecacheSound("music/skog_02/lostround.mp3");
}

public void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int victimId = event.GetInt("userid");
	int victim = GetClientOfUserId(victimId);
	
	int killerId = event.GetInt("attacker");
	int killer = GetClientOfUserId(killerId);
	
	decl String:killerNick[64]; 
	GetClientName(killer, killerNick, sizeof(killerNick));
	
	decl String:victimNick[64]; 
	GetClientName(victim, victimNick, sizeof(victimNick));

	if(GetClientTeam(victim) == CS_TEAM_CT && FirstZombiePicked)
	{
		if(IsClientInGame(victim))
		{
			CS_SwitchTeam(victim, CS_TEAM_T);
			CreateTimer(0.1, Respawn,victim);
			EmitSoundToClient(victim,"player/vo/seal/ct_death01.wav",SNDCHAN_WEAPON);
		}	
		
		for(new i = 1; i <= MaxClients; i++)
		{
				if(IsClientInGame(i))
				{
					SetHudTextParams(0.3, 0.5, 3.0, 50, 255, 50, 255);
					ShowSyncHudText(i,hudtext,"[ZombieMod] %s has infected %s !", killerNick,victimNick);
				}	
		}
	}
	else if (GetClientTeam(victim) == CS_TEAM_CT && !FirstZombiePicked)
	{
		if(IsClientInGame(victim)) CreateTimer(0.1, Respawn,victim);
	}
	
	if(GetClientTeam(victim) == CS_TEAM_T && FirstZombiePicked)
	{
		if(IsClientInGame(victim)) CreateTimer(0.1, Respawn,victim);
	}
	
	if(GetTeamClientCount(CS_TEAM_CT) <= 0)
	{
		ZombiesWin = true;
		if(ZombiesWin && !SurvivorsWin)
		{
			CS_TerminateRound(GetConVarFloat(FindConVar("mp_round_restart_delay")), CSRoundEnd_TerroristWin);
			
			if(!SetCTScoreOnce)
			{
				SetTeamScore(CS_TEAM_T, GetTeamScore(CS_TEAM_T) + 1);
				SetCTScoreOnce = true;
			}
			
			for (new i = 1; i <= MaxClients; i++) 
			{
				if (IsClientInGame(i)) 
				{
				StopSound(i,SNDCHAN_WEAPON, "music/skog_03/bombplanted.mp3");
				}
			}
			EmitSoundToAll("music/skog_02/lostround.mp3",SNDCHAN_WEAPON);
			SurvivorsWin = true;
		}
			
	}	
	
	if(GetTeamClientCount(CS_TEAM_CT) <= 1)
	{
		if(!lastSurvivorPicked)
		{
			decl String:lastSurvivor[64]; 
			for (new i = 1; i <= MaxClients; i++) 
			{
				if(IsClientInGame(i))
				{
					if(GetClientTeam(i) == CS_TEAM_CT)
					{
						GetClientName(i, lastSurvivor, sizeof(lastSurvivor));
						
						for(new f = 1; f <= MaxClients; f++)
						{
								if(IsClientInGame(f))
								{
									SetHudTextParams(0.3, 0.5, 3.0, 50, 255, 50, 255);
									ShowSyncHudText(f,hudtext,"[ZombieMod] %s is the last survivor !", lastSurvivor);
								}	
						}
						
						EmitSoundToAll("music/skog_03/bombplanted.mp3",SNDCHAN_WEAPON);
						lastSurvivorPicked = true;
					}
				}
			}
		}
	}
}

public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int userId = event.GetInt("userid");
	int user = GetClientOfUserId(userId);
			
	if(!FirstZombiePicked)
	{
		if(GetClientTeam(user) == CS_TEAM_CT || GetClientTeam(user) == CS_TEAM_T) if (IsClientInGame(user)) GiveItemsCT(user);
	}
	else
	{
		if(GetClientTeam(user) == CS_TEAM_T) if (IsClientInGame(user)) GiveItemsTT(user);
	}
}

public void Event_RoundStart(Event event, const char[] name, bool dontBroadcast) 
{
	FirstZombiePicked = false;
	lastSurvivorPicked = false;
	FirstZombiePicked = false;
	lastSurvivorPicked = false;
	SetCTScoreOnce = false;
	SetTTScoreOnce = false;
	
	g_roundStartedTime = GetTime();
	
	Seconds = 15;
	CallhTimerTest = CreateTimer(1.0, Test, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(17.0, PickZombie); // 2 more seconds than the "Seconds" variable
	CreateTimer(1.0, ForceCTWin, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action:Event_RoundEnd(Handle:event, const String:name[], bool:dontBroadcast) 
{
	FirstZombiePicked = false;
	lastSurvivorPicked = false;
	FirstZombiePicked = false;
	lastSurvivorPicked = false;
}

public Action:PickZombie(Handle:timer)
{
	if(!FirstZombiePicked)
	{
		FirstZombiePicked = true;
		
		new firstzombie;
		do
		{
			firstzombie = GetRandomInt(1, MaxClients);
		}
		while(!IsClientInGame(firstzombie)); 
	
		if(IsClientInGame(firstzombie))
		{
			decl String:nick[64];
			GetClientName(firstzombie, nick, sizeof(nick));
			
			CS_SwitchTeam(firstzombie, CS_TEAM_T);
			CS_UpdateClientModel(firstzombie);
			GiveItemsTT(firstzombie);
			
			EmitSoundToAll("coop_radio/m1_finish.wav",SNDLEVEL_NORMAL);
			
			for(new i = 1; i <= MaxClients; i++)
			{ 
					if(IsClientInGame(i))
					{
						SetHudTextParams(0.3, 0.5, 3.0, 255, 50, 50, 255);
						ShowSyncHudText(i,hudtext,"%s", nick);
						SetHudTextParams(0.3, 0.45, 3.0, 50, 255, 50, 255);
						ShowSyncHudText(i,hudtext2,"is the first zombie! Run!!");
					}	
			}
		}
	}
}

public Action:Respawn(Handle:timer,any:victim)
{
	if (IsClientInGame(victim)) CS_RespawnPlayer(victim);
}

public Action:ForceCTWin(Handle:timer)
{
	new Float:roundtime = float(GetCurrentRoundTime());
	
	if(roundtime >= GameRules_GetProp("m_iRoundTime"))
	{
		if(!SetTTScoreOnce)
		{
			SetTeamScore(CS_TEAM_CT, GetTeamScore(CS_TEAM_CT) + 1);
			SetTTScoreOnce = true;
		}
		
		CS_TerminateRound(GetConVarFloat(FindConVar("mp_round_restart_delay")), CSRoundEnd_CTWin);
	}	
}

public int GetCurrentRoundTime() {
  Handle h_freezeTime = FindConVar("mp_freezetime"); // Freezetime Handle
  int freezeTime = GetConVarInt(h_freezeTime); // Freezetime in seconds (5 by default)
  return (GetTime() - g_roundStartedTime) - freezeTime;
}

public Action:Test(Handle:timer) 
{
	if (Seconds < 0) // not have [client]
    { 
        return Plugin_Stop; // timer end 
    }
	
	for(new i = 1; i <= MaxClients; i++)
	{ 
		if(!FirstZombiePicked)
		{
			if(IsClientInGame(i))
			{
				SetHudTextParams(0.3, 0.5, 3.0, 50, 255, 50, 255);
				ShowSyncHudText(i,hudtext,"[ZombieMod] First Zombie will be picked in %i seconds", Seconds);
			}
		}		
	}

	Seconds -= 1; 
	return Plugin_Continue; 
}

public Action:Event_PlayerBlind(Handle:event, const String:name[], bool:dontBroadcast)
{
	for(new i = 1; i <= MaxClients; i++)
	{ 
		if(IsClientInGame(i))
		{
			SetEntPropFloat(i, Prop_Send, "m_flFlashMaxAlpha", 0.0);
		}	
	}
}

public Action:GiveFlashbang(Handle:timer,any:user)
{
	Client_GiveWeaponAndAmmo(user, "weapon_flashbang", false, 2, 0, 1,0);
}

public Action:GiveItemsCT(any:ct)
{
	if(IsClientInGame(ct))
	{
		CS_SwitchTeam(ct, CS_TEAM_CT);
		Client_RemoveWeapon(ct, "weapon_flashbang");
		GivePlayerItem(ct, "weapon_breachcharge");
		CS_UpdateClientModel(ct);
		SetEntityRenderColor(ct, 255, 255, 255, 255);
		SetEntityHealth(ct, 100);	
	}
}

public Action:GiveItemsTT(any:tt)
{
	if(IsClientInGame(tt))
	{		
		if(GetClientTeam(tt) == CS_TEAM_CT ) CS_SwitchTeam(tt, CS_TEAM_T);
			
		Client_RemoveAllWeapons(tt, "weapon_knife");
		CreateTimer(0.1, GiveFlashbang,tt); // 2 more seconds than the "Seconds" variable	

		SetEntityRenderColor(tt, 230, 10, 10, 255);
		SetEntityHealth(tt, 500);
	}
}