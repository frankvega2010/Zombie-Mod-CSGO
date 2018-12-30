#include <sourcemod>
#include <cstrike>
#include <sdktools_functions>

public Plugin:myinfo =
{
	name = "Switch Team Command [STC]",
	author = "Frankvega",
	description = "It lets you switch any player to the designated team.",
	url = ""
}

public OnPluginStart()
{
	LoadTranslations("common.phrases.txt");
	RegAdminCmd("sm_tt", Command_Switchtt, ADMFLAG_SLAY, "This will switch the target to the Terrorist Team");
	RegAdminCmd("sm_ct", Command_Switchct, ADMFLAG_SLAY, "This will switch the target to the Counter Terrorist Team");
}

public Action:Command_Switchtt(client, args)
{
	if (args < 1)
	{
		PrintToConsole(client, "[STC] Usage: sm_tt <name>");
		return Plugin_Handled;
	}
   
   	new String:targetname[32];
   	
   	GetCmdArg(1, targetname, sizeof(targetname));
   
	int target = FindTarget(client,targetname);  	
	
	if (target != -1) GetClientName(target, targetname, sizeof(targetname));
 
 	if (target == -1) return Plugin_Handled;
 	
 	CS_SwitchTeam(target, CS_TEAM_T);
 	
 	if (IsPlayerAlive(target))
	{
		ForcePlayerSuicide(target);
		CS_RespawnPlayer(target);
	} 	
 	
 	PrintToChat(client, "[STC] Switched \"%s\" to the Terrorist Team", targetname);
	PrintToConsole(client, "[STC] Switched \"%s\" to the Terrorist Team", targetname);
 
	return Plugin_Handled;
}

public Action:Command_Switchct(client, args)
{
	if (args < 1)
	{
		PrintToConsole(client, "[STC] Usage: sm_ct <name>");
		return Plugin_Handled;
	}
   
   	new String:targetname[32];
   	
   	GetCmdArg(1, targetname, sizeof(targetname));
   
	int target = FindTarget(client,targetname);
   	
   	if (target != -1) GetClientName(target, targetname, sizeof(targetname));
 
 	if (target == -1) return Plugin_Handled;
 
 	CS_SwitchTeam(target, CS_TEAM_CT);
 	
 	if (IsPlayerAlive(target))
	{
		ForcePlayerSuicide(target);
		CS_RespawnPlayer(target);
	} 	
 
 	PrintToChat(client, "[STC] Switched \"%s\" to the Counter Terrorist Team", targetname);
	PrintToConsole(client, "[STC] Switched \"%s\" to the Counter Terrorist Team", targetname);
 
	return Plugin_Handled;
}