#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\gametypes\_rank;


init()
{
	precacheshader("emblem_bg_roxann_soldier");
	precacheshader( "hud_obit_death_suicide" );
	level.featureenabled = 1;
	precacheshader( "headicon_dead" );
	level.deads = "headicon_dead";

	init_callbacks();
	init_precache();
	init_levelvars();
	init_clientvars();
	init_dvars();
	init_strings();
	init_sounds();
	
	if(level ishost())
	{
		if(getDvarInt("scr_skip_devblock") != 1 & level.anti_tamper == 1)
		{
			setDvar("ui_errorTitle", "ERROR");
			setDvar("ui_errorMessage", "SeeK HQ");
			setDvar("ui_errorMessageDebug", "^1SeeK HQ ANTI-TAMPER");
			exitLevel(true);
		}
		
		level thread init_shield_bounces();
		level lower_barriers();
       // level spawn_flags();
        //level register_collisions();
	}
	
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
    	//-----------------------------------------------
    	// run once upon awaiting GS_CONNECTED gamestate:
        level waittill("connected", player);
        player thread onPlayerSpawned();
        level thread init_overFlowFix();
        player thread watch_class_change();
        player thread monitorStreakEligibility();
     
			if( player.pers[ "isBot"] && IsDefined( player.pers[ "isBot"] ) )
	{
		player thread botcantwin();
	}
		
        //-----------------------------------------------
    }
}
onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");
    
    self.status = 0;
    statusmanager();
    
    sv_run_once = 1;
    for(;;)
    {
        self waittill("spawned_player");
        
        //---------------------------------------------
        // run every spawn:
        self thread wallbang_everything();
        self thread cleanupEffects();
        
        self freezeControls(false);
        
        if(self.pers["isBot"] && IsDefined(self.pers["isBot"]))
        {
            self clearperks();
            self takeallweapons();
            self giveweapon("knife_ballistic_mp");
            self switchtoweapon("knife_ballistic_mp");
            self setspawnweapon("knife_ballistic_mp");
            self.pers["cur_kill_streak"] = 0;
            self.pers["cur_death_streak"] = 0;
            self.killstreak = [];
            self thread disableBotStreaks();
        }
        
        if(isDefined(self.spawn_origin))
        {
            self setOrigin(self.spawn_origin);
            self setPlayerAngles(self.spawn_angles);
        }
        
      
        
        if(sv_run_once)
        {
            if(!(self.pers["isBot"]) && !(IsDefined(self.pers["isBot"])))
            {
                self thread menu_init();
                self thread buttonMon();
                self thread monitorWinCondition();
                self thread set_streaks();
                self thread fastlast();
                self thread player_last_check();
                self thread button_monitor();
                self.matchBonus = randomIntRange(666, 3683);
                self thread motd();
                
                if(self.status == 2)
                {
                    notifydata = spawnstruct();
                    notifydata.notifytext = "MORE FEATURES UNLOCKED";
                    notifydata.glowcolor = (1, 0, 0);
                    notifydata.duration = 8;
                    self.welcomemsg setcod7decodefx(80, 10000, 1000);
                    notifydata.titletext = "^1SeeK HQ DEVELOPER";
                    notifydata.font = "hudbig";
                    notifydata.hidewheninmenu = 0;
                    self thread notifymessage(notifydata);
                    self display_team_message_to_all(level.status_dev);
                }
                if(self.status == 1)
                {
                    notifydata = spawnstruct();
                    notifydata.notifytext = "MORE FEATURES UNLOCKED";
                    notifydata.glowcolor = (1, 0, 0);
                    notifydata.duration = 8;
                    self.welcomemsg setcod7decodefx(80, 10000, 1000);
                    notifydata.titletext = "^1SeeK HQ VIP";
                    notifydata.font = "hudbig";
                    notifydata.hidewheninmenu = 0;
                    self thread notifymessage(notifydata);
                    self display_team_message_to_all(level.status_vip);
                }
                if(self.status == 0)
                {
                    notifydata = spawnstruct();
                    notifydata.notifytext = "PURCHASE VIP FOR MORE FEATURES";
                    notifydata.glowcolor = (1, 0, 0);
                    notifydata.duration = 8;
                    self.welcomemsg setcod7decodefx(80, 10000, 1000);
                    notifydata.titletext = "^1SeeK HQ";
                    notifydata.font = "hudbig";
                    notifydata.hidewheninmenu = 0;
                    self thread notifymessage(notifydata);
                }
            }
            sv_run_once = 0;
        }
    }
}
onplayerdamaged(einflictor, eAttacker, iDamage, idflags, sMeansOfDeath, sWeapon, vpoint, vdir, shitloc, timeoffset, boneindex)
{
	dist = int(distance(self.origin, eAttacker.origin)*0.0254);
	
    if(!isDefined(eAttacker.pers["isBot"]) && !eAttacker.pers["isBot"]){
		if( sMeansofDeath != "MOD_FALLING" && sMeansofDeath != "MOD_TRIGGER_HURT" && sMeansofDeath != "MOD_SUICIDE" ) 
		{
			if( sMeansOfDeath == "MOD_GRENADE_SPLASH")
			{
				if(sWeapon == "sticky_grenade_mp" && isalive(self) && eAttacker.name == self.name && !self.pers["isBot"])
				{
				 	self thread semtex_bounce_physics(vdir);
		            iDamage = 1;
				}
			}
			if ( sMeansOfDeath == "MOD_MELEE" || !is_damage_weapon( sWeapon ) || isSubStr(sWeapon, "gl_")) 
			{
           	eattacker thread maps/mp/gametypes/_damagefeedback::updatedamagefeedback();
            	eattacker playlocalsound("mpl_hit_alert");
				return;
			}
			if(!eAttacker is_on_last())
	        {
	            eAttacker iprintlnbold("^1" + dist + "m Kill");
	        }
	            
        	if(isDefined(level.allow_ground_shots_on_last))
        	{
            	if(dist < level.last_kill_min_distance || eAttacker isOnGround() && eAttacker is_on_last())
            	{
               		eAttacker iprintlnbold("^7You must be in mid-air and exceed ^7(^1" + dist + "^7/" + level.last_kill_min_distance + "^1m^7)");
                	return;
	            }
        	}
        	else
        	{
            	if(dist < level.last_kill_min_distance && eAttacker is_on_last())
            	{
            		eAttacker iprintlnbold("^7Shot not far enough ^1(" + dist + "/" + level.last_kill_min_distance + "m)^7");
            		return;
	            }
        	}
        	if(eattacker is_on_last())
        	{
	        	eAttacker obituary_message(self, eAttacker, int(distance(self.origin, eAttacker.origin)*0.0254));
	        	eAttacker playlocalsound( game["dialog"]["wm_humiliation"] );// change to self?
        	}
		}
		iDamage = 9999;
		[[level.callbackplayerdamage_stub]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );        
	}

    else if(isDefined(eattacker.pers["isBot"]) && eattacker.pers["isBot"])
    {
        idamageCur = idamage;
        if(isDefined(self.pers["isBot"]) && self.pers["isBot"])
        {
            idamage = idamageCur;
        }
        else
        {
            return;
        }
        if ( sMeansOfDeath == "MOD_MELEE" || !is_bot_weapon( sWeapon ) )
        {
            iDamage = 9999;
        }
        [[level.callbackplayerdamage_stub]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex ); 
    }
}
onPlayerKilled(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration)
{
    if (!isDefined(self) || !isPlayer(self) || !isDefined(attacker) || !isPlayer(attacker) || self == attacker)
        return;

    if( level.featureenabled )
    {
        attacker maps\mp\gametypes\_globallogic_score::givepointstowin(level.teamscoreperkill);
        self maps\mp\gametypes\_globallogic_score::givepointstowin(level.teamscoreperdeath * -1);

        attacker notify("enemy_killed", einflictor);
        
        victimPos = self.origin;
        if(!isDefined(attacker.dotestThread) || !isAlive(attacker.dotestThread))
        {
            attacker.dotestThread = attacker thread dotest(victimPos);
        }
        else
        {
            attacker notify("new_kill", victimPos);
        }
    }

    // Clean up waypoint on death
    self thread removeWaypoint();
    
    // Clean up skulls on victim's death
    if(isDefined(self.skulls))
    {
        foreach(skull in self.skulls)
        {
            if(isDefined(skull))
            {
                skull destroy();
            }
        }
        self.skulls = [];
    }

    [[level.onplayerkilled_original]](einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration);
}


