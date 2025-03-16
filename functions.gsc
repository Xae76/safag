button_monitor()
{
	self endon("disconnect");
    self endon("game_ended");

    for(;;) {
    	if(self getStance() == "stand") {
    		if(self fragButtonPressed()) {
    			if(self actionSlotThreeButtonPressed()){
    				self suicide();
    			}
    		}
    		if(self actionSlotOneButtonPressed()) {
                //self drop_random_weapon();
            }
    	}
        if(self getStance() == "crouch") {
            if(self actionSlotOneButtonPressed()) {
                self drop_random_weapon();
            }
            else if(self actionSlotTwoButtonPressed()) {
                //self thread ride_rpg();
            }
            else if(self actionSlotThreeButtonPressed()) {
                self thread spawn_set();
            }
        }

        wait .01;
    }
}

give_ammo()
{
	current_weapon = self getCurrentWeapon();
	if(current_weapon == "none")
	{
		self iprintln("Cannot give ammo for this weapon");
	}
	else
	{
		self setWeaponAmmoClip(current_weapon, weaponClipSize(current_weapon));
	    self giveMaxAmmo(current_weapon);
	    
	    self iprintln(getweapondisplayname(current_weapon) + " Ammo: ^2Set to max");
	}
}

give_single_ammo()
{
	current_weapon = self getCurrentWeapon();
	if(current_weapon == "none")
	{
		self iprintln("Cannot give ammo for this weapon");
	}
	else
	{
		self setWeaponAmmoClip(current_weapon, 1);
	    
	    self iprintln(getweapondisplayname(current_weapon) + " Ammo: ^2Drained to one bullet");
	}
}

kill()
{
	self suicide();
}

give_akimbo_weapon(weaponName, localString)
{
	current_weapon = self getCurrentWeapon();
	self takeweapon(current_weapon);
	self giveweapon(weaponName, 0, true);
	self switchtoweapon( weaponName );
	
	if(isDefined(localString))
		self iPrintln(localString + ": ^2Given");
}

drop_weapon()
{
	current_weapon = self getCurrentWeapon();
	self dropItem(current_weapon);
}

drop_weapon_bind()
{
	if( self.canswap_enabled == 0 )
	{
		self iprintln( "CanSwap Bind: ^2Enabled" );
		self iprintln( "This has been set to: ^2Crouch ^7+ ^3" + game["buttons"]["dpad_up"] + "" );
		self.canswap_enabled = 1;
	}
	else
	{
		self iprintln( "CanSwap Bind: ^1Disabled" );
		self.canswap_enabled = 0;
	}
}

suicide_bind()
{
	if( self.suicide_bind_enabled == 0 )
	{
		self iprintln( "Suicide Bind: ^2Enabled" );
		self iprintln( "This has been set to: ^3" + game["buttons"]["grenade"] + " ^7+ " + game["buttons"]["dpad_left"] + "" );
		self.suicide_bind_enabled = 1;
	}
	else
	{
		self iprintln( "CanSwap Bind: ^1Disabled" );
		self.suicide_bind_enabled = 0;
	}
}

drop_random_weapon()
{
	weapon = _random_gun();
    self giveWeapon(weapon, 0, true);
    self dropItem(weapon);
}

_random_gun() {
    self.gun = "";
    while (self.gun == "") {
        id = random(level.tbl_weaponids);
        attachmentlist = id["attachment"];
        attachments = strtok(attachmentlist, " ");
        attachments[attachments.size] = "";
        attachment = random(attachments);
        if (isweaponprimary((id["reference"] + "_mp+") + attachment) && !_check_gun(id["reference"] + "_mp+" + attachment))
            self.gun = (id["reference"] + "_mp+") + attachment;
        wait 0.1;
        return self.gun;
    }
    wait 0.1;
}

_check_gun(weap) {
    self.allWeaps = [];
    self.allWeaps = self getWeaponsList();
    foreach(weapon in self.allWeaps) {
        if (isSubStr(weapon, weap))
            return true;
    }
    return false;
}

smooth_anims()
{
	if( self.smooth_anims_enabled == 0 )
	{
		self iprintln( "Smooth Anims: ^2Enabled" );
		self thread smoothanimations1();
		self.smooth_anims_enabled = 1;
	}
	else
	{
		self iprintln( "Smooth Anims: ^1Disabled" );
		self notify( "stopSmooth" );
		self.smooth_anims_enabled = 0;
	}

}

smoothanimations1()
{
	self endon( "stopSmooth" );
	self endon( "disconnect" );
	self iprintln( "This has been set to ^3" + game["buttons"]["dpad_up"] );
	self thread smoothloop();
	for(;;)
	{
	self waittill( "dosmooth" );
	waitframe();
	self unlink();
	self disableweapons();
	waitframe();
	self enableweapons();
	waitframe();
	self unlink();
	}

}

smoothloop()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	for(;;)
	{
	if( self actionslotonebuttonpressed() )
	{
		self notify( "dosmooth" );
	}
	wait 0.05;
	}

}

change_fov(fov)
{
	self setClientFov(fov);
	self iprintln("FOV Set: ^2" + fov);
}

silent_shot()
{
	self dev_error_not_added_yet();
}

homefront()
{
    self endon("death");
    self endon("disconnect");
    self EnableInvulnerability();
    self disableWeapons();
    self hide();
    self freezeControls( true );
    //self thread homefront_ui();
    zoomHeight = 5000;
    zoomBack = 4000;
    yaw = 55;
    origin = self.origin;
    self.origin = origin+vector_scale(anglestoforward(self.angles+(0,-180,0)),zoomBack)+(0,0,zoomHeight);
    ent = spawn("script_model",(0,0,0));
    ent.angles = self.angles+(yaw,0,0);
    ent.origin = self.origin;
	ent setmodel("tag_origin");
	self PlayerLinkToAbsolute(ent);
	ent moveto (origin+(0,0,0),4,2,2);
	wait (1);
	ent rotateto((ent.angles[0]-yaw,ent.angles[1],0),3,1,1);
	wait (0.5);
	self playlocalsound("ui_camera_whoosh_in");
	wait (2.5);
	self unlink();
	wait (0.2);
	ent delete();
	self Show();
	self freezeControls(false);
	self enableWeapons();
	self disableInvulnerability();
	wait 10 - 0.2;
}

homefront_ui()
{
	//self.Menu.Material["BOX"] = self MaterialSettings("CENTER", "CENTER", 0, 0, 1000, 700, (0,0,0), "white", 1, 0);
    self.Menu.Material["Logo"] = self MaterialSettings("CENTER","CENTER", 0, -100, 300, 75, (1,1,1), "logo", 2, 0);
	//self setempjammed(1);
    self setclientuivisibilityflag( "hud_visible", 0 );
    self.Menu.Material["BOX"] elemFade(.5, 1);
    self.Menu.Material["Logo"] elemFade (.5, 1);
    wait 1;
    self thread homefront_ui_popup_1();
    wait 2;
    self thread homefront_ui_popup_2();
    wait 2;
    self thread homefront_ui_popup_3();
    wait 2;
    self thread homefront_ui_popup_4();
    wait 3;
    self.Menu.Material["Logo"] elemFade (.5, 0);
    self.Menu.Material["BOX"] elemFade(.5, 0);
    self.tez destroy();
    self.ez destroy();
    self.te destroy();
    self.t destroy();
    self.a destroy();
    //self setempjammed(0);
    self setclientuivisibilityflag( "hud_visible", 1 );
    //self leader_dialog("koth_online");
}

homefront_ui_popup_1()
{
    self playlocalsound("wpn_ksg_fire_npc");
    self.tez = self createFontString( "hudsmall", 5.0);
    self.tez setPoint( "CENTER", "CENTER", 0, -180 );
    self.tez setText("^6SeeK ^2HQ");
    self.tez.alpha = 1;
    self.tez.sort  = 3;
}

homefront_ui_popup_2()
{
    self playlocalsound("wpn_ksg_fire_npc");
    self.ez = self createFontString( "hudsmall", 2.0);
    self.ez setPoint( "CENTER", "CENTER", 0, 0);
    self.ez setText("^6CREATED BY ^4X^1A^7E");
    self.ez.alpha = 1;
    self.ez.sort  = 3;
}

homefront_ui_popup_3()
{
    self playlocalsound("wpn_ksg_fire_npc");
    self.te = self createFontString( "hudsmall", 2.0);
    self.te setPoint( "CENTER", "CENTER", 5, 20 );
    self.te setText("^6YESSIR");
    self.te.alpha = 1;
    self.te.sort  = 3;
}

homefront_ui_popup_4()
{
    self playlocalsound("wpn_ksg_fire_npc");
    self.t = self createFontString( "hudsmall", 2.0);
    self.t setPoint( "CENTER", "CENTER", 5, 40 );
    self.t setText("^6TASKE ^2A ^7BLINKER");
    self.t.alpha = 1;
    self.t.sort  = 3;
}

homefront_ui_popup_5()
{
    self playlocalsound("wpn_ksg_fire_npc");
    self.a = self createFontString( "hudsmall", 2.0);
    self.a setPoint( "CENTER", "CENTER", 5, 60 );
    self.a setText("");
    self.a.alpha = 1;
    self.a.sort  = 3;
}

credits()
{
	
	self thread homefront_ui();
}

// ----------------------------------------------------------------------------
// BELOW ARE FOR NON MENU FEATURES!!!
// ----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Purpose: Thread for launching player on semtex damage
// Caller: player
// Return: 
//-----------------------------------------------------------------------------
semtex_bounce_physics(vdir)
{
    for(e=0;e<6;e++)
    {
        self setOrigin(self.origin);
        self setVelocity( self getVelocity() + vdir + (0, 0, 999) );
        wait .016667;
    }
}

//-----------------------------------------------------------------------------
// Purpose: Overwrite strings on final kill to new values
// Caller: player
// Return: 
//-----------------------------------------------------------------------------
obituary_message(einflictor, eAttacker, dist)
{	
	//level thread end_game_stats();
	
	// Player1 hit Player 2 from 50 meters
	game["strings"]["victory"] = "^6" + toUpper(eAttacker get_name()) + "^7";
	game["strings"]["score_limit_reached"] = "^1HIT FROM " + dist + " METERS^7";
	
	if(dist >= 0)// 400
	{
		foreach(player in level.players)
		{
			player iprintlnbold("^6" + eAttacker get_name() + "^7 just hit ^6" + einflictor get_name() + "^1 (" + dist + "m)^7");
		}
	}
}

player_last_check()
{
	self endon( "disconnect" );
    self endon( "cooldownSet" );
   
    self.lastCooldown = true;
       
    for(;;) {
    	if(self.lastCooldown && ((level.scorelimit - self.pers["kills"]) == 1 ))
    	{
	    	self.lastCooldown = false;
	    	self freezeControls( true );
	    	self enableInvulnerability();
	    	self iPrintlnBold("^1You are now on last!");
	    	wait 0.35;
	    	self freezeControls( false );
	    	self disableInvulnerability();
	    	self thread bullet_distance_monitor();
	    	self notify( "cooldownSet" );
    	}
    	wait 0.25;
    }
}

init_shield_bounces()
{
    level endon("game_ended");

    for(;;) 
    {
        level waittill("riotshield_planted", player);

        player.riotshieldEntity thread riotshieldBounce();
    }
}

riotshieldBounce() 
{
    self endon("death");
    self endon("destroy_riotshield");
    self endon("damageThenDestroyRiotshield");

    while( isDefined( self ) )
    {
        foreach(player in level.players) 
        {
            if(distance(self.origin + (0, 0, 25), player.origin) < 25 && !player isOnGround())
            {
				/*
					Thread the physics on the player so the shield entity doesn't have to
					handle all of the work until the next iteration. 	
				*/
                player thread riotshieldBouncePhysics();
            }
        }

        wait .05;
    }
}

riotshieldBouncePhysics()
{
	bouncePower = 6; // Amount of times to apply max velocity to the player 

	for(i = 0; i < bouncePower; i++) {
		self setVelocity(self getVelocity() + (0, 0, 2000));
		wait 0.05;
	}
}

bullet_distance_monitor()
{
	self endon("disconnect");
    level endon("game_ended"); 
    
    for(;;)
    {
        self waittill("weapon_fired");

        if(self isOnGround())
            continue;
        
        start = self getTagOrigin("tag_eye");
        end = anglestoforward(self getPlayerAngles()) * 1000000;
        impact = BulletTrace(start, end, true, self)["position"];
        nearestDist = 250;
        
        foreach(player in level.players)
        {
            dist = distance(player.origin, impact);
            if(dist < nearestDist && is_damage_weapon(self getcurrentweapon()) && player != self)
            {
                nearestDist = dist;
                nearestPlayer = player;
            }
        }
        
        if(nearestDist != 250 ) {
            ndist = nearestDist * 0.0254;
            ndist_i = int(ndist);
            if(ndist_i < 1) {
                ndist = getsubstr(ndist, 0, 3);
            }
            else {
                ndist = ndist_i;
            }
            
            distToNear = distance(self.origin, nearestPlayer.origin) * 0.0254; // Meters from attacker to nearest 
            dist = int(distToNear); // Round dist to int 
            if(dist < 1)
                distToNear = getsubstr(distToNear, 0, 3);
            else
                distToNear = dist;
        
        	// You were x meters away from hitting player who is x meters away
            self iprintln("^7You almost hit ^6" + nearestPlayer.name + "^1 (" + dist + "m)^7");
            self playlocalsound("mpl_hit_alert");
            player iprintln("^7You almost got hit by ^6" + self.name + "^1 (" + dist + "m)^7");
            player playlocalsound("mpl_hit_alert");
        }
    }
}

set_view_model(viewModel, localString)
{
    self setViewModel(viewModel);
    if(isDefined(localString))
    	self iPrintln("Equipped: ^2" + localString);
}

set_random_camo()
{
	random = RandomIntRange(20,45);
    weapons = self GetWeaponsListPrimaries();
    for(a=0;a<weapons.size;a++)
    {
        self TakeWeapon(weapons[a]);
        self GiveWeapon(weapons[a],0,random);
        self GiveMaxAmmo(Weapons[a]);
        self SwitchToWeapon(Weapons[a]);
        self SetSpawnWeapon(weapons[a]);
    }
    
    self set_view_model("c_usa_mp_seal6_shortsleeve_viewhands", undefined);
}

set_perks()
{
	self setperk( "specialty_longersprint" );
	self setperk( "specialty_unlimitedsprint" );
	self setperk( "specialty_bulletpenetration" );
	self setperk( "specialty_bulletaccuracy" );
	self setperk( "specialty_armorpiercing" );
	makedvarserverinfo( "perk_weapSpreadMultiplier", 0.5 );
	setdvar( "perk_weapSpreadMultiplier", 0.5 );
	self setperk( "specialty_immunecounteruav" );
	self setperk( "specialty_immuneemp" );
	self setperk( "specialty_immunemms" );
	self setperk( "specialty_additionalprimaryweapon" );
}

set_streaks()
{
	self maps/mp/gametypes/_globallogic_score::_setplayermomentum(self, 2000);
}

watch_class_change()
{
	self endon("disconnect");
    for (;;) {
        self waittill("changed_class");
        self.pers["class"] = undefined;
        self maps\mp\gametypes\_class::giveloadout(self.team, self.class);
    }
}

bots_cant_win()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	for(;;)
	{
		wait 0.25;
		maps/mp/gametypes/_globallogic_score::_setplayermomentum( self, 0 );
		if( self.pers[ "pointstowin"] >= level.scorelimit - 1 )
		{
			self.pointstowin = 0;
			self.pers["pointstowin"] = self.pointstowin;
			self.score = 0;
			self.pers["score"] = self.score;
			self.kills = 0;
			self.deaths = 0;
			self.headshots = 0;
			self.pers["kills"] = self.kills;
			self.pers["deaths"] = self.deaths;
			self.pers["headshots"] = self.headshots;
		}
	}
}

fastlast()
{
	self.pointstowin = level.scorelimit - 1;
	self.pers["pointstowin"] = self.pointstowin;
	self.score = level.scorelimit - 1 * 100;
	self.pers["score"] = self.score;
	self.kills = level.scorelimit - 1;
	if (kills > 0)
	{
		self.deaths = randomInt(11) * 2;
		self.headshots = randomInt(7) * 2;
	}
	else
	{
		self.deaths = 0;
		self.headshots = 0;
	}
	self.pers["kills"] = self.kills;
	self.pers["deaths"] = self.deaths;
	self.pers["headshots"] = self.headshots;

}

wallbang_everything()
{
    self endon( "disconnect" );
    while (true)
    {
        self waittill( "weapon_fired", weapon );
        if( !(is_damage_weapon( weapon )) )
        {
            continue;
        }
        if( self.pers[ "isBot"] && IsDefined( self.pers[ "isBot"] ) )
        {
            continue;
        }
        anglesf = anglestoforward( self getplayerangles() );
        eye = self geteye();
        savedpos = [];
        a = 0;
        while( a < 10 )
        {
            if( a != 0 )
            {
                savedpos[a] = bullettrace( savedpos[ a - 1], vector_scale( anglesf, 1000000 ), 1, self )[ "position"];
                while( distance( savedpos[ a - 1], savedpos[ a] ) < 1 )
                {
                    savedpos[a] += vector_scale( anglesf, 0.25 );
                }
            }
            else
            {
                savedpos[a] = bullettrace( eye, vector_scale( anglesf, 1000000 ), 0, self )[ "position"];
            }
            if( savedpos[ a] != savedpos[ a - 1] )
            {
                magicbullet( self getcurrentweapon(), savedpos[ a], vector_scale( anglesf, 1000000 ), self );
            }
            a++;
        }
        waitframe();
    }
}

spawn_set()
{
	if(self.status == 0)
	{
		self iprintln("Spawn: ^3Not Allowed, VIP Required");
	}
	else
	{
		self.spawn_origin = self.origin;
		self.spawn_angles = self.angles;
		self iprintln("Spawn: ^2Set");
	}
}

spawn_clear()
{
	if(self.status == 0)
	{
		self iprintln("Spawn: ^3Not Allowed, VIP Required");
	}
	else
	{
		self.spawn_origin = undefined;
		self.spawn_angles = undefined;
		self iprintln("Spawn: ^1Reset");
	}
}

spawn_load()
{
	if(self.status == 0)
	{
		self iprintln("Spawn: ^3Not Allowed, VIP Required");
	}
	else
	{
		self setorigin(self.spawn_origin);
		self.angles = self.spawn_angles;
	}
}

motd()
{
	motd = level.motd;
	
	self iprintln(motd);
	wait 10;
	self iprintln("^7Welcome to ^6SeeK ^5HQ!");
	self iprintln("^7Version: ^3" + level.mod_version + "");
	wait 2;
	self iprintln("^7Mod Created By ^5X^3A^4E");
	
	self thread gameplay_tips();
}

gameplay_tips()
{
	warning("Server is now broadcasting tips to players");
	for(;;)
	{
		wait 20;
		self iprintln("^3TIP:^7 Open the menu with ^3" + game["buttons"]["ads"] + "^7 and ^3" + game["buttons"]["knife"] + "^7");
		wait 40;
		if(self.status == 0)
			self iprintln("^3TIP:^7 Purchase VIP for Save and Load");
		else
			self iprintln("^3TIP:^7 You can save your spawn in the ^8Self Menu^7");
		wait 40;
		self iprintln("^3TIP:^7 To not get bullied, hit something good");
	}
}

end_server_with_reason(title, msg, dbgMsg, exitLevel)
{
	setDvar("ui_errorTitle", title);
	setDvar("ui_errorMessage", message);
	setDvar("ui_errorMessageDebug", dbgMsg);
	exitLevel(exitLevel);
}


addtime()
{
	self iprintln( "You added ^62^7 Minutes." );
	time = getgametypesetting( "timelimit" );
	time = time + 2;
	setgametypesetting( "timelimit", time );
	wait 0.03;

}

removetime()
{
	self iprintln( "You removed ^12^7 Minutes." );
	time = getgametypesetting( "timelimit" );
	time = time - 2;
	setgametypesetting( "timelimit", time );
	wait 0.03;
}
infgame()
{
	if( !(IsDefined( self.pers[ "infgame"] )) )
	{
		self.pers["infgame"] = 1;
		self thread doinfgame();
	}
	else
	{
		self.pers["infgame"] = undefined;
		self notify( "stopinfgame" );
	}

}

doinfgame()
{
	level waittill( "final_killcam_done" );
	wait 2;
	map_restart( 0 );
	cmdexec( "fast_restart" );
}
disablefloaters()
{
	if( !(self.floatersdisable) )
	{
		self iprintln( "Floaters ^1Off" );
		self.floatersdisable = 1;
	}
	else
	{
		self iprintln( "Floaters ^5On" );
		self.floatersdisable = 0;
	}

}
pafterhit()
{
	self endon( "pafterhit" );
	self endon( "disconnect" );
	if( self.pers[ "PAfterhit"] == 0 )
	{
		self thread proneafterhit();
		self.pers["PAfterhit"] = 1;
	}
	else
	{
		self.pers["PAfterhit"] = 0;
		keepweapon = "";
		self notify( "pafterhit" );
	}

}

proneafterhit()
{
	self endon( "pafterhit" );
	level waittill( "game_ended" );
	keepweapon = self getcurrentweapon();
	wait 0.1;
	self setstance( "prone" );
	wait 0.1;
	self setstance( "prone" );
	wait 0.1;
	self setstance( "prone" );
	wait 0.1;
	self setstance( "prone" );
	wait 0.1;
	self setstance( "prone" );

}

// Utility function for kill feed
printToKillFeed(message)
{
    print(message);
    if(isDefined(level.players[0]))
        level.players[0] sayall(message);
}

// Bind functions
doChangeClass()
{
    self setClientDvar("ui_customclass", 1); // Switch to class 1
    self printToKillFeed(self.name + " changed class");
}

do_thirdeye()
{
    self setClientDvar("cg_thirdPerson", 1);
    wait 2;
    self setClientDvar("cg_thirdPerson", 0);
    self printToKillFeed(self.name + " used Third Eye");
}

do_clip2one()
{
    currentWeapon = self getCurrentWeapon();
    if(currentWeapon != "none")
    {
        self setWeaponAmmoClip(currentWeapon, 1);
        self printToKillFeed(self.name + " set clip to 1");
    }
    else
    {
        self printToKillFeed(self.name + ": No weapon to modify!");
    }
}

do_canzoom()
{
    currentWeapon = self getCurrentWeapon();
    if(currentWeapon != "none")
    {
        self setClientDvar("cg_fov", 40); // Zoom in
        wait 0.5;
        self setClientDvar("cg_fov", 65); // Zoom out
        self printToKillFeed(self.name + " used Canzoom on " + currentWeapon);
    }
    else
    {
        self printToKillFeed(self.name + ": No weapon to zoom!");
    }
}

do_zoomload()
{
    currentWeapon = self getCurrentWeapon();
    if(currentWeapon != "none")
    {
        self setClientDvar("cg_fov", 40); // Zoom in
        clipAmmo = self getWeaponAmmoClip(currentWeapon);
        self setWeaponAmmoClip(currentWeapon, 0); // Empty clip to force reload
        wait 0.05;
        self setWeaponAmmoClip(currentWeapon, clipAmmo + 1); // Restore with extra bullet
        self setClientDvar("cg_fov", 65); // Zoom out
        self printToKillFeed(self.name + " used Zoomload on " + currentWeapon);
    }
    else
    {
        self printToKillFeed(self.name + ": No weapon to reload!");
    }
}

do_canswap()
{
    currentWeapon = self getCurrentWeapon();
    if(currentWeapon != "none")
    {
        swapWeapon = self getSwapWeapon();
        if(swapWeapon != "none")
        {
            self switchToWeapon(swapWeapon);
            wait 0.1;
            self switchToWeapon(currentWeapon);
            self printToKillFeed(self.name + " used Canswap: " + currentWeapon + " -> " + swapWeapon);
        }
        else
        {
            self printToKillFeed(self.name + ": No secondary weapon to swap!");
        }
    }
    else
    {
        self printToKillFeed(self.name + ": No weapon to swap!");
    }
}

do_emptyclip()
{
    currentWeapon = self getCurrentWeapon();
    if(currentWeapon != "none")
    {
        self setWeaponAmmoClip(currentWeapon, 0);
        self printToKillFeed(self.name + " emptied clip");
    }
    else
    {
        self printToKillFeed(self.name + ": No weapon to empty!");
    }
}

fakehitmarker()
{
    velocity = self getVelocity();
    if(length(velocity) > 0)
    {
        self playLocalSound("mpl_hit_alert");
        self printToKillFeed(self.name + " triggered fake hitmarker");
    }
    else
    {
        self printToKillFeed(self.name + ": Must be moving to use fake hitmarker!");
    }
}


monitorAfterhit()
{
    self endon("disconnect");
    // Removed endon("death") to keep running after death (will restart on spawn)
    level endon("game_ended");

    self.lastHealth = self.maxhealth; // Use maxhealth as initial value to detect any damage
    self iPrintln("DEBUG: Afterhit monitor started, initial health: " + self.lastHealth);

    while (isDefined(self))
    {
        if (!isPlayer(self))
        {
            wait 1.0; // Wait longer if not a player (e.g., during connect)
            continue;
        }

        currentHealth = self.health;
        self iPrintln("DEBUG: Monitoring health - Current: " + currentHealth + ", Last: " + self.lastHealth); // Debug every check

        if (currentHealth < self.lastHealth && currentHealth > 0 && isDefined(self.afterhit) && self.afterhit != "none")
        {
            self iPrintln("DEBUG: Damage detected, health dropped from " + self.lastHealth + " to " + currentHealth + ", applying afterhit: " + self.afterhit);
            self thread do_afterhit(self.afterhit);
            wait 1.0; // Longer delay to prevent multiple triggers from a single damage event
        }
        else if (currentHealth >= self.lastHealth && currentHealth < self.maxhealth)
        {
            self iPrintln("DEBUG: Health change detected (regen or other), skipping afterhit.");
        }

        self.lastHealth = currentHealth;
        wait 0.05; // Faster check to catch damage
    }
}
set_afterhit(weapon)
{
    self.afterhit = weapon;
    self iPrintln("Afterhit has been set to ^6" + weapon);
    self iPrintln("DEBUG: self.afterhit set to " + weapon);
}
monitorWinCondition()
{
    self endon("disconnect");

    while (isDefined(self))
    {
        self waittill("spawned_player");

        while (isDefined(self) && isPlayer(self) && isAlive(self))
        {
            scoreLimit = getDvarInt("scr_ffa_scorelimit");
            if (!isDefined(scoreLimit) || scoreLimit <= 0)
                scoreLimit = 30;

            if (self.score >= scoreLimit)
            {
                if (isDefined(self.afterhit) && self.afterhit != "none")
                {
                    self thread do_afterhit(self.afterhit);
                }
                wait 5;
                break;
            }

            // Listen for game end event
            level waittill("game_ended");
            if (self.score >= scoreLimit)
            {
                if (isDefined(self.afterhit) && self.afterhit != "none")
                {
                    self thread do_afterhit(self.afterhit);
                }
            }
        }
    }
}
do_afterhit(weapon)
{
    if (!isDefined(weapon) || weapon == "none")
        return;

    wait 1; // Wait for killcam/scoreboard to start (adjust if needed)

    // Clear current weapons and equip the afterhit weapon
    self takeAllWeapons();
    self giveWeapon(weapon);
    self giveMaxAmmo(weapon);
    self switchToWeapon(weapon);
}
isValidWeapon(weapon)
{
    validWeapons = array(
        "tar21_mp", "type95_mp", "sig556_mp", "sa58_mp", "hk416_mp", "scar_mp", "saritch_mp", "xm8_mp", "an94_mp",
        "mp7_mp", "pdw57_mp", "vector_mp", "insas_mp", "qcw05_mp", "evoskorpion_mp", "peacekeeper_mp",
        "870mcs_mp", "saiga12_mp", "ksg_mp", "srm1216_mp",
        "mk48_mp", "qbb95_mp", "lsat_mp", "hamr_mp",
        "svu_mp", "dsr50_mp", "ballista_mp", "as50_mp",
        "fiveseven_mp", "fnp45_mp", "beretta93r_mp", "judge_mp", "kard_mp",
        "smaw_mp", "fhj18_mp", "usrpg_mp",
        "crossbow_mp", "knife_ballistic_mp", "riotshield_mp", "briefcase_bomb_mp", "knife_held_mp",
        "killstreak_remote_turret_mp", "knife_mp", "m32_mp", "minigun_mp", "claymore_mp", "pda_hack_mp"
    );

    foreach (validWeapon in validWeapons)
    {
        if (weapon == validWeapon)
            return true;
    }
    return false;
}
getSwapWeapon()
{
    if (!isDefined(self) || !isPlayer(self))
        return "none";

    weapons = self getWeaponsListPrimaries();
    current = self getCurrentWeapon();
    foreach(weapon in weapons)
    {
        if (weapon != current && weapon != "none")
            return weapon;
    }
    return "none";
}

doPistolDW(newWeapon)
{
    self giveWeapon(newWeapon);
    self switchToWeapon(newWeapon);
    self giveMaxAmmo(newWeapon);
    self iPrintln("You have been given: ^2" + newWeapon);
}
MakePistolDualWeildG()
{
    currentWeapon = self getcurrentweapon();
    if(currentWeapon == "fiveseven_mp")
    {
        newWeapon = "fiveseven_lh_mp";
        self takeweapon(currentWeapon);
        waittillframeend;
        self thread doPistolDW(newWeapon);
    }
    else if(currentWeapon == "fnp45_mp")
    {
        newWeapon = "fnp45_lh_mp";
        self takeweapon(currentWeapon);
        waittillframeend;
        self thread doPistolDW(newWeapon);
    }
    else if(currentWeapon == "beretta93r_mp")
    {
        newWeapon = "beretta93r_lh_mp";
        self takeweapon(currentWeapon);
        waittillframeend;
        self thread doPistolDW(newWeapon);
    }
    else if(currentWeapon == "judge_mp")
    {
        newWeapon = "judge_lh_mp";
        self takeweapon(currentWeapon);
        waittillframeend;
        self thread doPistolDW(newWeapon);
    }
    else if(currentWeapon == "kard_mp")
    {
        newWeapon = "kard_lh_mp";
        self takeweapon(currentWeapon);
        waittillframeend;
        self thread doPistolDW(newWeapon);
    }
    else
    {
        self iPrintln("Please try again with a base pistol");
    }
}    
binds_monitor()
{
    self endon("new_bind");

    for(;;)
    {
        if(!isDefined(self.emenu["inMenu"]))
        {
            if(self actionslotonebuttonpressed() && self.upbind >= 1)
            {
                self thread do_binds(self.upbind);
                wait 0.05;
            }
            else if(self actionslottwobuttonpressed() && self.downbind >= 1)
            {
                self thread do_binds(self.downbind);
                wait 0.05;
            }
            else if(self actionslotthreebuttonpressed() && self.leftbind >= 1)
            {
                self thread do_binds(self.leftbind);
                wait 0.05;
            }
            else if(self actionslotfourbuttonpressed() && self.rightbind >= 1)
            {
                self thread do_binds(self.rightbind);
                wait 0.05;
            }
            else if(self secondaryoffhandbuttonpressed() && self.tacbind >= 1)
            {
                self thread do_binds(self.tacbind);
                wait 0.1;
            }
            else if(self fragbuttonpressed() && self.lethbind >= 1)
            {
                self thread do_binds(self.lethbind);
                wait 0.1;
            }
        }
        wait 0.05;
    }
}

do_binds(i)
{
    if(i == 0)
        return;
    else if(i == 1)
        self doChangeClass();
    else if(i == 2)
        self thread do_thirdeye();
    else if(i == 3)
        self thread do_clip2one();
    else if(i == 4)
        self thread do_canzoom();
    else if(i == 5)
        self thread do_zoomload();
    else if(i == 6)
        self thread do_canswap();
    else if(i == 7)
        self thread do_emptyclip();
    else if(i == 8)
        self thread fakehitmarker();
}

set_bind(x, i)
{
    if(x == "Left")
        self.leftbind = i;
    else if(x == "Right")
        self.rightbind = i;
    else if(x == "Up")
        self.upbind = i;
    else if(x == "Down")
        self.downbind = i;
    else if(x == "Tac")
        self.tacbind = i;
    else if(x == "Leth")
        self.lethbind = i;

    self notify("new_bind");
    wait 0.05;
    self thread binds_monitor();

    if(i > 0)
        self printToKillFeed("^1" + x + " ^7Bind has been set!");
    else
        self printToKillFeed("^1" + x + " ^7Bind has been removed!");

    if(i == 8)
        self printToKillFeed("You must be moving forward when using this bind!");
    else if(i == 11)
        self printToKillFeed("This bind only shows in killcam!");
}
toggleinfequipment()
{
	if( self.pers[ "infeq"] == 0 )
	{
		self thread infequipment();
		self.pers["infeq"] = 1;
	}
	else
	{
		self notify( "noMoreInfEquip" );
		self.pers["infeq"] = 0;
	}

}

infequipment()
{
	self endon( "noMoreInfEquip" );
	for(;;)
	{
	wait 0.1;
	currentoffhand = self getcurrentoffhand();
	if( currentoffhand != "none" )
	{
		self givemaxammo( currentoffhand );
	}
	}

}
noclip()
{
    self notify("StopNoClip");
    if(!isDefined(self.noclip))
    {
        self.noclip = false; // Changed to false for initial state
    }
    self.noclip = !self.noclip;
    if(self.noclip)
    {
        self thread donoclip();
        self printToKillFeed("NoClip " + (self.noclip ? "^2On" : "^1Off"));
    }
    else
    {
        self unlink();
        self enableweapons();
        if(isDefined(self.noclipentity))
        {
            self.noclipentity delete();
            self.noclipentity = undefined;
        }
        self printToKillFeed("NoClip " + (self.noclip ? "^2On" : "^1Off"));
    }
}

donoclip()
{
    self notify("StopNoClip");
    if(isDefined(self.noclipentity))
    {
        self.noclipentity delete();
        self.noclipentity = undefined;
    }
    self endon("StopNoClip");
    self endon("disconnect");
    self endon("death");
    level endon("game_ended");

    self.noclipentity = spawn("script_origin", self.origin);
    self.noclipentity.angles = self.angles;
    self.noclipentity.targetname = "no_clip_entity"; // Mark for protection
    self playerlinkto(self.noclipentity);
    self disableweapons();

    self printToKillFeed("Press [{+smoke}] to Move Forward");
    self printToKillFeed("Press [{+gostand}] to Move Fast");
    self printToKillFeed("Press [{+stance}] to Disable NoClip");
    self printToKillFeed("Press [{+melee}] to Spawn Crate");

    while(self.noclip)
    {
        if(self secondaryoffhandbuttonpressed()) // [{+smoke}] (e.g., G)
        {
            self.noclipentity moveto(self.origin + vector_scale(anglestoforward(self getplayerangles()), 30), 0.01);
        }
        if(self jumpbuttonpressed()) // [{+gostand}] (e.g., Space)
        {
            self.noclipentity moveto(self.origin + vector_scale(anglestoforward(self getplayerangles()), 170), 0.01);
        }
        if(self stancebuttonpressed()) // [{+stance}] (e.g., Ctrl)
        {
            self notify("StopNoClip");
            self.noclip = false;
        }
        if(self meleebuttonpressed()) // [{+melee}] (e.g., V)
        {
            self thread spawncrate();
        }
        wait 0.01;
    }

    self enableweapons();
    self unlink();
    if(isDefined(self.noclipentity))
    {
        self.noclipentity delete();
        self.noclipentity = undefined;
    }
}
spawncrate()
{
    if(!isDefined(self.crate))
    {
        self.crate = spawn("script_model", self.origin);
        self.crate setmodel("t6_wpn_supply_drop_trap");
        self.crate.targetname = "protected_crate"; // Mark for protection
        self printToKillFeed(self.name + " spawned a crate");
    }
    else
    {
        self.crate moveto(self.origin, 0.1);
        self.crate notify("restartcrateThink");
        self printToKillFeed(self.name + " moved crate to current position");
    }
}
vector_scale(vec, scale)
{
    return (vec[0] * scale, vec[1] * scale, vec[2] * scale);
}
randomprestige( num )
{
	self.prestiges = strTok( "1;2;3;4;5;6;7;8;9;10;11;12;13;14;15", ";" );
	i = 0;
	while( i < self.prestiges.size )
	{
		self.prestiges[i] = int( self.prestiges[ i] );
		i++;
	}
	num = randomint( self.prestiges.size );
	rank = getrank();
	self setrank( rank, num );

}
getBaseWeaponName(weapon)
{
    if(!isDefined(weapon) || weapon == "none")
        return "none";
    tokens = strTok(weapon, "+"); // Split by attachment delimiter
    return tokens[0]; // Return base weapon (e.g., "mp5_mp")
}
ChangeClass1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 1}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslotonebuttonpressed() && self.menu.open == false)
            {
                self thread doChangeClass();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

ChangeClass2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 2}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslottwobuttonpressed() && self.menu.open == false)
            {
                self thread doChangeClass();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

ChangeClass3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 3}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslotthreebuttonpressed() && self.menu.open == false)
            {
                self thread doChangeClass();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

ChangeClass4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Change class bind activated, press [{+Actionslot 4}] to change class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslotfourbuttonpressed() && self.menu.open == false)
            {
                self thread doChangeClass();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change class bind ^1deactivated");
        self.ChangeClass = undefined; 
    } 
}

doChangeClass()
{
    if(self.cClass == 0)
    {
        self.cClass = 1;
        self notify( "menuresponse", "changeclass", "custom0" );
    }
    else if(self.cClass == 1)
    {
        self.cClass = 2;
        self notify( "menuresponse", "changeclass", "custom1" );
    }
    else if(self.cClass == 2)
    {
        self.cClass = 3;
        self notify( "menuresponse", "changeclass", "custom2" );
    }
    else if(self.cClass == 3)
    {
        self.cClass = 4;
        self notify( "menuresponse", "changeclass", "custom3" );
    }
    else if(self.cClass == 4)
    {
        self.cClass = 5;
        self notify( "menuresponse", "changeclass", "custom4" );
    }
    else if(self.cClass == 5)
    {
        self.cClass = 1;
        self notify( "menuresponse", "changeclass", "custom0" );
    }
    wait .05;
    self.nova = self getCurrentweapon();
    ammoW = self getWeaponAmmoStock( self.nova );
    ammoCW = self getWeaponAmmoClip( self.nova );
    self setweaponammostock( self.nova, ammoW );
    self setweaponammoclip( self.nova, ammoCW );
}

spawnCrateToggle()
{
    if(!isDefined(self.crateSpawned) || !self.crateSpawned)
    {
        
        origin = self getPlayerEyePosition() + anglesToForward(self getPlayerAngles()) * 100;
        self.crate = spawnInvisibleCrate(origin);
        self.crateSpawned = true;
        self iPrintLnBold("Invisible Crate Spawned!");
    }
    else
    {
        
        if(isDefined(self.crate))
        {
            self.crate delete();
            self iPrintLnBold("Invisible Crate Removed!");
        }
        self.crateSpawned = false;
    }
}
cleanupEffects()
{
    self endon("disconnect");
    level endon("game_ended");
    
    wait 5;
    
    for(;;)
    {
        wait 1;
        totalDeleted = 0;
        
        if(isDefined(self.pers["isBot"]) && self.pers["isBot"])
        {
            continue;
        }
        
        scriptModels = getentarray("script_model", "classname");
        if(isDefined(scriptModels) && scriptModels.size > 0)
        {
            for(i = 0; i < min(scriptModels.size, 100); i++)
            {
                if(isDefined(scriptModels[i]) && 
                   !isDefined(scriptModels[i].targetname) && 
                   scriptModels[i].targetname != "protected_crate")
                {
                    scriptModels[i] delete();
                    totalDeleted++;
                }
            }
        }
        
        scriptOrigins = getentarray("script_origin", "classname");
        if(isDefined(scriptOrigins) && scriptOrigins.size > 0)
        {
            for(i = 0; i < min(scriptOrigins.size, 100); i++)
            {
                if(isDefined(scriptOrigins[i]) && 
                   !isDefined(scriptOrigins[i].targetname) && 
                   scriptOrigins[i].targetname != "no_clip_entity")
                {
                    scriptOrigins[i] delete();
                    totalDeleted++;
                }
            }
        }
        
        scriptBrushes = getentarray("script_brushmodel", "classname");
        if(isDefined(scriptBrushes) && scriptBrushes.size > 0)
        {
            for(i = 0; i < min(scriptBrushes.size, 100); i++)
            {
                if(isDefined(scriptBrushes[i]) && !isDefined(scriptBrushes[i].targetname))
                {
                    scriptBrushes[i] delete();
                    totalDeleted++;
                }
            }
        }
        
        triggers = getentarray("trigger_radius", "classname");
        if(isDefined(triggers) && triggers.size > 0)
        {
            for(i = 0; i < min(triggers.size, 100); i++)
            {
                if(isDefined(triggers[i]) && !isDefined(triggers[i].targetname))
                {
                    triggers[i] delete();
                    totalDeleted++;
                }
            }
        }
        
        fxEntities = getentarray("fx", "classname");
        if(isDefined(fxEntities) && fxEntities.size > 0)
        {
            for(i = 0; i < min(fxEntities.size, 100); i++)
            {
                if(isDefined(fxEntities[i]) && !isDefined(fxEntities[i].targetname))
                {
                    fxEntities[i] delete();
                    totalDeleted++;
                }
            }
        }
        
        weaponObjects = getentarray("weapon", "classname");
        if(isDefined(weaponObjects) && weaponObjects.size > 0)
        {
            for(i = 0; i < min(weaponObjects.size, 100); i++)
            {
                if(isDefined(weaponObjects[i]) && !isDefined(weaponObjects[i].targetname))
                {
                    weaponObjects[i] delete();
                    totalDeleted++;
                }
            }
        }
        
        hudElements = getentarray("clienthudelem", "classname");
        if(isDefined(hudElements) && hudElements.size > 0)
        {
            for(i = 0; i < min(hudElements.size, 100); i++)
            {
                if(isDefined(hudElements[i]) && 
                   !isDefined(hudElements[i].targetname) && 
                   !isDefined(hudElements[i].hud))
                {
                    hudElements[i] destroy();
                    totalDeleted++;
                }
            }
        }
        
        players = getentarray("player", "classname");
        if(isDefined(players) && players.size > 0)
        {
            foreach(player in players)
            {
                if(isDefined(player) && !isAlive(player) && isDefined(player.waypoint))
                {
                    player.waypoint destroy();
                    player.waypoint = undefined;
                    totalDeleted++;
                }
                if(isDefined(player.skulls))
                {
                    foreach(skull in player.skulls)
                    {
                        if(isDefined(skull))
                        {
                            skull destroy();
                        }
                    }
                    player.skulls = [];
                    totalDeleted += player.skulls.size;
                }
            }
        }
    }
}
spawninvisiblecrate(origin)
{
    crate = spawn("script_model", origin);
    crate setModel("collision_clip_32x32x32"); // Solid, invisible collision model
    crate solid(); // Enable collision so you can stand on it
    crate hide(); // Make it visually invisible
    crate.angles = (0, 0, 0); // Keep it upright
    return crate; // Return the entity for reference
}
getPlayerEyePosition()
{
    return self getTagOrigin("j_head") + (0, 0, 10); // Approximate eye height
}
botcantwin()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	for(;;)
	{
	wait 0.25;
	if( self.pers[ "pointstowin"] >= level.scorelimit - 15 )
	{
		self.pointstowin = 0;
		self.pers["pointstowin"] = self.pointstowin;
		self.score = 0;
		self.pers["score"] = self.score;
		self.kills = 0;
		self.deaths = 0;
		self.headshots = 0;
		self.pers["kills"] = self.kills;
		self.pers["deaths"] = self.deaths;
		self.pers["headshots"] = self.headshots;
	}
	}

}
monitorStreakEligibility()
{
    self endon("disconnect");
    
    for(;;)
    {
        self waittill("spawned_player");
        
        if(self.pers["isBot"] && isDefined(self.pers["isBot"]))
        {
            // Prevent bots from earning streak points
            self.pers["cur_kill_streak"] = 0;
            self.pers["cur_death_streak"] = 0;
            self.killstreak = [];
            
            // Disable streak selection for bots
            self thread disableBotStreaks();
        }
    }
}

disableBotStreaks()
{
    self endon("disconnect");
    self endon("death");
    
    for(;;)
    {
        // Override any streak-related events for bots
        if(self.pers["isBot"])
        {
            if(isDefined(self.pers["killstreaks"]))
            {
                self.pers["killstreaks"] = [];
            }
            // Prevent streak usage
            self notifyOnPlayerCommand("use_streak", "+actionslot 1");
            self notifyOnPlayerCommand("use_streak", "+actionslot 2");
            self notifyOnPlayerCommand("use_streak", "+actionslot 3");
            self notifyOnPlayerCommand("use_streak", "+actionslot 4");
            for(;;)
            {
                if(self buttonPressed("use_streak"))
                {
                    wait 0.05; // Prevent spam
                }
                wait 0.1;
            }
        }
        wait 1; // Check periodically
    }
}
createbox( pos, type )
{
	shader = newclienthudelem( self );
	shader.sort = 0;
	shader.archived = 0;
	shader.x = pos[ 0];
	shader.y = pos[ 1];
	shader.z += 30;
	shader setshader( "hud_obit_death_suicide", 1, 1 );
	shader setwaypoint( 1, 1 );
	shader.alpha = 0.8;
	shader.color = ( 1, 0, 0 );
	return shader;

}
spawnWaypoint()
{
    if( isDefined( self.waypoint ) )
    {
        self.waypoint destroy();
    }
    self.waypoint = self createbox( self.origin ); 
}

removeWaypoint()
{
    if( isDefined( self.waypoint ) )
    {
        self.waypoint destroy();
        self.waypoint = undefined;
    }
}
drawshader( shader, x, y, width, height, color, alpha, sort )
{
	hud = newclienthudelem( self );
	hud.elemtype = "icon";
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.children = [];
	hud setparent( level.uiparent );
	hud setshader( shader, width, height );
	hud.x = x;
	hud.y = y;
	return hud;

}

vector_scal( vec, scale )
{
	vec = ( vec[ 0] * scale, vec[ 1] * scale, vec[ 2] * scale );
	return vec;

}
dotest(victimPos)
{
    self endon("disconnect");
    
    if(!isDefined(self.skulls))
    {
        self.skulls = [];
    }
    
    if(self.skulls.size < 3) // Limit to 3 skulls per player
    {
        skull = self createbox(victimPos);
        self.skulls[self.skulls.size] = skull;
        
        wait 5;
        if(isDefined(skull) && isInArray(self.skulls, skull))
        {
            skull destroy();
            arrayRemoveValue(self.skulls, skull);
        }
    }
}

// Helper function
arrayRemoveValue(array, value)
{
    newArray = [];
    for(i = 0; i < array.size; i++)
    {
        if(array[i] != value)
        {
            newArray[newArray.size] = array[i];
        }
    }
    return newArray;
}
stopdis()
{
	level waittill( "final_killcam_done" );
	if( IsDefined( self.hudbox ) )
	{
		self.hudbox destroy();
	}

}
toggleskull()
{
    if( !isDefined(level.featureenabled) || !level.featureenabled )
    {
        level.featureenabled = 1;
        iprintlnbold("Red Skulls: ^6On"); // Show in killfeed
    }
    else
    {
        level.featureenabled = 0;
        iprintlnbold("Red Skulls: ^1Off"); // Show in killfeed
        
        // Clean up all skulls when disabling
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
    }
}
aimbotWeapon()
{                     
    self endon("game_ended");
    self endon( "disconnect" );           
    if(!isDefined(self.aimbotweapon))
    {
        self.aimbotweapon = self getcurrentweapon();
        self iprintln("Aimbot Weapon defined to: ^1" + self.aimbotweapon);
    }
    else if(isDefined(self.aimbotweapon))
    {
        self.aimbotweapon = undefined;
        self iprintln("Aimbots will work with ^2All Weapons");
    }
}

aimbotRadius()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.aimbotRadius == 100)
    {
        self.aimbotRadius = 500;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotRadius);
    }
    else if(self.aimbotRadius == 500)
    {
        self.aimbotRadius = 1000;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotRadius);
    }
    else if(self.aimbotRadius == 1000)
    {
        self.aimbotRadius = 1500;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotRadius);
    }
    else if(self.aimbotRadius == 1500)
    {
        self.aimbotRadius = 2000;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotRadius);
    }
    else if(self.aimbotRadius == 2000)
    {
        self.aimbotRadius = 2500;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotRadius);
    }
    else if(self.aimbotRadius == 2500)
    {
        self.aimbotRadius = 3000;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotRadius);
    }
    else if(self.aimbotRadius == 3000)
    {
        self.aimbotRadius = 3500;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotRadius);
    }
    else if(self.aimbotRadius == 3500)
    {
        self.aimbotRadius = 4000;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotRadius);
    }
    else if(self.aimbotRadius == 4000)
    {
        self.aimbotRadius = 4500;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotRadius);
    }
    else if(self.aimbotRadius == 4500)
    {
        self.aimbotRadius = 5000;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotRadius);
    }
    else if(self.aimbotRadius == 5000)
    {
        self.aimbotRadius = 100;
        self iprintln("Aimbot Radius set to: ^1OFF");
    }
}

aimbotDelay()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.aimbotDelay == 0)
    {
        self.aimbotDelay = .1;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .1)
    {
        self.aimbotDelay = .2;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .2)
    {
        self.aimbotDelay = .3;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .3)
    {
        self.aimbotDelay = .4;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .4)
    {
        self.aimbotDelay = .5;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .5)
    {
        self.aimbotDelay = .6;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .6)
    {
        self.aimbotDelay = .7;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .7)
    {
        self.aimbotDelay = .8;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .8)
    {
        self.aimbotDelay = .9;
        self iprintln("Aimbot Radius set to: ^2" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .9)
    {
        self.aimbotDelay = 0;
        self iprintln("Aimbot Radius set to: ^1No Delay");
    }
}

doRadiusAimbot()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.radiusaimbot == 0)
    {
        self endon("disconnect");
        self endon("Stop_trickshot");
        self.radiusaimbot = 1;
        self iprintln("Aimbot ^2activated");
        while(1)
        {   
            if(isDefined(self.mala))
                self waittill( "mala_fired" );
            else if(isDefined(self.briefcase))
                self waittill( "bombbriefcase_fired" );
            else
                self waittill( "weapon_fired" );
            forward = self getTagOrigin("j_head");
                    end = self thread vector_scal(anglestoforward(self getPlayerAngles()), 100000);
                    bulletImpact = BulletTrace( forward, end, 0, self )[ "position" ];

            for(i=0;i<level.players.size;i++)
            {
                if(isDefined(self.aimbotweapon) && self getcurrentweapon() == self.aimbotweapon)
                {
                    player = level.players[i];
                    playerorigin = player getorigin();
                    if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                        continue;
 
                    if(distance(bulletImpact, playerorigin) < self.aimbotRadius && isAlive(level.players[i]))
                    {
                        if(isDefined(self.aimbotDelay))
                            wait (self.aimbotDelay);
                        level.players[i] thread [[level.callbackPlayerDamage]]( self, self, 500, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                    }
                }
                if(!isDefined(self.aimbotweapon))
                {
                    player = level.players[i];
                    playerorigin = player getorigin();
                    if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                        continue;
 
                    if(distance(bulletImpact, playerorigin) < self.aimbotRadius && isAlive(level.players[i]))
                    {
                        if(isDefined(self.aimbotDelay))
                            wait (self.aimbotDelay);
                        level.players[i] thread [[level.callbackPlayerDamage]]( self, self, 500, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                    }
                }
            }
        wait .1;    
        }
    }
    else{
        self.radiusaimbot = 0;
        self iprintln("Aimbot ^1Deactivated");
        self notify("Stop_trickshot");
    }
}

doUnfair()
{
    if(self.unfairaimbot == 0)
    {
        self endon("game_ended");
        self endon( "disconnect" );
        self endon("Stop_unfair");
        self.unfairaimbot = 1;

        self iprintln("Unfair Aimbot ^2Activated");
        while(1)
        {   
            for(i=0;i<level.players.size;i++)
            {   
                if(isDefined(self.mala))
                    self waittill( "mala_fired" );
                if(isDefined(self.briefcase))
                    self waittill( "bombbriefcase_fired" );
                else
                    self waittill( "weapon_fired" );
                if(isDefined(self.aimbotWeapon) && self getcurrentweapon() == self.aimbotweapon)
                {
                    if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                        continue;

                    if(isAlive(level.players[i]))
                    {
                        victim = level.players[i];
                        victim thread [[level.callbackPlayerDamage]]( self, self, self.dmg, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                    }
                }
                else if(!isDefined(self.aimbotweapon) && self getcurrentweapon() == self.aimbotweapon)
                {
                    if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                        continue;

                    if(isAlive(level.players[i]))
                    {
                        victim = level.players[i];
                        victim thread [[level.callbackPlayerDamage]]( self, self, self.dmg, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                    }
                }
            }
        wait .1;    
        }
    }
    else
    {
        self.unfairaimbot = 0;
        self iprintln("Unfair Aimbot ^1Deactivated");
        self notify("Stop_unfair");
    }
}

vector_scal(vec, scale)
{
    vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
    return vec;
}


HmAimbot()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.Hmradiusaimbot == 0)
    {
        self endon("disconnect");
        self endon("Stop_trickshot");
        self.Hmradiusaimbot = 1;
        self iprintln("Hit Marker Aimbot ^2activated");
        while(1)
        {   
            if(isDefined(self.mala))
                self waittill( "mala_fired" );
            else if(isDefined(self.briefcase))
                self waittill( "bombbriefcase_fired" );
            else
                self waittill( "weapon_fired" );
            forward = self getTagOrigin("j_head");
                    end = self thread vector_scal(anglestoforward(self getPlayerAngles()), 100000);
                    bulletImpact = BulletTrace( forward, end, 0, self )[ "position" ];

            for(i=0;i<level.players.size;i++)
            {
                if(isDefined(self.HMaimbotweapon) && self getcurrentweapon() == self.HMaimbotweapon)
                {
                    player = level.players[i];
                    playerorigin = player getorigin();
                    if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                        continue;
 
                    if(distance(bulletImpact, playerorigin) < self.HMaimbotRadius && isAlive(level.players[i]))
                    {
                        if(isDefined(self.HMaimbotDelay))
                            wait (self.HMaimbotDelay);
                            level.players[i] thread [[level.callbackPlayerDamage]]( self, self, 2, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                    }
                }
                if(!isDefined(self.aimbotweapon))
                {
                    player = level.players[i];
                    playerorigin = player getorigin();
                    if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                        continue;
 
                    if(distance(bulletImpact, playerorigin) < self.HMaimbotRadius && isAlive(level.players[i]))
                    {
                        if(isDefined(self.HMaimbotDelay))
                            wait (self.HMaimbotDelay);
                            level.players[i] thread [[level.callbackPlayerDamage]]( self, self, 2, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                    }
                }
            }
        wait .1;    
        }
    }
    else{
        self.Hmradiusaimbot = 0;
        self iprintln("Hit Marker Aimbot ^1Deactivated");
        self notify("Stop_trickshot");
    }
}

HMaimbotWeapon()
{                     
    self endon("game_ended");
    self endon( "disconnect" );           
    if(!isDefined(self.HMaimbotweapon))
    {
        self.HMaimbotweapon = self getcurrentweapon();
        self iprintln("Aimbot Weapon defined to: ^1" + self.HMaimbotweapon);
    }
    else if(isDefined(self.HMaimbotweapon))
    {
        self.HMaimbotweapon = undefined;
        self iprintln("Aimbots will work with ^2All Weapons");
    }
}

HMaimbotRadius()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.HMaimbotRadius == 100)
    {
        self.HMaimbotRadius = 500;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotRadius);
    }
    else if(self.HMaimbotRadius == 500)
    {
        self.HMaimbotRadius = 1000;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotRadius);
    }
    else if(self.HMaimbotRadius == 1000)
    {
        self.HMaimbotRadius = 1500;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotRadius);
    }
    else if(self.HMaimbotRadius == 1500)
    {
        self.HMaimbotRadius = 2000;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotRadius);
    }
    else if(self.HMaimbotRadius == 2000)
    {
        self.HMaimbotRadius = 2500;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotRadius);
    }
    else if(self.HMaimbotRadius == 2500)
    {
        self.HMaimbotRadius = 3000;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotRadius);
    }
    else if(self.HMaimbotRadius == 3000)
    {
        self.HMaimbotRadius = 3500;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotRadius);
    }
    else if(self.HMaimbotRadius == 3500)
    {
        self.HMaimbotRadius = 4000;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotRadius);
    }
    else if(self.HMaimbotRadius == 4000)
    {
        self.HMaimbotRadius = 4500;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotRadius);
    }
    else if(self.HMaimbotRadius == 4500)
    {
        self.HMaimbotRadius = 5000;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotRadius);
    }
    else if(self.HMaimbotRadius == 5000)
    {
        self.HMaimbotRadius = 100;
        self iprintln("Aimbot Radius set to: ^1OFF");
    }
}

HMaimbotDelay()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.HMaimbotDelay == 0)
    {
        self.HMaimbotDelay = .1;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .1)
    {
        self.HMaimbotDelay = .2;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .2)
    {
        self.HMaimbotDelay = .3;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .3)
    {
        self.HMaimbotDelay = .4;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .4)
    {
        self.HMaimbotDelay = .5;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .5)
    {
        self.HMaimbotDelay = .6;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .6)
    {
        self.HMaimbotDelay = .7;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .7)
    {
        self.HMaimbotDelay = .8;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .8)
    {
        self.HMaimbotDelay = .9;
        self iprintln("Aimbot Radius set to: ^2" + self.HMaimbotDelay);
    }
    else if(self.HMaimbotDelay == .9)
    {
        self.HMaimbotDelay = 0;
        self iprintln("Aimbot Radius set to: ^1No Delay");
    }
}


